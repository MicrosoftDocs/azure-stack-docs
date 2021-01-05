---
title: Troubleshoot cluster validation reporting
description: Troubleshoot cluster validation reporting and validate QoS settings configuration for Azure Stack HCI clusters
author: khdownie
ms.topic: troubleshooting
ms.date: 01/05/2021
ms.author: v-kedow
ms.reviewer: JasonGerend
---

# Troubleshoot cluster validation reporting

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

This topic helps you troubleshoot cluster validation reporting for network and storage QoS (quality of service) settings across servers in an Azure Stack HCI cluster, and verify that important rules are defined. For optimal connectivity and performance, the cluster validation process verifies that Data Center Bridging (DCB) QoS configuration is consistent and, if defined, contains appropriate rules for Failover Clustering and SMB/SMB Direct traffic classes.

DCB is required for RDMA over Converged Ethernet (RoCE) networks, and is optional (but recommended) for Internet Wide Area RDMA Protocol (iWARP) networks.

## Install data center bridging

Data Center Bridging must be installed to use QoS-specific cmdlets. To check if the Data Center Bridging feature is already installed on a server, run the following cmdlet in PowerShell:

```PowerShell
Get-WindowsFeature -Name Data-Center-Bridging -ComputerName Server1
```

If Data Center Bridging is not installed, install it by running the following cmdlet on each server in the cluster:

```PowerShell
Install-WindowsFeature –Name Data-Center-Bridging -ComputerName Server1
```

## Run a cluster validation test

Either use the Validate feature in Windows Admin Center by selecting **Tools > Servers > Inventory > Validate cluster**, or run the following PowerShell command:

```PowerShell
Test-Cluster –Node Server1, Server2
```

Among other things, the test will validate that DCB QoS Configuration is consistent, and that all servers in the cluster have the same number of traffic classes and QoS Rules. It will also verify that all servers have QoS rules defined for Failover Clustering and SMB/SMB Direct traffic classes.

You can view the validation report in Windows Admin Center, or by accessing a log file in the current working directory. For example: C:\Users\<username>\AppData\Local\Temp\

Near the bottom of the report, you will see "Validate QoS Settings Configuration" and a corresponding report for each server in the cluster.

To understand which traffic classes are already set on a server, use the `Get-NetQosTrafficClass` cmdlet.

To learn more, see [Validate an Azure Stack HCI cluster](../deploy/validate.md).

## Validate networking QoS rules

Validate the consistency of DCB willing status and priority flow control status settings between servers in the cluster.

### DCB willing status

Network adapters that support the Data Center Bridging Capability Exchange protocol (DCBX) can accept configurations from a remote device. To enable this capability, the DCB willing bit on the network adapter must be set to true. If the willing bit is set to false, the device will reject all configuration attempts from remote devices and enforce only the local configurations. If you're using RDMA over Converged Ethernet (RoCE) adapters, then the willing bit should be set to false on all servers.

All servers in an Azure Stack HCI cluster should have the DCB willing bit set the same way.

Use the `Set-NetQosDcbxSetting` cmdlet to set the DCB willing bit to either true or false, as in the following example:

```PowerShell
Set-NetQosDcbxSetting –Willing $false
```

### DCB flow control status

Priority-based flow control is essential if the upper layer protocol, such as Fiber Channel, assumes a lossless underlying transport. DCB flow control can be enabled or disabled either globally or for individual network adapters. If enabled, it allows for the creation of QoS policies that prioritize certain application traffic.

In order for QoS policies to work seamlessly during failover, all servers in an Azure Stack HCI cluster should have the same flow control status settings. If you're using RoCE adapters, then priority flow control must be enabled on all servers.

Use the `Get-NetQosFlowControl` cmdlet to get the current flow control configuration. All priorities are disabled by default.

Use the `Enable-NetQosFlowControl` and `Disable-NetQosFlowControl` cmdlets with the -priority parameter to turn priority flow control on or off. For example, the following command enables flow control on traffic tagged with priority 3:

```PowerShell
Enable-NetQosFlowControl –Priority 3
```

## Validate storage QoS rules

Validate that all nodes have a QoS rule for failover clustering and for SMB or SMB Direct. Otherwise, connectivity problems and performance problems may occur.

### QoS Rule for failover clustering

If **any** storage QoS rules are defined in a cluster, then a QoS rule for failover clustering should be present, or connectivity problems may occur. To add a new QoS rule for failover clustering, use the `New-NetQosPolicy` cmdlet as in the following example:

```PowerShell
New-NetQosPolicy "Cluster" -IPDstPort 3343 -Priority 6
```

### QoS rule for SMB

If some or all nodes have QOS rules defined but do not have a QOS Rule for SMB, this may cause connectivity and performance problems for SMB. To add a new network QoS rule for SMB, use the `New-NetQosPolicy` cmdlet as in the following example:

```PowerShell
New-NetQosPolicy -Name "SMB" -SMB -PriorityValue8021Action 3
```

### QoS rule for SMB Direct

SMB Direct bypasses the networking stack, instead using RDMA methods to transfer data. If some or all nodes have QOS rules defined but do not have a QOS Rule for SMB Direct, this may cause connectivity and performance problems for SMB Direct. To create a new QoS policy for SMB Direct, issue the following commands:

```PowerShell
New-NetQosPolicy "SMB Direct" –NetDirectPort 445 –Priority 3
```

## Next steps

For related information, see also:

- [Data Center Bridging](/windows-server/networking/technologies/dcb/dcb-top)
- [Manage Data Center Bridging](/windows-server/networking/technologies/dcb/dcb-manage)
- [QoS Common Configurations](/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/jj735302(v=ws.11))