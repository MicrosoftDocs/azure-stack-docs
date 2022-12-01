---
title: Single machine Kubernetes
description: Learn how to deploy AKS on a single machine.
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/07/2022
ms.custom: template-how-to
---

# Single machine deployment

You can deploy AKS Edge Essentials on either a single machine or on multiple machines. In a single machine Kubernetes deployment, both the Kubernetes control node and worker node run on the same machine, which is your primary machine. This article describes how to create the Kubernetes control node on your machine on a private network.

## Prerequisites

Set up your primary machine as described in the [Setup article](aks-edge-howto-setup-machine.md).

## Create a single machine cluster

You can run the `New-AksLiteDeployment` cmdlet to deploy a single-machine AksIot cluster with a single Linux control-plane node. You can do so by providing your values in a JSON file. Run the `New-AksEdgeConfig` cmdlet to create a sample JSON **mydeployconfig.json** file with the default parameters and edit this file to provide your own values:

```powershell
#create a deployment configuration file with defaults
New-AksEdgeConfig -outFile .\mydeployconfig.json
```

You can edit **mydeployconfig**.json with the parameters you need and pass the JSON config file for deployment. To get a full list of the parameters and their default values, run `Get-Help New-AksEdgeDeployment -full` in your PowerShell window. You can then use this file in your deployment.

```powershell
New-AksEdgeDeployment -JsonConfigFilePath .\mydeployconfig.json
```

Alternatively, you can programmatically edit the json object and pass it as a string

```powershell
$jsonString = New-AksEdgeConfig -outFile .\mydeployconfig.json
$jsonObj = $jsonString | ConvertFrom-Json 
$jsonObj.EndUser.AcceptEula = $true
$jsonObj.EndUser.AcceptOptionalTelemetry = $true
$jsonObj.LinuxVm.CpuCount = 4
$jsonObj.LinuxVm.MemoryInMB = 4096
$jsonObj.Network.ServiceIpRangeSize = 10

New-AksEdgeDeployment -JsonConfigString ($jsonObj | ConvertTo-Json)
```

