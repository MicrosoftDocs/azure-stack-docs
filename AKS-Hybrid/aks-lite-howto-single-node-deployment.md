---
title: Single node deployment
description: Learn how to deploy AKS on a single machine.
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/07/2022
ms.custom: template-how-to
---

# Single machine deployment

You can deploy AKS on the light edge on either a single machine or on multiple machines. In case of a single machine, both the Kubernetes control node and worker node run on the same machine, which is your primary machine. This article describes how to create the Kubernetes control node on your machine on a private network.

## Prerequisites

Set up your primary machine as described in the [Setup article](aks-lite-howto-setup-machine.md).

## Create a single-node cluster

You can run the `New-AksIotSingleMachineCluster` cmdlet to deploy a single-machine AksIot cluster with a single Linux control-plane node. You can run the command with default parameters or supply your own values. Some of the parameters and their default values as as follows:

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| WorkloadType | **Linux** | **Linux** creates the Linux control plane. You cannot specify **Windows** because the control plane node needs to be Linux. Read more about [AKS-IoT workload types](/docs/AKS-IoT-Concepts.md#aks-lite-workload-types). Note that Windows nodes are not supported in this build. | **Linux** |
| NetworkPlugin | **calico** or **flannel** | CNI plugin choice for the Kubernetes network model. | **flannel** |
| LinuxVmCpuCount | number | Number of CPU cores reserved for Linux VM/VMs. | 2 |
| LinuxVmMemoryInMB | number | RAM in MBs reserved for Linux VM/VMs. | 2048 |
| ServiceIPRangeSize | number | Define a service IP range for your workloads. | 0 |

To get a full list of the parameters and their default values, run `Get-Help New-AksIotSingleMachineCluster -full` in your LaunchPrompt.

**Example Commands:**

Create a cluster with no service IPs. You cannot create a LoadBalancer service:

```powershell
New-AksIotSingleMachineCluster
```

To connect to Arc and deploy your apps with GitOps, allocate 4 CPUs or more for the `LinuxVmCpuCount` (processing power), 4GB or more for `LinuxVmMemory` (RAM), and assign a number greater than 0 to the `ServiceIpRangeSize`. Here, we allocate 10 IP addresses for your Kubernetes services:

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

![Screenshot of results showing all pods running.](media/aks-lite/all-pods-running.png)

## Deploy application

Deploy your application. Alternatively, deploy [sample applications](/docs/deploying-workloads.md) to test your deployment. Once you've deployed your application, [connect your cluster to Azure Arc](/docs/connect-to-arc.md).

> [!NOTE]
> AKS allocates IP addresses from your internal switch to run your Kubernetes services if you specified a **ServiceIPRangeSize**.

## Remove single machine cluster

To remove your single machine cluster, run the following cmdlet:

```powershell
Remove-AksIotSingleMachineCluster
```

## Alternate option: AksIotDeploy(Aide)

We have also included an **AksIotDeploy(Aide)** module to help you automate the installation, deployment and provisioning of AKS-IoT with a simple JSON specification. We have included a sample JSON for quick deployment as well as a template JSON that you can modify to specify your own parameters. This template is designed to support remote deployment scenarios. [Learn more about AksIotDeploy](/bootstrap/Modules/AksIotDeploy/Readme.md).

Otherwise, return to the [deployment guidance homepage](/docs/AKS-IoT-Deployment-Guidance.md).

## Next steps

- [Deploy your application](/docs/deploying-workloads.md).
- [Overview](aks-lite-overview.md)
- [Uninstall AKS cluster](aks-lite-howto-uninstall.md)
