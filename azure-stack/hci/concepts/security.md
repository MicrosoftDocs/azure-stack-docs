---
title: Azure Stack HCI security considerations
description: This topic provides guidance on security considerations for the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: article
ms.date: 06/15/2020
---

# Azure Stack HCI security considerations

>Applies to: Azure Stack HCI, version 20H2

This topic provides security considerations and recommendations related to the Azure Stack HCI operating system:
- Part 1 covers basic security tools and technologies to harden the operating system, and protect data and identities to efficiently build a secure foundation for your organization. It includes resources available through the Azure Security Center.
- Part 2 covers more advanced security considerations to further strengthen the security posture of your organization in these areas.

## Why are security considerations important?
Security affects everyone in your organization from upper-level management to the information worker. Inadequate security is a real risk for organizations, as a security breach can potentially disrupt all normal business and bring your organization to a halt. The sooner that you can detect a potential attack, the faster you can mitigate any compromise in security.

After researching an environment's weak points to exploit them, an attacker can typically within 24 to 48 hours of the initial compromise escalate privileges to take control of systems on the network. Good security measures harden the systems in the environment to extend the time it takes an attacker to potentially take control from hours to weeks or even months by blocking the attacker's movements. Implementing the security recommendations in this topic position your organization to detect and respond to such attacks as fast as possible.

## Part 1: Build a secure foundation
The following sections recommend security tools and technologies to build a secure foundation for the servers running the Azure Stack HCI operating system in your environment.

