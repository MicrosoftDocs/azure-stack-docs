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

## Prerequisites

Set up your primary machine as described in the [Set up machine](aks-edge-howto-setup-machine.md) article.

## 1. Single machine configuration parameters

The parameters needed to create a single machine cluster can be generated using the following command:

```powershell
New-AksEdgeConfig -DeploymentType SingleMachineCluster -outFile ./aksedge-config.json
```

This creates a configuration file called `aksedge-config.json` which includes the configurations needed to create a single-machine cluster with a Linux node. The file is created in your current working directory. Refer to the examples below for more options on creating the configuration file. A detailed description of the configuration parameters [is available here](aks-edge-deployment-config-json.md).

The key parameters for single machine deployment are:

- `DeploymentType` - This parameter defines the deployment type and is specified as `SingleMachineCluster`. 
- The `Network.NetworkPlugin` by default is `flannel`. This is the default for a K3S cluster. If you're using a K8S cluster change the CNI to `calico`. 
- The following parameters can be set according to your deployment configuration [as described here](aks-edge-deployment-config-json.md)  `LinuxVm.CpuCount`, `LinuxVm.MemoryInMB`, `LinuxVm.DataSizeInGB`, `WindowsVm.CpuCount`, `WindowsVm.MemoryInMB`, `Network.ServiceIPRangeSize`, `Network.InternetDisabled`.

## 2. Create a single machine cluster

1. You can now run the `New-AksEdgeDeployment` cmdlet to deploy a single-machine AKS Edge cluster with a single Linux control-plane node:

```PowerShell
New-AksEdgeDeployment -JsonConfigFilePath ./aksedge-config.json
```

## 3. Validate your cluster

Confirm that the deployment was successful by running:

```powershell
kubectl get nodes -o wide
kubectl get pods -A -o wide
```

The following image shows pods on a K3S cluster:

![Screenshot showing all pods running.](./media/aks-edge/all-pods-running.png)

## 4. Add a Windows worker node (optional)

If you want to add Windows node to an existing Linux only single machine cluster, first create the configuration file using the following command:

```powershell
New-AksEdgeScaleConfig -ScaleType AddNode -NodeType Windows -outFile ./ScaleConfig.json
```

This creates the configuration file `ScaleConfig.json` in the current working directory. You can also modify the Windows node parameters in the configuration file to specify the resources that needs to be allocated to the Windows node. With the configuration file, you can run the following command to add the node the single machine cluster.

```powershell
Add-AksEdgeNode -JsonConfigFilePath ./ScaleConfig.json
```

## Example deployment options

### Create a JSON object with the configuration parameters

You can programmatically edit the JSON object and pass it as a string:

```powershell
$jsonString = New-AksEdgeConfig -DeploymentType SingleMachineCluster
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
    {
      "SchemaVersion": "1.4",
      "Version": "1.0",
      "DeploymentType": "SingleMachineCluster",
      "Init": {
        "ServiceIPRangeSize": 10
      },
       "Network": {
           "NetworkPlugin": "flannel",
       },
       "EndUser": {
           "AcceptEula": true,
           "AcceptOptionalTelemetry": true
       },
       "LinuxVm": {
           "CpuCount": 4,
           "MemoryInMB": 4096
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

You can also create a cluster with both Linux and Windows node. You can create the configuration file using the command: 

```powershell
New-AksEdgeConfig -DeploymentType SingleMachineCluster -NodeType LinuxAndWindows
```
Once the configuration file is created, you can deploy your cluster using:
```PowerShell
New-AksEdgeDeployment -JsonConfigFilePath ./aksedge-config.json
```
## Next steps

- [Deploy your application](aks-edge-howto-deploy-app.md).
- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
