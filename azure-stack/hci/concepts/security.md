---
title: Azure Stack HCI security considerations
description: This topic provides guidance on security considerations for the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: article
ms.date: 06/10/2020
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

- **Update** via Windows Admin Center 
 
- **Cluster-Aware Updating** is a recommended feature that makes it easier to install Windows updates on every server in your cluster while keeping your applications running by automating the software updating process. You can use Cluster-Aware Updating on all editions of Windows Server, including the Azure Stack HCI operating system, and initiate it through either Windows Admin Center or using PowerShell.

    To learn more, see [Update Azure Stack HCI clusters](https://docs.microsoft.com/azure-stack/hci/manage/update-cluster?branch=pr-en-us-3363).

### Protect data
This section discusses how to protect data and workloads on the operating system:

### Protect identities
This section discusses how to protect privileged identities:

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



<!---Example note format.--->
   >[!NOTE]
   > TBD.

<!---Example figure format. See style sheet for new format standard.--->
![Deployment options for maximizing capacity](media/choose-drives/maximizing-capacity.png)


## Next steps
For more information, see also:
<!---Placeholders for format examples to other topics. Replace as needed before initial topic review.--->

- [Security best practices for Azure solutions](https://azure.microsoft.com/resources/security-best-practices-for-azure-solutions/)
- [Storage Spaces Direct hardware requirements](/windows-server/storage/storage-spaces/storage-spaces-direct-hardware-requirements)
- [Azure Stack HCI overview](../overview.md)
- [Understand the cache in Azure Stack HCI](cache.md)