### Harden the environment
This section discusses how to protect services and virtual machines (VMs) running on the operating system:
- **Azure Stack HCI certified hardware** provides consistent Secure Boot, UEFI, and TPM settings out of the box. Combining virtualization-based security and certified hardware helps protect security-sensitive workloads. You can also connect this trusted infrastructure to Azure Security Center to activate behavioral analytics and reporting to account for rapidly changing workloads and threats.

    - *Secure boot* is a security standard developed by the PC industry to help ensure that a device boots using only software that is trusted by the Original Equipment Manufacturer (OEM). To learn more, see [Secure boot](https://docs.microsoft.com/windows-hardware/design/device-experiences/oem-secure-boot).
    - *United Extensible Firmware Interface (UEFI)* controls the booting process of the server, and then passes control to either Windows or another operating system. To learn more, see [UEFI firmware requirements](https://docs.microsoft.com/windows-hardware/design/device-experiences/oem-uefi).
    - *Trusted Platform Module (TPM)* technology provides hardware-based, security-related functions. A TPM chip is a secure crypto-processor that generates, stores, and limits the use of cryptographic keys. To learn more, see [Trusted Platform Module Technology Overview](https://docs.microsoft.com/windows/security/information-protection/tpm/trusted-platform-module-overview).

    To learn more about Azure Stack HCI certified hardware providers, see the [Azure Stack HCI solutions](https://azure.microsoft.com/products/azure-stack/hci/) website.

- **Device Guard** and **Credential Guard**. Device Guard protects against malware with no known signature, unsigned code, and malware that gains access to the kernel to either capture sensitive information or damage the system. Windows Defender Credential Guard uses virtualization-based security to isolate secrets so that only privileged system software can access them.

    To learn more, see [Manage Windows Defender Credential Guard](https://docs.microsoft.com/windows/security/identity-protection/credential-guard/credential-guard-manage) and download the [Device Guard and Credential Guard hardware readiness tool](https://www.microsoft.com/en-us/download/details.aspx?id=53337).

- **Windows** and **firmware** updates are essential to help ensure that both the operating system and system hardware are protected from attackers. You can apply Windows updates via the **Updates** feature in Windows Admin Center to your servers. However, we recommend using the Cluster Creation wizard to streamline getting updates. To get the latest firmware updates from Azure Stack HCI certified hardware providers, see the [Azure Stack HCI Catalog](https://www.microsoft.com/cloud-platform/azure-stack-hci-catalog).
 
    To learn more, see [Create an Azure Stack HCI cluster using Windows Admin Center](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster).
 
- **Cluster-Aware Updating** makes it easier to install Windows updates on every server in your cluster while keeping your applications running by automating the software updating process. You can use Cluster-Aware Updating on all editions of Windows Server, including the Azure Stack HCI operating system, and initiate it through either Windows Admin Center or using PowerShell.

    To learn more, see [Cluster-Aware Updating requirements and best practices](/windows-server/failover-clustering/cluster-aware-updating-requirements) and [Update Azure Stack HCI clusters](https://docs.microsoft.com/azure-stack/hci/manage/update-cluster?branch=pr-en-us-3363).

### Protect data
This section discusses how to use Windows Admin Center to protect data and workloads on the operating system:

- **BitLocker for Storage Spaces** protects data at rest. You can use BitLocker to encrypt the contents of Storage Spaces data volumes on the operating system. Using BitLocker to protect data can help government and other organizations stay compliant with such standards as FIPS 140-2 and HIPAA.

    To access BitLocker in Windows Admin Center:

    1. Connect to a Storage Spaces Direct cluster, and then on the **Tools** pane, select **Volumes**.
    1. On the **Volumes** page, select **Inventory**, and then under **Optional features**, switch the **Encryption (BitLocker)** toggle on.
    1. On the **Encryption (BitLocker)** pop-up, select **Start**, and then on the **Turn on Encryption** page, provide your credentials to complete the workflow.

        :::image type="content" source="./media/security/bitlocker-toggle-switch.png" alt-text="The BitLocker toggle to enable the feature":::

   >[!NOTE]
   > If the **Install BitLocker feature first** pop-up displays, follow its instructions to install the feature on each server in the cluster, and then restart your servers.

- **SMB** encryption for Windows networking protects data in transit. *Server Message Block (SMB)* is a network file sharing protocol that allows applications on a computer to read and write to files and to request services from server programs on a computer network.

    To install SMB feature options on a server in Windows Admin Center:
    1. On the **All connections** page, select a server, then under **Tools**, select **Roles and Features**.
    1. Scroll down the **Features** list to select the options for **SMB 1.0/CIFS File Sharing Support** and **SMB Bandwidth Limit**, and then select **Install**.

    To learn more, see [Overview of file sharing using the SMB 3 protocol in Windows Server](https://docs.microsoft.com/windows-server/storage/file-server/file-server-smb-overview).

- **Windows Defender Antivirus** in Windows Admin Center protects the operating system on clients and servers against viruses, malware, spyware, other threats. To learn more, see [Microsoft Defender Antivirus on Windows Server 2016 and 2019](https://docs.microsoft.com/windows/security/threat-protection/microsoft-defender-antivirus/microsoft-defender-antivirus-on-windows-server-2016)

### Protect identities
This section discusses how to use Windows Admin Center to protect privileged identities:

- **Access control** can improve the security of your management landscape. Windows Admin Center defines two roles for access to the gateway service: gateway users and gateway administrators. Gateway administrator identity provider options include:
    - Active Directory or local machine groups to enforce smartcard authentication.
    - Azure Active Directory to enforce conditional access and multifactor authentication.
 
    To learn more, see [User access options with Windows Admin Center](/windows-server/manage/windows-admin-center/plan/user-access-options) and [Configure User Access Control and Permissions](/windows-server/manage/windows-admin-center/configure/user-access-control).

- **Browser traffic** 

<!---Describe at high level, address 4 related sub bullets in outline.--->

- **Local accounts** 

- **Multifactor authentication**

- **Role-based access control (RBAC)** in Windows Admin Center allows users limited access to the servers they need to manage instead of making them full local administrators. To use RBAC in Windows Admin Center, you configure each managed server with a PowerShell Just Enough Administration endpoint.

    To learn more, see [Role-based access control](/windows-server/manage/windows-admin-center/plan/user-access-options#role-based-access-control) and [Just Enough Administration](https://docs.microsoft.com/powershell/scripting/learn/remoting/jea/overview?view=powershell-7).

- **Windows Admin Center security tools** 

## Azure Security Center
TBD


## Part 2: Add advanced security
The following sections recommend advanced security tools and technologies to further harden the servers running the Azure Stack HCI operating system in your environment.

### Harden the environment
TBD

### Protect data
TBD

### Protect identities
TBD

## More security resources
TBD

## Next steps
For more information, see also:
<!---Placeholders for format examples to other topics. Replace all that don't apply before initial topic review.--->

- [Protect Azure Stack HCI VMs using Azure Site Recovery](https://docs.microsoft.com/azure-stack/hci/manage/azure-site-recovery)
- [Security best practices for Azure solutions](https://azure.microsoft.com/resources/security-best-practices-for-azure-solutions/)


- [Storage Spaces Direct hardware requirements](/windows-server/storage/storage-spaces/storage-spaces-direct-hardware-requirements)
- [Azure Stack HCI overview](../overview.md)
- [Understand the cache in Azure Stack HCI](cache.md)
