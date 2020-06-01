---
title: Validate QoS Settings
description: Validate QoS settings configuration for Azure Stack HCI clusters
author: khdownie
ms.topic: article
ms.date: 06/01/2020
ms.author: v-kedow
ms.reviewer: JasonGerend
---

# Validate QoS settings

> Applies to Azure Stack HCI v20H2, Windows Server 2019

As traffic increases on your network, it is increasingly important for you to balance network performance with the cost of service - but network traffic is not normally easy to prioritize and manage.

On your network, mission-critical and latency-sensitive applications must compete for network bandwidth against lower priority traffic. At the same time, some users and computers with specific network performance requirements might require differentiated service levels.

This article discusses how to validate your QoS (quality of service) settings for consistency across server nodes, and verify that important rules are defined.

## Run a cluster validation test

Either use the Validate feature in Windows Admin Center by selecting **Tools > Servers > Inventory > Validate cluster**, or run the following PowerShell command:

```PowerShell
Test-Cluster –Node Server1, Server2
```

Among other things, the test will validate that the Data Center Bridging (DCB) QoS Configuration is consistent, and that all servers in the cluster have the same number of traffic classes and QoS Rules. It will also verify that all servers have QoS rules defined for Failover Clustering and SMB traffic classes.

You can view the validation report in Windows Admin Center, or by accessing a log file in the current working directory. For example: C:\Users\<username>\AppData\Local\Temp\

Near the bottom of the report, you will see "Validate QoS Settings Configuration" and a corresponding report for each server in the cluster.

## Validate networking QoS rules

Validate the consistency of DCB Willing Status and Flow Control Status settings between cluster nodes.

### DCB Willing Status

Network adapters that support the Data Center Bridging Capability Exchange protocol (DCBX) can accept configurations from a remote device. To enable this capability, the DCB Willing bit on the network adapter must be set to true. If the Willing bit is set to false, the device will reject all configuration attempts from remote devices and enforce only the local configurations.

All servers in an Azure Stack HCI cluster should have the DCB Willing bit set the same way.

### DCB Flow Control Status

Priority-based flow control is essential if the upper layer protocol, such as Fiber Channel, assumes a lossless underlying transport. DCB flow control can be enabled or disabled either globally or for individual network adapters. If enabled, it allows for the creation of QoS policies that prioritize certain application traffic.

In order for QoS policies to work seamlessly during failover, all servers in an Azure Stack HCI cluster should have the same flow control status settings.

## Validate storage QoS rules

Validate that all nodes have a rule for Clustering and for SMB or SMB Direct. Otherwise, this may cause connectivity problems and performance problems.

### QoS Rule for Failover Clustering

If **any** storage QoS rules are defined in a cluster, then a QoS rule for failover clustering should be present, or connectivity problems may occur.

### QoS Rule for SMB

If some or all nodes have QOS rules defined but do not have a QOS Rule for SMB, this may cause connectivity and performance problems for SMB.

### QoS Rule for SMB Direct

If some or all nodes have QOS rules defined but do not have a QOS Rule for SMB Direct, this may cause connectivity and performance problems for SMB Direct.

## Next steps

For related information, see also:

- [Data Center Bridging](/windows-server/networking/technologies/dcb/dcb-top)
- [Manage Data Center Bridging](/windows-server/networking/technologies/dcb/dcb-manage)
- [QoS Common Configurations](/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/jj735302(v=ws.11))