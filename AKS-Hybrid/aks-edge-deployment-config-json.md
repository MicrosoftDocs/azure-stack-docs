---
title: AKS Edge Essentials deployment configuration JSON parameters
description: Description of deployment configuration JSON parameters.
author: yujinkim-msft
ms.author: yujinkim
ms.topic: conceptual
ms.date: 12/02/2022
ms.custom: template-concept
---

# Deployment configuration JSON parameters

After you set up your machines and downloaded the [GitHub repo](https://github.com/Azure/AKS-Edge) with our tools and samples, you can deploy your cluster using our configuration JSON. This article will explain the different parameters  found in the `aksedge-config.json`.

## Deployment options

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `SchemaVersion` |`1.5`|Specifies the version of the schema/format of the json | `1.5` |
| `Version` |`1.0`|Specifies the version of the json instance | `1.0` |
| `DeploymentType` |[`SingleMachineCluster`/`ScalableCluster` ]| Specify whether this is a single machine cluster. You cannot add new clusters to a single machine cluster. | `SingleMachineCluster` |

### Cluster initialization parameters

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `Init.ServiceIPRangeStart` |IPv4 address|Reserved IP start address for your Kubernetes services. This IP range must be free on your subnet **A.B.C**.| None |
| `Init.ServiceIPRangeSize` |Integer between 1-127|Number of reserved IP start addresses for your Kubernetes services. Based on the size, we will allocate a range of free IP addresses on your subnet. | `0` |

### Cluster join parameters

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `Join.ClusterJoinToken` |String|Key data required for joining an existing cluster. This will be auto-populated depending on the Kubernetes cluster when you get the scale JSON config using New-AksEdgeScaleConfig| None |
| `Join.DiscoveryTokenHash` |String|Key data required for joining an existing cluster. This will be auto-populated depending on the Kubernetes cluster when you get the scale JSON config using New-AksEdgeScaleConfig| None |
| `Join.CertificateKey` |String|Key data required for joining an existing cluster. This will be auto-populated depending on the Kubernetes cluster when you get the scale JSON config using New-AksEdgeScaleConfig| None |
| `Join.ClusterId` |String|Key data required for joining an existing cluster. This will be auto-populated depending on the Kubernetes cluster when you get the scale JSON config using New-AksEdgeScaleConfig| None |

### Azure Arc parameters


| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `Arc.ClusterName` |String|Name of the cluster in the Azure Portal| `<Machinename>-cluster` |
| `Arc.Location` |String|Location of resource group| None |
| `Arc.ResourceGroupName` |String|Resource group name| None |
| `Arc.SubscriptionId` |String|Azure subscription ID| None |
| `Arc.ClientId` |String|Client ID of the service principal| None |
| `Arc.ClientSecret` |String|Secret associated with the Service Principal| None |


### Network parameters


| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `Network.ControlPlaneEndpointIp` |IPv4 address `A.B.C.x`|A free IP address on your subnet **A.B.C**. The control plane (API server) gets this address. |  |
| `Network.NetworkPlugin` |`calico/flannel`|CNI plugin choice for the Kubernetes network model. For K8s cluster, always use `calico`.|  `flannel`|
| `Network.Ip4GatewayAddress` |IPv4 address `A.B.C.x`|Gateway address; typically the router address.|    |
| `Network.Ip4PrefixLength` |Integer between 1-31|The IP address subnet **A.B.C** prefix length. For example, use **24** if your network is **192.168.1.0/24**.|  24|
| `Network.DnsServers` |IPv4 address `A.B.C.x` |IP address of your DNS (typically the router address). To view what DNS your machine uses, issue the command `ipconfig /all \| findstr /R "DNS\ Servers"`.  | |
| `Network.InternetDisabled` |Boolean|Whether your cluster has access to the internet. The default is `false`, meaning your cluster by default has access to the internet.|  `false`|
| `Network.SkipAddressFreeCheck` |Boolean||  `false`|
| `Proxy.Http` | `string` | HttpProxy link. |
| `Proxy.Https` | `string` | HttpsProxy link. |
| `Proxy.No` | `string` | No proxy config for bypassing the proxy. |

## User

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `AcceptEula` | `boolean` | Accept or decline the [EULA](https://github.com/Azure/AKS-Edge/blob/main/EULA.md) for public preview. | `false` |
| `AcceptOptionalTelemetry` | `boolean` | Accept only the required telemetry or accept the optional telemetry as well. The default is only the required telemetry. | `false` |

## Machines

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `Vswitch.AdapterName` | `string` | NetAdapterName for VSwitch. It is mandatory for a full Kubernetes deployment. You can run the PowerShell `Get-NetAdapter -Physical` command to view the `Name` column for the adapter of your choice. |
| `ControlPlane` | `boolean` | Specify whether you want this new deployment to be a control plane. If `false`, it will be a worker node. Applicable for Linux nodes only.| `false` |
| `CpuCount` | `number` | Number of CPU cores reserved for VM/VMs. | `2` |
| `MemoryInMB` | `number` | RAM in MBs reserved for VM/VMs. | `2048` |
| `DataSizeInGB` | `number` | Size of the data partition. For large applications, we recommend increasing this number. *Only for Linux VM* | `20` |
| `Ip4Address` | `A.B.C.x` | Specify the IP address your VM will take. |
| `TimeoutSeconds` | `number` | Timeout provided for the kubernetes cluster to complete the bootstrap process. It's recommended that you use the default value. | `900` |

> [!NOTE]
> If you want to create a Windows node, add a section in your **aksedge-config.json** file to define your Windows VM parameters:

```json
"LinuxVm": {
        "CpuCount": 4,
        "MemoryInMB": 4096,
        "DataSizeinGB": 20,
        "Ip4Address": "192.168.1.171"
},
"WindowsVm": {
        "CpuCount": 2,
        "MemoryInMB": 2048,
        "Ip4Address": "192.168.1.172"
},   
```

## Next steps

- [AKS Edge Essentials concepts](./aks-edge-concept.md)
- [Set up your machine](./aks-edge-howto-setup-machine.md)
