---
title: AKS Edge Essentials full Kubernetes
description: Describes how to create a cluster with multiple machines.
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 12/05/2022
ms.custom: template-how-to
---

# Full Kubernetes deployments in AKS Edge Essentials

The AKS cluster can be configured to run on multiple machines to support a distributed microservices architecture. Unlike other AKS products, such as AKS in the cloud or AKS on HCI on-premises that have multiple VMs, AKS Edge Essentials is intended for static configurations and does not enable dynamic VM creation/deletion or cluster lifecycle management. AKS Edge Essentials has only one Linux VM per each machine, along with a Windows VM if needed, each with a static allocation of RAM, storage, and physical CPU cores assigned at install time. In a multi-node deployment, one of the machines is the primary machine with Kubernetes control node, and the other machines will be secondary machines with the worker nodes. In this deployment scenario, we will configure the K8S cluster using an external switch. With this configuration you can run `kubectl` from another machine on your network, evaluate your workload performance on an external switch, etc.  

## Prerequisites

Set up your machine as described in the [Set up machine](aks-edge-howto-setup-machine.md) article.

## Key configuration parameters for a full Kubernetes deployment

The parameters needed to create a full Kubernetes are defined in the **aksedge-config.json** file in the downloaded GitHub folder. A detailed description of the configuration parameters [is available here](aks-edge-deployment-config-json.md).

| Attribute | Value type      |Default Value|  Description |
| :------------ |:-----------|:-------|:--------|
|SingleMachineCluster |Boolean| `false`|Set this flag to `false` for full Kubernetes deployments.|
| NodeType | String | Linux | Creates the VM to host the control plane components and act as a worker. Read more about [AKS Edge Essentials node types](aks-edge-concept.md). |
| Network.Vswitch.Name | String |aksedge-switch| Name of the external switch used for AKS Edge Essentials. You can create one yourself using Hyper-V manager. If you do not specify a switch name, AKS Edge Essentials creates one for you. |
|Network.Vswitch.Type| String|External | Type of network switch - External.|
|Network.Vswitch.Adapter (Required) |String| "Ethernet"| Name of network adapter - Ethernet or Wi-Fi. |
| NetworkPlugin |String| calico or flannel | Name of the Kubernetes network plugin. Defaults to `flannel`. For Kubernetes clusters, only `calico` is supported.|
| ControlPlaneEndpointIp |IP Address| A.B.C.x | A free IP address on your subnet **A.B.C**. The control plane (API server) gets this address. |
| ServiceIPRangeStart |IP Address| A.B.C.x | Reserved IP start address for your Kubernetes services. This IP range must be free on your subnet **A.B.C**. |
| ServiceIPRangeEnd |IP Address| A.B.C.x | Reserved IP start address for your Kubernetes services. This IP range must be free on your subnet **A.B.C**.  |
| Ip4PrefixLength |Integer| number | The IP address subnet **A.B.C** prefix length. For example, use **24** if your network is **192.168.1.0/24**. |
| Ip4GatewayAddress | IP Address|A.B.C.1 | Gateway address; typically the router address. |
| DnsServers | IP Address|A.B.C.1 | IP address of your DNS (typically the router address). To view what DNS your machine uses, issue the following command: `ipconfig /all \| findstr /R "DNS\ Servers"`. |
| LinuxVmIp4Address |IP Address| A.B.C.x | Specify the IP address your Linux VM will take. |

Note the following considerations:

- The parameter that identifies a full deployment cluster is the `singlemachinecluster` flag, which must be set to `false`.
- **External switch information** - A full deployment uses an external switch to enable communication across the nodes. You must specify the adapter name as `Ethernet` or `Wi-Fi`. If you've created an external switch on your Hyper-V, you can choose to specify the vswitch details in your **aksedge-config.json** file. If you do not create an external switch in Hyper-V manager and run the deployment command below, AKS edge automatically creates an external switch named `aksedgesw-ext` and uses that for your deployment.

    > [!NOTE]
    > In this release, there is a known issue with automatic creation of an external switch with the `New-AksEdgeDeployment` command if you are using a **Wi-Fi** adapter for the switch. In this case, first create the external switch using the Hyper-V manager - Virtual Switch Manager, map the switch to the Wi-fi adapter, and then provide the switch details in your configuration JSON as described below.

    ![Screenshot of Hyper-v switch manager.](./media/aks-edge/hyper-v-external-switch.png)

