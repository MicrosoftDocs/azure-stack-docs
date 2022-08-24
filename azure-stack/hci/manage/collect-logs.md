---
title: Collect diagnostic logs for Azure Stack HCI, version 22H2 (preview)
description: How to collect diagnostic logs and share them with Microsoft.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/22/2022
---

# Collect diagnostic logs (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article describes how to collect diagnostic logs and send them to Microsoft to identify and fix any issues with your Azure Stack HCI solution. The article also provides information on known issue with log collection and the associated workaround.

You can manually collect and send the diagnostic logs to Microsoft. In this release, you can provide consent during deployment to allow Microsoft to use these logs for troubleshooting purposes.

## Collect logs via PowerShell

Use the `Send-DiagnosticData` cmdlet to manually collect and send diagnostic logs to Microsoft. You can run this cmdlet from any Azure Stack HCI server node.

Here's the syntax of the `Send-DiagnosticData` cmdlet:

```powershell
Send-DiagnosticData [[-FilterByRole] <string[]>] [[-FromDate] <datetime>] [[-ToDate] <datetime>] [[-CollectSddc] <bool>]  [<CommonParameters>]
```

where: 

- `FromDate` and `ToDate` parameters collect logs for a particular time period. If these parameters aren't specified, logs are collected for the past four hours by default. For example, to send diagnostics data with date filtering for log files for the past two hours, enter:

   ```powershell
   Send-DiagnosticData -FromDate (Get-Date).AddHours(-2) -ToDate (Get-Date)
   ```

- `FilterByRole` parameter collects and sends diagnostic logs for each role. For example, to send diagnostic data with role filtering for BareMetal and ECE, enter:

  ```powershell
  Send-DiagnosticData -FilterByRole BareMetal, ECE
  ```

- `CollectSddc` parameter is set to `$true` by default, which triggers the `Get-SDDCDiagnosticInfo` cmdlet and includes its logs as part of the log collection.

After Azure Stack HCI collects log data, it is retained for 90 days. To get a history of log collections for the last 90 days, enter:

  ```powershell
  Get-LogCollectionHistory  
  ```

## Known issue with log collection

There's one known issue with the manual log collection process in this release. When you execute the `Send-DiagnosticData` cmdlet, the Windows Event logs aren't collected by default.

**Workaround**

Before collecting logs, follow these steps:

1. Run PowerShell as administrator.

1. Run `Get-ASWDACPolicyInfo` cmdlet to get information about the policy mode.

   ```powershell
   Get-ASWDACPolicyInfo
   ```

1. Check the value of the `PolicyMode` parameter. It must be **Audit** and not **Enforced**.

   If `PolicyMode` is already **Audit**, skip steps 3 and 4. If it's **Enforced**, continue to step 3.

1. Run the following cmdlet to switch the policy mode. Wait up to five minutes for `PolicyMode` to get updated to **Audit**.

    ```powershell
    Switch-ASWDACPolicy -Mode Audit
    ```

1. Run `Get-ASWDACPolicyInfo` again to confirm the `PolicyMode` parameter is updated to **Audit**.

1. Run `Send-DiagnosticData` to collect logs.

   ```powershell
   Send-DiagnosticData -Verbose
   ```

1. After log collection is complete, run the following cmdlet to switch the policy mode back to the default **Enforced** mode.

    ```powershell
    Switch-ASWDACPolicy -Mode Enforced
    ```

## Next steps

- [Contact Microsoft Support](get-support.md)
- Review known issues in Azure Stack HCI, version 22H2 (preview)