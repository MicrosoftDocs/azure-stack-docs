---
title: Manage security defaults for Azure Local
description: Learn how to manage security default settings available for Azure Local.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-local
ms.date: 10/23/2025
ms.subservice: hyperconverged
---

# Manage security defaults for Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to manage default security settings for your Azure Local instance. You can also modify drift control and protected security settings defined during deployment so your device starts in a known good state.

## Prerequisites

Before you begin, make sure that you have access to an Azure Local system that is deployed, registered, and connected to Azure.

## View security default settings in the Azure portal

To view the security default settings in the Azure portal, make sure that you apply the MCSB initiative. For more information, see [Apply Microsoft Cloud Security Benchmark initiative](./manage-security-with-defender-for-cloud.md#apply-microsoft-cloud-security-benchmark-initiative).

Use the security default settings to manage system security, drift control, and Secured-core settings on your system.

:::image type="content" source="media/manage-secure-baseline/manage-secure-baseline.png" alt-text="Screenshot that shows Security defaults page in the Azure portal." lightbox="media/manage-secure-baseline/manage-secure-baseline.png":::

View the SMB signing status under the **Data protections** > **Network protection** tab. SMB signing allows you to digitally sign SMB traffic between an Azure Local instance and other systems.

:::image type="content" source="media/manage-secure-baseline/manage-bitlocker-network-protection.png" alt-text="Screenshot that shows the SMB signing status in the Azure portal." lightbox="media/manage-secure-baseline/manage-bitlocker-network-protection.png":::

## View security baseline compliance in the Azure portal

After you enroll your Azure Local instance with Microsoft Defender for Cloud or assign the built-in policy *Windows machines should meet requirements of the Azure compute security baseline*, a compliance report is generated. For the full list of rules your Azure Local instance is compared to, see [Windows security baseline](/azure/governance/policy/samples/guest-configuration-baseline-windows).

For an Azure Local host machine, when all the hardware requirements for Secured-core are met, the default expected compliance score is 99% of the rules are compliant.

The following table explains the rules that aren't compliant and the rationale of the current gap:

> [!NOTE]
> Starting with Azure Local, version 2604, the two **Interactive logon** rules in the following table (message text and message title) are set to default values by the security baseline and protected by drift control, so they're no longer reported as non-compliant. To customize either value, first [disable drift control](#disable-drift-control). In earlier versions, these settings weren't managed by the baseline.

| Rule name           | Compliance state    | Reason   | Comments    |
|---------------------|---------------------|----------|------------|
| Interactive logon: Message text for users attempting to log on| Compliant in 2604+; otherwise not compliant | Warning - ""is equal to"" | See the preceding note. |
| Interactive logon: Message title for users attempting to log on| Compliant in 2604+; otherwise not compliant | Warning - "" is equal to "" | See the preceding note. |
| Minimum password length | Not Compliant | Critical - Seven is less than the minimum value of 14. | This must be defined by customer, it does not have drift control enabled in order to allow this setting to align with your organization's policies.|

### Fixing the compliance for the rules

To fix the compliance for the rules, run the following commands or use any other tool you prefer. On Azure Local, version 2604 and later, the legal notice is already configured by the baseline and protected by drift control — skip step 1 unless you intend to customize it (and first [disable drift control](#disable-drift-control)).

1. **Legal notice**: Create a custom value for legal notice depending on your organization's needs and policies. Run the following commands:

    ```PowerShell
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LegalNoticeCaption" -Value "Legal Notice"
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LegalNoticeText" -Value "LegalNoticeText"
    ```

1. **Minimum password length**: Set the minimum password length policy to 14 characters on the Azure Local machine. The default value is 7, and any value below 14 is still flagged by the monitoring baseline policy. Run the following commands:

    ```PowerShell
    net accounts /minpwlen:14
    ```

## Manage security defaults with PowerShell

When you enable drift protection, you can only change nonprotected security settings. To change protected security settings that form the baseline, you must first disable drift protection.

### View and download security settings

Use the following table to view and download the complete list of security settings based on the software version you're running.

| Azure Local solution version             | Running Azure Local OS version                       | Download link for settings csv file |
|------------------------------------------|-------------------------------------------|-------------------------------------|
| Deployments running v 2505 and earlier     | Running OS build 25398.xxxx and domain-joined                      | [Download security baseline](https://aka.ms/SecBase) |
| Deployments running v 2506 and later   | Running OS build 26100.xxxx and domain-joined     | [Download security baseline](https://aka.ms/SecBaseDomJoin) |
| Deployments running v 2506 and later   | Running OS build 26100.xxxx and not domain-joined (also known as AD-less)    | [Download security baseline](https://aka.ms/SecBaseAdless) |

## Modify security defaults

Start with the initial security baseline, and then modify drift control and protected security settings defined during deployment.

### Enable drift control

Use the following steps to enable drift control:

1. Connect to your Azure Local machine.
1. Run the following cmdlet:

    ```PowerShell
    # Apply to the local node (default)
    Enable-AzsSecurity -FeatureName DriftControl -Local

    # Apply to all nodes in the cluster using the orchestrator
    Enable-AzsSecurity -FeatureName DriftControl -Cluster
    ```

   - **`-Local`** - Affects the local node only. This value is the default if you don't specify a scope switch.
   - **`-Cluster`** - Affects all nodes in the cluster by using the orchestrator.

### Disable drift control

Use the following steps to disable drift control:

1. Connect to your Azure Local machine.
1. Run the following cmdlet:

    ```PowerShell
    # Apply to the local node (default)
    Disable-AzsSecurity -FeatureName DriftControl -Local

    # Apply to all nodes in the cluster using the orchestrator
    Disable-AzsSecurity -FeatureName DriftControl -Cluster
    ```

   - **`-Local`** - Affects the local node only. This value is the default if you don't specify a scope switch.
   - **`-Cluster`** - Affects all nodes in the cluster by using the orchestrator.

> [!IMPORTANT]
> If you disable drift control, you can modify the protected settings. If you enable drift control again, any changes you made to the protected settings are overwritten.

## Configure security settings during deployment

As part of deployment, you can modify drift control and other security settings that constitute the security baseline on your cluster.

The following table describes security settings that you can configure on your Azure Local instance during deployment.

| Feature area | Feature     | Description           |
|--------------|-------------|----------------------|
| Governance                 | [Security baseline](#view-and-download-security-settings)            | Maintains the security defaults on each node. Helps protect against changes.  |
| Credential protection      | [Windows Defender Credential Guard](/windows/security/identity-protection/credential-guard/credential-guard)     | Uses virtualization-based security to isolate secrets from credential-theft attacks. |
| Application control        | [Windows Defender Application control](/windows/security/threat-protection/windows-defender-application-control/wdac-and-applocker-overview#windows-defender-application-control)           | Controls which drivers and apps are allowed to run directly on each node.           |
| Data at-rest encryption    | [BitLocker for OS boot volume](/windows/security/information-protection/bitlocker/bitlocker-overview)          | Encrypts the OS startup volume on each node.                                        |
| Data at-rest encryption    | [BitLocker for data volumes](/windows/security/information-protection/bitlocker/bitlocker-overview)            | Encrypts cluster shared volumes (CSVs) on this system                               |
| Data in-transit protection | [Signing for external SMB traffic](/troubleshoot/windows-server/networking/overview-server-message-block-signing)      | Signs SMB traffic between this system and others to help prevent relay attacks.       |
| Data in-transit protection | [SMB Encryption for in-cluster traffic](/windows-server/storage/file-server/smb-security#smb-encryption) | Encrypts traffic between nodes in the system (on your storage network).            |

## Modify security settings after deployment

After deployment, use PowerShell to modify security settings while maintaining drift control. Some features require a reboot to take effect.

### PowerShell cmdlet properties

The following cmdlet properties are for the *AzureStackOSConfigAgent* module. The deployment installs the module.

- `Get-AzsSecurity -FeatureName <name> [-Local | -PerNode | -AllNodes | -Cluster]`
  - **`-Local`** - Provides a boolean value (True/False) for the local node. You can run it from a regular remote PowerShell session. This value is the default if you don't specify a scope switch.
  - **`-PerNode`** - Provides a boolean value (True/False) for each node. Requires CredSSP or a remote desktop protocol (RDP) connection.
  - **`-AllNodes`** - Provides a boolean value (True/False) computed across all nodes. Requires CredSSP or an RDP connection.
  - **`-Cluster`** - Provides the boolean value from the ECE store. Interacts with the orchestrator and applies to all nodes in the cluster. Requires CredSSP or an RDP connection.
  

- `Enable-AzsSecurity -FeatureName <name> [-Local | -Cluster]`
- `Disable-AzsSecurity -FeatureName <name> [-Local | -Cluster]`
  - **`-Local`** - Applies the change to the local node only. This value is the default if you don't specify a scope switch.
  - **`-Cluster`** - Applies the change to all nodes in the cluster by using the orchestrator.
  - **`-FeatureName`** - The security feature to act on. The following table lists the valid values. `DriftControl` is also a valid value; see [Enable drift control](#enable-drift-control) and [Disable drift control](#disable-drift-control).

> [!IMPORTANT]
> The `Enable-AzsSecurity` and `Disable-AzsSecurity` cmdlets are only available on new deployments or on upgraded deployments after security baselines are properly applied to nodes. For more information, see [Manage security after upgrading Azure Local](manage-security-post-upgrade.md).

The following table lists the security features you can manage by using the `Get-AzsSecurity`, `Enable-AzsSecurity`, and `Disable-AzsSecurity` cmdlets. It shows the value to pass to `-FeatureName`, the operations each feature supports, whether it supports drift control, and whether a reboot is required.

| `-FeatureName` value | Feature | Supported operations | Supports drift control | Reboot required |
| --- | --- | --- | --- | --- |
| `VBS` | Virtualization Based Security (VBS) | Enable | Yes | Yes |
| `CredentialGuard` | Credential Guard | Enable, Disable | Yes | Yes |
| `DRTM` | Dynamic Root of Trust for Measurement (DRTM) | Enable, Disable | Yes | Yes |
| `HVCI` | Hypervisor-protected Code Integrity (HVCI) | Enable, Disable | Yes | Yes |
| `SideChannelMitigation` | Side channel mitigation | Enable, Disable | Yes | Yes |
| `SMBSigning` | SMB signing | Enable, Disable | Yes | No * |
| `SMBClusterEncryption` | SMB cluster encryption | Enable, Disable | No (cluster setting) | No * |

\* No reboot is required. Newly established SMB connections negotiate and honor the updated configuration immediately. Existing SMB sessions continue using their previously negotiated settings until they reconnect.

## Next steps

- [Understand BitLocker encryption](.././concepts/security-bitlocker.md).
