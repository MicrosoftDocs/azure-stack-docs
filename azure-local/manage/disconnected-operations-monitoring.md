---
title: Monitor Disconnected Operations in Azure Local (preview)
description: Learn how to monitor disconnected operations in Azure Local to ensure system reliability and performance (preview).
author: ronmiab
ms.topic: concept-article
ms.date: 08/06/2025
ms.author: robess
ms.reviewer: robess
ai-usage: ai-assisted
---

# Monitor disconnected operations for Azure Local (preview)

::: moniker range=">=azloc-2506"

This article explains how to monitor disconnected operations in Azure Local by integrating with external monitoring solutions. Learn how to use Microsoft, non-Microsoft, and open-source monitoring systems to ensure the reliability and performance of your infrastructure and workloads.

For more information on disconnected operations, see [Disconnected operations for Azure Local (preview)](./disconnected-operations-overview.md).

## Why monitor disconnected operations?

Monitoring is essential to keep your IT systems reliable, fast, and secure. When you continuously collect and analyze telemetry data—such as CPU usage, disk usage and utilization, memory consumption, network traffic, and error rates-you gain real-time visibility into the health of their environments, whether it's on-premises, in the cloud, or in a hybrid setup.

You can store monitored data on-premises or in the cloud, depending on your monitoring solution. This flexibility lets you choose the best approach for your organization's needs.

## Benefits

Monitoring disconnected operations for Azure Local:

- Ensures the availability and performance of critical systems.
- Detects and diagnoses issues in real-time.
- Analyzes performance trends and patterns.
- Optimizes resource utilization.
- Ensures compliance with security and regulatory requirements.
- Provides insights for capacity planning and resource allocation.

For information on the views that provide insights, visualization, and analysis of your monitored telemetry data, see [View types in Operations Manager](/system-center/scom/manage-console-view-types?view=sc-om-2025&preserve-view=true).

## What can be monitored?

You can monitor these components of Azure Local with disconnected operations using external solutions:

- [Azure Local](#monitor-azure-local-infrastructure) (infrastructure)
- The disconnected operations appliance (local Azure portal and Arc services).
- [Virtual machines](#monitor-virtual-machines) (VMs).
- [Azure Kubernetes Service (AKS)](#monitor-azure-kubernetes-service-clusters) clusters.

## Prerequisites

Install and deploy [System Center Operations Manager](/system-center/scom/system-requirements?view=sc-om-2025&preserve-view=true).

## Monitor Azure Local infrastructure

The disconnected operations appliance provides the local Azure portal and Arc services to deploy and manage Azure Local instances. Monitoring the appliance ensures the local portal and services remain available. Use System Center Operations Manager and the disconnected operations management pack for this purpose.

### System Center Operations Manager

When you deploy Azure Local using the disconnected operations feature, integrate with external solutions such as System Center Operations Manager to monitor the instance and nodes.

1. Install the Operations Manager agent on each node. Follow the steps in [Install Windows Agent Manually Using MOMAgent.msi](/system-center/scom/manage-deploy-windows-agent-manually?view=sc-om-2025#deploy-the-operations-manager-agent-with-the-agent-setup-wizard&preserve-view=true). Choose the installation method that fits your environment.

1. Import these management packs:

    - [Windows Server Operating System 2016 and above for Base OS](https://aka.ms/AAvqh49)

    - [Microsoft System Center Management Pack for Windows Server Cluster 2016 and above for Cluster](https://aka.ms/AAvqwlr)

    - [Microsoft System Center 2019 Management Pack for Hyper-V](https://aka.ms/AAvqh4i)

    - [AzS HCI S2D MP for Storage Spaces Direct (S2D)](https://aka.ms/AAvqwo9)

For more information, see [Operations Manager](/system-center/scom/welcome?view=sc-om-2025&preserve-view=true)

### Disconnected operations management pack

The disconnected operations management pack for System Center Operations Manager lets you monitor Azure Local instances and nodes deployed with the disconnected operations feature. Use this management pack to monitor the health and performance of your Azure Local infrastructure in a disconnected environment.

Capabilities of the disconnected operations management pack include:

- Management for a single disconnected operations deployment.

- Support for Active Directory Federation Services (AD FS).

- Health and metrics dashboards.

- Preconfigured alert rules based on metrics for issue detection and operator action, including certificate expiration 
warnings.

- Notification and reporting support.

To download the System Center Management Pack and user guide - please review the table and download the management pack suporting your SCOM installation
| SCOM Version                | Download link      |
|----------------------------|--------------|
| SCOM 2022                 | [Microsoft System Center Management Pack for Azure Local with disconnected operations](https://aka.ms/disconnected-operations-scom-mp)  |
| SCOM 2025                | [Microsoft System Center Management Pack for Azure Local with disconnected operations](https://aka.ms/disconnected-operations-scom-mp-2025)|

For monitoring failover clusters, see [Monitoring Failover Cluster with Operations Manager](/system-center/scom/manage-monitor-clusters-overview).

## Monitor virtual machines

Monitor virtual machines (VMs) on Azure Local with disconnected operations using System Center Operations Manager, non-Microsoft, or open-source solutions. Install the appropriate agents in each VM.

For more information, see [Operations Manager](/system-center/scom/welcome?view=sc-om-2025&preserve-view=true).

## Monitor Azure Kubernetes Service clusters

Monitor Azure Kubernetes Service (AKS) clusters and container apps on Azure Local with disconnected operations using non-Microsoft or open-source solutions. Here are some common solutions for monitoring AKS clusters:

- **Prometheus**: An open-source monitoring and alerting toolkit designed for reliability and scalability. It collects metrics from configured targets at specified intervals, evaluates rule expressions, and can trigger alerts if certain conditions are met.

    For more information on Prometheus, see [Overview Prometheus](https://prometheus.io/docs/introduction/overview/).

- **Grafana**: An open-source analytics and monitoring platform that works with Prometheus and other data sources to show metrics and logs. It provides a rich set of features for creating dashboards, alerts, and reports.

    For more information on Grafana, see [Grafana OSS](https://grafana.com/oss/grafana/).

Download these solutions from their repositories and install them on an AKS cluster running on Azure Local, or deploy them on a Kubernetes cluster outside Azure Local.

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506.

::: moniker-end
