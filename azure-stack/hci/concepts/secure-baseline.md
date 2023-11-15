---
title: Security baseline settings on Azure Stack HCI, version 23H2 (preview)
description: Learn about the default security baseline settings available for new deployments of Azure Stack HCI, version 23H2 (preview).
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/13/2023
---

# Security baseline settings for Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes the security baseline settings associated with your Azure Stack HCI cluster, the associated drift control mechanism, and baseline management.

Azure Stack HCI is a secure-by-default product and has more than 300 security settings enabled right from the start. These settings provide a consistent security baseline to ensure that the device always starts in a known good state.

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

With drift protection applied, the security settings are refreshed regularly after every 90 minutes. This refresh interval is the same as that for the group policies and ensures that any changes from the desired state are remediated. This continuous monitoring and auto-remediation allows you to have a consistent and reliable security posture throughout the lifecycle of the device.

## Modify drift control

To adjust security hardening as per your requirements, we recommend that you keep a balanced security posture. Use the initial security baseline, stop the drift control, and modify any of the protected security settings that you defined during the deployment.

To toggle drift control, follow these steps.

1. Connect to your Azure Stack HCI node.

1. Run the following PowerShell command using local administrator credentials or deployment user account credentials.

1. To disable drift control:

    ```PowerShell
    Disable-AzsSecurity -FeatureName DriftControl -Scope <Local | Cluster>
    ```

    - **Local** - Affects local node only. Can be run on a regular remote PowerShell session.
    - **Cluster** - Affects all nodes in the cluster using the orchestrator. Requires user to belong to the deployment authorization group (PREFIX-ECESG) and CredSSP or an Azure Stack HCI server using a remote desktop protocol (RDP) connection.

1. To enable drift control:

    ```PowerShell
    Enable-AzsSecurity -FeatureName DriftControl -Scope <Local | Cluster>
    ```

    - **Local** - Affects local node only. Can be run on a regular remote PowerShell session.
    - **Cluster** - Affects all nodes in the cluster using the orchestrator. Requires user to belong to the deployment authorization group (PREFIX-ECESG) and CredSSP or an Azure Stack HCI server using a remote desktop protocol (RDP) connection.

## Manage security baseline

When deploying your cluster via the Supplemental Package, you can modify the drift control settings as well as other security settings that constitute the security baseline. The changes that you make to the security settings are also reflected in the *config.json* that you are create using the deployment tool.

### Configure security during deployment

The following table describes the security settings that can be configured on your Azure Stack HCI cluster during deployment.

| Feature area | Feature     |Description           | Supports drift control? |
|--------------|-------------|----------------------|---------------------------------|
| Governance                 | [Security baseline](secure-baseline.md)            | Maintains the security defaults on each server. Helps protect against changes.  | Yes                             |
| Credential protection      | [Windows Defender Credential Guard](/windows/security/identity-protection/credential-guard/credential-guard)     | Uses virtualization-based security to isolate secrets from credential-theft attacks. | Yes                             |
| Application control        | [Windows Defender Application control](/windows/security/threat-protection/windows-defender-application-control/wdac-and-applocker-overview#windows-defender-application-control)           | Controls which drivers and apps are allowed to run directly on each server.           | No                              |
| Data at-rest encryption    | [BitLocker for OS boot volume](/windows/security/information-protection/bitlocker/bitlocker-overview)          | Encrypts the OS startup volume on each server.                                        | No                              |
| Data at-rest encryption    | [BitLocker for data volumes](/windows/security/information-protection/bitlocker/bitlocker-overview)            | Encrypts cluster shared volumes (CSVs) on this cluster                               | No                              |
| Data in-transit protection | [Signing for external SMB traffic](/troubleshoot/windows-server/networking/overview-server-message-block-signing)      | Signs SMB traffic between this system and others to help prevent relay attacks.       | Yes                             |
| Data in-transit protection | [SMB Encryption for in-cluster traffic](/windows-server/storage/file-server/smb-security#smb-encryption) | Encrypts traffic between servers in the cluster (on your storage network).            | No                              |

### Modify security after deployment

Once the deployment is complete, you can also enable security features while maintaining drift control. Here is a table of the commands used to modify these security features.

As noted, some of these features might require a reboot to take effect. We provide commands to Get, Enable, and Disable security features.

### PowerShell cmdlet properties for `AzureStackOSConfigAgent` module

The following cmdlet properties are for module *AzureStackOSConfigAgent*.

- `Get-AzsSecurity`  -Scope: <Local | PerNode | AllNodes | Cluster>
- `Enable-AzsSecurity`   -Scope <Local | Cluster>
- `Disable-AzsSecurity`  -Scope <Local | Cluster>

  - **Local** - Provides boolean value (true/False) on local node. Can be run on a regular remote PowerShell session.
  - **PerNode** - Provides boolean value (true/False) per node.
  - **Report** - Requires CredSSP or an Azure Stack HCI server using a remote desktop protocol (RDP) connection.
    AllNodes –Provides boolean value (true/False) computed across nodes-  requires CredSSP (when using remote PowerShell) or Console session (RDP).
    Cluster  –Provides boolean value from ECE store. Interacts with the orchestrator and acts to all the nodes in the cluster, requires deployment authorization (PREFIX-ECESG) and either CredSSP (when using remote PowerShell) or Console session (RDP).
  - **FeatureName** - <CredentialGuard | DriftControl | DRTM | HVCI | SideChannelMitigation | SMBEncryption | SMBSigning | VBS>
    - Credential Guard
    - Drift Control
    - VBS (Virtualization Based Security)- We only support enable command.
    - DRTM (Dynamic Root of Trust for Measurement)
    - HVCI (Hypervidor Enforced if Code Integrity)
    - Side Channel Mitigation
    - SMB Encryption
    - SMB Signing

|Name |Feature |Supports drift control |Reboot required |
|-----|--------|-----------------------|----------------|
|Enable <br> |Virtualization Bsed Security (VBS) |Yes   |Yes |
|Enable <br> Disable |Dynamic Root of Trust for Measurement (DRTM) |Yes |Yes |
|Enable <br> Disable |Hypervisor-protected Code Integrity (HVCI) |Yes |Yes |
|Enable <br> Disable |Side channel mitigation |Yes |Yes |
|Enable <br> Disable |SMB signing |Yes |Yes |
|Enable <br> Disable |SMB cluster encryption |No, cluster setting |No |

## View the settings

With drift protection enabled, you can only modify non-protected security settings. To modify protected security settings that form the baseline, you must first disable drift protection. You can find and download the complete list of security settings at: [SecurityBaseline](https://aka.ms/hci-securitybase).

## Next steps

- [Understand BitLocker encryption](./security-bitlocker.md)
