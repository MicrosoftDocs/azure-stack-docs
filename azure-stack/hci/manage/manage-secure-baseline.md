---
title: Manage security defaults on Azure Stack HCI, version 23H2
description: Learn how to manage security default settings available for Azure Stack HCI, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/29/2024
---

# Manage security defaults for Azure Stack HCI, version 23H2

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage default security settings for your Azure Stack HCI cluster. You can also modify drift control and protected security settings defined during deployment so your device starts in a known good state.

## Prerequisites

Before you begin, make sure that you have access to an Azure Stack HCI, version 23H2 system that is deployed, registered, and connected to Azure.

## View security default settings in the Azure portal

To view the security default settings in the Azure portal, make sure that you have applied the MCSB initiative. For more information, see [Apply Microsoft Cloud Security Benchmark initiative](./manage-security-with-defender-for-cloud.md#apply-microsoft-cloud-security-benchmark-initiative).

You can use the security default settings to manage cluster security, drift control, and Secured core server settings on your cluster.

:::image type="content" source="media/manage-secure-baseline/manage-secure-baseline.png" alt-text="Screenshot that shows Security defaults page in the Azure portal." lightbox="media/manage-secure-baseline/manage-secure-baseline.png":::

View the SMB signing status under the **Data protections** > **Network protection** tab. SMB signing allows you to digitally sign SMB traffic between an Azure Stack HCI system and other systems.

:::image type="content" source="media/manage-secure-baseline/manage-bitlocker-network-protection.png" alt-text="Screenshot that shows the SMB signing status in the Azure portal." lightbox="media/manage-secure-baseline/manage-bitlocker-network-protection.png":::

## View security baseline compliance in the Azure portal

After you enroll your Azure Stack HCI system with Microsoft Defender for Cloud or assign the built-in policy *Windows machines should meet requirements of the Azure compute security baseline*, a compliance report is generated. For the full list of rules your Azure Stack HCI server is compared to, see [Windows security baseline](/azure/governance/policy/samples/guest-configuration-baseline-windows).

For Azure Stack HCI server, when all the hardware requirements for Secured-core are met, the compliance score is 281 out of 288 rules - that is, 281 out of 288 rules are compliant.

The following table explains the rules that aren't compliant and the rationale of the current gap:

| Rule name           | Expected    | Actual   | Logic    | Comments    |
|---------------------|---------------|---------|----------|------------|
| Interactive logon: Message text for users attempting to log on| Expected: | Actual: | Operator: <br> NOTEQUALS|We expect you to define this value with no drift control in place.|
| Interactive logon: Message title for users attempting to log on|Expected: | Actual: | Operator: <br> NOTEQUALS|We expect you to define this value with no drift control in place.|
| Minimum password length |Expected: 14 | Actual: 0 | Operator: <br> GREATEROREQUAL| We expect you to define this value with no drift control in place that aligns with your organization's policy.|
| Prevent device metadata retrieval from the Internet|Expected: 1 | Actual: (null) | Operator: <br> EQUALS|This control doesn't apply to Azure Stack HCI.|
| Prevent users and apps from accessing dangerous websites|Expected: 1 | Actual: (null) | Operator: <br> EQUALS | This control is a part of the Windows Defender protections, not enabled by default. <br> You can evaluate whether you want to enable.|
| Hardened UNC Paths - NETLOGON | Expected: <br> RequireMutualAuthentication=1 <br> RequireIntegrity=1 | Actual: RequireMutualAuthentication=1 <br> RequireIntegrity=1 <br> RequirePrivacy=1 | Operator: <br> EQUALS | Azure Stack HCI is more restrictive. <br> This rule can be safely ignored.|
|Hardened UNC Paths - SYSVOL | Expected: <br> RequireMutualAuthentication=1 <br> RequireIntegrity=1 | Actual: <br> RequireMutualAuthentication=1 <br> RequireIntegrity=1 <br> RequirePrivacy=1 | Operator: <br> EQUALS |Azure Stack HCI is more restrictive. <br> This rule can be safely ignored.|

## Manage security defaults with PowerShell

With drift protection enabled, you can only modify nonprotected security settings. To modify protected security settings that form the baseline, you must first disable drift protection. To view and download the complete list of security settings, see [Security Baseline](https://aka.ms/hci-securitybase).

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

> [!IMPORTANT]
> If you disable drift control, the protected settings can be modified. If you enable drift control again, any changes that you since made to the protected settings are overwritten.

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
    - Drift Control
    - Credential Guard
    - VBS (Virtualization Based Security)- We only support enable command.
    - DRTM (Dynamic Root of Trust for Measurement)
    - HVCI (Hypervisor Enforced if Code Integrity)
    - Side Channel Mitigation
    - SMB Signing
    - SMB Cluster encryption

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
