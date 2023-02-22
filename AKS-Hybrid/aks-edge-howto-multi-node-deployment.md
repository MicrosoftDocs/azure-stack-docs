---
title: AKS Edge Essentials full Kubernetes
description: Describes how to create a cluster with multiple machines.
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 02/13/2023
ms.custom: template-how-to
---

# Full Kubernetes deployments in AKS Edge Essentials

> [!CAUTION]
> Full deployment on multiple machines is an experimental feature at this point. We are actively working on this and will have an update soon.

You can configure the AKS cluster to run on multiple machines to support a distributed microservices architecture. AKS Edge Essentials is for static configurations and doesn't enable dynamic VM creation/deletion or cluster lifecycle management, unlike AKS in the cloud or AKS HCI. AKS Edge Essentials has only one Linux VM per each machine, along with a Windows VM if needed. Each VM has a static allocation of RAM, storage, and physical CPU cores assigned at install time. In a multi-node deployment, one of the machines is the primary machine with Kubernetes control node, and the other machines will be secondary machines with the worker nodes. In this deployment scenario, we'll configure the K8S cluster using an external switch. With this configuration you can run `kubectl` from another machine on your network, evaluate your workload performance on an external switch, etc.  

## Prerequisites

Set up your machine as described in the [Set up machine](aks-edge-howto-setup-machine.md) article.

## 1. Full Kubernetes deployment configuration parameters

The parameters needed to create a scalable cluster can be generated using the following command:

```powershell
New-AksEdgeConfig -DeploymentType ScalableCluster -outFile .\aksedge-config.json | Out-Null
```

This creates a configuration file called `aksedge-config.json` which includes the configurations needed to create a scalable cluster with a Linux node. The file is created in your current working directory. Refer to the examples below for more options on creating the configuration file. A detailed description of the configuration parameters [is available here](aks-edge-deployment-config-json.md).

The key parameters to note for a scalable Kubernetes deployment are:

- **External switch information** - A full deployment uses an external switch to enable communication across the nodes. You must specify the `MachineConfigType.NetworkConnection.AdapterName` as either `Ethernet` or `Wi-Fi`.

    ```powershell
    # get the list of available adapters in the machine
    Get-NetAdapter -Physical | Where-Object { $_.Status -eq 'Up' }
    ```

    If you've created an external switch on your Hyper-V, you can choose to specify the vswitch details in your configuration file. If you don't create an external switch in Hyper-V manager and run the `New-AksEdgeDeployment` command, AKS edge automatically creates an external switch named `aksedgesw-ext` and uses that for your deployment.

    > [!NOTE]
    > In this release, there is a known issue with automatic creation of an external switch with the `New-AksEdgeDeployment` command if you are using a **Wi-Fi** adapter for the switch. In this case, first create the external switch using the Hyper-V manager - Virtual Switch Manager, map the switch to the Wi-fi adapter, and then provide the switch details in your configuration JSON as described below.

    ![Screenshot of Hyper-v switch manager.](./media/aks-edge/hyper-v-external-switch.png)

