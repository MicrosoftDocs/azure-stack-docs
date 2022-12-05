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

After you set up your machines and downloaded the [GitHub repo](https://github.com/Azure/aks-edge-utils) with our tools and samples, you can deploy your cluster using our configuration JSON. This article will explain the different parameters  found in the `aksedge-config.json`.

## Deployment Options
| Attribute | Value type      |  Description |  Default value |
| :------------ |:-----------|:--------|:--------|
| `ControlPlane` | `boolean` | Specify whether you want this new deployment to be a control plane. If `false`, it will be a worker node. | `false` |
| `Headless` | `boolean` |  | `false` |
| `JoinCluster` | `boolean` | Specify whether you are joining an existing cluster on another machine. | `false` |
| `NetworkPlugin` | `string` |  CNI plugin choice for the Kubernetes network model. | `flannel` |
| `SingleMachineCluster` | `boolean` | Specify whether this is a single machine cluster. You cannot add new clusters to a single machine cluster. | `true` |
| `TimeoutSeconds` | `number` | | `900` |
| `NodeType` | `Linux` or `LinuxAndWindows` | `Linux` creates the Linux control plane. You cannot specify `Windows` because the control plane node needs to be Linux. Read more about [AKS edge workload types](/docs/AKS-Edge-Concepts.md#aks-iot-workload-types) *(Note: In order to deploy Windows worker node, you need to opt the Windows VHDX into your MSI installer. Learn how to do this [here](/docs/set-up-machines.md).)* | `Linux` |
| `ServerTLSBootstrap` | `boolean` |  | `false` |

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
| `DataSizeInGB` | `number` | Size of the data partition. For large applications, we recommend increasing this number. | `20` |
| `Ip4Address` | `A.B.C.x` | Specify the IP address your VM will take. |

> [!NOTE]
> If you would like to create a Windows node, add a section in your `aksedge-config.json` to define your Windows VM parameters:

```powershell
"LinuxVm": {
        "CpuCount": 4,
        "MemoryInMB": 4096,
        "DataSizeinGB": 20,
        "Ip4Address": "192.168.1.171"
},
"WindowsVm": {
        "CpuCount": 2,
        "MemoryInMB": 2048,
        "DataSizeinGB": 10,
        "Ip4Address": "192.168.1.172"
},   
```
## Network

| Attribute | Value type      |  Description |
| :------------ |:-----------|:--------|
| `Vswitch Name` | `string` | Name of the external switch used for AKS Edge Essentials. You can create one yourself using Hyper-V manager. If you specify a switch name that does not exist, AKS Edge Essentials creates one for you. |
| `Vswitch Type` | `string` |   |
| `Vswitch AdapterName` | `string` |  |
| `ControlPlaneEndpointIp` | `A.B.C.x` | A free IP address on your subnet **A.B.C**. The control plane (API server) will get this address. |
| `Ip4GatewayAddress` | `A.B.C.1` | Gateway address; typically the router address. |
| `Ip4PrefixLength` | `number` | The IP address subnet **A.B.C** prefix length. For example, use **24** if your network is **192.168.1.0/24**. |
| `ServiceIPRangeSize` | `number` | Number of reserved IP start addresses for your Kubernetes services. Based on the size, we will carve out a range of free IP addresses on your subnet. |
| `ServiceIPRangeStart`| `A.B.C.x` | Reserved IP start address for your Kubernetes services. This IP range must be free on your subnet **A.B.C**. |
| `ServiceIPRangeEnd` | `A.B.C.x` | Reserved IP start address for your Kubernetes services. This IP range must be free on your subnet **A.B.C**.  |
| `DnsServers` | `A.B.C.1` | IP address of your DNS (typically the router address). To view what DNS your machine uses: **ipconfig /all \| findstr /R "DNS\ Servers"** |
| `InternetDisabled` | `boolean` | Whether your cluster has access to the internet. The default is `false`, meaning your cluster will by default have access to the internet. |
| `Proxy Http` | `string` |  |
| `Proxy  Https` | `string` |  | 
| `Proxy No` | `string` |  | 


## Next steps
- [AKS Edge Essentials Concepts](./aks-edge-concept.md)
- [Set up your machine](./aks-edge-howto-setup-machine.md)
