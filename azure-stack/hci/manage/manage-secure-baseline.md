---
title: Manage baseline security settings on Azure Stack HCI, version 23H2 (preview)
description: Learn about managing baseline security settings available for new deployments of Azure Stack HCI, version 23H2 (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/04/2023
---

# Manage baseline security settings for Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage baseline security settings for your Azure Stack HCI cluster and the associated drift control mechanism to ensure that the device starts in a known good state.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Enable, disable, or toggle drift control

To adjust security hardening, we recommend a balanced security posture. Use the initial security baseline, toggle drift control, and modify protected security settings defined during deployment.

### Enable drift control

Use the following steps to enable drift control:

1. Connect to your Azure Stack HCI node.
1. Run the following cmdlet:

    ```PowerShell
    Enable-AzsSecurity -FeatureName DriftControl -Scope <Local | Cluster>
    ```

   - **Local** - Affects the local node only. Can be run from a remote PowerShell session.
   - **Cluster** - Affects all nodes in the cluster using the orchestrator. Requires user to belong to the deployment authorization group (PREFIX-ECESG) and CredSSP, or an Azure Stack HCI server using a remote desktop protocol (RDP) connection.

### Disable drift control

Use the following steps to disable drift control:

1. Connect to your Azure Stack HCI node.
1. Run the following cmdlet:

    ```PowerShell
    Disable-AzsSecurity -FeatureName DriftControl -Scope <Local | Cluster>
    ```

   - **Local** - Affects the local node only. Can be run from a regular remote PowerShell session.
   - **Cluster** - Affects all nodes in the cluster using the orchestrator. Requires user to belong to the deployment authorization group (PREFIX-ECESG) and CredSSP, or an Azure Stack HCI server using a remote desktop protocol (RDP) connection.

### Toggle drift control

Use the following steps to toggle drift control:

1. Connect to your Azure Stack HCI node.
1. Run the following cmdlet using local administrator credentials or deployment user account credentials.

## Configure security during deployment

When deploying your cluster via the Supplemental Package, you can modify drift control settings and other security settings that constitute the security baseline. Changes you make to security settings are also reflected in the *config.json* file that you create using the deployment tool.

The following table describes security settings that can be configured on your Azure Stack HCI cluster during deployment.

| Feature area | Feature     |Description           | Supports drift control? |
|--------------|-------------|----------------------|---------------------------------|
| Governance                 | [Security baseline](./manage/secure-baseline.md)            | Maintains the security defaults on each server. Helps protect against changes.  | Yes                             |
| Credential protection      | [Windows Defender Credential Guard](/windows/security/identity-protection/credential-guard/credential-guard)     | Uses virtualization-based security to isolate secrets from credential-theft attacks. | Yes                             |
| Application control        | [Windows Defender Application control](/windows/security/threat-protection/windows-defender-application-control/wdac-and-applocker-overview#windows-defender-application-control)           | Controls which drivers and apps are allowed to run directly on each server.           | No                              |
| Data at-rest encryption    | [BitLocker for OS boot volume](/windows/security/information-protection/bitlocker/bitlocker-overview)          | Encrypts the OS startup volume on each server.                                        | No                              |
| Data at-rest encryption    | [BitLocker for data volumes](/windows/security/information-protection/bitlocker/bitlocker-overview)            | Encrypts cluster shared volumes (CSVs) on this cluster                               | No                              |
| Data in-transit protection | [Signing for external SMB traffic](/troubleshoot/windows-server/networking/overview-server-message-block-signing)      | Signs SMB traffic between this system and others to help prevent relay attacks.       | Yes                             |
| Data in-transit protection | [SMB Encryption for in-cluster traffic](/windows-server/storage/file-server/smb-security#smb-encryption) | Encrypts traffic between servers in the cluster (on your storage network).            | No                              |

### Modify security after deployment

Once the deployment is complete, you can modify security features while maintaining drift control. Some features require a reboot to take effect.

### PowerShell cmdlet properties

The following cmdlet properties are for the *AzureStackOSConfigAgent* module.

- `Get-AzsSecurity`  -Scope: <Local | PerNode | AllNodes | Cluster>
- `Enable-AzsSecurity`   -Scope <Local | Cluster>
- `Disable-AzsSecurity`  -Scope <Local | Cluster>

  - **Local** - Provides boolean value (true/False) on local node. Can be run from a regular remote PowerShell session.
  - **PerNode** - Provides boolean value (true/False) per node.
  - **Report** - Requires CredSSP or an Azure Stack HCI server using a remote desktop protocol (RDP) connection.
    - AllNodes –Provides boolean value (true/False) computed across nodes-  requires CredSSP (when using remote PowerShell) or Console session (RDP).
    - Cluster  –Provides boolean value from ECE store. Interacts with the orchestrator and acts to all the nodes in the cluster, requires deployment authorization (PREFIX-ECESG) and either CredSSP (when using remote PowerShell) or Console session (RDP).
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

## View security settings

With drift protection enabled, you can only modify non-protected security settings. To modify protected security settings that form the baseline, you must first disable drift protection. To view and download the complete list of security settings, see [SecurityBaseline](https://aka.ms/hci-securitybase).

## Next steps

- [Understand BitLocker encryption](./manage./security-bitlocker.md).
