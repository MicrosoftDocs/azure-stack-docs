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

This article describes how to manage security posture after upgrading Azure Local from version 22H2 to version 23H2.

## Prerequisites

Before you begin, make sure that you have access to an Azure Local, version 23H2 system that is deployed, registered, and connected to Azure.

## Post upgrade security changes

When your Azure Local is upgraded from version 22H2 to version 23H2, the security posture of your system is not modified.

We strongly recommended that you take these extra steps to avail of the security benefits by updating security posture after upgrade. The update will provide you the following security benefits:

- Improves the security posture by disabling legacy protocols and ciphers, and hardening your deployment.
- Reduces OPEX with a built-in drift protection mechanism that enables consistent at-scale monitoring via the Azure Arc Hybrid Edge baseline.
- Enables you to closely meet Center for Internet Security (CIS) benchmark and Defense Information System Agency (DISA) Security Technical Implementation Guide (STIG) requirements for the OS.

Make the following high-level changes after the upgrade has completed:

1. Apply the security baseline.
1. Apply encryption at-rest.
1. Enable Application Control.

Each of these steps is described in detail in the following sections.

### Apply security baselines

New deployment of Azure Local introduces 2 baselines documents injected by our security management layer, whilst upgraded cluster does not.

**Important:**

After applying the Security baselines documents, we will use a new mechanism to apply and maintain the settings described here: [Security Baselines](https://aka.ms/hci-securitybase).

If your servers are inheriting any of these settings described above using mechanisms like GPO, DSC, Scripts, etc., we recommend you to:

- Remove these duplicate settings from such mechanisms.
- Alternatively, after applying the security baseline, disable the drift control mechanism following the instructions here: [Manage security defaults on Azure Local, version 23H2 - Azure Local | Microsoft Learn](https://learn.microsoft.com/en-us/azure-stack/hci/manage/security-defaults).

The resultant new security posture of your servers will be:

Previous Settings + New Settings + Overlapping settings with updated values = New security posture.

**Note:** Azure Local 23H2, security settings are being tested and validated by the product owners and should be kept. Additional customer-driven settings can cause system instability, incompatibility with the new product scenarios and should be properly investigated and troubleshooted by the customer.

When running the next commands, you will find the documents are not in place:

```powershell
Get-AzSSecuritySettingsConfiguration
Get-AzSSecuredCoreConfiguration
```    
These cmdlets will not return any output.

To enable the baselines, go to each of the nodes you upgraded and execute (locally or remotely using a privileged administrator account):

```powershell
Start-AzSSecuritySettingsConfiguration
Start-AzSSecuredCoreConfiguration
```
Then proceed to reboot the nodes in a proper sequence for the new settings to become effective.

Confirming the status of the security baselines
After rebooting, re-run the cmdlets:

```powershell
Get-AzSSecuritySettingsConfiguration
Get-AzSSecuredCoreConfiguration
```

Now you will get an output for each of them with the baseline information:

Example of the SecureSettingsConfiguration baseline output:

### Enable encryption at-rest

During the upgrade process, Microsoft detects if your system nodes had BitLocker enabled. If BitLocker is enabled, you are prompted to suspend it.
If you previously enabled BitLocker across your volumes, after you resume the protection, there are no further steps required for you. 

To verify the status of your Encryptions across your volumes, run the following commands:

```powershell
Get-AsBitlocker -VolumeType BootVolume
Get-AsBitlocker -VolumeType ClusterSharedVolume
```

If any of your volumes need have BitLocker enabled, follow the steps here: [Manage BitLocker encryption on Azure Local, version 23H2](../manage/manage-bitlocker.md).

### Enable Application Control

Application control for business (formerly known as Windows Defender Application Control or WDAC) provides a great layer of defense against running untrusted code.

After you've upgraded to version 23H2, consider enabling WDAC. This can be disruptive if the necessary measures are not taken for proper validation of existing 3rd party software already existing on the servers.

For such reason, while in clean new deployments, WDAC is enabled in enforced mode (blocking non-trusted binaries), for upgraded systems we recommend you follow the next sequence:

1. [Enable WDAC in Audit mode (assuming unknown software might be present)](./manage-wdac.md).
1. [Monitor WDAC events](./manage-wdac.md).
1. [Create the necessary supplemental policies](./manage-wdac.md).
1. Repeat steps #2 and #3 as necessary until no further audit events are observed, then you can proceed to switch to Enforced mode.

    > [!WARNING]
    Failing to create the necessary AppControl policies to enable additional 3rd party software will prevent such software from running.

For instructions to enable in Enforced mode, see [Manage Windows Defender Application Control for Azure Local](./manage-wdac.md).

## Next steps

- [Understand BitLocker encryption](.././concepts/security-bitlocker.md).
