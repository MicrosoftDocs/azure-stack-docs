---
title: AKS-IoT Scale
description: Learn how to scale out your AKS lite applications to multiple nodes. 
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/07/2022
ms.custom: template-how-to
---

# Scaling out on multiple nodes

Now that AKS on Windows IoT is installed on your primary machine, this article describes how you can scale out your cluster to secondary machines to create a multi-node deployment. Remember to specify the [workload type](./aks-lite-concept.md) and [reserve enough memory for each node](./aks-lite-concept.md).

## 1. Get cluster configuration from your primary machine

- On your primary machine on which you created your full deployment, run the following steps in an elevated PowerShell window. To add a Linux-only worker node, specify the `WorkloadType` as Linux, and provide a unique IP address for the Linux node:

   ```powershell
   $params = @{
       WorkloadType = "Linux"
       LinuxIp = "192.168.1.173"
       ourFile = ".\LinuxWorkerNodeConfig.json"
   }
   $workernodeConfig = Export-AksEdgeWorkerNodeConfig @params
   ```

- To add a Linux control plane node, specify the `WorkloadType` as Linux, set the `ControlPlane` flag as true, and provide a unique IP address for the Linux node:

   ```powershell
   $params = @{
       WorkloadType = "Linux"
       ControlPlane = $true
       LinuxIp = "192.168.1.173"
       ourFile = ".\LinuxWorkerNodeConfig.json"
   }
   $workernodeConfig = Export-AksEdgeWorkerNodeConfig @params
   ```

- To add a Windows-only worker node, specify the `WorkloadType` as Windows and provide a unique IP address for the Linux node:

   ```powershell
   $params = @{
       WorkloadType = "Windows"
       WindowsIp = "192.168.1.174"
       ourFile = ".\WindowsWorkerNodeConfig.json"
   }
   $workernodeConfig = Export-AksEdgeWorkerNodeConfig @params
   ```

- To add a Linux and Windows worker node, specify the `WorkloadType` as `LinuxAndWindows` and provide a unique IP address for both the Linux and Windows node as shown below.

   ```powershell
   $params = @{
       WorkloadType = "LinuxAndWindows"
       LinuxIp = "192.168.1.173"
       WindowsIp = "192.168.1.174"
       ourFile = ".\LinuxAndWindowsWorkerNodeConfig.json"
   }
   $workernodeConfig = Export-AksEdgeWorkerNodeConfig @params
   ```

- To add a Linux Control plane node and Windows worker node, specify the `WorkloadType` as `LinuxAndWindows`, set the `ControlPlane` flag as true and provide a unique IP address for both the Linux and Windows node as shown below.

   ```powershell
   $params = @{
       WorkloadType = "LinuxAndWindows"
       LinuxIp = "192.168.1.173"
       ControlPlane = $true
       WindowsIp = "192.168.1.174"
       ourFile = ".\LinuxAndWindowsWorkerNodeConfig.json"
   }
   $workernodeConfig = Export-AksEdgeWorkerNodeConfig @params
   ```

This command returns a JSON string and also stores the JSON content in the **.\*WorkerNodeConfig.json** file. This command also exports the necessary data to join a cluster in the JSON format.

## 2. Bring up a node on your secondary machine

Now you're ready to bring up clusters on your secondary machines. You cannot mix different Kubernetes distributions among your clusters. If the cluster on your primary machine is running **k8s**, you must install the **k8s** msi on the secondary machines as well.

>[!NOTE]
> The only supported setting is to have an odd number of control plane nodes. Therefore, if you want to scale up/down your control plane, make sure you have one, three, or five control plane nodes.

To deploy the corresponding node on the secondary machine, you can now use the **WorkerNodeConfig.json** file created in the previous step:

```powershell
New-AksEdgeDeployment -JsonConfigFilePath .\WorkerNodeConfig.json
```

## 3. Validate your cluster setup

On any node in the cluster, run the following cmdlet:

```powershell
kubectl get nodes -o wide
```

You should be able to see all the nodes of the cluster. 

![Screenshot showing multiple nodes.](./media/aks-lite/aks-lite-multi-nodes.png)

## Next steps

- [Deploy your application](aks-lite-howto-deploy-app.md) or [connect to Arc](aks-lite-howto-connect-to-arc.md)
- [Overview](aks-lite-overview.md)
- [Uninstall AKS cluster](aks-lite-howto-uninstall.md)
