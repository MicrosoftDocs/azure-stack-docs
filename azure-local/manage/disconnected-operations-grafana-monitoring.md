---
title: Monitor Disconnected Operations on Azure Local With Grafana
description: Set up point-in-time monitoring for disconnected operations on Azure Local to ensure system reliability and performance.
author: amdeocha
ms.topic: concept-article
ms.date: 08/17/2026
ms.author: amdeocha
ms.reviewer: robess
ms.service: azure-local
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Monitor disconnected operations on Azure Local with Grafana

::: moniker range=">=azloc-2604"

The AzureLocal-Observability Grafana data source plugin gives you point-in-time visibility into your Azure Local clusters by querying the local Azure Resource Manager endpoint directly. You can track cluster health and performance without relying on Azure-based monitoring services.


This article shows you how to install the plugin, configure it against your local Azure Resource Manager endpoint, and import a prebuilt dashboard that surfaces more than 50 metrics across processor, disk, memory, network, and services.

## What the plugin does

- Connects to the Azure Local Azure Resource Manager endpoint by using service principal credentials.
- Queries metrics from the local metrics API (API version `2024-09-01`).
- Includes a prebuilt **Point in Time Metrics** dashboard that covers CPU, disk, memory, network, TCP, Winsock, services, and scenarios.

## Prerequisites

- Grafana version 12.3.0 or later. To install Grafana:
  
  1. Download the Grafana MSI or ZIP file on an internet-connected machine.
  1. Copy the file to the target host by using a shared folder, USB drive, or another transfer method.
  1. For an MSI installation, run the following command:

      ```powershell
      Start-Process msiexec.exe -Wait -ArgumentList '/I "grafana-enterprise-12.x.x.windows-amd64.msi" /quiet'
      ```

  1. Verify that you can access Grafana at `http://localhost:3000`.

- An Azure Local cluster running disconnected operations, with the Azure Resource Manager endpoint reachable from the Grafana host.
- A service principal (Microsoft Entra ID app registration) with a client secret and permission to read cluster metrics.

## Install the plugin

To install the Grafana plugin, follow these steps:

1. Copy the plugin files.

    1. [Download the Grafana plugin](https://aka.ms/disconnected-operations-grafana-package) on a machine with internet access.  
  
    1. Extract the zip file and copy the `microsoft-azurelocalobservability-datasource/` folder into Grafana's plugins directory.
  
        ```powershell
        # Linux
        sudo cp -r microsoft-azurelocalobservability-datasource/ /var/lib/grafana/plugins/microsoft-azurelocalobservability-datasource/
        
        # Windows (admin PowerShell)
        Copy-Item -Recurse microsoft-azurelocalobservability-datasource\ "C:\Program Files\GrafanaLabs\grafana\data\plugins\microsoft-azurelocalobservability-datasource\"
        ```

1. Import the root CA certificate into the system store on the Grafana host.

     ```powershell
     Import-Certificate -FilePath "C:\path\to\publicroot.cer" -CertStoreLocation Cert:\LocalMachine\Root
     ```

1.  Create a service principal with the **Reader** role.

     ```powershell
     az ad sp create-for-rbac -n "grafana-monitoring" --role Reader --scopes "/subscriptions/<sub-id>"
     ```

1. Restart Grafana.

    ```powershell
    # Linux
    sudo systemctl restart grafana-server
    
    # Windows (admin PowerShell)
    Restart-Service grafana
    ```

## Configure the data source

### Add the data source

1. In Grafana, select **Connections** > **Data sources** > **Add data source**.
1. Search for **AzureLocal-Observability**.
1. Enter your Azure Resource Manager endpoint, `https://armmanagement.<ExternalDomainSuffix>` (for example, `https://armmanagement.autonomous.cloud.private`).
1. Enter the tenant ID, client ID, and client secret from the service principal creation step. To retrieve the tenant ID and subscription ID, run `az account show` on any cluster node.
1. Select **Load Subscriptions** and select your subscription.
1. Select **Save & test**.

### Import the dashboard

1. Select **Dashboards** > **New** > **Import**.
1. On an internet-connected machine, download the [Point in Time Metrics dashboard (JSON)](https://aka.ms/disconnected-operations-grafana-template), and then upload it in the import dialog. For prerequisites and the full sample, see the [ReadMe and JSON file](https://github.com/Azure-Samples/AzureLocal/tree/main/disconnected-operations).
1. Select your **Azure Local Monitor** data source when prompted.
1. Select **Import**.

## Troubleshooting

### Dashboard panels show no data

The Grafana plugin queries the `Microsoft.EdgeOperator` resource provider to retrieve metrics. If this provider isn't registered on the subscription, all dashboard panels show **No data**, and the data source returns the following error:

```output
HTTP 404: {"error":{"code":"SubscriptionNotRegistered","message":"The subscription '<sub-id>' is not registered to 'Microsoft.EdgeOperator'."}}
```

To resolve this issue, run the following commands from a machine where the Azure CLI is authenticated to the local Azure Resource Manager endpoint:

```powershell
az provider register --namespace Microsoft.EdgeOperator --subscription <subscription-id>

# Wait for registration (1–3 minutes):
az provider show -n Microsoft.EdgeOperator --subscription <subscription-id> --query "registrationState" -o tsv
# Expect: "Registered"
```

### DNS resolution failure

The Grafana plugin connects to `https://armmanagement.<ExternalDomainSuffix>`. If the Grafana host can't resolve this hostname, the plugin fails with a timeout or "host not found" error.

Verify DNS resolution from the Grafana host:

```powershell
nslookup armmanagement.<ExternalDomainSuffix>
```

If the hostname doesn't resolve:

1. Configure the Grafana host's DNS settings to use the domain controller as its primary DNS server.
1. Verify that a DNS record exists for `armmanagement.<ExternalDomainSuffix>` and points to the cluster ingress IP address.

::: moniker-end

::: moniker range="<azloc-2604"

This feature is available only in Azure Local 2604 or later.

::: moniker-end
