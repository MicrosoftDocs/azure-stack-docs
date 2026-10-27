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

## What the security baseline covers

Azure Local applies a security baseline when you deploy, and reapplies it every time you update, so each machine starts and stays in a known good state. Drift control then holds each setting at its baseline value, or at the value you customized, and reverts changes made outside the supported cmdlets.

Starting with Azure Local, version 2610, the baseline evaluates 429 settings on a domain-joined deployment, compared with 408 in earlier versions. Deployments that aren't domain-joined, also known as AD-less, evaluate 403 settings, compared with 382. You don't need to do anything to pick up the new settings. They're applied as part of the solution update, and drift control covers them from that point on.

To see the full list of settings for the version you're running, download the settings file from [View and download security settings](#view-and-download-security-settings). To change the value of an individual setting, see [Customize individual security settings](#customize-individual-security-settings).

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
> Starting with Azure Local, version 2607, the security baseline configures all three rules in the following table, so they're no longer reported as non-compliant. Starting with version 2610, to change any of these values, use [`Set-AzsSecurity`](#customize-individual-security-settings).

| Rule name           | Compliance state    | Reason   | Comments    |
|---------------------|---------------------|----------|------------|
| Interactive logon: Message text for users attempting to log on| Compliant in 2604+; otherwise not compliant | Warning - ""is equal to"" | Set by the baseline in 2604+. |
| Interactive logon: Message title for users attempting to log on| Compliant in 2604+; otherwise not compliant | Warning - "" is equal to "" | Set by the baseline in 2604+. |
| Minimum password length | Compliant in 2607+; otherwise not compliant | Critical - Seven is less than the minimum value of 14. | Set by the baseline in 2607+. |

### Fixing the compliance for the rules

Run the following commands only on versions where the table shows the rule as not compliant.

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

