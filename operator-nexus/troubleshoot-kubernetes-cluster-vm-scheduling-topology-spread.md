---
title: Troubleshoot Nexus Kubernetes VM scheduling failures due to topology spread constraints
description: Learn how to resolve VM scheduling failures caused by MaxSkew topology spread constraints when racks are unavailable in Azure Operator Nexus.
ms.service: azure-operator-nexus
ms.custom: troubleshooting
ms.topic: troubleshooting
ms.date: 03/05/2026
ms.author: rickbartra
author: rickbartra91
---

# Troubleshoot Nexus Kubernetes VM scheduling failures due to topology spread constraints

This guide helps you resolve Nexus Azure Kubernetes Service (NAKS) virtual machine (VM) scheduling failures caused by topology spread constraints when one or more racks are unavailable or at capacity.

## Background

Nexus Kubernetes spreads VMs across availability zones (racks) to provide high availability. This spreading behavior is enforced using [Kubernetes topology spread constraints](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/) with a `maxSkew` value of `1` and a `whenUnsatisfiable` policy of `DoNotSchedule`.

- **`maxSkew`** controls the maximum allowed difference in VM count between any two racks. A value of `1` means racks can differ by at most one VM.
- **`DoNotSchedule`** means the scheduler rejects a VM placement that would violate the `maxSkew` constraint, rather than placing it on an imbalanced rack.

This combination ensures VMs are evenly distributed across racks under normal conditions. However, when one or more racks become unavailable (due to maintenance, hardware failure, cordoned bare metal machines, or capacity constraints), new VMs may fail to schedule because placing them on the remaining racks would exceed the `maxSkew` limit.

## Symptoms

New VMs fail to schedule and report an error similar to:

~~~
ErrorUnschedulable: X node(s) didn't match pod topology spread constraints
~~~

This error occurs when:

- One or more racks are unavailable due to runtime upgrade, capacity constraints, maintenance, or other reasons.
- An operation that results in the creation of new Nexus Kubernetes cluster VMs that can only be placed on a subset of racks.
- Placing a new VM would cause the difference in VM count between racks to exceed `maxSkew: 1`.

## Prerequisites

1. The latest `networkcloud` CLI extension is required. It can be installed following the steps listed [here](./howto-install-cli-extensions.md).
1. Identify a control-plane bare metal machine in the cluster's managed resource group. Run commands that use `kubectl` must be executed from a control-plane bare metal machine.
1. Identify the internal Nexus Kubernetes cluster name. The undercloud uses an internal name that includes a hash suffix appended to your Nexus Kubernetes cluster name (for example, `my-naks-cluster-0601b5b4`). You can find this name by listing the nodes in your Nexus Kubernetes cluster — the control plane node names are prefixed with the internal cluster name. For example, a node named `my-naks-cluster-0601b5b4-control-plane-8s4vh` indicates the internal cluster name is `my-naks-cluster-0601b5b4`.

1. Identify the stuck VM(s). Use the internal cluster name to list VMs for your cluster. VMs with `ErrorUnschedulable` status are affected:

    ~~~azurecli
    az networkcloud baremetalmachine run-read-command \
        --name "<controlPlaneBareMetalMachineName>" \
        --resource-group "<cluster_MRG>" \
        --subscription "<subscription>" \
        --limit-time-seconds 60 \
        --commands "[{command:'kubectl get',arguments:[vm,-n,nc-system,-l,'cluster.x-k8s.io/cluster-name=<internal-cluster-name>']}]"
    ~~~

    > [!NOTE]
    > Replace `<cluster_MRG>` with the managed resource group of the Nexus cluster (undercloud), which contains the bare metal machine resources.

    Example output showing a stuck VM:

    ```
    NAME                                                STATUS               READY
    virtualmachine.kubevirt.io/my-naks-cluster-0601b5b4-md-46pdq-8m5mf   ErrorUnschedulable   False
    ```

## Mitigation options

There are two approaches to resolve this scheduling failure. Review the pros and cons of each approach to determine which is best for your environment.

### Option A: Relax to ScheduleAnyway

