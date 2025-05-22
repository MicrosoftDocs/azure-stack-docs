---
title: Monitor Disconnected Operations for Azure Local (preview)
description: Learn how to monitor Disconnected operations for Azure Local (preview).
author: ronmiab
ms.topic: concept-article
ms.date: 05/22/2025
ms.author: robess
ms.reviewer: robess
ai-usage: ai-assisted
---
# Monitor disconnected operations for Azure Local (preview)

::: moniker range=">=azloc-24112"

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article explains how to monitor infrastructure and workloads running on Azure Local with disconnected operations by integrating with external monitoring solutions. Integrate with Microsoft, non-Microsoft, and open-source monitoring systems for specific resource types.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Overview

Disconnected operations for Azure Local let you deploy and manage Azure Local instances and workloads in disconnected environments. This feature is designed for organizations that need a local Azure portal and Arc services to manage resources without an internet connection.

## Monitor disconnected operations appliance

The disconnected operations appliance provides the local Azure portal and Arc services to deploy and manage Azure Local instances. It's important to monitor the health of the appliance to ensure the local portal and services are available. To monitor the appliance, you can use the System Center Operations manager and the disconnected operations management pack.  

The management pack for disconnected operations includes these capabilities:

- Manage a single disconnected operation deployment.

- Support for Active Directory Federation Services (AD FS).

- Health and a metrics dashboard.

- Pre-configured alert rules based on metrics to detect issues and highlight operator actions. This includes certificate expiration warnings.

- Notification and reporting support.

To download the System Center Management Pack and user guide, see [Microsoft System Center Management Pack for Azure Local with disconnected operations](https://aka.ms/disconnected-operations-scom-mp).

For more information on System Center Operations Manager, see [Operations Manager](/system-center/scom/welcome?view=sc-om-2025&preserve-view=true).

## Monitor Azure Local infrastructure

Azure Local instances and nodes, when managed by Azure, leverage
integration with Azure Monitor to collect and analyze logs, metrics, and generate alerts. When you deploy Azure Local using the disconnected operations feature, integrate with external monitoring solutions to monitor the instance and nodes.

To monitor the Azure Local instance and nodes, integrate with System Center Operations Manager. Install the agents on each node and make sure the following management packs are available.

- [Windows Server Operating System 2016 and above for Base OS](https://aka.ms/AAvqh49).

- [Microsoft System Center Management Pack for Windows Server Cluster 2016 and above for Cluster](https://aka.ms/AAvqwlr).

- [Microsoft System Center 2019 Management Pack for Hyper-V](https://aka.ms/AAvqh4i).

- [AzS HCI S2D MP for Storage Spaces Direct (S2D)](https://aka.ms/AAvqwo9).

For more information on System Center Operations Manager, see [Operations Manager](/system-center/scom/welcome?view=sc-om-2025&preserve-view=true).

For more information on monitoring failover clusters, see [Monitoring Failover Cluster with Operations Manager
](/system-center/scom/manage-monitor-clusters-overview).

## Monitor virtual machines

running Windows Server or Linux on Azure Local with disconnected operations by integrating System Center Operations Manager or third-party and open-source solutions. Install the agents from these products in the VM.

For more information on System Center Operations Manager, see [Operations Manager](/system-center/scom/welcome?view=sc-om-2025&preserve-view=true).

## Monitor AKS clusters

Monitor AKS clusters deployed on Azure Local with disconnected operations, and container applications deployed on these clusters, by using third-party open-source solutions like Prometheus and Grafana. Download and install these solutions from their repositories on an AKS cluster running on Azure Local, or deploy them on a Kubernetes cluster running outside Azure Local.

For more information on Prometheus, see [Overview Prometheus](https://prometheus.io/docs/introduction/overview/).

For more information on Grafana, see [Grafana OSS](https://grafana.com/oss/grafana/).

::: moniker-end

::: moniker range="<=azloc-24111"

This feature is available only in Azure Local 2411.2.

::: moniker-end
