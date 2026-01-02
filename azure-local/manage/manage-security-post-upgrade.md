---
title: Manage security after upgrading your Azure Local from an Azure Stack HCI, version 22H2.
description: Learn how to manage security posture after you upgrade Azure Local from an Azure Stack HCI, version 22H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 02/19/2025
ms.subservice: hyperconverged
---

# Manage security after upgrading Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to manage security settings on an Azure Local that was upgraded from an Azure Stack HCI, version 22H2.

## Prerequisites

Before you begin, make sure that you have access to an Azure Local system that was upgraded from an Azure Stack HCI, version 22H2.

## Post upgrade security changes

When you upgrade your system from Azure Stack HCI, version 22H2, the security posture of your system doesn't change. We strongly recommend that you update the security settings after the upgrade to benefit from enhanced security.

Here are the benefits of updating the security settings:

- Improves the security posture by disabling legacy protocols and ciphers, and hardening your deployment.
- Reduces Operating Expense (OpEx) with a built-in drift protection mechanism for consistent at-scale monitoring via the Azure Arc Hybrid Edge baseline.
- Enables you to closely meet Center for Internet Security (CIS) benchmarks and Defense Information System Agency (DISA) Security Technical Implementation Guide (STIG) requirements for the OS.

Make these high-level changes after the upgrade is complete:

1. Apply the security baseline.
1. Apply encryption at-rest.
1. Enable Application Control.

Each of these steps is described in detail in the following sections.

### Apply security baselines

A new deployment of Azure Local introduces two baselines documents injected by the security management layer, while the upgraded cluster doesn't.

> [!IMPORTANT]
> After you apply the security baseline documents, a new mechanism is used to apply and maintain [Security baseline settings](https://aka.ms/hci-securitybase).

1. If your servers inherit baseline settings through mechanisms such as GPO, DSC, or scripts, we recommend that you:

    - Remove these duplicate settings from such mechanisms.
    - Alternatively, after you apply the security baseline, [Disable the drift control mechanism](./manage-secure-baseline.md).

    The new security posture of your servers combines previous settings, new settings, and overlapping settings with updated values.

    > [!NOTE]
    > Microsoft tests and vaildates the Azure Local security settings. We strongly recommend that you keep these settings. Use of custom settings can potentially lead to system instability, incompatibility with new product scenarios, and could require extensive testing and troubleshooting on your part.

1. When running the following commands, you'll find the documents aren't in place. These cmdlets won't return any output.

   ```powershell
   Get-ASOSConfigSecuredCoreDoc
   Get-ASOSConfigSecuritySettingsDoc
   ```

1. To enable the baselines, go to each of the nodes you upgraded. Run the following commands locally or remotely using a privileged administrator account:

   ```powershell
   Start-AzSSecuritySettingsConfiguration
   Start-AzSSecuredCoreConfiguration
   ```

1. Reboot the nodes in a proper sequence for the new settings to become effective.

### Confirm the status of the security baselines

After rebooting, rerun the following cmdlets to confirm the status of security baselines:

```powershell
Get-ASOSConfigSecuredCoreDoc
Get-ASOSConfigSecuritySettingsDoc
```

You get an output for each cmdlet with baseline information.

Here's an example of the baseline output:

```powershell
OsConfiguration": {
"Document": {
"schemaversion": "1.0",
"id": "<GUID>", "version": "1.0",
"context": "device",
"scenario": "ApplianceSecurityBaselineConfig"
```

### Enable encryption at-rest

During the upgrade, Microsoft detects if your system nodes have BitLocker enabled. If BitLocker is enabled, you're prompted to suspend it. If you previously enabled BitLocker across your volumes, resume the protection. No further steps are required.

To verify the status of encryption across your volumes, run the following commands:

```powershell
Get-AsBitlocker -VolumeType BootVolume
Get-AsBitlocker -VolumeType ClusterSharedVolume
```

If you need to enable BitLocker on any of your volumes, see [Manage BitLocker encryption on Azure Local](../manage/manage-bitlocker.md).

### Enable Application Control

Application control for business (formerly known as Windows Defender Application Control or WDAC) provides a great layer of defense against running untrusted code.

After you upgrade your system, consider enabling Application Control. This can be disruptive if the necessary measures aren't taken for proper validation of existing non-Microsoft software already existing on the servers.

For new deployments, Application Control is enabled in *Enforced* mode (blocking nontrusted binaries), whereas for upgraded systems we recommend that you follow these steps:

1. [Enable Application Control in *Audit* mode (assuming unknown software might be present)](./manage-wdac.md#switch-application-control-policy-modes).
1. [Monitor Application Control events](/windows/security/application-security/application-control/app-control-for-business/operations/event-id-explanations).
1. [Create the necessary supplemental policies](./manage-wdac.md#create-an-application-control-supplemental-policy).
1. Repeat steps #2 and #3 as necessary until no further audit events are observed. Switch to *Enforced* mode.

    > [!WARNING]
    > Failure to create the necessary AppControl policies to enable non-Microsoft software may prevent that software from running.

For instructions to enable in *Enforced* mode, see [Manage Windows Defender Application Control for Azure Local](./manage-wdac.md#switch-application-control-policy-modes).

## Next steps

- [Understand BitLocker encryption](../manage/manage-secure-baseline.md).
