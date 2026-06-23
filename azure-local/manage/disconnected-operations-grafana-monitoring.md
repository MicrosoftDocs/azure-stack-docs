---
title: Using Grafana for point in time monitoring Disconnected Operations in Azure Local
description: Learn how to configure Grafana to monitor disconnected operations for Azure Local to ensure system reliability and performance.
author: amdeocha
ms.topic: concept-article
ms.date: 06/19/2026
ms.author: amdeocha
ms.reviewer: robess
ms.service: azure-local
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Point in time Metrics to Monitor disconnected operations for Azure Local 

::: moniker range=">=azloc-2604"

# Azure Local Observability — Grafana Plugin

A Grafana datasource plugin for monitoring **Azure Local** clusters running in **disconnected operations** mode. It queries the local ARM endpoint directly, without requiring connectivity to Azure public cloud.

## What it does

- Connects to the Azure Local ARM management endpoint using service principal credentials
- Queries metrics from the local metrics API (API version `2024-09-01`)
- Ships a pre-built **Point in Time Metrics** dashboard covering CPU, disk, memory, network, TCP, Winsock, services, and scenarios

## Prerequisites

- **Grafana** ≥ 12.3.0
- **Azure Local cluster** running with disconnected operations, ARM endpoint reachable from the Grafana host
- **Service principal** (Azure AD app registration) with a client secret that can read cluster metrics

## Install the plugin

### 1. Copy plugin files

Copy the `dist/` folder into Grafana's plugins directory:

```powershell
# Linux
sudo cp -r dist/ /var/lib/grafana/plugins/microsoft-azurelocalobservability-datasource/

# Windows (admin PowerShell)
Copy-Item -Recurse dist\ "C:\Program Files\GrafanaLabs\grafana\data\plugins\microsoft-azurelocalobservability-datasource\"
```

### 2. Allow unsigned plugin

Add to your Grafana config (`custom.ini` on Windows, `grafana.ini` on Linux):

```ini
[plugins]
allow_loading_unsigned_plugins = microsoft-azurelocalobservability-datasource
```

### 3. Restart Grafana

```powershell
# Linux
sudo systemctl restart grafana-server

# Windows (admin PowerShell)
Restart-Service grafana
```

## Configure the datasource

1. Open Grafana → **Connections** → **Data sources** → **Add data source**
2. Search for **AzureLocal-Observability**
3. Enter your ARM endpoint (e.g. `https://armmanagement.autonomous.cloud.private`)
4. Enter Tenant ID, Client ID, and Client Secret
5. Click **Load Subscriptions** and select your subscription
6. Click **Save & test**

## Import the dashboard

1. Go to **Dashboards** → **New** → **Import**
2. Upload `provisioning/dashboards/point-in-time-metrics.json` from [here](https://learn.microsoft.com/en-us/azure/azure-local/manage/media/disconnected-operations/monitor/point-in-time-metrics.json)
3. Select your **Azure Local Monitor** datasource when prompted
4. Click **Import**


The dashboard shows 50+ metrics across Processor, Disk, System, Memory, Network, TCP, Winsock, Services, and Scenarios.


-----------------------------------------------


::: moniker-end

::: moniker range="<=azloc-2604"

This feature is available only in Azure Local 2604 or later.

::: moniker-end