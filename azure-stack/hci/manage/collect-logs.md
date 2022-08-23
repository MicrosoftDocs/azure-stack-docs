---
title: Collect log data (preview)
description: How to use the Environment Checker to assess if your environment is ready for deploying Azure Stack HCI.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/22/2022
---

# Collect log data

> Applies to: Azure Stack HCI, version 22H2 (preview)

You can collect and send diagnostic logs to Microsoft to identify or fix issues with your Azure Stack HCI solution. You can either manually send log files to Microsoft or you can give consent to Microsoft to proactively collect log data.

This article describes how to collect log data and send it to Microsoft. It also provides information on one known issue in this release.

## Send logs manually using PowerShell

Use the `Send-DiagnosticData` cmdlet to collect and send diagnostic logs manually.

To send on-demand logs, enter the following cmdlet:

```powershell
Send-DiagnosticData
```

After Azure Stack HCI collects log data, it is retained for 90 days. To get a history of log collections on stamp for last 90 days:

```powershell
Get-LogCollectionHistory  
```   

## Send logs proactively

During deployment, you can provide consent to Microsoft to proactively collect diagnostic logs from a secure and controlled environment. Proactive log collection is enabled by default. The `-IncludeGetSDDCLogs`parameter is set to `$true` by default, which indicates the proactive log collection is enabled. You can disable proactive log collection to stop Microsoft from collecting logs.

## Known issues

There's one known issue with this release.

**Issue**

When you execute the `Send-DiagnosticData` cmdlet, the Windows Event logs isn't collected by default.

**Workaround**

Before collecting logs, perform the following steps:

1.  Before collecting logs execute Get-ASWDACPolicyInfo to get information about the PolicyMode

    -   Ensure the PolicyMode is "**Audit**" and not "**Enforced**" as
        in the screenshot below.

> ![Text Description automatically
> generated](./media//media/image1.png){width="4.541666666666667in"
> height="1.6354166666666667in"}

-   If the PolicyMode is already in "**Audit**", skip step 2. If
    PolicyMode is "Enforced" continue to step 2.

2.  Switch-ASWDACPolicy -Mode -mode Audit

> ![](./media//media/image2.png){width="5.947916666666667in"
> height="0.6145833333333334in"}
>
> You may have to wait upto 5 minutes for the PolicyMode to get updated
> to Audit.

-   Confirm the policy change is complete by executing
    Get-ASWDACPolicyInfo

> ![Text Description automatically
> generated](./media//media/image3.png){width="4.260416666666667in"
> height="1.65625in"}

3.  Execute Log collection using Send-DiagnosticData

> ![Text Description automatically
> generated](./media//media/image4.png){width="6.229166666666667in"
> height="2.4166666666666665in"}
>
> ![Text Description automatically generated with medium
> confidence](./media//media/image5.png){width="3.5520833333333335in"
> height="2.3125in"}

4.  After log collection is complete, please execute the following
    cmdlet to switch policy back to the default Enforced mode.

> Switch-ASWDACPolicy -Mode Enforced


## Next steps

- [Contact Microsoft Support](get-support.md)