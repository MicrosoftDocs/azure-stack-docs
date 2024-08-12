---
title: PCI DSS guidance for Azure Stack HCI
description: Learn about PCI DSS compliance using Azure Stack HCI.
ms.date: 2/5/2024
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.author: nguyenhung
author: dv00000
ms.reviewer: alkohli
---

# Azure Stack HCI and PCI DSS

This article explains how Microsoft Azure Stack HCI security features can help organizations in the payment card industry achieve the security control requirements of PCI DSS, both in the cloud and in their on-premises environments.

## PCI DSS

The Payment Card Industry (PCI) Data Security Standard (DSS) is a global information security standard designed to prevent fraud through increased control of credit card data. The PCI DSS is mandated by payment card brands and administered by the Payment Card Industry Security Standards Council.

Compliance with PCI DSS is required for any organization that stores, processes, or transmits cardholder data (CHD). Organizations subject to PCI DSS compliance include (but aren't limited to) merchants, payment processors, issuers, acquirers, and service providers.

Learn more about the standard at the [PCI Security Standards Council documentation library](https://www.pcisecuritystandards.org/document_library/).

## Shared responsibilities

It's important to understand that PCI DSS isn't just a technology and product standard, but that it also covers security requirements for people and processes. The responsibility for compliance is shared between you as a covered entity and Microsoft as a service provider.

### Microsoft customers

As a covered entity, it is your responsibility to achieve and manage your own PCI DSS certificate. Organizations need to assess their distinct environment, especially the parts that host service payments or payments-related workloads where cardholder data are stored, processed, and/or transmitted. This is called the cardholder data environment (CDE). After that, organizations need to plan and implement the proper security controls, policies, and procedures to fulfill all the specified requirements before undergoing an official testing process. Organizations ultimately contract with a Qualified Security Assessor (QSA) who verifies if the environment meets all the requirements.

### Microsoft

Although it is your responsibility to maintain compliance with the PCI DSS standard, you aren't alone in the journey. Microsoft provides supplemental materials and security features across the hybrid environment to help you reduce the associated effort and cost of completing PCI DSS validation. For example, instead of testing everything from scratch, your assessors can use the Azure Attestation of Compliance (AOC) for the portion of your cardholder data environment that is deployed in Azure. Learn more in the following content.

## Azure Stack HCI compliance

When designing and building Azure Stack HCI, Microsoft takes into account security requirements for both the Microsoft cloud and customer on-premises environments.

### Connected cloud services

Azure Stack HCI offers deep integration with various Azure services, such as Azure Monitor, Azure Backup, and Azure Site Recovery, to bring new capabilities to the hybrid setting. These cloud services are certified as compliant under PCI DSS version 4.0 at Service Provider Level 1. Learn more about the compliance program of Azure cloud services at [PCI DSS – Azure Compliance](/azure/compliance/offerings/offering-pci-dss).

> [!IMPORTANT]
> It is important to note that Azure PCI DSS compliance status does not automatically translate to PCI DSS validation for the services that organizations build or host on the Azure platform. Customers are responsible for ensuring that their organizations achieve compliance with PCI DSS requirements.

### On-premises solutions

As an on-premises solution, Azure Stack HCI provides an array of features that help organizations satisfy compliance with PCI DSS and other security standards for financial services.

## Azure Stack HCI capabilities relevant for PCI DSS

This section briefly outlines how organizations can use Azure Stack HCI functionality to meet the requirements of PCI DSS. It's important to note that PCI DSS requirements are applicable to all system components included in or connected to the cardholder data environment (CDE). The following content focuses on the Azure Stack HCI platform level, which hosts service payments or payments-related workloads that include cardholder data.

### Requirement 1: Install and maintain network security controls

With Azure Stack HCI, you can apply network security controls to safeguard your platform and the workloads running on it from network threats outside and inside. The platform also guarantees fair network allocation on a host and improves workload performance and availability with load balancing capabilities. Learn more about network security in Azure Stack HCI at the following articles.

- [Datacenter Firewall overview](/azure-stack/hci/concepts/datacenter-firewall-overview)
- [Software Load Balancer (SLB) for Software Define Network (SDN)](/azure-stack/hci/concepts/software-load-balancer)
- [Remote Access Service (RAS) Gateway for SDN](/azure-stack/hci/concepts/gateway-overview)
- [Quality of Service policies for your workloads hosted on Azure Stack HCI](https://techcommunity.microsoft.com/t5/azure-stack-blog/quality-of-service-policies-for-your-workloads-hosted-on-azure/ba-p/2385379)

### Requirement 2: Apply secure configurations to all system components

#### Secure by Default

Azure Stack HCI is configured securely by default with security tools and technologies to defend against modern threats and align with the [Azure Compute Security baselines](/azure/governance/policy/samples/guest-configuration-baseline-windows). Learn more at [Security baseline settings for Azure Stack HCI](/azure-stack/hci/concepts/secure-baseline).

#### Drift protection

The default security configuration and secured-core settings of the platform are protected during both deployment and runtime with [drift control](/azure-stack/hci/concepts/secure-baseline#about-security-baseline-and-drift-control) protection. When enabled, drift control protection refreshes the security settings regularly every 90 minutes to ensure that any changes from the specified state are remediated. This continuous monitoring and autoremediation allows you to have a consistent and reliable security configuration throughout the lifecycle of the device. You can disable the drift protection during the deployment when you configure the security settings.

#### Security baseline for workload

For workloads running on the Azure Stack HCI platform, you can use the Azure recommended operating system baseline (for both [Windows](/azure/governance/policy/samples/guest-configuration-baseline-windows) and [Linux](/azure/governance/policy/samples/guest-configuration-baseline-linux)) as a benchmark to define your compute resource configuration baseline.

### Requirement 3: Protect stored account data

#### Encrypting data with BitLocker

On Azure Stack HCI clusters, all data-at-rest can be encrypted via BitLocker XTS-AES 256-bit encryption. By default, the system will recommend you enable BitLocker to encrypt all the operating system (OS) volumes and cluster shared volumes (CSV) in your Azure Stack HCI deployment. For any new storage volumes added after the deployment, you need to manually turn-on BitLocker to encrypt the new storage volume. Using BitLocker to protect data can help organizations stay compliant with ISO/IEC 27001. Learn more at [Use BitLocker with Cluster Shared Volumes (CSV)](/windows-server/failover-clustering/bitlocker-on-csv-in-ws-2022).

### Requirement 4: Protect cardholder data with strong cryptography during transmission over open, public networks

#### Protecting external network traffic with TLS/DTLS

By default, all host communications to local and remote endpoints are encrypted using TLS1.2, TLS1.3, and DTLS 1.2. The platform disables the use of older protocols/hashes such as TLS/DTLS 1.1 SMB1. Azure Stack HCI also supports strong cipher suites like SDL-compliant elliptic curves limited to NIST curves P-256 and P-384 only.

### Requirement 5: Protect all systems and networks from malicious software

#### Windows Defender Antivirus

Windows Defender Antivirus is a utility application that enables enforcement of real-time system scanning and periodic scanning to protect platform and workloads against viruses, malware, spyware, and other threats. By default, Microsoft Defender Antivirus is enabled on Azure Stack HCI. Microsoft recommends using Microsoft Defender Antivirus with Azure Stack HCI rather than third-party antivirus and malware detection software and services as they may impact the operating system's ability to receive updates. Learn more at [Microsoft Defender Antivirus on Windows Server](/microsoft-365/security/defender-endpoint/microsoft-defender-antivirus-on-windows-server).

#### Windows Defender Application Control (WDAC)

Windows Defender Application Control (WDAC) is enabled by default on Azure Stack HCI to control which drivers and applications are allowed to run directly on each server, helping prevent malware from accessing the systems. Learn more about base policies included in Azure Stack HCI and how to create supplemental policies at [Windows Defender Application Control for Azure Stack HCI](/azure-stack/hci/concepts/security-windows-defender-application-control).

#### Microsoft Defender for Cloud

Microsoft Defender for Cloud with Endpoint Protection (enabled through server plans) provides a security posture management solution with advanced threat protection capabilities. It provides you with tools to assess the security status of your infrastructure, protect workloads, raise security alerts, and follow specific recommendations to remediate attacks and address future threats. It performs all these services at high speed in the cloud with no deployment overhead through autoprovisioning and protection with Azure services. Learn more at [Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud/).

### Requirement 6: Develop and maintain secure systems and software

#### Platform update

All components of the Azure Stack HCI platform, including the operating system, core agents and services, and the solution extension, can be maintained easily with the Lifecycle Manager. This feature allows you to bundle different components into an update release and validates the combination of versions to ensure interoperability. Learn more at [Lifecycle Manager for Azure Stack HCI solution updates](/azure-stack/hci/update/update-azure-stack-hci-solution).

#### Workload update

For workloads running on top of the Azure Stack HCI platform, including Azure Kubernetes Service (AKS) hybrid, Azure Arc, and infrastructure virtual machines (VMs) which aren't integrated into the Lifecycle Manager, follow the methods explained in [Use Lifecycle Manager for updates](/azure-stack/hci/update/update-azure-stack-hci-solution#workload-updates) to keep them updated and aligned with PCI DSS requirements.

### Requirement 7: Restrict access to system components and cardholder data by business need to know

It is your responsibility to identify roles and their access needs based on the business requirements of your organization, and then ensure that only authorized personnel have access to sensitive systems and data by assigning privileges based on job responsibilities. Use the capabilities described in [Requirement 8: Identify users and authenticate access to system components](#requirement-8-identify-users-and-authenticate-access-to-system-components) to implement your policies and procedures.

### Requirement 8: Identify users and authenticate access to system components

The Azure Stack HCI platform provides full and direct access to the underlying system running on cluster nodes via multiple interfaces such as Azure Arc and Windows PowerShell. You can use either conventional Windows tools in local environments or cloud-based solutions like Microsoft Entra ID (formerly Azure Active Directory) to manage identity and access to the platform. In both cases, you can take advantage of built-in security features, such as multifactor authentication (MFA), conditional access, role-based access control (RBAC), and privileged identity management (PIM) to ensure your environment is secure and compliant.

Learn more about local identity and access management at [Microsoft Identity Manager](/microsoft-identity-manager/microsoft-identity-manager-2016) and [Privileged Access Management for Active Directory Domain Services](/microsoft-identity-manager/pam/privileged-identity-management-for-active-directory-domain-services). Learn more about cloud-based identity and access management at [Microsoft Entra ID](/entra/fundamentals/whatis).

### Requirement 9: Restrict physical access to cardholder data

For on-premises environments, ensure physical security commensurate with the value of Azure Stack HCI platform and the data it contains.

### Requirement 10: Log and monitor all access to system components and cardholder data

#### Local system logs

By default, all operations that are performed within the Azure Stack HCI platform are recorded so that you can track who did what, when, and where on the platform. Logs and alerts created by Windows Defender are also included to help you prevent, detect, and minimize the likelihood and impact of a data compromise. However, since the system log often contains a large volume of information, much of it extraneous to information security monitoring, you need to identify which events are relevant to be collected and utilized for security monitoring purposes. Azure monitoring capabilities help collect, store, alert, and analyze those logs. Reference the [Security Baseline for Azure Stack HCI](https://aka.ms/hci-securitybase) to learn more.

#### Local activity logs

Azure Stack HCI Lifecycle Manager creates and stores activity logs for any action plan executed. These logs support deeper investigation and compliance monitoring.

#### Cloud activity logs

By registering your clusters with Azure, you can use [Azure Monitor activity logs](/azure/azure-monitor/essentials/activity-log) to record operations on each resource at the subscription layer to determine the what, who, and when for any write operations (put, post, or delete) taken on the resources in your subscription.

#### Cloud identity logs

If you're using Microsoft Entra ID to manage identity and access to the platform, you can view logs in [Azure AD reporting](/entra/identity/monitoring-health/concept-audit-logs) or integrate them with Azure Monitor, Microsoft Sentinel, or other SIEM/monitoring tools for sophisticated monitoring and analytics use cases. If you're using on-premises Active Directory, use the Microsoft Defender for Identity solution to consume your on-premises Active Directory signals to identify, detect, and investigate advanced threats, compromised identities, and malicious insider actions directed at your organization.

#### SIEM integration

Microsoft Defender for Cloud and Microsoft Sentinel is natively integrated with Arc-enabled Azure Stack HCI nodes. You can enable and onboard your logs to Microsoft Sentinel, which provides security information event management (SIEM) and security orchestration automated response (SOAR) capability. Microsoft Sentinel, like other Azure cloud services, complies with many well-established security standards such as PCI DSS, HITRUST, and FedRAMP Authorization, which can help you with your accreditation process. Additionally, Azure Stack HCI provides a native syslog event forwarder to send the system events to third party SIEM solutions.

#### Azure Stack HCI Insights

Azure Stack HCI Insights enables you to monitor health, performance, and usage information for clusters that are connected to Azure and are enrolled in monitoring. During Insights configuration, a data collection rule is created, which specifies the data to be collected. This data is stored in a Log Analytics workspace, which is then aggregated, filtered, and analyzed to provide prebuilt monitoring dashboards using Azure workbooks. You can view the monitoring data for a single cluster or multiple clusters from your Azure Stack HCI resource page or Azure Monitor. Learn more at [Monitor Azure Stack HCI with Insights](/azure-stack/hci/manage/monitor-hci-single?tabs=22h2-and-later).

#### Azure Stack HCI Metrics

Metrics stores numeric data from monitored resources into a time-series database. You can use [Azure Monitor metrics explorer](/azure/azure-monitor/essentials/analyze-metrics) to interactively analyze the data in your metric database and chart the values of multiple metrics over time. With Metrics, you can create charts from metric values and visually correlate trends.

#### Log alerts

To indicate problems in real time, you may set up alerts for Azure Stack HCI systems, using pre-existing sample log queries such as average server CPU, available memory, available volume capacity and more. Learn more at [Set up alerts for Azure Stack HCI systems](/azure-stack/hci/manage/setup-hci-system-alerts).

#### Metric alerts

A metric alert rule monitors a resource by evaluating conditions on the resource metrics at regular intervals. If the conditions are met, an alert is fired. A metric time-series is a series of metric values captured over a period of time. You can use these metrics to create alert rules. Learn more about how to create metrics alerts at [Metric alerts](/azure/azure-monitor/alerts/alerts-types#metric-alerts).

#### Service and device alerts

Azure Stack HCI provides service-based alerts for connectivity, OS updates, Azure configuration and more. Device-based alerts for cluster health faults are available as well. You may also monitor Azure Stack HCI clusters and their underlying components using [PowerShell](/azure-stack/hci/manage/monitor-cluster#query-and-process-performance-history-with-powershell) or [Health Service](/azure-stack/hci/manage/health-service-overview).

### Requirement 11: Test security of systems and networks regularly

Besides carrying out frequent security assessments and penetration tests yourself, you may also use [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) to assess security status across hybrid workloads in the cloud and on premises, including virtual machines, container images, and SQL servers that are Arc-enabled.

### Requirement 12: Support information security with organizational policies and programs

It is your responsibility to maintain the information security policies and activities that establish your organizational security program and safeguard your cardholder data environment. The automation features offered by Azure services such as Microsoft Entra ID and the information shared in [Details of the PCI DSS Regulatory Compliance built-in initiative](/azure/governance/policy/samples/pci-dss-3-2-1) can help you reduce the hassle of managing these policies and programs.
