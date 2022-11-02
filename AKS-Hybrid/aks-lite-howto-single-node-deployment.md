---
title: Single node deployment #Required; page title is displayed in search results. Include the brand.
description: Deploy AKS on a single machine #Required; article description that is displayed in search results. 
author: rcheeran #Required; your GitHub user alias, with correct capitalization.
ms.author: rcheeran #Required; microsoft alias of author; optional team alias.
#ms.service: #Required; service per approved list. slug assigned by ACOM.
ms.topic: how-to #Required; leave this attribute/value as-is.
ms.date: 09/30/2022 #Required; mm/dd/yyyy format.
ms.custom: template-how-to #Required; leave this attribute/value as-is.
---

<!--
Remove all the comments in this template before you sign-off or merge to the 
main branch.
-->

<!--
This template provides the basic structure of a how-to article.
See the [how-to guidance](contribute-how-to-write-howto.md) in the contributor guide.

To provide feedback on this template contact 
[the templates workgroup](mailto:templateswg@microsoft.com).
-->

<!-- 1. H1
Required. Start your H1 with a verb. Pick an H1 that clearly conveys the task the 
user will complete.
-->

# Single machine deployment

<!-- 2. Introductory paragraph 
Required. Lead with a light intro that describes, in customer-friendly language, 
what the customer will learn, or do, or accomplish. Answer the fundamental “why 
would I want to do this?” question. Keep it short.
-->

AKS on the light edge can be deployed on either a single machine or on multiple machine. In case of a single machine, both the Kubernetes control node and worker node runs on the same machine, which is your **primary** machine. In this document we create the Kubernetes control node on your machine on a private network.

<!-- 3. Prerequisites 
Optional. If you need prerequisites, make them your first H2 in a how-to guide. 
Use clear and unambiguous language and use a list format.
-->

## Prerequisites

- Setup your primary machine as described in the [Setup page](aks-lite-howto-setup-machine.md)

<!-- 4. H2s 
Required. A how-to article explains how to do a task. The bulk of each H2 should be 
a procedure.
-->

## Create a single-node cluster

You can simply run `New-AksIotSingleMachineCluster` to deploy a single-machine AksIot cluster with a single Linux control-plane node. You can run the command with default parameters or input your own values. Below are some of the parameters and its defaults values:

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| WorkloadType | `Linux` | `Linux` creates the Linux control plane. You cannot specify `Windows` because the control plane node needs to be Linux. Read more about [AKS-IoT workload types](/docs/AKS-IoT-Concepts.md#aks-lite-workload-types) *(Note: Windows nodes are not supported in this build.)* | `Linux` |
| NetworkPlugin | `calico` or `flannel` | CNI plugin choice for the Kubernetes network model. | `flannel` |
| LinuxVmCpuCount | `number` | Number of CPU cores reserved for Linux VM/VMs. | `2` |
| LinuxVmMemoryInMB | `number` | RAM in MBs reserved for Linux VM/VMs. | `2048` |
| ServiceIPRangeSize | `number` | Define a service IP range for your workloads. | `0` |

To get a **full list** of the parameters and their default values, run `Get-Help New-AksIotSingleMachineCluster -full` in your LaunchPrompt.

**Example Commands:**

Create a cluster with no service IPs. You cannot create a LoadBalancer service.

```powershell
New-AksIotSingleMachineCluster
```

**NOTE**: To connect to Arc and deploy your apps with GitOps, please allocate **4 CPU or more** for the `LinuxVmCpuCount` (processing power), **4GB or more** for `LinuxVmMemory` (RAM) and to **assign a number > 0** to the `ServiceIpRangeSize`. Here, we simply allocate 10 IP addresses for your Kubernetes services.

```powershell
New-AksIotSingleMachineCluster -AcceptEula yes -LinuxVmCpuCount 4 -LinuxVmMemoryInMB 4096 -ServiceIpRangeSize 10
```

It can take some time for this step to complete.

## Validate cluster

Configure the `kubeconfig` so you can use `kubectl` to connect to your cluster:

```powershell
Get-AksIotCredential
```

Confirm that the installation was successful by running:

```powershell
kubectl get nodes -o wide
kubectl get pods --all-namespaces -o wide
```

![all pods running](media/aks-lite/all-pods-running.png)

## Next

Deploy your application. Alternatively, deploy [sample applications](/docs/deploying-workloads.md) to test your deployment.
Once you've deployed your application, [connect your cluster to Azure Arc](/docs/connect-to-arc.md).

> [!NOTE]
> We will carve out IP addresses from your internal switch to run your Kubernetes services if you specified a ServiceIPRangeSize.

<!-- ## Autodeploy Setup

If you have used autodeploy scripts to install and deploy, simply confirm that the installation was successful by running: 

```powershell
Get-AksIotCredential
```

```powershell
kubectl get nodes -o wide
kubectl get pods --all-namespaces -o wide
```

![all pods running](images/all-pods-running1.png)

Now, deploy your application. Alternatively, deploy [sample applications](/docs/deploying-workloads.md) to test your deployment. Otherwise, return to the [deployment guidance homepage](/docs/AKS-IoT-Deployment-Guidance.md). -->

## Remove Single Machine Cluster

To remove your single machine cluster, simply run:

```powershell
Remove-AksIotSingleMachineCluster
```

## Alternate option : AksIotDeploy(Aide)

We have also included AksIotDeploy(Aide) module to help you automate the installation, deployment and provisioning of AKS-IoT with a simple json specification. We have included a sample json for quick deployment as well as a template json that you can fill out to specify your own parameters. This is designed to support **remote deployment** scenarios. Learn more about [AksIotDeploy](/bootstrap/Modules/AksIotDeploy/Readme.md).

Otherwise, return to the [deployment guidance homepage](/docs/AKS-IoT-Deployment-Guidance.md).

## Next steps
<!-- Add a context sentence for the following links -->
- You can now [deploy your application](/docs/deploying-workloads.md).
- [Overview](aks-lite-overview.md)
- [Uninstall AKS cluster](aks-lite-howto-uninstall.md)
