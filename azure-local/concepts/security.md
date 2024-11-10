---
title: Azure Stack HCI security considerations
description: This topic provides guidance on security considerations for the Azure Stack HCI operating system.
author:  jasongerend
ms.author:  jgerend
ms.topic: conceptual
ms.date: 04/17/2023
---

# Azure Stack HCI security considerations

>Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019

This topic provides security considerations and recommendations related to the Azure Stack HCI operating system:

- Part 1 covers basic security tools and technologies to harden the operating system, and protect data and identities to efficiently build a secure foundation for your organization.
- Part 2 covers resources available through the Microsoft Defender for Cloud. See [Microsoft Defender for Cloud Introduction](/azure/defender-for-cloud/defender-for-cloud-introduction).
- Part 3 covers more advanced security considerations to further strengthen the security posture of your organization in these areas.

## Why are security considerations important?
Security affects everyone in your organization from upper-level management to the information worker. Inadequate security is a real risk for organizations as a security breach can potentially disrupt all normal business and bring your organization to a halt. The sooner that you can detect a potential attack, the faster you can mitigate any compromise in security.

After researching an environment's weak points to exploit them, an attacker can typically within 24 to 48 hours of the initial compromise escalate privileges to take control of systems on the network. Good security measures harden the systems in the environment to extend the time it takes an attacker to potentially take control from hours to weeks or even months by blocking the attacker's movements. Implementing the security recommendations in this topic position your organization to detect and respond to such attacks as fast as possible.

## Part 1: Build a secure foundation

The following sections recommend security tools and technologies to build a secure foundation for the servers running the Azure Stack HCI operating system in your environment.

### Harden the environment

This section discusses how to protect services and virtual machines (VMs) running on the operating system:

