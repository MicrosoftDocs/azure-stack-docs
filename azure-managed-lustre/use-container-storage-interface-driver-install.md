---
title: Install the Azure Managed Lustre CSI Driver
description: Prepare your AKS cluster, install the Azure Lustre CSI driver v0.6.0 with Helm or a script, and verify driver readiness.
ms.topic: how-to
ms.date: 10/23/2026
author: pauljewellmsft
ms.author: akashdubey
ms.reviewer: brianl
ms.custom: sfi-image-nochange

# Intent: As an IT pro, I want to prepare my AKS cluster and install the Azure Lustre CSI Driver for either provisioning method.
# Keyword:

---

# Install the Azure Managed Lustre CSI driver

Install the driver once for either dynamic or static provisioning. If it's already installed, follow [Upgrade the CSI driver](use-container-storage-interface-driver-upgrade.md#upgrade-the-csi-driver). You can optionally [verify the image signatures](use-container-storage-interface-driver-image-security.md#pre-deployment-image-verification) before installation.

## Prerequisites

Review the [CSI driver prerequisites](use-csi-driver-kubernetes.md#prerequisites), including Kubernetes 1.29 or later, supported node operating systems and architectures, installation tools, network access, and node scheduling.

For dynamic provisioning, configure the [controller identity permissions](use-container-storage-interface-driver-dynamic-provisioning.md#permissions) before installing the driver.

## Prepare the cluster

These steps apply to both provisioning methods.

### Create an AKS cluster

If you don't already have an AKS cluster, create one. See [Deploy an Azure Kubernetes Service (AKS) cluster by using the Azure portal](/azure/aks/learn/quick-kubernetes-deploy-portal).

### Create a virtual network peering

For dynamic provisioning, choose or create the target virtual network and subnet before peering. The driver creates the file system, not the network. Follow the [Azure Managed Lustre network prerequisites](amlfs-prerequisites.md#network-prerequisites).

> [!NOTE]
> Skip this network peering step if you installed AKS in a subnet on the Azure Managed Lustre virtual network.

Identify the virtual network and subnet used by your AKS node pools. An AKS-created virtual network is in the cluster's **Infrastructure** resource group, shown under **Properties** in the Azure portal. If you supplied your own virtual network, use its resource group instead. Peer that virtual network with the virtual network you selected for Azure Managed Lustre.

To peer the AKS virtual network with your Azure Managed Lustre virtual network, consult [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview).

> [!TIP]
> Due to the naming of the MC_ resource groups and virtual networks, names of networks can be similar or the same across multiple AKS deployments. When you're setting up peering, be careful to choose the AKS networks that you intend to choose.

### Connect to the AKS cluster

1. Open a terminal session with access to the Azure CLI tools and sign in to your Azure account.

   ```azurecli
   az login
   ```

1. Sign in to [the Azure portal](https://portal.azure.com).

1. Find your AKS cluster. On the **Overview** pane, select the **Connect** button, and then copy the command for **Download cluster credentials**.

1. In your terminal session, paste the command to download the credentials. The command is similar to:

   ```azurecli
   az aks get-credentials --subscription <AKS_subscription_id> --resource-group <AKS_resource_group_name> --name <name_of_AKS>
   ```

1. Install kubectl if it's not present in your environment.

   ```azurecli
   az aks install-cli
   ```

1. Verify that the current context is the AKS cluster where you installed the credentials and that you can connect to it.

   ```bash
   kubectl config current-context
   kubectl get deployments --all-namespaces=true
   ```

## Install the driver

The driver commands use `kube-system`; substitute your driver namespace throughout if it differs for a Helm installation. The script uses `kube-system`. Create the example PVCs and pods in the same workload namespace, selected by your current kubectl context.

After either installation method, complete the [driver readiness checks](#verify-the-installation) before creating claims or mounting volumes.

### Install with Helm

Helm is the recommended installation method. Install the released OCI chart from Microsoft Container Registry (MCR):

```bash
helm install azurelustre \
   oci://mcr.microsoft.com/microsoft.azuremanagedlustre/azurelustre-csi-driver \
   --namespace kube-system --create-namespace \
   --version 0.6.0 --wait --timeout 30m
```

The chart version is `0.6.0`, without a `v` prefix. This chart selects the `v0.6.0` driver image family. Chart versions and driver versions are independent.

For Microsoft Entra Workload Identity, complete the [identity setup](use-container-storage-interface-driver-dynamic-provisioning.md#permissions), then add `--set IsWorkloadIdentityEnabled=Enabled` and `--set IdentityClientId=<managed-identity-client-id>` to this command.

### Install with the script

Alternatively, install the version-pinned manifests:

```bash
set -o pipefail
curl -sSL --fail https://raw.githubusercontent.com/kubernetes-sigs/azurelustre-csi-driver/v0.6.0/deploy/install-driver.sh | bash -s v0.6.0
```

> [!IMPORTANT]
> Specify `v0.6.0` in both the script URL and the script argument so the command installs the release described in this article. Without the argument, the installer can install a different release from the `main` branch.

For the corresponding source and deployment manifests, see the [v0.6.0 release](https://github.com/kubernetes-sigs/azurelustre-csi-driver/releases/tag/v0.6.0).

## Verify the installation

Helm resource names depend on the release name, so the commands use labels shared by both installation methods. They assume the `kube-system` namespace; use your installation namespace if it differs.

1. Wait for the controller and node DaemonSets to be ready:

   ```bash
   kubectl get deployment -n kube-system -l app=csi-azurelustre-controller
   kubectl rollout status deployment -n kube-system -l app=csi-azurelustre-controller --timeout=300s
   kubectl rollout status daemonset -n kube-system -l app=csi-azurelustre-node --timeout=1800s
   ```

   There must be one controller Deployment with its desired replicas ready and available.

1. Confirm that each node DaemonSet has the expected number of ready pods:

   ```bash
   kubectl get daemonset -n kube-system -l app=csi-azurelustre-node -L flavor
   ```

   There must be three node DaemonSets, with `jammy`, `noble`, and `azurelinux3` flavors. A DaemonSet can have zero desired pods when no eligible nodes match that flavor. For every DaemonSet with desired pods, `CURRENT`, `READY`, `UP-TO-DATE`, and `AVAILABLE` must equal `DESIRED`.

1. Compare the node and pod lists to confirm that every intended node has a CSI node pod:

   ```bash
   kubectl get nodes -L kubernetes.azure.com/os-sku-effective
   kubectl get pods -n kube-system -l app=csi-azurelustre-node -o wide
   ```

   Every node where you intend to run Azure Managed Lustre workloads must appear in the `NODE` column of the pod list. A node without a CSI node pod can't mount Azure Managed Lustre, even when all three DaemonSets report ready.

1. Confirm that every CSI node pod is ready and uses the expected v0.6.0 images:

   ```bash
   kubectl get pods -n kube-system -l app=csi-azurelustre-node -o wide
   kubectl get pods -n kube-system -l app=csi-azurelustre-node -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.nodeName}{"\t"}{.spec.containers[?(@.name=="azurelustre")].image}{"\t"}{.spec.initContainers[?(@.name=="lustre-loader")].image}{"\n"}{end}'
   kubectl get pods -n kube-system -l app=csi-azurelustre-controller -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[?(@.name=="azurelustre")].image}{"\n"}{end}'
   ```

   Every node pod must show `4/4` in the `READY` column and `Running` in the `STATUS` column. The fourth container is the `lustre-loader` native sidecar, which loads kernel modules and checks LNet readiness. A running pod with fewer than four ready containers isn't ready to serve mounts. Both the `azurelustre` and `lustre-loader` images must use the MCR repository and appropriate `v0.6.0-jammy`, `v0.6.0-noble`, or `v0.6.0-azurelinux3` tag listed in the [compatibility table](use-csi-driver-kubernetes.md#azure-lustre-csi-driver-versions). The controller uses the `v0.6.0-noble` image.

After a new installation, continue with [dynamic provisioning](use-container-storage-interface-driver-dynamic-provisioning.md#create-a-storage-class-for-dynamic-provisioning) or [static provisioning](use-container-storage-interface-driver-static-provisioning.md#create-and-configure-a-persistent-volume-for-static-provisioning). For an upgrade, continue with [Verify the upgrade](use-container-storage-interface-driver-upgrade.md#verify-the-upgrade) before restarting workloads.

## Related content

- [Azure Lustre CSI driver overview](use-csi-driver-kubernetes.md)
- [Plan network architecture for AKS with Azure Managed Lustre](use-container-storage-interface-driver-network-planning.md)
- [Upgrade or uninstall the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-upgrade.md)
- [Validate CSI driver image security](use-container-storage-interface-driver-image-security.md)
