---
title: Diagnostic log collection
description: Learn about diagnostic log collection.
author: sethmanheim
ms.topic: article
ms.date: 09/20/2021
ms.author: sethm
ms.reviewer: shisab
ms.lastreviewed: 09/20/2021

#Intent: As an Azure Stack Hub operator, I want to learn about diagnostic log collection so I can share them with Microsoft Support when I need help addressing an issue.
#Keyword: diagnostic log collection azure stack hub

---
# Diagnostic log collection

You can share diagnostic logs created by Azure Stack Hub. The Windows components and on-premises Azure services create these logs. Microsoft Support can use the logs to fix or identify issues with your Azure Stack Hub instance.

To get started with Azure Stack Hub diagnostic log collection, you have to register your instance. If you haven't registered Azure Stack Hub, use [the privileged endpoint (PEP)](azure-stack-get-azurestacklog.md) to share logs.

::: moniker range=">= azs-2005"

You have multiple ways to send diagnostic logs to Microsoft Support. Depending on your connectivity to Azure, your options include:
* [Send logs proactively (recommended)](#send-logs-proactively)
* [Send logs now](#send-logs-now)
* [Save logs locally](#save-logs-locally)

The flowchart shows which option to use for sending diagnostic logs. If Azure Stack Hub connects to Azure, enable **Proactive log collection**. Proactive log collection automatically uploads diagnostic logs to a Microsoft-controlled storage blob in Azure when a critical alert gets raised. You can also collect logs on-demand by using **Send logs now**. For an Azure Stack Hub that runs in a disconnected environment, or if you're having connectivity issues, choose to **Save logs locally**.

![Flowchart shows how to send logs now to Microsoft](media/azure-stack-help-and-support/send-logs-now-flowchart.png)

::: moniker-end

## Send logs proactively

Proactive log collection automatically collects and sends diagnostic logs from Azure Stack Hub to Microsoft before you open a support case. Only when a system health alert is raised are these logs collected. Microsoft Support only accesses these logs in the context of a support case.

::: moniker range=">= azs-2008"

Beginning with Azure Stack Hub version 2008, proactive log collection uses an improved algorithm to capture logs even during error conditions that aren't visible to an operator. This improvement helps ensure that the right diagnostic info is collected at the right time without needing any operator interaction. Microsoft support can begin troubleshooting and resolve problems sooner in some cases. Initial algorithm improvements focus on **patch and update operations**.

When an event triggers these alerts, Azure Stack Hub proactively sends the logs to Microsoft. **In addition, Azure Stack Hub sends logs to Microsoft triggered by other failure events. These events are not visible to the operator**.

Enabling proactive log collection is highly recommended. It allows the product team to diagnose problems due to failure events and improve the quality of the product.

>[!NOTE]
>If proactive log collection is enabled and you renew or change your Azure Stack Hub registration, as described in [Renew or change registration](azure-stack-registration.md#renew-or-change-registration), you must re-enable proactive log collection.

::: moniker-end

::: moniker range=">= azs-2102"

Azure Stack Hub proactively collects logs for:

::: moniker-end

::: moniker range="= azs-2102"

| Alert   | Fault ID type |
|---------|---------------|
| Update needs attention | Urp.UpdateWarning |
| Update failed | Urp.UpdateFailure |

::: moniker-end

::: moniker range=">= azs-2108"

| Alert   | Fault ID type |
|---------|---------------|
| Table server data corruption | StorageService.Table.server.data.corruption-Critical |
| Node inaccessible for virtual machine placement | AzureStack.ComputeController.HostUnresponsive |
| Blob service data is corrupted | StorageService.Blob.service.data.is.corrupted-Critical |
| Account and Container Service data corruption | StorageService.Account.and.Container.Service.data.corruption-Critical |

Beginning with Azure Stack Hub version 2108 if proactive log collection is disabled, logs are captured and stored locally for proactive failure events. Microsoft only accesses the local logs in the context of a support case.

::: moniker-end

Proactive log collection can be disabled and re-enabled anytime. Follow these steps to set up proactive log collection.

1. Sign in to the Azure Stack Hub administrator portal.
1. Open **Help + support Overview**.
1. If the banner appears, select **Enable proactive log collection**. Or you can select **Settings** and set **Proactive log collection** to **Enable**, then select **Save**.

> [!NOTE]
> If log location settings are configured for a local file share, make sure lifecycle management policies will prevent share storage from reaching its size quota. Azure Stack Hub does not monitor local file share or enforce any retention policies.

### How the data is handled

You agree to periodic automatic log collections by Microsoft based only on Azure Stack Hub system health alerts. You also acknowledge and consent to the upload and retention of those logs in an Azure storage account managed and controlled by Microsoft.

The data is used for troubleshooting system health alerts and isn't used for marketing, advertising, or any other commercial purposes without your consent. The data can be retained for up to 90 days and Microsoft handles any data collected following our [standard privacy practices](https://privacy.microsoft.com/).

The revocation of your permission doesn't affect any data previously collected with your consent.

Logs collected using **Proactive log collection** are uploaded to an Azure storage account managed and controlled by Microsoft. Microsoft might access these logs in the context of a support case and to improve the health of Azure Stack Hub.

## Send logs now

> [!TIP]
> Save time by using [Send logs proactively](#send-logs-proactively) instead of Send logs now.

Send logs now is an option where you manually collect and uploads your diagnostic logs from Azure Stack Hub, usually before opening a support case.

There are two ways you can manually send diagnostic logs to Microsoft Support:

* [Administrator portal (recommended)](#send-logs-now-with-the-administrator-portal)
* [PowerShell](#send-logs-now-with-powershell)

If Azure Stack Hub is connected to Azure, we recommend using the administrator portal because it's the simplest way to send the logs directly to Microsoft. If the portal is unavailable, you should send logs using PowerShell.

> [!NOTE]
> If you send logs using the administrator portal or PowerShell cmdlet, [Test-AzureStack](azure-stack-diagnostic-test.md) runs automatically in the background to collect diagnostic information.

### Send logs now with the administrator portal

To send logs now using the administrator portal:

1. Open **Help + support > Log Collection > Send logs now**.
1. Specify the start time and end time for log collection.
1. Choose the local time zone.
1. Select **Collect and Upload**.

If you're disconnected from the internet or want to only save logs locally, use the [Get-AzureStackLog](azure-stack-get-azurestacklog.md) method to send logs.

### Send logs now with PowerShell

If you're using the **Send logs now** method and want to use PowerShell instead of the administrator portal, you can use the `Send-AzureStackDiagnosticLog` cmdlet to collect and send specific logs.

* The **FromDate** and **ToDate** parameters can be used to collect logs for a particular time period. If these parameters aren't specified, logs are collected for the past four hours by default.

* Use the **FilterByNode** parameter to filter logs by computer name. For example:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByNode azs-xrp01
  ```

* Use the **FilterByLogType** parameter to filter logs by type. You can choose to filter by File, Share, or WindowsEvent. For example:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByLogType File
  ```

* Use the **FilterByResourceProvider** parameter to send diagnostic logs for value-add Resource Providers (RPs). The general syntax is:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvider <<value-add RP name>>
  ```

  ::: moniker range=">= azs-2008"

  To send diagnostic logs for SQL RP:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvider SQLAdapter
  ```
  To send diagnostic logs for MySQL RP:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvider MySQLAdapter
  ```

  ::: moniker-end

  To send diagnostic logs for Event Hubs:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvider eventhub
  ```

  To send diagnostic logs for Azure Stack Edge:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvide databoxedge
  ```

* Use the **FilterByRole** parameter to send diagnostic logs from VirtualMachines and BareMetal roles:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByRole VirtualMachines,BareMetal
  ```

* To send diagnostic logs from VirtualMachines and BareMetal roles, with date filtering for log files for the past 8 hours:

  ```powershell
  $fromDate = (Get-Date).AddHours(-8)
  Invoke-Command -Session $pepsession -ScriptBlock {Send-AzureStackDiagnosticLog -FilterByRole VirtualMachines,BareMetal -FromDate $using:fromDate}
  ```

* To send diagnostic logs from VirtualMachines and BareMetal roles, with date filtering for log files for the time period between 8 hours ago and 2 hours ago:

  ```powershell
  $fromDate = (Get-Date).AddHours(-8)
  $toDate = (Get-Date).AddHours(-2)
  Invoke-Command -Session $pepsession -ScriptBlock {Send-AzureStackDiagnosticLog -FilterByRole VirtualMachines,BareMetal -FromDate $using:fromDate -ToDate $using:toDate}
  ```

> [!NOTE]
> If you're disconnected from the internet or want to only save logs locally, use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) method to send logs.

### How the data is handled

By initiating diagnostic log collection from Azure Stack Hub, you acknowledge and consent to uploading those logs and retaining them in an Azure storage account managed and controlled by Microsoft. Microsoft Support can access these logs right away with the support case without having to engage with the customer for log collection.

::: moniker range=">= azs-2005"

## Save logs locally

You can save logs to a local Server Message Block (SMB) share when Azure Stack Hub is disconnected from Azure. You may, for example, run a disconnected environment. If you're normally connected but are experiencing connectivity issues, you can save logs locally to help with troubleshooting.

 In the **Settings** blade, enter the path and a username and password with permission to write to the share. During a support case, Microsoft Support works to provide detailed steps on how to get these local logs transferred. If the Administrator portal is unavailable, you can use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) to save logs locally.

![Screenshot of diagnostic log collection options](media/azure-stack-help-and-support/save-logs-locally.png)

::: moniker-end

## Bandwidth considerations

The average size of diagnostic log collection varies based on whether it runs proactively or manually. The average size for **Proactive log collection** is around 2 GB. The collection size for **Send logs now** depends on how many hours (up to 4 hours) are being collected and the number of physical nodes in the Azure Stack Hub scale unit (4 to 16 nodes).

The following table lists considerations for environments with limited or metered connections to Azure.

| Network connection | Impact |
|----|---|
| Low-bandwidth/high-latency connection | Log upload takes an extended amount of time to complete. |
| Shared connection | The upload may also affect other apps/users sharing the network connection. |
| Metered connection | There may be another charge from your ISP for the extra network usage. |

For example, if the internet connection or link speed from Azure Stack Hub is 5 Megabits/second (low-bandwidth), it would take approximately 57 minutes to upload 2 GB of diagnostic log data to Microsoft support. For an 8 GB manual log collection using a 5 Megabits/second link speed, it would take approx. 3 hours and 49 minutes to upload the data. This extended length of time to upload diagnostic data could delay or affect the support experience.

## View log collection

The history of logs collected from Azure Stack Hub appears on the **Log collection** page in **Help + support**, with the following dates and times:

- **Time Collected**: When the log collection operation began.
- **Status**: Either in progress or complete.
- **Logs start**: Start of the time period for which you want to collect.
- **Logs end**: End of the time period.
- **Type**: If it's a manual or proactive log collection.

![Log collections in Help + support](media/azure-stack-help-and-support/azure-stack-log-collection.png)

## See also

[Azure Stack Hub log and customer data handling](./azure-stack-data-collection.md)
