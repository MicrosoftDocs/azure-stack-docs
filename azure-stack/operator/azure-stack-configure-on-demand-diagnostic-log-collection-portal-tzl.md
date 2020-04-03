---
title: Send Azure Stack Hub diagnostic logs now 
description: Learn how to collect diagnostic logs on demand in Azure Stack Hub using the Administrator portal or a PowerShell script.
author: justinha

ms.topic: article
ms.date: 03/30/2020
ms.author: justinha
ms.reviewer: shisab
ms.lastreviewed: 03/30/2020

---
# Send Azure Stack Hub diagnostic logs now

::: moniker range="azs-2002"

Azure Stack operators can send diagnostics logs on-demand to Microsoft Customer Support Services (CSS), before requesting support, by using the Administrator portal or PowerShell. If Azure Stack Hub is connected to the Azure, the **Send logs now** option in the Administrator portal is recommended because it's the simplest way to send the logs directly to Microsoft. If the portal is unavailable, operators should instead [send logs now using Send-AzureStackDiagnosticLog](azure-stack-configure-on-demand-diagnostic-log-collection-powershell-tzl.md). 

If you are disconnected from the internet or want to only save logs locally, use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) method to send logs. The following flowchart shows which option to use for sending diagnostic logs in each case. 

![Flowchart shows how to send logs now to Microsoft](media/azure-stack-help-and-support/send-logs-now-flowchart.png)

>[!NOTE]
>As an alternative to collecting logs on demand, you can streamline the troubleshooting process by [proactively collecting diagnostic logs](azure-stack-configure-automatic-diagnostic-log-collection-tzl.md). If system health conditions need to be investigated, the logs are uploaded automatically for analysis before opening a case with CSS. If proactive log collection is enabled, **Help and Support** shows when log collection is in progress. If you click **Send logs now** to collect logs from a specific time while proactive log collection is in progress, on-demand collection begins after proactive log collection is complete.

Specify the start time and end time for log collection and click **Collect and Upload**. 

![Screenshot of option to Send logs now](media/azure-stack-help-and-support/send-logs-now.png)


::: moniker-end
::: moniker range="azs-1910"
## Use Help and Support to collect diagnostic logs on demand

To troubleshoot a problem, CSS might request an Azure Stack Hub operator to collect diagnostic logs on demand for a specific time window from the previous week. In that case, CSS will provide the operator with a SAS URL for uploading the collection. 
Use the following steps to configure on-demand log collection using the SAS URL from CSS:

1. Open **Help and Support Overview** and click **Collect logs now**. 
1. Choose a 1-4 hour sliding window from the last seven days. 
1. Choose the local time zone.
1. Enter the SAS URL that CSS provided.

   ![Screenshot of on-demand log collection](media/azure-stack-automatic-log-collection/collect-logs-now.png)

>[!NOTE]
>If automatic diagnostic log collection is enabled, **Help and Support** shows when log collection is in progress. If you click **Collect logs now** to collect logs from a specific time while automatic log collection is in progress, on-demand collection begins after automatic log collection is complete. 


::: moniker-end

## Next steps

[Use the privileged endpoint (PEP) to send Azure Stack Hub diagnostic logs](azure-stack-configure-on-demand-diagnostic-log-collection-powershell-tzl.md)