This option changes the topology spread constraint from a hard requirement (`DoNotSchedule`) to a soft preference (`ScheduleAnyway`). The scheduler still *prefers* even distribution across racks but places the VM on an available rack rather than leaving it unscheduled.

| Pros | Cons |
|---|---|
| VMs always get scheduled — no more stuck pods | Could concentrate all VMs on one rack — reduced high availability |
| Scheduler still tries to spread (uses skew as a scoring factor) | Harder to detect placement drift since nothing fails visibly |
| No risk of scheduling failure in degraded rack scenarios | If a rack goes down with a disproportionate number of VMs, bigger blast radius |

Patch the VM to use `ScheduleAnyway` and delete the VMI so KubeVirt recreates it with the updated constraints. Replace `<vm-name>` with the name of the affected VM identified in the prerequisites:

~~~azurecli
az networkcloud baremetalmachine run-command \
    --bare-metal-machine-name "<controlPlaneBareMetalMachineName>" \
    --resource-group "<cluster_MRG>" \
    --subscription "<subscription>" \
    --limit-time-seconds 60 \
    --script "$(printf 'kubectl patch vm "%s" -n nc-system --type=json -p '\''[{"op":"replace","path":"/spec/template/spec/topologySpreadConstraints/0/whenUnsatisfiable","value":"ScheduleAnyway"},{"op":"replace","path":"/spec/template/spec/topologySpreadConstraints/1/whenUnsatisfiable","value":"ScheduleAnyway"}]'\''\nkubectl delete vmi "%s" -n nc-system' '<vm-name>' '<vm-name>' | base64 -w 0)"
~~~

### Option B: Increase MaxSkew

This option keeps the hard scheduling constraint but increases the `maxSkew` value from `1` to `2`, allowing more imbalance between racks before blocking.

| Pros | Cons |
|---|---|
| Still enforces a bound on how uneven placement can get | Doesn't fully solve the problem — with enough racks down, you can still hit the limit |
| Provides more headroom for rack failures and rolling upgrades | Choosing the right value is dependent on rack count and pool size |
| Failures remain visible (pods go Pending) so you know something is wrong | |

Patch the VM to increase `maxSkew` from `1` to `2` and delete the VMI so KubeVirt recreates it with the updated constraints. Replace `<vm-name>` with the name of the affected VM identified in the prerequisites:

~~~azurecli
az networkcloud baremetalmachine run-command \
    --bare-metal-machine-name "<controlPlaneBareMetalMachineName>" \
    --resource-group "<cluster_MRG>" \
    --subscription "<subscription>" \
    --limit-time-seconds 60 \
    --script "$(printf 'kubectl patch vm "%s" -n nc-system --type=json -p '\''[{"op":"replace","path":"/spec/template/spec/topologySpreadConstraints/0/maxSkew","value":2},{"op":"replace","path":"/spec/template/spec/topologySpreadConstraints/1/maxSkew","value":2}]'\''\nkubectl delete vmi "%s" -n nc-system' '<vm-name>' '<vm-name>' | base64 -w 0)"
~~~

## Important caveats

- **Not persistent:** The Cluster API Provider KubeVirt (CAPK) owns the VM lifecycle and can recreate it from the original template at any time, wiping out the patch. New VMs created on scale-up or upgrade will also have `maxSkew: 1`. You must patch the VM and delete the VMI quickly before CAPK reconciles. If the patch command errors, the VM may have been recreated with a new name — re-run the VM listing command to get the current name.
- **VMI delete required:** Patching the VM alone does not restart the virt-launcher pod. You must delete the VMI so KubeVirt recreates it with the updated constraints.
- **Only apply to affected VMs:** These mitigation steps only need to be applied to VMs that are in `ErrorUnschedulable` status. VMs that are already running are not affected and do not need to be patched.

## Verification

After applying the mitigation, it may take a few minutes for the VM to be scheduled and running. Verify the cluster is healthy by confirming all nodes in your Nexus Kubernetes cluster are in `Ready` status.

If you still have questions, [contact support](https://portal.azure.com/?#blade/Microsoft_Azure_Support/HelpAndSupportBlade).
For more information about Support plans, see [Azure Support plans](https://azure.microsoft.com/support/plans/response/).
