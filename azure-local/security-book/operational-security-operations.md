---
title:  Azure Local security book ongoing operations
description: Ongoing operations for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/16/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Ongoing operations

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]


## Windows Admin Center in Azure

Traditional server administration requires on-premises identities, roles, and groups to manage the server. With Azure Local, you can manage your system through Windows Admin Center in Azure using your Microsoft Entra identities. This allows you to use Azure capabilities such as [Microsoft Entra](https://www.microsoft.com/security/business/microsoft-entra) for additional security. Windows Admin Center in Azure has many capabilities that make your management platform more secure.

### No inbound connectivity

You can securely manage your system from anywhere without needing a VPN, public IP address, or other inbound connectivity to your machine. 

With the Windows Admin Center extension in Azure, you get the management, configuration, troubleshooting, and maintenance functionality for managing your Azure Local instance in the Azure portal. Azure Local instance and workload management no longer requires you to establish line-of-sight or Remote Desktop Protocol (RDP) - this can all be done natively from the Azure portal. Windows Admin Center provides tools and experiences that you would normally find in Failover Cluster Manager, Device Manager, Task Manager, Hyper-V Manager, and most other Microsoft Management Console (MMC) tools.

### Azure Active Directory authentication

Authentication to Windows Admin Center is provided via a single sign-on experience that uses your Microsoft Entra credentials to authenticate you to your system. You no longer need to manage or share credentials for your system to provide your system administrators with access to your system. Windows Admin Center can authenticate you to your system using your Azure AD credentials, regardless of whether the device is Azure AD joined or not.

### Role-based access control

Access to Windows Admin Center is controlled by an Azure role-based access control (RBAC) role named Windows Admin Center Administrator Login. Customers must be a part of this role to gain access to Windows Admin Center. To further enhance security, customers can leverage Azure AD Privileged Identity Management (PIM) to enable customers to get just-in-time (JIT) RBAC access to Windows Admin Center. 

### Two-factor authentication

With Windows Admin Center integrated in Azure portal, you can configure Azure AD multi-factor authentication (MFA) settings to control access to Windows Admin Center. To customize the end-user experience for Azure AD multi-factor authentication, you can configure options for settings like account lockout thresholds or fraud alerts and notifications. Some settings are available directly in the Azure portal for Microsoft Entra, and some are in a separate Azure AD Multi-Factor Authentication portal. 

### Logging

Windows Admin Center writes event logs to give you insight into management activities being performed on their machines, and to help you troubleshoot any Windows Admin Center issues.

### Always up to date

Windows Admin Center, just like any other Azure service, is always up to date with the latest and greatest management experiences. Unlike previous on-premises tools that had long release cycles, Windows Admin Center in Azure updates often and automatically.

### Security tool

The built-in security tool within Windows Admin Center gives you the ability to monitor and toggle Azure Local security settings. This tool lets you monitor and change your Secured-core, Windows Defender Application Control, and many other settings, all from within the Azure portal.

### Lost Azure connectivity

In the event you lose connectivity to Azure, you can use an on-premises deployment of Windows Admin Center to troubleshoot issues and continue to manage your system with a familiar experience, until connectivity to Azure has been restored.

## Continuous monitoring with Microsoft Defender for Cloud

[Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud/) is a security posture management solution with advanced threat protection capabilities. It provides you with tools to assess the security status of your infrastructure, protect workloads, raise security alerts, and follow specific recommendations to remediate attacks and address future threats. It performs all these services at high speed in the cloud through auto-provisioning and protection with Azure services.

You can use Microsoft Defender for Cloud to assess both the individual and overall security posture of all your hybrid resources across your entire fleet. Microsoft Defender for Cloud helps [improve the security posture](/azure/defender-for-cloud/defender-for-cloud-introduction#improve-your-security-posture) of your environment, and can protect against existing and evolving threats. You can use Microsoft Defender for Cloud to monitor the security posture of your Azure Local infrastructure. This requires connectivity to Azure.

[Azure Arc](https://azure.microsoft.com/products/azure-arc/) simplifies governance and management by delivering a consistent multi-cloud and on-premises management platform. 
It extends management to edge and multi-cloud and provides a single pane of glass management control plane. Azure Local is Arc-enabled by default and has Azure Monitor agent installed via Azure Arc on each machine in the system. This allows Azure Local to be monitored through Microsoft Defender for Cloud along with other resources. This enables you to manage and continuously monitor the security posture of your entire Azure Local fleet through Microsoft Defender for Cloud. 
 

## Related content

- [Ongoing compliance](operational-security-compliance.md)
- [Updates](operational-security-updates.md)