- **IP addresses**:  You must allocate free IP addresses from your network for the **Control Plane**, **Kubernetes services**, and **Nodes (VMs)**. Read the [AKS Edge Essentials Networking](aks-edge-concept.md) overview for more details. For example, in local networks with the 192.168.1.0/24 IP address range, 1.151 and above are outside of the DHCP scope, and therefore are guaranteed to be free. AKS Edge Essentials currently supports IPv4 addresses only. You can use the [AksEdge-ListUsedIPv4s](https://github.com/Azure/AKS-Edge/blob/main/tools/scripts/network/AksEdge-ListUsedIPv4s.ps1) script that is included in the [GitHub repo](https://github.com/Azure/AKS-Edge) to view IPs that are currently in use, so you can avoid using those IP addresses in your configuration.

## Validate the configuration file

After you update the **aksedge-config.json** file, open the [AksEdgePrompt](https://github.com/Azure/AKS-Edge/blob/main/tools/AksEdgePrompt.cmd). This tool opens an elevated PowerShell window with the modules loaded. Now run the following command to validate your network parameters using the `Test-AksEdgeNetworkParameters` cmdlet:

```powershell
Test-AksEdgeNetworkParameters -JsonConfigFilePath .\aksedge-config.json
```

## Create a full deployment cluster

If `Test-AksEdgeNetworkParameters` returns true, you are ready to create your deployment. You can create your deployment using the `New-AksEdgeDeployment` cmdlet:

```powershell
New-AksEdgeDeployment -JsonConfigFilePath .\aksedge-config.json
```

The `New-AksEdgeDeployment` cmdlet automatically gets the kubeconfig file.

## Validate your deployment

```powershell
kubectl get nodes -o wide
kubectl get pods --all-namespaces -o wide
```

A screenshot of a Kubernetes cluster is shown below:

![Diagram showing all pods running.](./media/aks-edge/all-pods-running.png)


## Example configurations for different deployment options

### Create your own configuration file

You can create your own configuration file using the `New-AksEdgeConfig` command:

```powershell
$jsonString = New-AksEdgeConfig .\mydeployconfig.json
```

You can now update your configuration file **mydeployconfig.json** with the right set of values. Some of the sample values are as follows:

```json
"DeployOptions": {
    "NetworkPlugin": "flannel",
    "SingleMachineCluster": false,
    "TimeoutSeconds": 900,
    "NodeType": "Linux"
},
"EndUser": {
    "AcceptEula": false,
    "AcceptOptionalTelemetry": false
},
"LinuxVm": {
    "CpuCount": 4,
    "MemoryInMB": 4096,
    "DataSizeinGB": 20,
    "Ip4Address": "192.168.1.171"
},
"Network": {
    "VSwitch":{
        "Name": "aksedgesw-ext",
        "Type":"External",
        "AdapterName" : "Ethernet"
    },
    "ControlPlaneEndpointIp": "192.168.1.191",
    "Ip4GatewayAddress": "192.168.1.1",
    "Ip4PrefixLength": 24,
    "ServiceIPRangeStart": "192.168.1.151",
    "ServiceIPRangeEnd": "192.168.1.170",
    "DnsServers": ["192.168.1.1"]
}
```

### Allocate resources to your nodes

To connect to Arc and deploy your apps with GitOps, allocate four CPUs or more for the `LinuxVm.CpuCount` (processing power), 4 GB or more for `LinuxVm.MemoryinMB` (RAM), and assign a number greater than 0 to `ServiceIpRangeSize`. Here, we allocate 10 IP addresses for your Kubernetes services:

```json
 "LinuxVm": {
        "CpuCount": 4,
        "MemoryInMB": 4096,
        "DataSizeinGB": 20,
        "Ip4Address": "192.168.1.171"
    },
    "WindowsVm": {
        "CpuCount": 2,
        "MemoryInMB": 4096,
        "DataSizeinGB": 20,
        "Ip4Address": "192.168.1.172"
    },
"Network": {
    "VSwitch":{
        "Name": "aksedgesw-ext",
        "Type":"External",
        "AdapterName" : "Ethernet"
    },
    "ControlPlaneEndpointIp": "192.168.1.191",
    "Ip4GatewayAddress": "192.168.1.1",
    "Ip4PrefixLength": 24,
    "ServiceIpRangeSize":10,
    "ServiceIPRangeStart": "192.168.1.151",
    "ServiceIPRangeEnd": "192.168.1.160",
    "DnsServers": ["192.168.1.1"]
}
```

### Create Linux and Windows node

To run both the Linux control plane and the Windows worker node on a machine:

```json
"DeployOptions": {
    "ControlPlane": false,
    "Headless": false,
    "JoinCluster": false,
    "NetworkPlugin": "flannel",
    "SingleMachineCluster": false,
    "TimeoutSeconds": 300,
    "NodeType": "LinuxAndWindows",
    "ServerTLSBootstrap": false
  },
  "EndUser": {
    "AcceptEula": false,
    "AcceptOptionalTelemetry": false
  },
  "LinuxVm": {
    "CpuCount": 2,
    "MemoryInMB": 2048,
    "DataSizeInGB": 10,
    "Ip4Address": "192.168.1.171",
    "MacAddress": null,
    "Mtu": 0
  },
  "WindowsVm": {
    "CpuCount": 2,
    "MemoryInMB": 2048,
    "Ip4Address": "192.168.1.172",
    "MacAddress": null,
    "Mtu": 0
  },
```

## Add a Windows worker node (optional)

If you want to add Windows workloads to an existing Linux only cluster, you can run:

```powershell
Add-AksEdgeNode -NodeType Windows
```

You can also specify parameters such as `CpuCount` and/or `MemoryInMB` for your Windows VM here.

## Next steps

- [Deploy your application](aks-edge-howto-deploy-app.md).
- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
