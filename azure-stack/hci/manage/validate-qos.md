---
title: Validate QoS Settings
description: Validate QoS settings configuration for Azure Stack HCI clusters
author: v-kedow
ms.topic: article
ms.date: 05/29/2020
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

The test will validate that the Data Center Bridging (DCB) QoS Configuration is consistent, and that all servers in the cluster have the same number of traffic classes and QoS Rules. It will also verify that all servers have QoS rules defined for Failover Clustering and SMB traffic classes.

You can view the validation report in Windows Admin Center, or by accessing a log file in the current working directory. For example: C:\Users\<username>\AppData\Local\Temp\

## Validate networking QoS rules

Validate the consistency of DCB Willing Status and Flow Control Status settings between cluster nodes.

- DCB Willing Status
- DCB Flow Control Status

When should these be enabled or disabled?

## Validate storage QoS rules

Validate that all nodes have a rule for Clustering and for SMB or SMB Direct. Otherwise, this may cause connectivity problems and performance problems.

- QOS Rule for Clustering
- QOS Rule for SMB
- QOS Rule for SMB Direct

When should these be present? When should they not?

## Next steps

Learn how to do xyz next [Do XYZ].