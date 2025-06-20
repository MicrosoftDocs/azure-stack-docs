---
title: Manage security defaults on Azure Local, version 23H2
description: Learn how to manage security default settings available for Azure Local, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 02/03/2025
---

# Manage security defaults for Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to manage default security settings for your Azure Local instance. You can also modify drift control and protected security settings defined during deployment so your device starts in a known good state.

## Prerequisites

Before you begin, make sure that you have access to an Azure Local system that is deployed, registered, and connected to Azure.

## View security default settings in the Azure portal

To view the security default settings in the Azure portal, make sure that you have applied the MCSB initiative. For more information, see [Apply Microsoft Cloud Security Benchmark initiative](./manage-security-with-defender-for-cloud.md#apply-microsoft-cloud-security-benchmark-initiative).

You can use the security default settings to manage system security, drift control, and Secured core settings on your system.

:::image type="content" source="media/manage-secure-baseline/manage-secure-baseline.png" alt-text="Screenshot that shows Security defaults page in the Azure portal." lightbox="media/manage-secure-baseline/manage-secure-baseline.png":::

View the SMB signing status under the **Data protections** > **Network protection** tab. SMB signing allows you to digitally sign SMB traffic between an Azure Local instance and other systems.

:::image type="content" source="media/manage-secure-baseline/manage-bitlocker-network-protection.png" alt-text="Screenshot that shows the SMB signing status in the Azure portal." lightbox="media/manage-secure-baseline/manage-bitlocker-network-protection.png":::

## View security baseline compliance in the Azure portal

After you enroll your Azure Local instance with Microsoft Defender for Cloud or assign the built-in policy *Windows machines should meet requirements of the Azure compute security baseline*, a compliance report is generated. For the full list of rules your Azure Local instance is compared to, see [Windows security baseline](/azure/governance/policy/samples/guest-configuration-baseline-windows).

For an Azure Local machine, when all the hardware requirements for Secured-core are met, the default expected compliance score is 321 out of 324 rules - that is, 99% of the rules are compliant.

The following table explains the rules that aren't compliant and the rationale of the current gap:

| Rule name           | Compliance state    | Reason   | Comments    |
|---------------------|---------------------|----------|------------|
| Interactive logon: Message text for users attempting to log on| Not compliant | Warning - ""is equal to"" | This must be defined by customer, it does not have drift control enabled.|
| Interactive logon: Message title for users attempting to log on| Not Compliant | Warning - "" is equal to "" |This must be defined by customer, it does not have drift control enabled.|
| Minimum password length | Not Compliant | Critical - Seven is less than the minumum value of 14. | This must be defined by customer, it does not have drift control enabled in order to allow this setting to align with your organization's policies.|

### Fixing the compliance for the rules

To fix the compliance for the rules, run the following commands or use any other tool you prefer:

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

With drift protection enabled, you can only modify nonprotected security settings. To modify protected security settings that form the baseline, you must first disable drift protection.

### View and download security settings

Use the following table to view and download the complete list of security settings based on the software version you are running.

| Azure Local solution version             | Running Azure Local OS version                       | Download link for settings csv file |
|------------------------------------------|-------------------------------------------|-------------------------------------|
| 2505 existing deployments                | Running OS build 25398.xxxx and domain-joined                      | [Download security baseline](https://aka.ms/2505-secbase) |
| 2506 new deployments                     | Running OS build 26100.xxxx and domain-joined     | [Download security baseline](https://aka.ms/2506-26100-secbase) |
| 2506 existing deployments                | Running OS build 26100.xxxx and not domain-joined (also known as AD-less)    | [Download security baseline](https://aka.ms/2506-25398-secbase) |

## Modify security defaults

Start with the initial security baseline and then modify drift control and protected security settings defined during deployment.

### Enable drift control

Use the following steps to enable drift control:

1. Connect to your Azure Local machine.
1. Run the following cmdlet:

    ```PowerShell
    Enable-AzsSecurity -FeatureName DriftControl -Scope <Local | Cluster>
    ```

   - **Local** - Affects the local node only.
   - **Cluster** - Affects all nodes in the cluster using the orchestrator.

### Disable drift control

Use the following steps to disable drift control:

1. Connect to your Azure Local machine.
1. Run the following cmdlet:

    ```PowerShell
    Disable-AzsSecurity -FeatureName DriftControl -Scope <Local | Cluster>
    ```

   - **Local** - Affects the local node only.
   - **Cluster** - Affects all nodes in the cluster using the orchestrator.

> [!IMPORTANT]
> If you disable drift control, the protected settings can be modified. If you enable drift control again, any changes that you since made to the protected settings are overwritten.

## Configure security settings during deployment

As part of deployment, you can modify drift control and other security settings that constitute the security baseline on your cluster.

The following table describes security settings that can be configured on your Azure Local instance during deployment.

| Feature area | Feature     |Description           | Supports drift control? |
|--------------|-------------|----------------------|---------------------------------|
| Governance                 | [Security baseline](.././concepts/secure-baseline.md)            | Maintains the security defaults on each node. Helps protect against changes.  | Yes                             |
| Credential protection      | [Windows Defender Credential Guard](/windows/security/identity-protection/credential-guard/credential-guard)     | Uses virtualization-based security to isolate secrets from credential-theft attacks. | Yes                             |
| Application control        | [Windows Defender Application control](/windows/security/threat-protection/windows-defender-application-control/wdac-and-applocker-overview#windows-defender-application-control)           | Controls which drivers and apps are allowed to run directly on each node.           | No                              |
| Data at-rest encryption    | [BitLocker for OS boot volume](/windows/security/information-protection/bitlocker/bitlocker-overview)          | Encrypts the OS startup volume on each node.                                        | No                              |
| Data at-rest encryption    | [BitLocker for data volumes](/windows/security/information-protection/bitlocker/bitlocker-overview)            | Encrypts cluster shared volumes (CSVs) on this system                               | No                              |
| Data in-transit protection | [Signing for external SMB traffic](/troubleshoot/windows-server/networking/overview-server-message-block-signing)      | Signs SMB traffic between this system and others to help prevent relay attacks.       | Yes                             |
| Data in-transit protection | [SMB Encryption for in-cluster traffic](/windows-server/storage/file-server/smb-security#smb-encryption) | Encrypts traffic between nodes in the system (on your storage network).            | No                              |

## Modify security settings after deployment

After deployment is complete, you can use PowerShell to modify security settings while maintaining drift control. Some features require a reboot to take effect.

### PowerShell cmdlet properties

The following cmdlet properties are for the *AzureStackOSConfigAgent* module. The module is installed during deployment.

- `Get-AzsSecurity`  -Scope: <Local | PerNode | AllNodes | Cluster>
  - **Local** - Provides boolean value (true/False) on local node. Can be run from a regular remote PowerShell session.
  - **PerNode** - Provides boolean value (true/False) per node.
  - **Report** - Requires CredSSP or an Azure Local machine using a remote desktop protocol (RDP) connection.
    - AllNodes – Provides boolean value (true/False) computed across nodes.
    - Cluster – Provides boolean value from ECE store. Interacts with the orchestrator and acts to all the nodes in the cluster.
  

- `Enable-AzsSecurity`   -Scope <Local | Cluster>
- `Disable-AzsSecurity`  -Scope <Local | Cluster>
  - **FeatureName** - <CredentialGuard | DriftControl | DRTM | HVCI | SideChannelMitigation | SMBEncryption | SMBSigning | VBS>
    - Drift Control
    - Credential Guard
    - VBS (Virtualization Based Security)- We only support enable command.
    - DRTM (Dynamic Root of Trust for Measurement)
    - HVCI (Hypervisor Enforced if Code Integrity)
    - Side Channel Mitigation
    - SMB Signing
    - SMB Cluster encryption
    
    > [!IMPORTANT]
    > `Enable AzsSecurity` and `Disable AzsSecurity` cmdlets are only available on new deployments or on upgraded deployments after security baselines are properly applied to nodes. For more information, see [Manage security after upgrading Azure Local](manage-security-post-upgrade.md).

The following table documents supported security features, whether they support drift control, and whether a reboot is required to implement the feature.

|Name |Feature |Supports drift control |Reboot required |
|-----|--------|-----------------------|----------------|
|Enable <br> |Virtualization Based Security (VBS) |Yes   |Yes |
|Enable <br> |Credential Guard |Yes   |Yes |
|Enable <br> Disable |Dynamic Root of Trust for Measurement (DRTM) |Yes |Yes |
|Enable <br> Disable |Hypervisor-protected Code Integrity (HVCI) |Yes |Yes |
|Enable <br> Disable |Side channel mitigation |Yes |Yes |
|Enable <br> Disable |SMB signing |Yes |Yes |
|Enable <br> Disable |SMB cluster encryption |No, cluster setting |No |

## Next steps

- [Understand BitLocker encryption](.././concepts/security-bitlocker.md).
