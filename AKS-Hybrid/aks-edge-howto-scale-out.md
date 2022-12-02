---
title: AKS-IoT Scale
description: Learn how to scale out your AKS Edge Essentials applications to multiple nodes. 
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/07/2022
ms.custom: template-how-to
---

# Scaling out on multiple nodes

Now that AKS Edge Essentials is installed on your primary machine, this article describes how you can scale out your cluster to secondary machines to create a multi-node deployment. Remember to specify the [workload type](./aks-edge-concept.md) and [reserve enough memory for each node](./aks-edge-concept.md).

## 1. Get cluster configuration from your primary machine

- On your primary machine on which you created your full deployment, run the following steps in an elevated PowerShell window. To add a Linux-only worker node, specify the `NodeType` as Linux, and provide a unique IP address for the Linux node:

   ```powershell
   $params = @{
       NodeType = "Linux"
       LinuxIp = "192.168.1.173"
       ourFile = ".\LinuxWorkerNodeConfig.json"
   }
   $workernodeConfig = New-AksEdgeScaleConfig @params
   ```
![Screenshot showing the creation of config file.](./media/aks-edge/scale-config-file.png)
- To add a Linux control plane node, specify the `NodeType` as Linux, set the `ControlPlane` flag as true, and provide a unique IP address for the Linux node:

   ```powershell
   $params = @{
       NodeType = "Linux"
       ControlPlane = $true
       LinuxIp = "192.168.1.173"
       ourFile = ".\LinuxWorkerNodeConfig.json"
   }
   $workernodeConfig = New-AksEdgeScaleConfig @params
   ```

- To add a Windows-only worker node, specify the `NodeType` as Windows and provide a unique IP address for the Linux node:

   ```powershell
   $params = @{
       NodeType = "Windows"
       WindowsIp = "192.168.1.174"
       ourFile = ".\WindowsWorkerNodeConfig.json"
   }
   $workernodeConfig = New-AksEdgeScaleConfig @params
   ```

- To add a Linux and Windows worker node, specify the `NodeType` as `LinuxAndWindows` and provide a unique IP address for both the Linux and Windows node as shown below.

   ```powershell
   $params = @{
       NodeType = "LinuxAndWindows"
       LinuxIp = "192.168.1.173"
       WindowsIp = "192.168.1.174"
       ourFile = ".\LinuxAndWindowsWorkerNodeConfig.json"
   }
   $workernodeConfig = New-AksEdgeScaleConfig @params
   ```

- To add a Linux Control plane node and Windows worker node, specify the `NodeType` as `LinuxAndWindows`, set the `ControlPlane` flag as true and provide a unique IP address for both the Linux and Windows node as shown below.

   ```powershell
   $params = @{
       NodeType = "LinuxAndWindows"
       LinuxIp = "192.168.1.173"
       ControlPlane = $true
       WindowsIp = "192.168.1.174"
       ourFile = ".\LinuxAndWindowsWorkerNodeConfig.json"
   }
   $workernodeConfig = New-AksEdgeScaleConfig @params
   ```

This command returns a JSON string and also stores the JSON content in the **.\ScaleConfig.json** file. This command also exports the necessary data to join a cluster in the JSON format.

## 2. Bring up a node on your secondary machine

Now you're ready to bring up clusters on your secondary machines. You cannot mix different Kubernetes distributions among your clusters. If the cluster on your primary machine is running **k8s**, you must install the **k8s** msi on the secondary machines as well.

>[!NOTE]
> The only supported setting is to have an odd number of control plane nodes. Therefore, if you want to scale up/down your control plane, make sure you have one, three, or five control plane nodes.

> [!NOTE]
> In this release, there is a known issue with automatic creation of external switch with the `New-AksEdgeDeployment` command if you are using a Wi-fi adapter for the switch. In this case, first create the external switch using the Hyper-V manager - Virtual Switch Manager and map the switch to the Wi-fi adapter and then provide the switch details in your configuration JSON as described below.

![Screenshot of Hyper-v switch manager](./media/aks-edge/hyper-v-external-switch.png)

To deploy the corresponding node on the secondary machine, you can now use the **ScaleConfig.json** file created in the previous step:

```powershell
New-AksEdgeDeployment -JsonConfigFilePath .\ScaleConfig.json
```
>[!NOTE]
> 
## 3. Validate your cluster setup

On any node in the cluster, run the following cmdlet:

```powershell
kubectl get nodes -o wide
```

You should be able to see all the nodes of the cluster. 

![Screenshot showing multiple nodes.](./media/aks-edge/aks-edge-multi-nodes.png)

## 4. Add more nodes

Using the **.\ScaleConfig** file as your reference configuration file, you can add more nodes to your Kubernetes cluster. Ensure that you provide IP addresses that are available in your network in the VM block of parameters
```json
"LinuxVm": {
    "CpuCount": 2,
    "MemoryInMB": 2048,
    "DataSizeInGB": 10,
    "Ip4Address": "<provide a free IP address>",
    "MacAddress": null,
    "Mtu": 0
  },
```

## Next steps

- [Deploy your application](aks-edge-howto-deploy-app.md) or [connect to Arc](aks-edge-howto-connect-to-arc.md)
- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
