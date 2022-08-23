---
title: Collect diagnostic logs (preview)
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

This article describes how to collect diagnostic logs and send them to Microsoft for identifying and fixing any issues with your Azure Stack HCI solution. It also provides information on one known issue in this release associated with log collection and its workaround.

In this release, you can manually send log files to Microsoft or you can provide consent during deployment to allow Microsoft to utilize the diagnostics logs for troubleshooting.

## Collect logs manually using PowerShell

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

## Known issues

There's one known issue with the manual log collection process in this release. When you execute the `Send-DiagnosticData` cmdlet, the Windows Event logs aren't collected by default.

**Workaround**

Before collecting logs, perform the following steps:

1. Run `Get-ASWDACPolicyInfo` cmdlet to get information about the policy mode.

   ```powershell
   Get-ASWDACPolicyInfo
   ```

1. Check the value of the `PolicyMode` parameter. It must be **Audit** and not **Enforced**.

   If `PolicyMode` is already **Audit**, skip steps 3 and 4. If it's **Enforced** as shown in the following screenshot, continue to step 3.
    
   :::image type="content" source="./media/collect-logs/policy-mode-enforced.png" alt-text="Screenshot showing the policy mode as "Enforced"." lightbox="./media/collect-logs/policy-mode-enforced.png":::

1. Run the following cmdlet to switch the policy mode. Wait up to five minutes for `PolicyMode` to get updated to **Audit**.

    ```powershell
    Switch-ASWDACPolicy -Mode -mode Audit
    ```

1. Run `Get-ASWDACPolicyInfo` again to confirm the `PolicyMode` parameter is updated to **Audit**, as shown in the following screenshot:

   :::image type="content" source="./media/collect-logs/policy-mode-audit.png" alt-text="Screenshot showing the policy mode as "Audit"." lightbox="./media/collect-logs/policy-mode-audit.png":::

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