- **Azure Stack HCI-certified hardware** provides consistent Secure Boot, UEFI, and TPM settings out of the box. Combining virtualization-based security and certified hardware helps protect security-sensitive workloads. You can also connect this trusted infrastructure to Microsoft Defender for Cloud to activate behavioral analytics and reporting to account for rapidly changing workloads and threats.

    - *Secure boot* is a security standard developed by the PC industry to help ensure that a device boots using only software that is trusted by the Original Equipment Manufacturer (OEM). To learn more, see [Secure boot](/windows-hardware/design/device-experiences/oem-secure-boot).
    - *United Extensible Firmware Interface (UEFI)* controls the booting process of the server and then passes control to either Windows or another operating system. To learn more, see [UEFI firmware requirements](/windows-hardware/design/device-experiences/oem-uefi).
    - *Trusted Platform Module (TPM)* technology provides hardware-based, security-related functions. A TPM chip is a secure crypto-processor that generates, stores, and limits the use of cryptographic keys. To learn more, see [Trusted Platform Module Technology Overview](/windows/security/information-protection/tpm/trusted-platform-module-overview).

    To learn more about Azure Stack HCI-certified hardware providers, see the [Azure Stack HCI solutions](https://azure.microsoft.com/products/azure-stack/hci/) website.

- The **Security tool** is available natively in Windows Admin Center for both single server and Azure Stack HCI clusters to make security management and control easier. The tool centralizes some key security settings for servers and clusters, including the ability to view the Secured-core status of systems.

    To learn more, see [Secured-core server](/windows-server/get-started/whats-new-in-windows-server-2022#secured-core-server).

- **Device Guard** and **Credential Guard**. Device Guard protects against malware with no known signature, unsigned code, and malware that gains access to the kernel to either capture sensitive information or damage the system. Windows Defender Credential Guard uses virtualization-based security to isolate secrets so that only privileged system software can access them.

    To learn more, see [Manage Windows Defender Credential Guard](/windows/security/identity-protection/credential-guard/credential-guard-manage) and download the [Device Guard and Credential Guard hardware readiness tool](https://www.microsoft.com/download/details.aspx?id=53337).

- **Windows** and **firmware** updates are essential on clusters, servers (including guest VMs), and PCs to help ensure that both the operating system and system hardware are protected from attackers. You can use the Windows Admin Center **Updates** tool to apply updates to individual systems. If your hardware provider includes Windows Admin Center support for getting driver, firmware, and solution updates, you can get these updates at the same time as Windows updates; otherwise, get them directly from your vendor.

    To learn more, see [Update the cluster](../manage/update-cluster.md).

    To manage updates on multiple clusters and servers at a time, consider subscribing to the optional Azure Update Management service, which is integrated with Windows Admin Center. For more information, see [Azure Update Management using Windows Admin Center](https://www.thomasmaurer.ch/2018/11/azure-update-management-windows-admin-center).

### Protect data
This section discusses how to use Windows Admin Center to protect data and workloads on the operating system:

- **BitLocker for Storage Spaces** protects data at rest. You can use BitLocker to encrypt the contents of Storage Spaces data volumes on the operating system. Using BitLocker to protect data can help organizations stay compliant with government, regional, and industry-specific standards such as FIPS 140-2 and HIPAA.
 
    To learn more about using BitLocker in Windows Admin Center, see [Enable volume encryption, deduplication, and compression](../manage/volume-encryption-deduplication.md)

- **SMB** encryption for Windows networking protects data in transit. *Server Message Block (SMB)* is a network file-sharing protocol that allows applications on a computer to read and write to files and to request services from server programs on a computer network.

    To enable SMB encryption, see [SMB security enhancements](/windows-server/storage/file-server/smb-security).

- **Windows Defender Antivirus** protects the operating system on clients and servers against viruses, malware, spyware, and other threats. To learn more, see [Microsoft Defender Antivirus on Windows Server](/microsoft-365/security/defender-endpoint/microsoft-defender-antivirus-on-windows-server).

### Protect identities
This section discusses how to use Windows Admin Center to protect privileged identities:

- **Access control** can improve the security of your management landscape. If you're using a Windows Admin Center server (vs. running on a Windows 10 PC), you can control two levels of access to Windows Admin Center itself: gateway users and gateway administrators. Gateway administrator identity provider options include:
    - Active Directory or local machine groups to enforce smartcard authentication.
    - Microsoft Entra ID to enforce conditional access and multifactor authentication.
 
    To learn more, see [User access options with Windows Admin Center](/windows-server/manage/windows-admin-center/plan/user-access-options) and [Configure User Access Control and Permissions](/windows-server/manage/windows-admin-center/configure/user-access-control).

- **Browser traffic** to Windows Admin Center uses HTTPS. Traffic from Windows Admin Center to managed servers uses standard PowerShell and Windows Management Instrumentation (WMI) over Windows Remote Management (WinRM). Windows Admin Center supports the Local Administrator Password Solution (LAPS), resource-based constrained delegation, gateway access control using Active Directory (AD) or Microsoft Entra ID, and role-based access control (RBAC) for managing the Windows Admin Center gateway.

    Windows Admin Center supports Microsoft Edge (Windows 10, version 1709 or later), Google Chrome, and Microsoft Edge Insider on Windows 10. You can install Windows Admin Center on either a Windows 10 PC or a Windows server.

    If you install Windows Admin Center on a server, it runs as a gateway, with no UI on the host server. In this scenario, administrators can log on to the server via an HTTPS session, secured by a self-signed security certificate on the host. However, it's better to use an appropriate SSL certificate from a trusted certificate authority for the sign-on process because supported browsers treat a self-signed connection as unsecure, even if the connection is to a local IP address over a trusted VPN.

    To learn more about installation options for your organization, see [What type of installation is right for you?](/windows-server/manage/windows-admin-center/plan/installation-options).

- **CredSSP** is an authentication provider that Windows Admin Center uses in a few cases to pass credentials to machines beyond the specific server you are targeting to manage. Windows Admin Center currently requires CredSSP to:
    - Create a new cluster.
    - Access the **Updates** tool to use either the Failover clustering or Cluster-Aware Updating features.
    - Manage disaggregated SMB storage in VMs.

    To learn more, see [Does Windows Admin Center use CredSSP?](/windows-server/manage/windows-admin-center/understand/faq#does-windows-admin-center-use-credssp)

- **Security tools** in Windows Admin Center that you can use to manage and protect identities include Active Directory, Certificates, Firewall, Local Users and Groups, and more.

    To learn more, see [Manage Servers with Windows Admin Center](/windows-server/manage/windows-admin-center/use/manage-servers).

## Part 2: Use Microsoft Defender for Cloud (MDC)

*Microsoft Defender for Cloud* is a unified infrastructure security management system that strengthens the security posture of your data centers and provides advanced threat protection across your hybrid workloads in the cloud and on premises. Defender for Cloud provides you with tools to assess the security status of your network, protect workloads, raise security alerts, and follow specific recommendations to remediate attacks and address future threats. Defender for Cloud performs all of these services at high speed in the cloud with no deployment overhead through auto-provisioning and protection with Azure services.

Defender for Cloud protects VMs for both Windows servers and Linux servers by installing the Log Analytics agent on these resources. Azure correlates events that the agents collect into recommendations (hardening tasks) that you perform to make your workloads secure. The hardening tasks based on security best practices include managing and enforcing security policies. You can then track the results and manage compliance and governance over time through Defender for Cloud monitoring while reducing the attack surface across all of your resources.

Managing who can access your Azure resources and subscriptions is an important part of your Azure governance strategy. Azure RBAC is the primary method of managing access in Azure. To learn more, see [Manage access to your Azure environment with role-based access control](/azure/cloud-adoption-framework/ready/azure-setup-guide/manage-access).

Working with Defender for Cloud through Windows Admin Center requires an Azure subscription. To get started, see [Protect Windows Admin Center Resources with Microsoft Defender for Cloud](/azure/defender-for-cloud/windows-admin-center-integration). To get started, see [Plan your Defender for Server Deployment](/azure/defender-for-cloud/plan-defender-for-servers).  For licensing of Defender for Servers (server plans), see [Select a Defender for Servers Plan](/azure/defender-for-cloud/plan-defender-for-servers-select-plan).

After registering, access MDC in Windows Admin Center: On the **All Connections** page, select a server or VM, under **Tools**, select **Microsoft Defender for Cloud**, and then select **Sign into Azure**.

For more information, see [What is Microsoft Defender for Cloud?](/azure/defender-for-cloud/defender-for-cloud-introduction).

## Part 3: Add advanced security

The following sections recommend advanced security tools and technologies to further harden servers running the Azure Stack HCI operating system in your environment.

### Harden the environment

- **Microsoft security baselines** are based on security recommendations from Microsoft obtained through partnership with commercial organizations and the US government, such as the Department of Defense. The security baselines include recommended security settings for Windows Firewall, Windows Defender, and many others.

    The security baselines are provided as Group Policy Object (GPO) backups that you can import into Active Directory Domain Services (AD DS) and then deploy to domain-joined servers to harden the environment. You can also use Local Script tools to configure standalone (non-domain-joined) servers with security baselines. To get started using the security baselines, download the [Microsoft Security Compliance Toolkit 1.0](https://www.microsoft.com/download/details.aspx?id=55319).

    To learn more, see [Microsoft Security Baselines](https://techcommunity.microsoft.com/t5/microsoft-security-baselines/bg-p/Microsoft-Security-Baselines).

### Protect data

- **Hardening the Hyper-V environment** requires hardening Windows Server running on a VM just as you would harden the operating system running on a physical server. Because virtual environments typically have multiple VMs sharing the same physical host, it is imperative to protect both the physical host and the VMs running on it. An attacker who compromises a host can affect multiple VMs with a greater impact on workloads and services. This section discusses the following methods that you can use to harden Windows Server in a Hyper-V environment:
     
     - **Virtual Trusted Platform Module (vTPM)** in Windows Server supports TPM for VMs, which lets you use advanced security technologies, such as BitLocker in VMs. You can enable TPM support on any Generation 2 Hyper-V VM by using either Hyper-V Manager or the `Enable-VMTPM` Windows PowerShell cmdlet.
     
       >[!NOTE]
       > Enabling vTPM will impact VM mobility: manual actions will be required to allow the VM to start on different Host from the one you enabled vTPM originally.

        To learn more, see [Enable-VMTPM](/powershell/module/hyper-v/enable-vmtpm).
     
     - **Software Defined Networking (SDN)** in Azure Stack HCI and Windows Server centrally configures and manages virtual network devices, such as the software load balancer, data center firewall, gateways, and virtual switches in your infrastructure. Virtual network elements, such as Hyper-V Virtual Switch, Hyper-V Network Virtualization, and RAS Gateway are designed to be integral elements of your SDN infrastructure.

        To learn more, see [Software Defined Networking (SDN)](/windows-server/networking/sdn/).

       >[!NOTE]
       > Shielded VMs protected by Host Guardian Service are not supported in Azure Stack HCI.

### Protect identities

- **Local Administrator Password Solution (LAPS)** is a lightweight mechanism for Active Directory domain-joined systems that periodically sets each computer’s local admin account password to a new random and unique value. Passwords are stored in a secured confidential attribute on the corresponding computer object in Active Directory, where only specifically-authorized users can retrieve them. LAPS uses local accounts for remote computer management in a way that offers some advantages over using domain accounts. To learn more, see [Remote Use of Local Accounts: LAPS Changes Everything](/archive/blogs/secguide/remote-use-of-local-accounts-laps-changes-everything).

    To get started using LAPS, download [Local Administrator Password Solution (LAPS)](https://www.microsoft.com/download/details.aspx?id=46899).

- **Microsoft Advanced Threat Analytics (ATA)** is an on-premises product that you can use to help detect attackers attempting to compromise privileged identities. ATA parses network traffic for authentication, authorization, and information gathering protocols, such as Kerberos and DNS. ATA uses the data to build behavioral profiles of users and other entities on the network to detect anomalies and known attack patterns.
    
    To learn more, see [What is Advanced Threat Analytics?](/advanced-threat-analytics/what-is-ata)

- **Windows Defender Remote Credential Guard** protects credentials over a Remote Desktop connection by redirecting Kerberos requests back to the device that's requesting the connection. It also provides single sign-on (SSO) for Remote Desktop sessions. During a Remote Desktop session, if the target device is compromised, your credentials are not exposed because both credential and credential derivatives are never passed over the network to the target device.

    To learn more, see [Manage Windows Defender Credential Guard](/windows/security/identity-protection/credential-guard/credential-guard-manage).

- **Microsoft Defender for Identities** helps you protect privileged identities by monitoring user behavior and activities, reducing the attack surface, protecting Active Directory Federal Service (AD FS) in a hybrid environment, and identifying suspicious activities and advanced attack across the cyber-attack kill-chain.

    To learn more, see [What is Microsoft Defender for Identity?](/defender-for-identity/what-is).


## Next steps
For more information about security and regulatory compliance, see:
- [Security and Assurance](/windows-server/security/security-and-assurance)
