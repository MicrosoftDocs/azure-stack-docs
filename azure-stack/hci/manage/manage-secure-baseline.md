---
title: Manage security defaults on Azure Stack HCI, version 23H2
description: Learn how to manage security default settings available for Azure Stack HCI, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 02/09/2024
---

# Manage security defaults for Azure Stack HCI, version 23H2

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage default security settings for your Azure Stack HCI cluster. You can also modify drift control and protected security settings defined during deployment so your device starts in a known good state.

## Prerequisites

Before you begin, make sure that the following prerequisites are completed:

- You have access to an Azure Stack HCI, version 23H2 system that is deployed, registered, and connected to Azure.
- If viewing settings via the Azure portal, make sure to satisfy these extra prerequisites:
  - You have applied the Microsoft Cloud Security Benchmark (MCSB) initiative. See [Apply Microsoft Cloud Security Benchmark initiative](#apply-microsoft-cloud-security-benchmark-initiative).
  - You have at least **Owner** or **Contributor** roles in your Azure subscription to apply MCSB.

### Apply Microsoft Cloud Security Benchmark initiative

[!INCLUDE [hci-apply-security-benchmark-initiative](../../includes/hci-apply-security-benchmark-initiative.md)]

## View security default settings in the Azure portal

Use security default settings to manage cluster security, drift control, and Secured core server settings on your cluster.

:::image type="content" source="media/manage-secure-baseline/manage-secure-baseline.png" alt-text="Screenshot that shows Security defaults page in the Azure portal." lightbox="media/manage-secure-baseline/manage-secure-baseline.png":::

View the SMB signing status under the **Data protections** > **Network protection** tab. SMB signing allows you to digitally sign SMB traffic between an Azure Stack HCI system and other systems.

:::image type="content" source="media/manage-secure-baseline/manage-bitlocker-network-protection.png" alt-text="Screenshot that shows the SMB signing status in the Azure portal." lightbox="media/manage-secure-baseline/manage-bitlocker-network-protection.png":::

## Manage security defaults with PowerShell

With drift protection enabled, you can only modify non-protected security settings. To modify protected security settings that form the baseline, you must first disable drift protection. To view and download the complete list of security settings, see [SecurityBaseline](https://aka.ms/hci-securitybase).

## Modify security defaults

Start with the initial security baseline and then modify drift control and protected security settings defined during deployment.

### Enable drift control

Use the following steps to enable drift control:

1. Connect to your Azure Stack HCI node.
1. Run the following cmdlet:

    ```PowerShell
    Enable-AzsSecurity -FeatureName DriftControl -Scope <Local | Cluster>
    ```

   - **Local** - Affects the local node only.
   - **Cluster** - Affects all nodes in the cluster using the orchestrator.

### Disable drift control

Use the following steps to disable drift control:

1. Connect to your Azure Stack HCI node.
1. Run the following cmdlet:

    ```PowerShell
    Disable-AzsSecurity -FeatureName DriftControl -Scope <Local | Cluster>
    ```

   - **Local** - Affects the local node only.
   - **Cluster** - Affects all nodes in the cluster using the orchestrator.

## Configure security settings during deployment

As part of deployment, you can modify drift control and other security settings that constitute the security baseline on your cluster.

The following table describes security settings that can be configured on your Azure Stack HCI cluster during deployment.

| Feature area | Feature     |Description           | Supports drift control? |
|--------------|-------------|----------------------|---------------------------------|
| Governance                 | [Security baseline](.././concepts/secure-baseline.md)            | Maintains the security defaults on each server. Helps protect against changes.  | Yes                             |
| Credential protection      | [Windows Defender Credential Guard](/windows/security/identity-protection/credential-guard/credential-guard)     | Uses virtualization-based security to isolate secrets from credential-theft attacks. | Yes                             |
| Application control        | [Windows Defender Application control](/windows/security/threat-protection/windows-defender-application-control/wdac-and-applocker-overview#windows-defender-application-control)           | Controls which drivers and apps are allowed to run directly on each server.           | No                              |
| Data at-rest encryption    | [BitLocker for OS boot volume](/windows/security/information-protection/bitlocker/bitlocker-overview)          | Encrypts the OS startup volume on each server.                                        | No                              |
| Data at-rest encryption    | [BitLocker for data volumes](/windows/security/information-protection/bitlocker/bitlocker-overview)            | Encrypts cluster shared volumes (CSVs) on this cluster                               | No                              |
| Data in-transit protection | [Signing for external SMB traffic](/troubleshoot/windows-server/networking/overview-server-message-block-signing)      | Signs SMB traffic between this system and others to help prevent relay attacks.       | Yes                             |
| Data in-transit protection | [SMB Encryption for in-cluster traffic](/windows-server/storage/file-server/smb-security#smb-encryption) | Encrypts traffic between servers in the cluster (on your storage network).            | No                              |

## Modify security settings after deployment

After deployment is complete, you can use PowerShell to modify security settings while maintaining drift control. Some features require a reboot to take effect.

### PowerShell cmdlet properties

The following cmdlet properties are for the *AzureStackOSConfigAgent* module. The module is installed during deployment.

- `Get-AzsSecurity`  -Scope: <Local | PerNode | AllNodes | Cluster>
  - **Local** - Provides boolean value (true/False) on local node. Can be run from a regular remote PowerShell session.
  - **PerNode** - Provides boolean value (true/False) per node.
  - **Report** - Requires CredSSP or an Azure Stack HCI server using a remote desktop protocol (RDP) connection.
    - AllNodes – Provides boolean value (true/False) computed across nodes.
    - Cluster – Provides boolean value from ECE store. Interacts with the orchestrator and acts to all the nodes in the cluster.

- `Enable-AzsSecurity`   -Scope <Local | Cluster>
- `Disable-AzsSecurity`  -Scope <Local | Cluster>
  - **FeatureName** - <CredentialGuard | DriftControl | DRTM | HVCI | SideChannelMitigation | SMBEncryption | SMBSigning | VBS>
    - Credential Guard
    - Drift Control
    - VBS (Virtualization Based Security)- We only support enable command.
    - DRTM (Dynamic Root of Trust for Measurement)
    - HVCI (Hypervisor Enforced if Code Integrity)
    - Side Channel Mitigation
    - SMB Encryption
    - SMB Signing

The following table documents supported security features, whether they support drift control, and whether a reboot is required to implement the feature.

|Name |Feature |Supports drift control |Reboot required |
|-----|--------|-----------------------|----------------|
|Enable <br> |Virtualization Based Security (VBS) |Yes   |Yes |
|Enable <br> Disable |Dynamic Root of Trust for Measurement (DRTM) |Yes |Yes |
|Enable <br> Disable |Hypervisor-protected Code Integrity (HVCI) |Yes |Yes |
|Enable <br> Disable |Side channel mitigation |Yes |Yes |
|Enable <br> Disable |SMB signing |Yes |Yes |
|Enable <br> Disable |SMB cluster encryption |No, cluster setting |No |

## Next steps

- [Understand BitLocker encryption](.././concepts/security-bitlocker.md).
