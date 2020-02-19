---
title: Send Azure Stack Hub diagnostic logs now 
description: Learn how to collect diagnostic logs on demand in Azure Stack Hub using the Administrator portal or a PowerShell script.
author: justinha

ms.topic: article
ms.date: 02/18/2020
ms.author: justinha
ms.reviewer: shisab
ms.lastreviewed: 02/18/2020

---
# Send diagnostic logs now

Azure Stack operators can send diagnostics logs to Microsoft, before requesting support, by using the Administrator portal or PowerShell. Using the Administrator portal is recommended over PowerShell because it's simpler. But if the portal is unavailable, operators can then use the privileged endpoint (PEP).

This topic covers both ways of collecting diagnostic logs on demand.

If your want to provide logs to Microsoft for support, please use Send logs now. if portal is down. If you are disconnected or save logs locally use Get-AzurestackLog


>[!Note]
>As an alternative to collecting logs on demand, you can streamline the troubleshooting process by [proactively collecting diagnostic logs](azure-stack-configure-automatic-diagnostic-log-collection-tzl.md). If system health conditions need to be investigated, the logs are uploaded automatically for analysis before opening a case with CSS. 

## Using the Administrator portal

Specify the start time and end time for log collection and click **Collect and Upload**. 

![Screenshot of option to Send logs now](media/azure-stack-help-and-support/send-logs-now.png)

>[!NOTE]
>If proactive log collection is enabled, **Help and Support** shows when log collection is in progress. If you click **Send logs now** to collect logs from a specific time while proactive log collection is in progress, on-demand collection begins after proactive log collection is complete. 

## Using PowerShell

```powershell
$session = New-PSSession -ComputerName S11R1804-ERCS01 -ConfigurationName PrivilegedEndpoint -Credential $cred
$stampinfo=Invoke-Command -Session $session { Get-Azurestackstampinformation }
$stampinfo.CloudId
$stampinfo=Invoke-Command -Session $session { Send-AzureStackDiagnosticLog }
```


