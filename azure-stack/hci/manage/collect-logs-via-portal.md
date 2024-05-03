---
title: Collect diagnostic logs for Azure Stack HCI using the Azure portal
description: How to collect diagnostic logs using the Azure portal and share them with Microsoft.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/05/2024
---

# Collect diagnostic logs for Azure Stack HCI using the Azure portal

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to collect diagnostic logs using the Azure portal and send them to Microsoft to help identify and fix any issues with your Azure Stack HCI solution.

For information on on-demand log collection, its benefits and prerequisites, see [] to collect diagnostic logs via PowerShell, see [Collect diagnostic logs for Azure Stack HCI](./collect-logs.md).

## On-demand log collection

On-demand log collection involves manually collecting and sending diagnostic logs to Microsoft. You can perform on-demand log collection using any of the following methods:

- (Recommended) Azure portal. When you collect logs and send them to Microsoft using the Azure portal, you collect logs at the cluster level. This send the default logs.
- PowerShell. But if you need like specific parameters around, OK like you need to share them, you need to either like save them to an SMB share or you need to just send the supplementary logs or you only wanna send specific rules, then you still need to use PowerShell. If you want to Use the `Send-DiagnosticData` cmdlet from any node within the Azure Stack HCI cluster to collect logs and send them to Microsoft. When you run this cmdlet, the logs are temporarily copied locally. This copy is parsed, sent to Microsoft, and then deleted from your system. Microsoft retains this diagnostic data for up to 30 days and handles it as per the [standard privacy practices](https://privacy.microsoft.com/).

### When to use on-demand log collection

Here are the scenarios in which you can perform on-demand log collection:

- Microsoft Support requests for logs based on an open case.
- Logs are collected when a cluster is connected and registered.
- Logs are collected when the Observability components are operational and installed.
- Logs are collected when a cluster is only partly registered.
- Logs are collected for issues not related to registration failures.

To explore additional log collection methods in Azure Stack HCI and understand when to use them, see [Diagnostics](../concepts/observability.md#diagnostics).

## Prerequisites

Before you collect on-demand logs via the Azure portal, you must complete the following prerequisites:

- You must have access to an Azure Stack HCI cluster.
- You must have access to Azure.
- You must have installed the `AzureEdgeTelemetryAndDiagnostics` extension to collect telemetry and diagnostics information from your Azure Stack HCI system. For information about the extension, see [Azure Stack HCI telemetry and diagnostics extension overview](../concepts/telemetry-and-diagnostics-overview.md).
- Review the terms and conditions for log collection.

## Collect logs via the Azure portal

Follow these steps to collect diagnostic logs for you Azure Stack HCI cluster via the Azure portal:

1. the Azure portal, go to the Azure Stack HCI cluster resource.
1. In the left pane, under **Settings**, select **HCI diagnostics and Support**.
1. On the **Troubleshoot issues and get support** pane, under the **Send Diagnostics Logs** tile, select **Go to diagnostics**.
1. The **Diagnostics** tab displays the log activity, the timestamp of collected logs and their statuses. To collect logs now, select **Send logs**.
1. On the **Send logs** pane on the right, select the *Log start time** and **Log end tme** by selecting a date and time from the.
1. Select the **Collect and upload logs** button. By selecting this, you agree to the terms and conditions of collection logs.

Run the `Send-DiagnosticData` cmdlet from any node on your Azure Stack HCI cluster to perform on-demand log collection.

Here are some important points to consider:

- The completion time of the `Send-DiagnosticData` cmdlet varies depending on factors, such as the roles for which logs are being collected, time duration specified, and the number of nodes in your Azure Stack HCI environment.
- If you don't specify any parameters, the `Send-DiagnosticData` cmdlet collects data from all nodes for the previous one-hour duration.

Here's the syntax of `Send-DiagnosticData`:

```powershell
Send-DiagnosticData [[-FilterByRole] <string[]>] [[-FromDate] <datetime>] [[-ToDate] <datetime>] [[-CollectSddc] <bool>] [<CommonParameters>]
```

For reference information on `Send-DiagnosticData`, see the [`Send-DiagnosticData` command reference](#send-diagnosticdata-command-reference) section later in this article.

## Perform on-demand log collection via Windows Admin Center in the Azure portal

The `Diagnostics` extension in Windows Admin Center in the Azure portal enables you to perform on-demand log collection and share the logs with Microsoft.

Follow these steps to perform on-demand log collection via Windows Admin Center in the Azure portal:

1. Connect to Windows Admin Center in the Azure portal. For information, see [Manage Azure Stack HCI clusters using Windows Admin Center in Azure](/windows-server/manage/windows-admin-center/azure/manage-hci-clusters).
1. In the left pane, under **Extensions**, select **Diagnostics**.
1. On the **Diagnostics** page, under **Log activity** review log collection history or select a row to show the details about a specific log collection.
1. Select **Send manually**. In the context pane on the right, enter the log start and end time and then select **Collect & upload logs**.

   :::image type="content" source="./media/collect-logs/send-logs-manually.png" alt-text="Screenshot of the Diagnostics page showing the Send manually button for on-demand log collection." lightbox="./media/collect-logs/send-logs-manually.png" :::

## Next steps

- [Contact Microsoft Support](get-support.md)
- [Review known issues in Azure Stack HCI](../known-issues-2311-2.md)
