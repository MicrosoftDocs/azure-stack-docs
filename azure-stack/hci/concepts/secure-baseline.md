---
title: Security baseline settings on Azure Stack HCI (preview)
description: Learn about the default security baseline settings available for new deployments of Azure Stack HCI (preview).
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 01/09/2023
---

# Security baseline settings for Azure Stack HCI (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes the security baseline settings associated with your Azure Stack HCI cluster, the associated drift control mechanism, and baseline management.

Azure Stack HCI is a secure-by-default product and has more than 200 security settings enabled right from the start. These settings provide a consistent security baseline and ensure that the device always starts in a known good state.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Benefits of the security baseline

The security baseline on Azure Stack HCI:

- Enables you to closely meet Center for Internet Security (CIS) benchmark and Defense Information System Agency (DISA) Security Technical Implementation Guide (STIG) requirements for the operating system (OS) and the Microsoft recommended security baseline.
- Reduces the operating expenditure (OPEX) with its built-in drift protection mechanism and consistent at-scale monitoring via the Azure Arc Hybrid Edge baseline.
- Improves the security posture by disabling legacy protocols and ciphers.

## About security baseline and drift control

When you prepare the Active Directory for Azure Stack HCI and create a dedicated organizational unit (OU), by default, the existing group policies and Group Policy Object (GPO) inheritance are blocked. Blocking these policies ensures that there is no conflict of security settings.

The Azure Stack HCI Supplemental Package deployment then establishes and maintains:

- A new built-in configuration management stack in the operating system.
- A security baseline.
- Secured-core settings for your cluster.

You can monitor and perform drift protection of this default enabled security baseline and secured-core settings during both deployment and runtime. You can also disable the drift protection during the deployment when you configure the security settings.

With the drift protection applied, the security settings are refreshed regularly after every 90 minutes. This refresh interval is the same as that for the group policies and ensures that any changes from the desired state are remediated. This continuous monitoring and auto-remediation allows you to have a consistent and reliable security posture throughout the lifecycle of the device.


## Modify drift control

To adjust security hardening as per your requirements, we recommend that you keep a balanced security posture. Use the initial security baseline, stop the drift control, and modify any of the protected security settings that you defined during the deployment.

To disable or enable drift control, follow these steps.

1. Connect to your Azure Stack HCI node via Remote Desktop Protocol.
1. By default, drift control is enabled. To disable the drift control, run the following command:
    ```azurepowershell
    Disable-ASOSConfigDriftControl

    ```

1. To enable the drift control again, run the following command:
    ```azurepowershell
    Enable-ASOSConfigDriftControl
    ```
1. If using a multi-node cluster, repeat this command on all the nodes of your cluster.


> [!IMPORTANT]
> With the drift control enabled, the only way to modify the security baseline settings is via the [PowerShell cmdlets](#enable-commands).
> 
> Do not modify the protected security settings via any other mechanism, for example, manually edit using Registry editor, SecEdit (including local policies), System Center Configuration Manager, Desired State Configuration (DSC), or a third-party tool. Any changes made through these tools will only be temporary. The change will revert when the drift protection is triggered every 90 minutes.

## Manage security baseline 

When deploying your cluster via the Supplemental Package, you can modify the drift control settings as well as other security settings that constitute the security baseline. The changes that you make to the security settings are also reflected in the *config.json* that you are create using the deployment tool.

### Configure security during deployment

The following table describes the security settings that can be configured on your Azure Stack HCI cluster during deployment.

| Feature area | Feature     |Description           | Supports drift control? |
|--------------|-------------|----------------------|---------------------------------|
| Governance                 | [Security baseline](secure-baseline.md)            | Maintains the security defaults on each server. Helps protect against changes.  | Yes                             |
| Credential protection      | [Windows Defender Credential Guard](/windows/security/identity-protection/credential-guard/credential-guard)     | Uses virtualization-based security to isolate secrets from credential-theft attacks. | Yes                             |
| Application control        | [Windows Defender Application control](/windows/security/threat-protection/windows-defender-application-control/wdac-and-applocker-overview#windows-defender-application-control)           | Controls which drivers and apps are allowed to run directly on each server.           | No                              | 
| Data at-rest encryption    | [BitLocker for OS boot volume](windows/security/information-protection/bitlocker/bitlocker-overview)          | Encrypts the OS startup volume on each server.                                        | No                              | 
| Data at-rest encryption    | [BitLocker for data volumes](windows/security/information-protection/bitlocker/bitlocker-overview)            | Encrypts cluster shared volumes (CSVs) on this cluster                               | No                              |
| Data in-transit protection | [Signing for external SMB traffic](/troubleshoot/windows-server/networking/overview-server-message-block-signing)      | Signs SMB traffic between this system and others to help prevent relay attacks.       | Yes                             |
| Data in-transit protection | [SMB Encryption for in-cluster traffic](/windows-server/storage/file-server/smb-security#smb-encryption) | Encrypts traffic between servers in the cluster (on your storage network).            | No                              | 


### Modify security after deployment

Once the deployment is complete, you can also toggle certain security features via while maintaining the drift control. Here is a comprehensive table of the commands used to modify these security features. As noted, some of these features may require a reboot to take effect.

#### Enable commands

| Name                                           | Supports drift control | Reboot to take effect? |
|------------------------------------------------|------------------------|------------------------|
| Enable-ASOSConfigCredentialGuardSetting        |                        |                        |
| Enable-ASOSConfigDRTMSetting                   |                        |                        |
| Enable-ASOSConfigHVCISetting                   |                        |                        |
| Enable-ASOSConfigSideChannelMitigationSetting  |                        |                        |
| Enable-ASOSConfigSMBSigning                    | Yes                    | Yes                    |
| Enable-ASOSConfigSMBClusterEncryption          | No, cluster setting    | No                     |

#### Disable commands

| Name                                           | Supports drift control | Reboot to take effect? |
|------------------------------------------------|------------------------|------------------------|
| Disable-ASOSConfigCredentialGuardSetting       |                        |                        |
| Disable-ASOSConfigDRTMSetting                  |                        |                        |
| Disable-ASOSConfigHVCISetting                  |                        |                        |
| Disable-ASOSConfigSideChannelMitigationSetting |                        |                        |
| Disable-ASOSConfigSMBSigning                   | Yes                    | Yes                    |
| Disable-ASOSConfigSMBClusterEncryption         | No, cluster setting    | No                     |


## View the settings

With the drift protection enabled, you can only modify the non-protected security settings. To modify the protected security settings that form the baseline, you need to first disable the drift protection. You can find and download the complete list of security settings at: [aka.ms/hci-securitybase](https://aka.ms/hci-securitybase).


## Next steps

- [Azure Stack HCI security considerations](./security.md)
