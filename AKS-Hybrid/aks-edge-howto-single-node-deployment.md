---
title: Single machine Kubernetes
description: Learn how to deploy AKS on a single machine.
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 12/05/2022
ms.custom: template-how-to
---

# Single machine deployment

You can deploy AKS Edge Essentials on either a single machine or on multiple machines. In a single machine Kubernetes deployment, both the Kubernetes control node and worker node run on the same machine. This article describes how to create the Kubernetes control node on your machine on a private network.

## Prerequisite

Set up your primary machine as described in the [Set up machine](aks-edge-howto-setup-machine.md) article.

## Create a single machine cluster

1. The parameters needed to create a single machine cluster are defined in the [**aksedge-config.json**](https://github.com/Azure/AKS-Edge/blob/main/tools/aksedge-config.json) file in the downloaded GitHub folder. A detailed description of the configuration parameters [is available here](aks-edge-deployment-config-json.md). The parameter that defines a single machine cluster is the `singlemachinecluster` flag, which must be set to `true`.
1. Open the [AksEdgePrompt](https://github.com/Azure/AKS-Edge/blob/main/tools/AksEdgePrompt.cmd) tool. The tool opens an elevated PowerShell window with the modules loaded.
1. You can now run the `New-AksEdgeDeployment` cmdlet to deploy a single-machine AKS Edge cluster with a single Linux control-plane node:

    ```PowerShell
    New-AksEdgeDeployment -JsonConfigFilePath .\aksedge-config.json
    ```

## Single machine configuration parameters

The key parameters and their default values applicable for single machine deployment:

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
|`SingleMachineCluster` |`boolean`| Set this flag to `true` for single machine cluster deployments.|`true`
| `NodeType` | `Linux` or `LinuxAndWindows` | `Linux` creates the Linux control plane. You can't specify `Windows` because the control plane node needs to be Linux. Read more about [AKS edge workload types](aks-edge-concept.md#workload-types) | `Linux` |
| `NetworkPlugin` | `calico` or `flannel` | CNI plugin choice for the Kubernetes network model. For K8S clusters, only `calico` is supported. | `flannel` |
| `LinuxVm.CpuCount` | number | Number of CPU cores reserved for Linux VM. | `2` |
| `LinuxVm.MemoryInMB` | number | RAM in MBs reserved for Linux VM. | `2048` |
| `LinuxVm.DataSizeInGB` | number | Size of the data partition.  | `10` |
| `WindowsVm.CpuCount` | number | Number of CPU cores reserved for Windows VM. | `2` |
| `WindowsVm.MemoryInMB` | number | RAM in MBs reserved for Windows VM. | `2048` |
| `Network.ServiceIPRangeSize` | number | Defines a service IP range for your workloads. We recommend you reserve some IP range (ServiceIPRangeSize > 0) for your Kubernetes services.| `0` |
| `Network.InternetDisabled` | boolean | Defines if internet access is available or not.| `false` |

## Example deployment options

### Create your own configuration file

You can create your own configuration file using the `New-AksEdgeConfig` command:

```powershell
# Create a deployment configuration file with defaults
New-AksEdgeConfig -outFile .\mydeployconfig.json
```

You can edit **mydeployconfig.json** with the parameters you need and pass the JSON config file for deployment.

```powershell
New-AksEdgeDeployment -JsonConfigFilePath .\mydeployconfig.json
```

Alternatively, you can programmatically edit the JSON object and pass it as a string:

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

### Create a simple cluster without a load balancer

You can create a simple cluster with no service IPs (`ServiceIPRangeSize` set as 0). You can't create a LoadBalancer service in this approach.

   ```powershell
   New-AksEdgeDeployment -JsonConfigString (New-AksEdgeConfig)
   ```

### Allocate resources to your nodes

 To connect to Arc and deploy your apps with GitOps, allocate four CPUs or more for the `LinuxVm.CpuCount` (processing power), 4 GB or more for `LinuxVm.MemoryinMB` (RAM) and to assign a number greater than 0 to the `ServiceIpRangeSize`. Here, we allocate 10 IP addresses for your Kubernetes services:

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
           "ServiceIPRangeSize": 10
       }
   ```

> [!NOTE]
> AKS allocates IP addresses from your internal switch to run your Kubernetes services if you specified a `ServiceIPRangeSize`.

You can also choose to pass the parameters as a JSON string, as previously mentioned:

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

### Create a mixed workload cluster

You can also deploy mixed-workloads clusters. The following example shows how to bring up both Linux and Windows workloads at the same time:

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
           "ServiceIPRangeSize": 10
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

Here is a screenshot showing pods on a K3S cluster.
![Screenshot showing all pods running.](./media/aks-edge/all-pods-running.png)

## Add a Windows worker node (optional)

If you would like to add Windows workloads to an existing Linux only single machine cluster, you can run:

```powershell
Add-AksEdgeNode -NodeType Windows
```

You can also specify parameters such as `CpuCount` and/or `MemoryInMB` for your Windows VM here.

## Next steps

- [Deploy your application](aks-edge-howto-deploy-app.md).
- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
