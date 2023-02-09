---
title: AKS Edge Essentials deployment configuration JSON parameters
description: Description of deployment configuration JSON parameters.
author: yujinkim-msft
ms.author: yujinkim
ms.topic: conceptual
ms.date: 02/02/2023
ms.custom: template-concept
---

# Deployment configuration JSON parameters

This page describes the AKS Edge Essentials deployment schema used in the `aksedge-config.json`.

You can find the complete schema json file at `C:\Program Files\AksEdge\aksedge-dcschema.json`

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `SchemaVersion` |`1.5`|Specifies the version of the schema/format of the json | `1.5` |
| `Version` |`1.0`|Specifies the version of the json instance | `1.0` |
| `DeploymentType` |[`SingleMachineCluster` / `ScalableCluster`]| Specifies deployment type. Only in `ScalableCluster`, you can add additional machines to the cluster infrastructure | `SingleMachineCluster` |
| `Init.ServiceIPRangeStart` |IPv4 address `A.B.C.x`|Reserved IP start address for your Kubernetes services. This IP range must be free on your subnet **A.B.C.0**| None |
| `Init.ServiceIPRangeSize` |`[0-127]`|Number of reserved IP start addresses for your Kubernetes services. Based on the size, we will allocate a range of free IP addresses on your subnet | `0` |
| `Join.ClusterJoinToken` |String|`Reserved` | None |
| `Join.DiscoveryTokenHash` |String|`Reserved`| None |
| `Join.CertificateKey` |String|`Reserved`| None |
| `Join.ClusterId` |String|`Reserved`| None |
| `Arc.ClusterName` |String|Preferred name for the cluster to show in the Azure portal| `<Machinename>-cluster` |
| `Arc.Location` |String|Location of resource group| None |
| `Arc.ResourceGroupName` |String|Resource group name| None |
| `Arc.SubscriptionId` |GUID|Azure subscription ID| None |
| `Arc.TenantId` |GUID| TenantID for the Azure subscription| None |
| `Arc.ClientId` |GUID| AppID of the service principal| None |
| `Arc.ClientSecret` |String|Secret associated with the Service Principal| None |
| `Network.ControlPlaneEndpointIp` |IPv4 address `A.B.C.x`|A free IP address on your subnet **A.B.C**. The control plane (API server) gets this address. |  |
| `Network.NetworkPlugin` |[`calico` / `flannel`]|CNI plugin choice for the Kubernetes network model. For K8s cluster, always use `calico` and for K3s cluster, always use `flannel`.|  `flannel`|
| `Network.Ip4GatewayAddress` |IPv4 address `A.B.C.x`|Gateway address; typically the router address.|    |
| `Network.Ip4PrefixLength` |`[1-31]`|The IP address subnet **A.B.C** prefix length. For example, use **24** if your network is **192.168.1.0/24**.| `24`|
| `Network.DnsServers` |IPv4 address `A.B.C.x` |IP address of your DNS (typically the router address). To view what DNS your machine uses, issue the command `Get-DnsClientServerAddress -AddressFamily IPv4`.  | |
| `Network.InternetDisabled` |Boolean|Whether your cluster has access to the internet. The default is `false`, meaning your cluster by default has access to the internet.|  `false`|
| `Network.SkipAddressFreeCheck` |Boolean|Ignores IP Address check failures and continues with deployment.|  `false`|
| `Network.Proxy.Http` |String | HttpProxy link. |
| `Network.Proxy.Https` |String | HttpsProxy link. |
| `Network.Proxy.No` |String | No proxy config for bypassing the proxy. |
| `User.AcceptEula` | Boolean | Accept or decline the [EULA](https://github.com/Azure/AKS-Edge/blob/main/EULA.md) | `false` |
| `User.AcceptOptionalTelemetry` | Boolean | Accept or decline the `optional` telemetry. The `required` telemetry is enabled always. | `false` |
| `Machines[].ArcHybridComputeMachineId` |String | `Reserved` | `null` |
| `Machines[].NetworkConnection.AdapterName` |String | NetAdapterName for VSwitch. It is mandatory for a full Kubernetes deployment. You can run the PowerShell `Get-NetAdapter -Physical` command to view the `Name` column for the adapter of your choice. |
| `Machines[].NetworkConnection.Mtu` | Number | The maximum transmission unit (MTU) for the network | `0` |
| `Machines[].LinuxNode.ControlPlane` | Boolean | Specify whether you want this new deployment to be a control plane. If `false`, it will be a worker node. *Only for Linux VM*| `false` |
| `Machines[].LinuxNode.CpuCount` | [`2-x`] | Number of CPU cores reserved for VM/VMs. | `2` |
| `Machines[].LinuxNode.MemoryInMB` | [`2048-2x`] | RAM in MBs reserved for VM/VMs. | `2048` |
| `Machines[].LinuxNode.DataSizeInGB` | Number | Size of the data partition. For large applications, we recommend increasing this number. *Only for Linux VM* | `10` |
| `Machines[].LinuxNode.Ip4Address` | `A.B.C.x` | Specify the IP address your VM will take. |
| `Machines[].LinuxNode.MacAddress` |`00:00:00:00:00:00` | Specify the Mac address your VM will take. |
| `Machines[].LinuxNode.TimeoutSeconds` | Number | Timeout provided for the kubernetes cluster to complete the bootstrap process. It's recommended that you use the default value. | `300` |
| `Machines[].WindowsNode.CpuCount` | [`2-x`] | Number of CPU cores reserved for VM/VMs. | `2` |
| `Machines[].WindowsNode.MemoryInMB` | [`2048-2x`] | RAM in MBs reserved for VM/VMs (multiples of 2). | `2048` |
| `Machines[].WindowsNode.Ip4Address` | `A.B.C.x` | Specify the IP address your VM will take. |
| `Machines[].WindowsNode.MacAddress` |`00:00:00:00:00:00` | Specify the Mac address your VM will take. |
| `Machines[].WindowsNode.TimeoutSeconds` | Number | Timeout provided for the kubernetes cluster to complete the bootstrap process. It's recommended that you use the default value. | `900` |

## Next steps

- [AKS Edge Essentials nodes and clusters](./aks-edge-concept-clusters-nodes.md)
- [Set up your machine](./aks-edge-howto-setup-machine.md)
