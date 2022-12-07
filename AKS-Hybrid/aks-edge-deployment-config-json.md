---
title: AKS Edge Essentials Deployment Configuration JSON Parameters
description: Description of deployment configuration JSON parameters
author: yujinkim-msft
ms.author: yujinkim
ms.topic: conceptual
ms.date: 12/02/2022
ms.custom: template-concept
---

# Deployment Configuration JSON Parameters

After you set up your machines and downloaded the [GitHub repo](https://github.com/Azure/AKS-Edge) with our tools and samples, you can deploy your cluster using our configuration JSON. This article will explain the different parameters  found in the `aksedge-config.json`.

## Deployment Options
| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `SingleMachineCluster` | `boolean` | Specify whether this is a single machine cluster. You cannot add new clusters to a single machine cluster. | `true` |
| `NodeType` | [`Linux`/<br/>`LinuxAndWindows`/<br/>`Windows`] | `Linux` creates the Linux node. `LinuxAndWindows` creates both the nodes. `Windows` only node is supported in Full Kubernetes deployment as a scaling option. Read more about [AKS edge workload types](/docs/AKS-Edge-Concepts.md#aks-iot-workload-types) *(Note: In order to deploy Windows worker node, you need to opt the Windows VHDX into your MSI installer. Learn how to do this [here](/docs/set-up-machines.md).)* | `Linux` |
| `NetworkPlugin` | [`calico`/`flannel`] |  CNI plugin choice for the Kubernetes network model. *For K8s cluster, always use `calico`*. | `flannel` |
| `Headless` | `boolean` | Flag to suppress any user interaction/prompts and continue. | `false` |
| `TimeoutSeconds` | `number` | Timeout provided for the kubernetes cluster to complete the bootstrap process. Recommend to use the default value. | `900` |
| `ServerTLSBootstrap` | `boolean` | Flag to bootstrap Server TLS process in K8s cluster. Not applicable for K3s cluster. See [more info](./aks-edge-howto-metric-server.md). | `false` |


### Additional Deployment Options for scaling a cluster

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `ControlPlane` | `boolean` | Specify whether you want this new deployment to be a control plane. If `false`, it will be a worker node. Applicable for Linux nodes only| `false` |
| `JoinCluster` | `boolean` | Specify whether you are joining an existing cluster on another machine. | `false` |
| `ClusterId` | `guid` | Auto generated GUID for the cluster. |  |
|`DiscoveryTokenHash` <br>`CertificateKey`<br>`ClusterJoinToken` |`string` | Key data required for joining an existing cluster. This will be auto-populated depending on the K8s/k3s cluster when you get the scale json config using [`New-AksEdgeScaleConfig`]() | `null` |

## End User

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `AcceptEula` | `boolean` | Accept or decline our EULA for Public Preview. | `false` |
| `AcceptOptionalTelemetry` | `boolean` | Accept only the required telemetry or accept the optional telemetry as well. Default is only the required telemetry. | `false` |

## VM

| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `CpuCount` | `number` | Number of CPU cores reserved for VM/VMs. | `2` |
| `MemoryInMB` | `number` | RAM in MBs reserved for VM/VMs. | `2048` |
| `DataSizeInGB` | `number` | Size of the data partition. For large applications, we recommend increasing this number. *Only for Linux VM* | `20` |
| `Ip4Address` | `A.B.C.x` | Specify the IP address your VM will take. |

> [!NOTE]
> If you would like to create a Windows node, add a section in your `aksedge-config.json` to define your Windows VM parameters:

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

## Network

| Attribute | Value type      |  Description |
| :------------ |:-----------|:--------|
| `Vswitch.Name` | `string` | Name of the external switch used for AKS Edge Essentials. You can create one yourself using Hyper-V manager. If you specify a switch name that does not exist, AKS Edge Essentials creates one for you. |
| `Vswitch.Type` | `string` | Only `External` switch supported currently. Single machine cluster uses `Internal` switch by default and is not required to be specified. |
| `Vswitch.AdapterName` | `string` | NetAdapterName for VSwitch. It is mandatory for Full kubernetes deployment. |
| `ControlPlaneEndpointIp` | `A.B.C.x` | A free IP address on your subnet **A.B.C**. The control plane (API server) will get this address. |
| `Ip4GatewayAddress` | `A.B.C.1` | Gateway address; typically the router address. |
| `Ip4PrefixLength` | `number` | The IP address subnet **A.B.C** prefix length. For example, use **24** if your network is **192.168.1.0/24**. |
| `ServiceIPRangeSize` | `number` | Number of reserved IP start addresses for your Kubernetes services. Based on the size, we will carve out a range of free IP addresses on your subnet. |
| `ServiceIPRangeStart`| `A.B.C.x` | Reserved IP start address for your Kubernetes services. This IP range must be free on your subnet **A.B.C**. |
| `ServiceIPRangeEnd` | `A.B.C.x` | Reserved IP start address for your Kubernetes services. This IP range must be free on your subnet **A.B.C**.  |
| `DnsServers` | `A.B.C.1` | IP address of your DNS (typically the router address). To view what DNS your machine uses: **ipconfig /all \| findstr /R "DNS\ Servers"** |
| `InternetDisabled` | `boolean` | Whether your cluster has access to the internet. The default is `false`, meaning your cluster will by default have access to the internet. |
| `Proxy.Http` | `string` | HttpProxy link. |
| `Proxy.Https` | `string` | HttpsProxy link. | 
| `Proxy.No` | `string` | No proxy config for bypassing the proxy. | 


## Next steps

- [AKS Edge Essentials Concepts](./aks-edge-concept.md)
- [Set up your machine](./aks-edge-howto-setup-machine.md)