Starting with Azure Local, version 2610, you can change any customizable setting in the security baseline while drift control stays enabled. In version 2609 and earlier, you must first disable drift control to change a protected setting. For details, see [Modify security defaults](#modify-security-defaults).

### View and download security settings

Use the following table to view and download the complete list of security settings based on the software version you're running.

| Azure Local solution version             | Running Azure Local OS version                       | Download link for settings csv file |
|------------------------------------------|-------------------------------------------|-------------------------------------|
| Deployments running v 2505 and earlier     | Running OS build 25398.xxxx and domain-joined                      | [Download security baseline](https://aka.ms/SecBase) |
| Deployments running v 2506 through 2609   | Running OS build 26100.xxxx and domain-joined     | [Download security baseline](https://aka.ms/SecBaseDomJoin) |
| Deployments running v 2506 through 2609   | Running OS build 26100.xxxx and not domain-joined (also known as AD-less)    | [Download security baseline](https://aka.ms/SecBaseAdless) |
| Deployments running v 2610 and later   | Running OS build 26100.xxxx and domain-joined     | [Download security baseline](https://aka.ms/SecBaseDomJoin2610) |
| Deployments running v 2610 and later   | Running OS build 26100.xxxx and not domain-joined (also known as AD-less)    | [Download security baseline](https://aka.ms/SecBaseAdless2610) |

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

After deployment, you have two ways to change security on your Azure Local instance. Drift control stays enabled with both methods:

- **Turn a security feature on or off.** Use `Enable-AzsSecurity` and `Disable-AzsSecurity` to toggle the named features listed in this section, such as Credential Guard, HVCI, or SMB signing. Some features require a reboot to take effect.
- **Change the value of an individual setting.** Starting with version 2610, use `Set-AzsSecurity` to customize a single setting in the security baseline. Drift control then protects the value you set, instead of the baseline value. For details, see [Customize individual security settings](#customize-individual-security-settings).

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
> The `Enable-AzsSecurity`, `Disable-AzsSecurity`, and, starting with version 2610, `Set-AzsSecurity` and `Get-AzsSecurityPolicyIntent` cmdlets are only available on new deployments or on upgraded deployments after security baselines are properly applied to nodes. For more information, see [Manage security after upgrading Azure Local](manage-security-post-upgrade.md).

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

::: moniker range=">=azloc-2610"

## Customize individual security settings

The `Enable-AzsSecurity` and `Disable-AzsSecurity` cmdlets turn named security features on and off. To change the value of an individual setting inside the security baseline, use `Set-AzsSecurity`. Drift control stays enabled for every setting, including the one you customize. It protects the value you set instead of the baseline value.

Use `-Cluster` to apply the same value on every machine. A cluster customization is recorded as policy intent, and Azure Local reapplies that intent when you update. This method is the recommended way to customize a setting.

Run the cmdlet without `-Cluster` to change only the machine you're connected to. A local change also persists through solution updates, which lets you keep a different value on a specific machine.

When a setting has cluster intent, the intent takes precedence over any local change on every machine. Don't make a local change to a setting that already has cluster intent, because Azure Local reapplies the cluster value at the next solution update.

> [!IMPORTANT]
> Customize baseline settings only with `Set-AzsSecurity`. Changing the same settings any other way, such as through Group Policy or directly in the registry, isn't supported, and drift control reverts those changes.

### Security policy types

Every setting belongs to one of three policy types. Pass the type that owns the setting to `-Type`:

| `-Type` value | Settings it contains |
| --- | --- |
| `SecuritySettings` | The OS security baseline: registry, security policy, audit policy, and user rights settings. Most customizations use this type. |
| `SecuredCore` | Secured-core platform features: virtualization-based security, hypervisor-enforced code integrity, and System Guard launch. |
| `DefenderAntivirus` | Microsoft Defender Antivirus configuration. |

To find the name to pass to `-SettingName`, download the security baseline CSV for your version from [View and download security settings](#view-and-download-security-settings) and use the value in the **Name** column. The name must match exactly; the cmdlet doesn't complete setting names when you press Tab. For example, the **Enable insecure guest logons** control is `LanmanWorkstationEnableInsecureGuestLogons`.

### Customize a setting

1. Connect to your Azure Local machine.
1. Run the following cmdlet:

    ```PowerShell
    # Recommended. Applies to every machine
    Set-AzsSecurity -Type SecuritySettings -SettingName "LanmanWorkstationEnableInsecureGuestLogons" -Value "1" -Cluster

    # Applies only to the machine you're connected to
    Set-AzsSecurity -Type SecuritySettings -SettingName "LanmanWorkstationEnableInsecureGuestLogons" -Value "1"
    ```

   - **`-Cluster`** - Records the change as cluster policy intent, then applies it on every machine. If you omit this switch, only the machine you're connected to changes.

A value can be a string, an integer, or a list. Integers are converted to strings. To set a list value, pass an array:

```PowerShell
Set-AzsSecurity -Type SecuritySettings -SettingName "<setting name>" -Value @("<value1>", "<value2>") -Cluster
```

### Customize several settings at the same time

To change more than one setting as a single operation, pass a hash table to `-Settings`. Either all of the settings are applied, or none of them are:

```PowerShell
Set-AzsSecurity -Type SecuritySettings -Settings @{ "<setting1>" = "1"; "<setting2>" = @("<value1>", "<value2>") } -Cluster
```

### Reset a setting to its baseline value

To discard a customization and return a setting to the value defined by the baseline, use `-Default`. Match the scope of the reset to the scope of the change you're undoing:

```PowerShell
# Undo a cluster customization and remove the recorded policy intent
Set-AzsSecurity -Type SecuritySettings -SettingName "LanmanWorkstationEnableInsecureGuestLogons" -Default -Cluster

# Undo a change made on only the machine you're connected to
Set-AzsSecurity -Type SecuritySettings -SettingName "LanmanWorkstationEnableInsecureGuestLogons" -Default
```

To reset several settings in one operation, use `-DefaultSettings`. You can combine it with `-Settings` to customize some settings and reset others at the same time. A setting can't appear in both parameters:

```PowerShell
Set-AzsSecurity -Type SecuritySettings -Settings @{ "<setting1>" = "1" } -DefaultSettings @("<setting2>") -Cluster
```

Resetting with `-Cluster` removes the recorded policy intent, so the setting follows the baseline again after future updates.

### Confirm a change

`Set-AzsSecurity` asks you to confirm before it changes anything. The prompt names the setting, the value it's moving from and to, and where the change applies:

```PowerShell
Set-AzsSecurity -Type SecuritySettings -SettingName "LanmanWorkstationEnableInsecureGuestLogons" -Value "1" -Cluster
```

```output
Confirm
Are you sure you want to perform this action?
Performing the operation "change 'LanmanWorkstationEnableInsecureGuestLogons' from '0' to '1'" on target "SecuritySettings on all cluster bare-metal nodes".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
```

Enter **Y** to apply the change or **N** to cancel.

A small number of settings weaken your security posture when you change them. Those settings show a warning and ask you to confirm it as well.

To run the cmdlet unattended in a script, add both `-Confirm:$false` and `-Force`. Together they suppress the confirmation prompt and the security warning. Before you suppress the warning, make sure you understand the effect of the change.

### Settings you can't customize

You can't change some settings because they're critical to the integrity and supportability of your Azure Local instance. If you target one of these settings, `Set-AzsSecurity` blocks the change, reports which setting it rejected, and makes no modification. You can't override blocked settings with `-Force`.

A blocked attempt returns an error that names the setting:

```output
The setting 'WinRMAllowBasicAuthClient' is blocked from customization.
```

Nothing is written when this happens. The setting keeps its baseline value, no customer intent is recorded, and a `SecuritySettingBlocked` event is emitted so that support can see the attempt.

The blocked settings fall into six groups.

**Credential protection and authentication.** These settings govern how credentials are stored, delegated, and sent across the network. Weakening them exposes credentials to theft or replay.

- `AllowPKU2UAuthenticationAllowOnlineID`
- `CredDelegationNonExportable`
- `CredSspAllowEncryptionOracle`
- `DenyStoredCredsForNetAuth`
- `DeviceLockClearTextPassword`
- `LANManagerAuthenticationLevel`
- `LimitBlankPasswordConsoleOnly`
- `SendUnencryptedPasswordToThirdPartySMBServers`

**Platform integrity.** These settings underpin virtualization-based security and the signed boot chain, which the rest of the security baseline depends on.

- `DeviceGuardLsaCfgFlags`
- `DeviceGuardRequireMicrosoftSignedBootChain`
- `DeviceGuardRequirePlatformSecurityFeatures`

**Host firewall.** Turning a firewall profile off, or allowing inbound connections by default, exposes cluster traffic that the baseline is designed to contain.

- `FirewallDomainProfileApplyLocalFirewallRules`
- `FirewallDomainProfileInboundConnection`
- `FirewallDomainProfileState`
- `FirewallPrivateProfileInboundConnection`
- `FirewallPrivateProfileState`
- `FirewallPublicProfileInboundConnection`
- `FirewallPublicProfileState`
- `FWDomainLocalConnSecRules`

**SMB protocol version.** Lowering the minimum SMB version reintroduces protocol weaknesses that affect storage and cluster communication.

- `MinimumSMBClientVersion`
- `MinimumSMBServerVersion`

**Remote management.** These settings control how the instance is administered remotely. Allowing basic or unencrypted authentication would expose administrative credentials in transit.

- `RemoteManagementAllowRemoteServerManagement`
- `WinRMAllowBasicAuthClient`
- `WinRMAllowBasicAuthService`
- `WinRMAllowUnencryptedClient`
- `WinRMAllowUnencryptedService`
- `WinRMDisallowRunAsCreds`

**Microsoft Defender Antivirus.** Changing these settings turns off real-time protection or the attack surface reduction rule that blocks process creation from PsExec and WMI commands.

- `ASRBlockProcessCreationFromPSExecAndWMICommands`
- `DisableAntiSpyware`
- `DisableRealtimeMonitoring`

You can customize settings that aren't listed here either without a prompt or after you confirm that the change weakens your security posture.

### Review the settings you customized

To see which settings currently have a recorded customization, run:

```PowerShell
Get-AzsSecurityPolicyIntent
```

The cmdlet returns the cluster customizations recorded as policy intent, grouped by policy type. The cmdlet doesn't list settings that still follow the baseline, or changes made on a single machine without `-Cluster`.

::: moniker-end

## Modify security defaults

This section applies to Azure Local, version 2609 and earlier. In those versions, to change a protected setting in the security baseline, you disable drift control, make the change, and then decide whether to enable drift control again.

Starting with version 2610, don't disable drift control to change a setting. Use [`Set-AzsSecurity`](#customize-individual-security-settings) instead. Drift control stays enabled and keeps protecting every setting, including the ones you customize.

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

## Next steps

- [Manage Application Control for Azure Local](manage-wdac.md)
- [Manage BitLocker encryption on Azure Local](manage-bitlocker.md)
- [Manage security with Microsoft Defender for Cloud](manage-security-with-defender-for-cloud.md)