Some of the common parameters and their default values as follows:

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `NodeType` | `Linux` or `LinuxAndWindows` | `Linux` creates the Linux control plane. You cannot specify `Windows` because the control plane node needs to be Linux. Read more about [AKS edge workload types](/docs/AKS-Edge-Concepts.md#aks-iot-workload-types) *(Note: In order to deploy Windows worker node, you need to opt the Windows VHDX into your MSI installer. Learn how to do this [here](/docs/set-up-machines.md).)* | `Linux` |
| `NetworkPlugin` | `calico` or `flannel` | CNI plugin choice for the Kubernetes network model. | `flannel` |
| `LinuxVm.CpuCount` | number | Number of CPU cores reserved for Linux VM/VMs. | `2` |
| `LinuxVm.MemoryInMB` | number | RAM in MBs reserved for Linux VM/VMs. | `2048` |
| `LinuxVm.DataSizeInGB` | number | Size of the data partition. For large applications, we recommend  | `10` |
| `ServiceIPRangeSize` | number | Defines a service IP range for your workloads. We recommend you reserve some IP range (ServiceIPRangeSize > 0) for your Kubernetes services.| `0` |

## Example deployment options

- **Create a simple cluster without a load balancer**. You can also create a very simple cluster with no service IPs. You cannot create a LoadBalancer service in this approach.

   ```powershell
   New-AksEdgeDeployment -JsonConfigString (New-AksEdgeConfig)
   ```

- **Allocate resources to your nodes**. To connect to Arc and deploy your apps with GitOps, allocate four CPUs or more for the `LinuxVm.CpuCount` (processing power), 4GB or more for `LinuxVm.MemoryinMB` (RAM) and to assign a number greater than 0 to the `ServiceIpRangeSize`. Here, we allocate 10 IP addresses for your Kubernetes services:

   ```json
       "DeployOptions": {
           "NetworkPlugin": "flannel",
           "SingleMachineCluster": true,
           "NodeType": "Linux"
       },
       "EndUser": {
           "AcceptEula": true,
           "AcceptOptionalTelemetry": true
       },
       "LinuxVm": {
           "CpuCount": 4,
           "MemoryInMB": 4096
       },
       "Network": {
           "ServiceIPRangeRange": 10
       }
   ```

   ```powershell
   #create a deployment configuration file with defaults
   New-AksEdgeConfig -outFile .\mydeployconfig.json
   #Edit mydeployconfig.json with the parameters you need and pass the json config for deployment
   New-AksEdgeDeployment -JsonConfigFilePath .\mydeployconfig.json
   ```

   Passing the parameters as a JSON string as mentioned above: 

   ```powershell
   $jsonString = New-AksEdgeConfig -outFile .\mydeployconfig.json
   $jsonObj = $jsonString | ConvertFrom-Json 
   $jsonObj.EndUser.AcceptEula = $true
   $jsonObj.EndUser.AcceptOptionalTelemetry = $true
   $jsonObj.LinuxVm.CpuCount = 4
   $jsonObj.LinuxVm.MemoryInMB = 4096
   $jsonObj.Network.ServiceIpRangeSize = 10

   New-AksEdgeDeployment -JsonConfigString ($jsonObj | ConvertTo-Json)
   ```

   > [!NOTE]
   > AKS allocates IP addresses from your internal switch to run your Kubernetes services if you specified a `ServiceIPRangeSize`.

- **Create a mixed workload cluster**. You can also deploy mixed-workloads clusters. The following example shows how to bring up both Linux and Windows workloads at the same time:

   ```json
       "DeployOptions": {
           "NetworkPlugin": "flannel",
           "SingleMachineCluster": true,
           "NodeType": "LinuxAndWindows"
       },
       "EndUser": {
           "AcceptEula": true,
           "AcceptOptionalTelemetry": true
       },
       "LinuxVm": {
           "CpuCount": 4,
           "MemoryInMB": 4096
       },
       "WindowsVm": {
           "CpuCount": 2,
           "MemoryInMB": 4096
       },
       "Network": {
           "ServiceIPRangeRange": 10
       }
   ```

   ```powershell
   $jsonString = New-AksEdgeConfig .\mydeployconfig.json
   $jsonObj = $jsonString | ConvertFrom-Json 
   $jsonObj.EndUser.AcceptEula = $true
   $jsonObj.EndUser.AcceptOptionalTelemetry = $true
   $jsonObj.DeployOptions.NodeType = "LinuxAndWindows"
   $jsonObj.LinuxVm.CpuCount = 4
   $jsonObj.LinuxVm.MemoryInMB = 4096
   $jsonObj.WindowsVm.CpuCount = 2
   $jsonObj.WindowsVm.MemoryInMB = 4096
   $jsonObj.Network.ServiceIpRangeSize = 10

   New-AksEdgeDeployment -JsonConfigString ($jsonObj | ConvertTo-Json)
   ```

## Validate your cluster

Confirm that the deployment was successful by running:

```powershell
kubectl get nodes -o wide
kubectl get pods -A -o wide
```

![Screenshot showing all pods running.](./media/aks-edge/all-pods-running.png)

> [!NOTE]
> This screenshot is for a k3s cluster so the pods will look different for k8s.

Optionally, add a Windows node. If you would like to add Windows workloads to an existing Linux only single machine cluster, you can run:

```powershell
Add-AksEdgeNode -NodeType Windows
```

You can also specify parameters such as `CpuCount` and/or `MemoryInMB` for your Windows VM here.

## Alternate option: AksEdgeDeploy(Aide)

We have also included AksEdgeDeploy(Aide) module in our [GitHub repo](https://github.com/Azure/aks-edge-utils) to help you automate the installation, deployment and provisioning of AKS edge with the JSON specification. We have included a sample JSON for quick deployment as well as a template JSON that you can fill out to specify your own parameters. This is designed to support remote deployment scenarios.

## Next steps

* [Deploy your application](./aks-edge-howto-deploy-app.md).
* [Overview](./aks-edge-overview.md)
* [Uninstall AKS cluster](./aks-edge-howto-uninstall.md)
