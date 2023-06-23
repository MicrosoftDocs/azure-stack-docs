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

| Attribute | Value type      |  Description |  Default value |   Applicable deployment types   |
| :------------ |:-----------|:------------------|:--------|:------------|
| `SchemaVersion` |String|Specifies the version of the schema/format of the json | `1.6` |Single-machine and <br> full deployment|
| `Version` |`1.0`|Specifies the version of the json instance | `1.0` |Single-machine and <br> full deployment|
| `DeploymentType` |[`SingleMachineCluster` / `ScalableCluster`]| Specifies deployment type. Only in `ScalableCluster`, you can add additional machines to the cluster infrastructure | `SingleMachineCluster` |Single-machine and <br> full deployment|
| `Init.ServiceIPRangeStart` |IPv4 address `A.B.C.x`|Reserved IP start address for your Kubernetes services. This IP range must be free on your subnet **A.B.C.0**| None |Single-machine and <br> full deployment|
| `Init.ServiceIPRangeSize` |`[0-127]`|Number of reserved IP start addresses for your Kubernetes services. Based on the size, we will allocate a range of free IP addresses on your subnet | `0` |Single-machine and <br> full deployment|
| `Join.ClusterJoinToken` |String|`Reserved` | None |Full deployment only|
| `Join.DiscoveryTokenHash` |String|`Reserved`| None |Full deployment only|
| `Join.CertificateKey` |String|`Reserved`| None |Full deployment only|
| `Join.ClusterId` |String|`Reserved`| None |Full deployment only|
| `Arc.ClusterName` |String|Preferred name for the cluster to show in the Azure portal| `<Machinename>-cluster` |Single-machine and <br> full deployment|
| `Arc.Location` |String|Location of resource group| None |Single-machine and <br> full deployment|
| `Arc.ResourceGroupName` |String|Resource group name| None |Single-machine and <br> full deployment|
| `Arc.SubscriptionId` |GUID|Azure subscription ID| None |Single-machine and <br> full deployment|
| `Arc.TenantId` |GUID| TenantID for the Azure subscription| None |Single-machine and <br> full deployment|
| `Arc.ClientId` |GUID| AppID of the service principal. You can use the **App Registrations** page in the Azure Active Directory resource page on the Azure portal, to list and manage the service principals in a tenant.| None |Single-machine and <br> full deployment|
| `Arc.ClientSecret` |String|Secret associated with the Service Principal| None |Single-machine and <br> full deployment|
| `Network.ControlPlaneEndpointIp` |IPv4 address `A.B.C.x`|A free IP address on your subnet **A.B.C**. The control plane (API server) gets this address. |  |Full deployment only|
| `Network.NetworkPlugin` |[`calico` / `flannel`]|CNI plugin choice for the Kubernetes network model. For K8s cluster, always use `calico` and for K3s cluster, always use `flannel`.|  `flannel`|Single-machine and <br> full deployment|
| `Network.Ip4GatewayAddress` |IPv4 address `A.B.C.x`|Gateway address; typically the router address.|    |Full deployment only|
| `Network.Ip4PrefixLength` |`[1-31]`|The IP address subnet **A.B.C** prefix length. For example, use **24** if your network is **192.168.1.0/24**.| `24`|Full deployment only|
| `Network.DnsServers` |IPv4 address `A.B.C.x` |IP address of your DNS (typically the router address). To view what DNS your machine uses, issue the command `Get-DnsClientServerAddress -AddressFamily IPv4`.  | |Full deployment only|
| `Network.InternetDisabled` |Boolean|Whether your cluster has access to the internet. The default is `false`, meaning your cluster by default has access to the internet.|  `false`|Single-machine and <br> full deployment|
| `Network.SkipAddressFreeCheck` |Boolean|Ignores IP Address check failures and continues with deployment.|  `false`|Full deployment|
| `Network.Proxy.Http` |String | HttpProxy link. ||Single-machine and <br> full deployment|
| `Network.Proxy.Https` |String | HttpsProxy link. ||Single-machine and <br> full deployment|
| `Network.Proxy.No` |String | No proxy config for bypassing the proxy. ||Single-machine and <br> full deployment|
| `User.AcceptEula` | Boolean | Accept or decline the EULA | `false` |Single-machine and <br> full deployment|
| `User.AcceptOptionalTelemetry` | Boolean | Accept or decline the `optional` telemetry. The `required` telemetry is enabled always. | `false` |Single-machine and <br> full deployment|
| `Machines[].ArcHybridComputeMachineId` |String | `Reserved` | `null` |Single-machine and <br> full deployment|
| `Machines[].NetworkConnection.AdapterName` |String | NetAdapterName for VSwitch. It is mandatory for a full Kubernetes deployment. You can run the PowerShell `Get-NetAdapter -Physical` command to view the `Name` column for the adapter of your choice. ||Single-machine and <br> full deployment|
| `Machines[].NetworkConnection.Mtu` | Number | The maximum transmission unit (MTU) for the network | `0` |Single-machine and <br> full deployment|
| `Machines[].LinuxNode.ControlPlane` | Boolean | Specify whether you want this new deployment to be a control plane. If `false`, it will be a worker node. *Only for Linux VM*| `false` |Single-machine and <br> full deployment|
| `Machines[].LinuxNode.CpuCount` | [`2-x`] | Number of CPU cores reserved for VM/VMs. | `2` |Single-machine and <br> full deployment|
| `Machines[].LinuxNode.MemoryInMB` | [`2048-2x`] | RAM in MBs reserved for VM/VMs. | `2048` |Single-machine and <br> full deployment|
| `Machines[].LinuxNode.DataSizeInGB` | Number | Size of the data partition. For large applications, we recommend increasing this number. *Only for Linux VM* | `10` |Single-machine and <br> full deployment|
| `Machines[].LinuxNode.Ip4Address` | `A.B.C.x` | Specify the IP address your VM will take. ||Single-machine and <br> full deployment|
| `Machines[].LinuxNode.MacAddress` |`00:00:00:00:00:00` | Specify the Mac address your VM will take. ||Single-machine and <br> full deployment|
| `Machines[].LinuxNode.TimeoutSeconds` | Number | Timeout provided for the kubernetes cluster to complete the bootstrap process. It's recommended that you use the default value. | `300` |Single-machine and <br> full deployment|
| `Machines[].LinuxNode.TpmPassthrough` | Boolean | Enables TPM access from the Linux node. | `false` |Single-machine and <br> full deployment|
| `Machines[].LinuxNode.SecondaryNetworks` | Array | Specify secondary network to be added to the Linux Node. You can specify an array of `VMSwitchName` with optional static IP information (`Ip4Address,Ip4GatewayAddress and Ip4PrefixLength`)  | `null` |Single-machine and <br> full deployment|
| `Machines[].WindowsNode.CpuCount` | [`2-x`] | Number of CPU cores reserved for VM/VMs. | `2` |Single-machine and <br> full deployment|
| `Machines[].WindowsNode.MemoryInMB` | [`2048-2x`] | RAM in MBs reserved for VM/VMs (multiples of 2). | `2048` |Single-machine and <br> full deployment|
| `Machines[].WindowsNode.Ip4Address` | `A.B.C.x` | Specify the IP address your VM will take. ||Single-machine and <br> full deployment|
| `Machines[].WindowsNode.MacAddress` |`00:00:00:00:00:00` | Specify the Mac address your VM will take. ||Single-machine and <br> full deployment|
| `Machines[].WindowsNode.TimeoutSeconds` | Number | Timeout provided for the kubernetes cluster to complete the bootstrap process. It's recommended that you use the default value. | `900` |Single-machine and <br> full deployment|

## Next steps

- [AKS Edge Essentials nodes and clusters](./aks-edge-concept-clusters-nodes.md)
- [Set up your machine](./aks-edge-howto-setup-machine.md)