- **IP addresses**:  You must allocate free IP addresses from your network for the **Control Plane**, **Kubernetes services**, and **Nodes (VMs)**. Read the [AKS Edge Essentials Networking](./aks-edge-concept-networking.md) overview for more details. For example, in local networks with the 192.168.1.0/24 IP address range, 1.151 and above are outside of the DHCP scope, and therefore are guaranteed to be free. AKS Edge Essentials currently supports IPv4 addresses only. You can use the [AksEdge-ListUsedIPv4s](https://github.com/Azure/AKS-Edge/blob/main/tools/scripts/network/AksEdge-ListUsedIPv4s.ps1) script from the [GitHub repo](https://github.com/Azure/AKS-Edge) to view IPs that are currently in use, to avoid using those IP addresses in your configuration. The following parameters will need to be provided in the `Network` section of the configuration file -  `ControlPlaneEndpointIp`, `Ip4GatewayAddress`, `Ip4PrefixLength`, `ServiceIPRangeSize`, `ServiceIPRangeStart` and `DnsServers`.
- The `Network.NetworkPlugin` by default is `flannel`. Flannel is the default CNI for a K3S cluster. In K8S cluster change the `NetworkPlugin` to `calico`.
- In addition to the above, the following parameters can be set according to your deployment configuration as described [here](aks-edge-deployment-config-json.md)  -  `LinuxNode.CpuCount`, `LinuxNode.MemoryInMB`, `LinuxNode.DataSizeInGB`,  `LinuxNode.Ip4Address`, `WindowsNode.CpuCount`, `WindowsNode.MemoryInMB`, `WindowsNode.Ip4Address`, `Init.ServiceIPRangeSize`,  `Network.InternetDisabled`.

## 2. Validate the configuration file

After you update the **aksedge-config.json** file, open the [AksEdgePrompt](https://github.com/Azure/AKS-Edge/blob/main/tools/AksEdgePrompt.cmd). This tool opens an elevated PowerShell window with the modules loaded. Now run the following command to validate your network parameters using the `Test-AksEdgeNetworkParameters` cmdlet:

```powershell
Test-AksEdgeNetworkParameters -JsonConfigFilePath .\aksedge-config.json
```

## 3. Create a full deployment cluster

If `Test-AksEdgeNetworkParameters` returns true, you're ready to create your deployment. You can create your deployment using the `New-AksEdgeDeployment` cmdlet:

```powershell
New-AksEdgeDeployment -JsonConfigFilePath .\aksedge-config.json
```

The `New-AksEdgeDeployment` cmdlet automatically gets the kubeconfig file.

## 4. Validate your deployment

```powershell
kubectl get nodes -o wide
kubectl get pods --all-namespaces -o wide
```

A screenshot of a Kubernetes cluster is shown below:

![Diagram showing all pods running.](./media/aks-edge/all-pods-running.png)

## 5. Add a Windows worker node (optional)

If you want to add Windows node to an existing Linux only machine, you can run:

```powershell
New-AksEdgeScaleConfig -ScaleType AddNode -NodeType Windows -WindowsNodeIp "xxx" -outFile .\ScaleConfig.json | Out-Null
```

You can also specify parameters such as `CpuCount` and/or `MemoryInMB` for your Windows VM here.

You can use the generated configuration file and run the following command to add the Windows node

```powershell
Add-AksEdgeNode -JsonConfigFilePath .\ScaleConfig.json
```

## Example configurations for different deployment options

### Allocate resources to your nodes

To connect to Arc and deploy your apps with GitOps, allocate four CPUs or more for the `LinuxNode.CpuCount` (processing power), 4 GB or more for `LinuxNode.MemoryinMB` (RAM), and assign a number greater than 0 to `ServiceIpRangeSize`. Here, we allocate 10 IP addresses for your Kubernetes services:

```json
    "Init": {
        "ServiceIpRangeSize": 10,
        "ServiceIPRangeStart": "192.168.1.151"
    },
    "Network": {
        "ControlPlaneEndpointIp": "192.168.1.191",
        "NetworkPlugin": "calico",
        "Ip4GatewayAddress": "192.168.1.1",
        "Ip4PrefixLength": 24,
        "DnsServers": ["192.168.1.1"]
    },
    "Machines": [
        {
            "NetworkConnection": {
                "AdapterName": "Ethernet"
            },
            "LinuxNode": {
                "CpuCount": 4,
                "MemoryInMB": 4096,
                "DataSizeInGB": 20,
                "Ip4Address": "192.168.1.171"
            }
        }
    ]
```

### Create Linux and Windows node

To run both the Linux control plane and the Windows worker node on a machine, create the configuration file using the following command:

```powershell
New-AksEdgeConfig -DeploymentType ScalableCluster -NodeType LinuxAndWindows -outFile .\aksedge-config.json | Out-Null
```

Create the deployment using the command:

```powershell
New-AksEdgeDeployment -JsonConfigFilePath .\aksedge-config.json
```

```json
    "Machines": [
        {
            "NetworkConnection": {
                "AdapterName": "Ethernet"
            },
            "LinuxNode": {
                "CpuCount": 4,
                "MemoryInMB": 4096,
                "DataSizeInGB": 20,
                "Ip4Address": "192.168.1.171"
            },
            "WindowsNode": {
                "CpuCount": 2,
                "MemoryInMB": 4096,
                "Ip4Address": "192.168.1.172"
            }
        }
    ]
```

## Next steps

- [Deploy your application](aks-edge-howto-deploy-app.md).
- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
