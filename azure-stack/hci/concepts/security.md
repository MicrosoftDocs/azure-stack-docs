---
title: Azure Stack HCI security considerations
description: This topic provides guidance on security considerations for the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: conceptual
ms.date: 06/23/2020
---

# Azure Stack HCI security considerations

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

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
    
        :::image type="content" source="./media/security/bitlocker-toggle-switch.png" alt-text="The toggle switch to enable BitLocker":::
    
    1. On the **Encryption (BitLocker)** pop-up, select **Start**, and then on the **Turn on Encryption** page, provide your credentials to complete the workflow.

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

- **Browser traffic** to Windows Admin Center uses HTTPS. Traffic from Windows Admin Center to managed servers uses standard PowerShell and Windows Management Instrumentation (WMI) over Windows Remote Management (WinRM). Windows Admin Center supports the Local Administrator Password Solution (LAPS), resource-based constrained delegation, gateway access control using Active Directory (AD) or Microsoft Azure Active Directory (Azure AD), and role-based access control (RBAC) for managing target servers.

    Windows Admin Center supports Microsoft Edge (Windows 10, version 1709 or later), Google Chrome, and Microsoft Edge Insider on Windows 10. You can install Windows Admin Center on either a Windows 10 PC or a Windows server.

    If you install Windows Admin Center on a server it runs as a gateway, with no UI on the host server. In this scenario, administrators can log on to the server via an HTTPS session, secured by a self-signed security certificate on the host. However, it's better to use an appropriate SSL certificate from a trusted certificate authority for the sign-on process, because supported browsers treat a self-signed connection as unsecure, even if the connection is to a local IP address over a trusted VPN.

    To learn more about installation options for your organization, see [What type of installation is right for you?](https:///windows-server/manage/windows-admin-center/plan/installation-options).

- **CredSSP** is an authentication provider that Windows Admin Center uses in a few cases to pass credentials to machines beyond the specific server you are targeting to manage. Windows Admin Center currently requires CredSSP to:
    - Manage disaggregated SMB storage in virtual machines.
    - Access the **Updates** tool to use either the Failover clustering or Cluster-Aware Updating features.

    To learn more, see [Does Windows Admin Center use CredSSP?](/windows-server/manage/windows-admin-center/understand/faq#does-windows-admin-center-use-credssp)

- **Role-based access control (RBAC)** in Windows Admin Center allows users limited access to the servers they need to manage instead of making them full local administrators. To use RBAC in Windows Admin Center, you configure each managed server with a PowerShell Just Enough Administration endpoint.

    To learn more, see [Role-based access control](/windows-server/manage/windows-admin-center/plan/user-access-options#role-based-access-control) and [Just Enough Administration](https://docs.microsoft.com/powershell/scripting/learn/remoting/jea/overview?view=powershell-7).

- **Security tools** in Windows Admin Center that you can use to manage and protect identities include Active Directory, Certificates, Firewall, Local Users and Groups, and more.

    To learn more, see [Manage Servers with Windows Admin Center](/windows-server/manage/windows-admin-center/use/manage-servers).

## Azure Security Center
*Azure Security Center* is a unified infrastructure security management system that strengthens the security posture of your data centers, and provides advanced threat protection across your hybrid workloads in the cloud and on premises. Security Center provides you with tools to assess the security status of your network, protect workloads, raise security alerts, and follow specific recommendations to remediate attacks and address future threats. Security Center performs all of these services at high speed in the cloud with no deployment overhead through auto-provisioning and protection with Azure services.

Security Center protects VMs for both Windows servers and Linux servers by installing the Log Analytics agent on these resources. Azure correlates events that the agents collect into recommendations (hardening tasks) that you perform to make your workloads secure. The hardening tasks based on security best practices include managing and enforcing security policies. You can then track the results and manage compliance and governance over time through Security Center monitoring while reducing the attack surface across all of your resources.

Managing who can access your Azure resources and subscriptions is an important part of your Azure governance strategy. Azure role-based access control (RBAC) is the primary method of managing access in Azure. To learn more, see [Manage access to your Azure environment with role-based access control](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-setup-guide/manage-access).

Working with Security Center through Windows Admin Center requires an Azure subscription. To get started, see [Connect Azure Stack HCI to Azure](https://docs.microsoft.com/azure-stack/hci/deploy/connect-to-azure).

After registering, access Security Center in Windows Admin Center: On the **All Connections** page, select a server or VM, under **Tools**, select **Azure Security Center**, and then select **Sign into Azure**.

To learn more, see [What is Azure Security Center?](https://docs.microsoft.com/azure/security-center/security-center-intro)

## Part 2: Add advanced security
The following sections recommend advanced security tools and technologies to further harden servers running the Azure Stack HCI operating system in your environment.

### Harden the environment
- **Control Flow Guard (CFG)** in Windows helps protect the operating system and applications from memory corruption-based attacks. CFG places tight restrictions on where an application can execute code, making it much harder for exploits to execute arbitrary code through vulnerabilities such as buffer overflows.

    To learn more, see [Control Flow Guard](https://docs.microsoft.com/windows/win32/secbp/control-flow-guard)

- **Microsoft security baselines** are based on security recommendations from Microsoft obtained through partnership with commercial organizations and the US government, such as the Department of Defense. The security baselines include recommended security settings for Windows Firewall, Windows Defender, and many others.

    The security baselines are provided as Group Policy object (GPO) backups that you can import into Active Directory Domain Services (AD DS), and then deploy to domain-joined servers to harden the environment. You can also use Local Script tools to configure standalone (non domain-joined) servers with security baselines. To get started using the security baselines, download the [Microsoft Security Compliance Toolkit 1.0](https://www.microsoft.com/download/details.aspx?id=55319).

    To learn more, see [Microsoft Security Baselines](https://techcommunity.microsoft.com/t5/microsoft-security-baselines/bg-p/Microsoft-Security-Baselines).

- **Turbine** enables you to hot patch VMs running on the latest Windows Server operating systems with security updates and minimal downtime. Turbine significantly reduces the number of restarts VMs require to get fully updated. Operating system security updates are responsible for nearly 70% of server restarts.

    To learn more, see [Turbine]().
    <!--Either update this feature reference when it ships or pull it if to ship after HCI release--!>

### Protect data
- **Hardening the Hyper-V environment** requires hardening Windows Server running on a VM just as you would harden the operating system running
on a physical server. Because virtual environments typically have multiple VMs sharing the same physical host, it is imperative to protect both the physical host and the VMs running on it. An attacker who compromises a host can affect multiple VMs with a greater impact on workloads and services. This section discusses the following methods that you can use to harden Windows Server in a Hyper-V environment:

    - **Guarded fabric and shielded VMs** strengthen the security for VMs running in Hyper-V environments by preventing attackers from modify VM files. A *guarded fabric* consists of a Host Guardian Service (HGS) that is typically a cluster of three nodes, one or more guarded hosts, and a set of shielded VMs. The Attestation Service evaluates the validity of hosts requests, while the Key Protection Service determines whether to release keys that the guarded hosts can use to start the shielded VM.

        To learn more, see [Guarded fabric and shielded VMs overview](https://docs.microsoft.com/windows-server/security/guarded-fabric-shielded-vm/guarded-fabric-and-shielded-vms).
     
     - **Virtual Trusted Platform Module (vTPM)** in Windows Server supports TPM for VMs, which lets you use advanced security technologies, such as BitLocker in VMs. You can enable TPM support on any Generation 2 Hyper-V VM by using either Hyper-V Manager or the `Enable-VMTPM` Windows PowerShell cmdlet.
     
        To learn more, see [Enable-VMTPM](https://docs.microsoft.com/powershell/module/hyper-v/enable-vmtpm?view=win10-ps).
     
     - **Software Defined Networking (SDN)** in Windows Server lets you to centrally configure and manage physical and virtual network devices, such as routers, switches, and gateways in your datacenter. Virtual network elements, such as Hyper-V Virtual Switch, Hyper-V Network Virtualization, and RAS Gateway are designed to be integral elements of your SDN infrastructure.

        To learn more, see [Software Defined Networking (SDN)](https://docs.microsoft.com/windows-server/networking/sdn/).

### Protect identities
- **Just in Time (JIT) access** in Windows Server lets you lock down inbound traffic to Azure VMs by assigning users to privileged groups from which they can perform specific tasks for a limited time. JIT reduces network exposure to attacks while providing users access to VMs when needed. Using JIT requires a subscription to Security Center's standard pricing tier. 

    To learn more, see [Secure your management ports with just-in-time access](https://docs.microsoft.com/azure/security-center/security-center-just-in-time) and [Upgrade to Standard tier for enhanced security](https://docs.microsoft.com/azure/security-center/security-center-pricing).

- **Local Administrator Password Solution (LAPS)** is a lightweight mechanism for Active Directory domain-joined systems that periodically sets each computer’s local admin account password to a new random and unique value. Passwords are stored in a secured confidential attribute on the corresponding computer object in Active Directory, where only specifically-authorized users can retrieve them. LAPS uses local accounts for remote computer management in a way that offers some advantages over using domain accounts. To learn more, see [Remote Use of Local Accounts: LAPS Changes Everything](https://docs.microsoft.com/archive/blogs/secguide/remote-use-of-local-accounts-laps-changes-everything).

    To get started using LAPS, download [Local Administrator Password Solution (LAPS)](https://www.microsoft.com/download/details.aspx?id=46899).

- **Microsoft Advanced Threat Analytics (ATA)** is an on-premises product that you can use to help detect attackers attempting to compromise privileged identities. ATA parses network traffic for authentication, authorization, and information gathering protocols, such as Kerberos and DNS. ATA uses the data to build behavioral profiles of users and other entities on the network to detect anomalies and known attack patterns.
    
    To learn more, see [What is Advanced Threat Analytics?](https://docs.microsoft.com/advanced-threat-analytics/what-is-ata).

- **Windows Defender Remote Credential Guard** protects credentials over a Remote Desktop connection by redirecting Kerberos requests back to the device that's requesting the connection. It also provides single sign-on (SSO) for Remote Desktop sessions. During a Remote Desktop session, if the target device is compromised, your credentials are not exposed because both credential and credential derivatives are never passed over the network to the target device.

    To learn more, see [Manage Windows Defender Credential Guard](https://docs.microsoft.com/windows/security/identity-protection/credential-guard/credential-guard-manage).

## More security resources
For more information on security and regulatory compliance, see also:
- [Beginning your General Data Protection Regulation (GDPR) journey for Windows Server](https://docs.microsoft.com/windows-server/security/gdpr/gdpr-winserver-whitepaper)
- [Security and Assurance](https://docs.microsoft.com/windows-server/security/security-and-assurance)- 
- [Security best practices for Azure solutions](https://azure.microsoft.com/resources/security-best-practices-for-azure-solutions/)

## Next steps
For more information, see also:
- [Protect Azure Stack HCI VMs using Azure Site Recovery](https://docs.microsoft.com/azure-stack/hci/manage/azure-site-recovery)
