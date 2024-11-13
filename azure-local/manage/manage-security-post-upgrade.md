---
title: Manage security after upgrading your Azure Local from version 22H2 to version 23H2.
description: Learn how to manage security posture after you have upgraded Azure Local to version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack-hci
ms.date: 11/13/2024
---

# Manage security after upgrading Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to manage security settings after upgrading Azure Local from version 22H2 to version 23H2.

## Prerequisites

Before you begin, make sure that you have access to an Azure Local, version 23H2 system that was upgraded from version 22H2.

## Post upgrade security changes

When your Azure Local is upgraded from version 22H2 to version 23H2, the security posture of your system isn't modified. We strongly recommend that you take extra steps to avail of the security benefits by updating security posture after upgrade.

Updating the security settings provides you the following benefits:

- Improves the security posture by disabling legacy protocols and ciphers, and hardening your deployment.
- Reduces Operating Expense (OpEx) with a built-in drift protection mechanism that enables consistent at-scale monitoring via the Azure Arc Hybrid Edge baseline.
- Enables you to closely meet Center for Internet Security (CIS) benchmark and Defense Information System Agency (DISA) Security Technical Implementation Guide (STIG) requirements for the OS.

Make the following high-level changes after the upgrade is complete:

1. Apply the security baseline.
1. Apply encryption at-rest.
1. Enable Application Control.

Each of these steps is described in detail in the following sections.

### Apply security baselines

A new deployment of Azure Local introduces two baselines documents injected by the security management layer, while the upgraded cluster doesn't.

> [!IMPORTANT]
> After applying the security baseline documents, a new mechanism is used to apply and maintain the [Security baseline settings]((https://aka.ms/hci-securitybase).

1. If your servers are inheriting any baseline settings using mechanisms such as GPO, DSC, Scripts, we recommend that you:

    - Remove these duplicate settings from such mechanisms.
    - Alternatively, after applying the security baseline, [Disable the drift control mechanism](./manage-secure-baseline.md).

    The resultant new security posture of your servers will be a combination of the previous settings, the new settings, and the overlapping settings with updated values.

    > [!NOTE]
    > Microsoft tests and vaildates the Azure Local, version 23H2 security settings. We strongly recommend that you keep these settings. Use of custom settings can potentially lead to system instability, incompatibility with the new product scenarios, and could require extensive testing and troubleshooting on your part.

1. When running the next commands, you'll find the documents aren't in place. These cmdlets won't return any output.

    ```powershell
    Get-AzSSecuritySettingsConfiguration
    Get-AzSSecuredCoreConfiguration
    ```

1. To enable the baselines, go to each of the nodes you upgraded and execute. Run the following commands locally or remotely using a privileged administrator account:

    ```powershell
    Start-AzSSecuritySettingsConfiguration
    Start-AzSSecuredCoreConfiguration
    ```

1. Proceed to reboot the nodes in a proper sequence for the new settings to become effective.

### Confirm the status of the security baselines

After rebooting, rerun the cmdlets to confirm the status of the security baselines:

```powershell
Get-AzSSecuritySettingsConfiguration
Get-AzSSecuredCoreConfiguration
```

You'll get an output for each cmdlet with the baseline information.

Example of the SecureSettingsConfiguration baseline output:

### Enable encryption at-rest

During the upgrade, Microsoft detects if your system nodes has BitLocker enabled. If enabled, you're prompted to suspend it.
If you previously enabled BitLocker across your volumes, after you resume the protection, no further steps are required from you.

To verify the status of encryption across your volumes, run the following commands:

```powershell
Get-AsBitlocker -VolumeType BootVolume
Get-AsBitlocker -VolumeType ClusterSharedVolume
```

If you need to enable BitLocker on any of your volumes, see how to [Manage BitLocker encryption on Azure Local](../manage/manage-bitlocker.md).

### Enable Application Control

Application control for business (formerly known as Windows Defender Application Control or WDAC) provides a great layer of defense against running untrusted code.

After you've upgraded to version 23H2, consider enabling WDAC. This can be disruptive if the necessary measures aren't taken for proper validation of existing third party software already existing on the servers.

For this reason, for new deployments, WDAC is enabled in *Enforced* mode (blocking nontrusted binaries), whereas for upgraded systems we recommend that you follow these steps:

1. [Enable WDAC in *Audit* mode](./manage-wdac.md)(assuming unknown software might be present).
1. [Monitor WDAC events](./manage-wdac.md).
1. [Create the necessary supplemental policies](./manage-wdac.md).
1. Repeat steps #2 and #3 as necessary until no further audit events are observed, then you can proceed to switch to *Enforced* mode.

    > [!WARNING]
    Failure to create the necessary AppControl policies to enable additional third party software will prevent that software from running.

For instructions to enable in *Enforced* mode, see [Manage Windows Defender Application Control for Azure Local](./manage-wdac.md).

## Next steps

- [Understand BitLocker encryption](.././concepts/security-bitlocker.md).
