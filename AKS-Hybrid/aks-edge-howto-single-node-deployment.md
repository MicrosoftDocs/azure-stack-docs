---
title: Single machine Kubernetes
description: Learn how to deploy AKS on a single machine.
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 10/06/2023
ms.custom: template-how-to
---

# Single machine deployment

You can deploy AKS Edge Essentials on either a single machine or on multiple machines. In a single machine Kubernetes deployment, both the Kubernetes control node and worker node run on the same machine. This article describes how to create the Kubernetes control node on your machine on a private network.

## Prerequisites

Set up your primary machine as described in the [Set up machine](aks-edge-howto-setup-machine.md) article.

## Step 1: single machine configuration parameters

You can generate the parameters you need to create a single machine cluster using the following command:

```powershell
New-AksEdgeConfig -DeploymentType SingleMachineCluster -outFile .\aksedge-config.json | Out-Null
```

This command creates a configuration file called **aksedge-config.json** that includes the configuration needed to create a single-machine cluster with a Linux node. The file is created in your current working directory. Refer to the following examples for more options for creating the configuration file. A detailed description of the configuration parameters [is available here](aks-edge-deployment-config-json.md).

The key parameters for single machine deployment are:

- `DeploymentType`: This parameter defines the deployment type and is specified as `SingleMachineCluster`.
- The `Network.NetworkPlugin` by default is `flannel`. This is the default for a K3S cluster. If you're using a K8S cluster, change the CNI to `calico`.
- You can set the following parameters according to your deployment configuration [as described here](aks-edge-deployment-config-json.md): `LinuxNode.CpuCount`, `LinuxNode.MemoryInMB`, `LinuxNode.DataSizeInGB`, `WindowsNode.CpuCount`, `WindowsNode.MemoryInMB`, `Init.ServiceIPRangeSize`, and `Network.InternetDisabled`.

## Step 2: create a single machine cluster

1. You can now run the `New-AksEdgeDeployment` cmdlet to deploy a single-machine AKS Edge cluster with a single Linux control-plane node:

```PowerShell
New-AksEdgeDeployment -JsonConfigFilePath .\aksedge-config.json
```

## Step 3: validate your cluster

Confirm that the deployment was successful by running:

```powershell
kubectl get nodes -o wide
kubectl get pods -A -o wide
```

The following image shows pods on a K3S cluster:

:::image type="content" source="media/aks-edge/all-pods-running.png" alt-text="Screenshot showing all pods running." lightbox="media/aks-edge/all-pods-running.png":::

## Step 4: Add a Windows worker node (optional)

> [!CAUTION]
> Windows worker nodes is an experimental feature in this release. We are actively working on this feature.

If you want to add a Windows node to an existing Linux only single machine cluster, first create the configuration file using the following command:

```powershell
New-AksEdgeScaleConfig -ScaleType AddNode -NodeType Windows -outFile .\ScaleConfig.json | Out-Null
```

This creates the configuration file **ScaleConfig.json** in the current working directory. You can also modify the Windows node parameters in the configuration file to specify the resources that need to be allocated to the Windows node. With the configuration file, you can run the following command to add the node the single machine cluster:

```powershell
Add-AksEdgeNode -JsonConfigFilePath .\ScaleConfig.json
```

## Example deployment options

### Create a JSON object with the configuration parameters

You can programmatically edit the JSON object and pass it as a string:

```powershell
$jsonObj = New-AksEdgeConfig -DeploymentType SingleMachineCluster
$jsonObj.User.AcceptEula = $true
$jsonObj.User.AcceptOptionalTelemetry = $true
$jsonObj.Init.ServiceIpRangeSize = 10
$machine = $jsonObj.Machines[0]
$machine.LinuxNode.CpuCount = 4
$machine.LinuxNode.MemoryInMB = 4096

New-AksEdgeDeployment -JsonConfigString ($jsonObj | ConvertTo-Json -Depth 4)
```

### Create a simple cluster with NodePort service

You can create a simple cluster with no service IPs (`ServiceIPRangeSize` set as 0):

   ```powershell
   New-AksEdgeDeployment -JsonConfigString (New-AksEdgeConfig | ConvertTo-Json -Depth 4)
   ```

### Allocate resources to your nodes

To connect to Arc and deploy your apps with GitOps, allocate four CPUs or more for the `LinuxNode.CpuCount` (processing power), 4 GB or more for `LinuxNode.MemoryinMB` (RAM), and to assign a number greater than 0 to the `ServiceIpRangeSize`. Here, we allocate 10 IP addresses for your Kubernetes services:

```json
{
  "SchemaVersion": "1.5",
  "Version": "1.0",
  "DeploymentType": "SingleMachineCluster",
  "Init": {
    "ServiceIPRangeSize": 10
  },
  "Network": {
      "NetworkPlugin": "flannel"
  },
  "User": {
      "AcceptEula": true,
      "AcceptOptionalTelemetry": true
  },
  "Machines": [
       {
         "LinuxNode": {
              "CpuCount": 4,
              "MemoryInMB": 4096
          }
       }
   ]
}
```

> [!NOTE]
> AKS Edge Essentials allocates IP addresses from your internal switch to run your Kubernetes services if you specified a `ServiceIPRangeSize`.

You can also choose to pass the parameters as a JSON string, as previously described:

   ```powershell
   $jsonObj = New-AksEdgeConfig -DeploymentType SingleMachineCluster
   $jsonObj.User.AcceptEula = $true
   $jsonObj.User.AcceptOptionalTelemetry = $true
   $jsonObj.Init.ServiceIpRangeSize = 10
   $machine = $jsonObj.Machines[0]
   $machine.LinuxNode.CpuCount = 4
   $machine.LinuxNode.MemoryInMB = 4096

   New-AksEdgeDeployment -JsonConfigString ($jsonObj | ConvertTo-Json -Depth 4)
   ```

### Create a mixed workload cluster

You can create a cluster with both Linux and Windows nodes. You can create the configuration file using the command:

```powershell
New-AksEdgeConfig -DeploymentType SingleMachineCluster -NodeType LinuxAndWindows -outFile .\aksedge-config.json | Out-Null
```

Once the configuration file is created, you can deploy your cluster using the following command:

```PowerShell
New-AksEdgeDeployment -JsonConfigFilePath .\aksedge-config.json
```

## Next steps

- [Deploy your application](aks-edge-howto-deploy-app.md).
- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
