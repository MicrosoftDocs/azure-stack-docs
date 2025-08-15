---
title:  Operational security for the Azure Local security book
description: Learn about operational security for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 08/11/2025
ms.author: alkohli
ms.reviewer: alkohli
---


# Operational security for the Azure Local security book

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]


Operational security in Azure Local means ongoing operations using Windows Admin Center and ongoing compliance using Microsoft Defender for Cloud and other tools.

## Ongoing operations

Windows Admin Center in Azure plays a central in the daily operations of Azure Local.

### Windows Admin Center in Azure

Traditional server administration requires on-premises identities, roles, and groups to manage the server. With Azure Local, you can manage your system through Windows Admin Center in Azure using your Microsoft Entra identities. This allows you to use Azure capabilities such as [Microsoft Entra](https://www.microsoft.com/security/business/microsoft-entra) for additional security. Windows Admin Center in Azure has many capabilities that make your management platform more secure.

#### No inbound connectivity

You can securely manage your system from anywhere without needing a VPN, public IP address, or other inbound connectivity to your machine. 

With the Windows Admin Center extension in Azure, you get the management, configuration, troubleshooting, and maintenance functionality for managing your Azure Local instance in the Azure portal. Azure Local instance and workload management no longer requires you to establish line-of-sight or Remote Desktop Protocol (RDP) - this can all be done natively from the Azure portal. Windows Admin Center provides tools and experiences that you would normally find in Failover Cluster Manager, Device Manager, Task Manager, Hyper-V Manager, and most other Microsoft Management Console (MMC) tools.

#### Azure Active Directory authentication

Authentication to Windows Admin Center is provided via a single sign-on experience that uses your Microsoft Entra credentials to authenticate you to your system. You no longer need to manage or share credentials for your system to provide your system administrators with access to your system. Windows Admin Center can authenticate you to your system using your Azure AD credentials, regardless of whether the device is Azure AD joined or not.

#### Role-based access control

Access to Windows Admin Center is controlled by an Azure role-based access control (RBAC) role named Windows Admin Center Administrator Login. Customers must be a part of this role to gain access to Windows Admin Center. To further enhance security, customers can leverage Azure AD Privileged Identity Management (PIM) to enable customers to get just-in-time (JIT) RBAC access to Windows Admin Center. 

#### Two-factor authentication

With Windows Admin Center integrated in Azure portal, you can configure Azure AD multifactor authentication (MFA) settings to control access to Windows Admin Center. To customize the end-user experience for Azure AD multifactor authentication, you can configure options for settings like account lockout thresholds or fraud alerts and notifications. Some settings are available directly in the Azure portal for Microsoft Entra, and some are in a separate Azure AD Multi-Factor Authentication portal. 

#### Logging

Windows Admin Center writes event logs to give you insight into management activities being performed on their machines, and to help you troubleshoot any Windows Admin Center issues.

#### Always up to date

Windows Admin Center, just like any other Azure service, is always up to date with the latest and greatest management experiences. Unlike previous on-premises tools that had long release cycles, Windows Admin Center in Azure updates often and automatically.

#### Security tool

The built-in security tool within Windows Admin Center gives you the ability to monitor and toggle Azure Local security settings. This tool lets you monitor and change your Secured-core, Application Control for Windows, and many other settings, all from within the Azure portal.

#### Lost Azure connectivity

In the event you lose connectivity to Azure, you can use an on-premises deployment of Windows Admin Center to troubleshoot issues and continue to manage your system with a familiar experience, until connectivity to Azure has been restored.

### Continuous monitoring with Microsoft Defender for Cloud

[Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud/) is a security posture management solution with advanced threat protection capabilities. It provides you with tools to assess the security status of your infrastructure, protect workloads, raise security alerts, and follow specific recommendations to remediate attacks and address future threats. It performs all these services at high speed in the cloud through auto-provisioning and protection with Azure services.

You can use Microsoft Defender for Cloud to assess both the individual and overall security posture of all your hybrid resources across your entire fleet. Microsoft Defender for Cloud helps [improve the security posture](/azure/defender-for-cloud/defender-for-cloud-introduction#improve-your-security-posture) of your environment, and can protect against existing and evolving threats. You can use Microsoft Defender for Cloud to monitor the security posture of your Azure Local infrastructure. This requires connectivity to Azure.

[Azure Arc](https://azure.microsoft.com/products/azure-arc/) simplifies governance and management by delivering a consistent multi-cloud and on-premises management platform. 
It extends management to edge and multi-cloud and provides a single pane of glass management control plane. Azure Local is Arc-enabled by default and has Azure Monitor agent installed via Azure Arc on each machine in the system. This allows Azure Local to be monitored through Microsoft Defender for Cloud along with other resources. This enables you to manage and continuously monitor the security posture of your entire Azure Local fleet through Microsoft Defender for Cloud. 

## Ongoing compliance

### Configuration monitoring and drift protection

With Azure Local, you can apply the recommended Azure Local security baseline and Secured-core settings, monitor, and perform drift protection from desired state during both deployment and run-time, using the built-in configuration management stack in the operating system. You can choose if you want drift protection to be turned on or off during deployment time or after deployment using Windows Admin Center or PowerShell.

Once drift protection is applied, the security settings are refreshed at regular intervals, thus ensuring any change from desired state is remediated. This continuous monitoring and autoremediation allows you to have consistent and reliable security posture throughout the lifecycle of the system.

For those who need to adjust or update security settings based on their own business requirements, in addition to keeping a balanced security posture based on Microsoft’s recommendation, you can still apply the initial security baseline, stop the drift control, and make any modification over any of the 300+ settings initially defined. To learn more, see [Security baseline and drift control](../manage/manage-secure-baseline.md).
 
### Azure security baseline compliance assessment

[Azure Policy](/azure/governance/policy/overview) helps to enforce organizational standards and to assess compliance at-scale. Through its compliance dashboard, it provides an aggregated view to evaluate the overall state of the environment, with the ability to drill down to the per-resource, per-policy granularity.

During run-time, you can use Azure Policy to audit Azure Local host machine configuration and perform compliance assessments based on Azure security baseline policies. 

### SIEM integration

Security compliance requires strict logging and auditing of security events. In Azure Local, we recommend customers to use our Cloud SIEM [Azure Sentinel](https://www.microsoft.com/security/business/siem-and-xdr/microsoft-sentinel/) service. For those organizations that use their own SIEM, Azure Local comes with an [integrated syslog forwarder](/azure/azure-local/manage/manage-syslog-forwarding?tabs=syslog-message-schema) mechanism, which can be used to forward security related events to a SIEM.
  
The integrated syslog forwarder, once configured, emits syslog messages as defined in RFC 3164, with the payload in Common Event Format (CEF).  All audits and security events are collected on each host and exported via syslog with CEF payload to a Syslog Server endpoint.  

### Microsoft Defender for Cloud regulatory compliance

Microsoft Defender for Cloud streamlines the process for meeting [regulatory compliance requirements](/azure/defender-for-cloud/update-regulatory-compliance-packages#what-regulatory-compliance-standards-are-available-in-defender-for-cloud), using the regulatory compliance dashboard. Defender for Cloud continuously assesses your hybrid cloud environment to analyze the risk factors according to the controls and best practices in the regulatory standards that you applied to your subscriptions. The dashboard reflects the status of your compliance with those standards. The regulatory compliance dashboard provides insights into your compliance posture based on how you're meeting specific compliance requirements such as ISO 27001:2013, PCI DSS v4, and NIST SP 800-53 R5. 

## Software updates

Azure Local contains many individual features and components, such as OS, agents and services, drivers, and firmware. Staying up to date with recent security fixes and feature improvements is important and essential for proper operation. The update feature in Azure Local uses an orchestrator (Lifecycle Manager) which centrally manages the deployment experience for the entire system.  

The update feature offers many benefits:

- Provides a simplified, consolidated, single update management experience.
- Provides a well-tested configuration.
- Helps avoid downtime with health checks before and during an update.
- Improves reliability with automatic retry and remediation of known issues.
- Provides a common backend experience irrespective of whether the updates are managed locally or via Azure portal.

Azure Local solutions are designed to have a predictable update experience: 

- Microsoft releases monthly patch (quality and reliability) updates, quarterly baseline (features and improvements) updates, hotfixes (for critical or security issues) as needed, and solution builder extension updates (driver, firmware, and other partner content specific to the system solution used) as needed.

- To keep your Azure Local instance in a supported state, you must install updates regularly and stay current within six months of the most recent release. We recommend installing updates as and when they are released.
 
You can update your Azure Local instance either via Azure portal using Azure Update Manager or via PowerShell command line interface. For more information on how to keep your Azure Local instance up to date, read about [updates for Azure Local](../update/about-updates-23h2.md). The Cluster-Aware Updating feature orchestrates update install on each machine in the system so that your applications continue to run during the system upgrade.  
 
To regularly update virtual machines running on your Azure Local, you can use Windows Update, Windows Server Update Services, and Azure Update Management to update VMs. 
 

## Related content

[Workload security](workload-security.md)

