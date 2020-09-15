---
title: Send Azure Stack Hub diagnostic logs now 
description: Learn how to collect diagnostic logs on demand in Azure Stack Hub using the Administrator portal or a PowerShell script.
author: myoungerman

ms.topic: article
ms.date: 08/24/2020
ms.author: v-myoung
ms.reviewer: shisab
ms.lastreviewed: 08/24/2020

---
# Send Azure Stack Hub diagnostic logs now

::: moniker range=">= azs-2002"

Azure Stack operators can send diagnostics logs on-demand to Microsoft Support, before requesting support, by using the Administrator portal or PowerShell. If Azure Stack Hub is connected to the Azure, the **Send logs now** option in the Administrator portal is recommended because it's the simplest way to send the logs directly to Microsoft. If the portal is unavailable, operators should instead [send logs now using Send-AzureStackDiagnosticLog](./azure-stack-configure-on-demand-diagnostic-log-collection-powershell.md?view=azs-2002). 

If you are disconnected from the internet or want to only save logs locally, use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) method to send logs. The following flowchart shows which option to use for sending diagnostic logs in each case. 

![Flowchart shows how to send logs now to Microsoft](media/azure-stack-help-and-support/send-logs-now-flowchart.png)

>[!NOTE]
>As an alternative to collecting logs on demand, you can streamline the troubleshooting process by [proactively collecting diagnostic logs](./azure-stack-configure-automatic-diagnostic-log-collection.md?view=azs-2002). If system health conditions need to be investigated, the logs are uploaded automatically for analysis before opening a case with Microsoft Support. If proactive log collection is enabled, **Help and Support** shows when log collection is in progress. If you click **Send logs now** to collect logs from a specific time while proactive log collection is in progress, on-demand collection begins after proactive log collection is complete.

Specify the start time and end time for log collection and click **Collect and Upload**. 

![Screenshot of option to Send logs now](media/azure-stack-help-and-support/send-logs-now.png)


::: moniker-end
::: moniker range=">= azs-2005"
## Save logs locally

You can save logs to a local SMB share when Azure Stack Hub is disconnected from Azure. In the **Settings** blade, enter the path and a username and password with permission to write to the share. During a support case, Microsoft Support will provide detailed steps on how to get these local logs transferred. If the Administrator portal is unavailable, you can use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) to save logs locally.

![Screenshot of diagnostic log collection options](media/azure-stack-help-and-support/save-logs-locally.png)

::: moniker-end
::: moniker range="<= azs-1910"
## Use Help and Support to collect diagnostic logs on demand

To troubleshoot a problem, Microsoft Support might request an Azure Stack Hub operator to collect diagnostic logs on demand for a specific time window from the previous week. In that case, Microsoft Support will provide the operator with a SAS URL for uploading the collection. 
Use the following steps to configure on-demand log collection using the SAS URL from Microsoft Support:

1. Open **Help + support > Log Collection > Collect logs now**. 
1. Choose a 1-4 hour sliding window from the last seven days. 
1. Choose the local time zone.
1. Enter the SAS URL that Microsoft Support provided.

   ![Screenshot of on-demand log collection](media/azure-stack-automatic-log-collection/collect-logs-now.png)

>[!NOTE]
>If automatic diagnostic log collection is enabled, **Help and Support** shows when log collection is in progress. If you click **Collect logs now** to collect logs from a specific time while automatic log collection is in progress, on-demand collection begins after automatic log collection is complete. 


::: moniker-end


## Next steps

[Use the privileged endpoint (PEP) to send Azure Stack Hub diagnostic logs](./azure-stack-configure-on-demand-diagnostic-log-collection-powershell.md?view=azs-2002)
