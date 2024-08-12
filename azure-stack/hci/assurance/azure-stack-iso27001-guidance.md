---
title: ISO 27001 guidance for Azure Stack HCI
description: Learn about ISO 27001 compliance using Azure Stack HCI.
ms.date: 2/5/2024
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.author: nguyenhung
author: dv00000
ms.reviewer: alkohli
---

# Azure Stack HCI and ISO/IEC 27001:2022

This article outlines how Azure Stack HCI helps organizations meet the security control requirements of ISO/IEC 27001:2022, both in cloud and on premises. Learn more about Azure Stack and other security standards at [Azure Stack and security standards](azure-stack-security-standards.md).

## ISO/IEC 27001:2022

ISO/IEC 27001 is a global security standard that specifies requirements for establishing, implementing, operating, monitoring, maintaining, and improving an Information Security Management System (ISMS).  Certification to ISO/IEC 27001:2022 helps organizations enhance their security posture, build trust with their clients, and can help meet various legal and regulatory obligations that involve information security, such as PCI DSS, HIPAA, HITRUST, and FedRAMP. Learn more about the standard at [ISO/IEC 27001](https://www.iso.org/standard/27001).

## Azure Stack HCI

Azure Stack HCI is a hybrid solution that provides seamless integration between organizations' on-premises infrastructure and Azure cloud services, helping to consolidate virtualized workloads and containers and gain cloud efficiencies when data needs to remain on premises for legal or privacy reasons. Organizations seeking ISO/IEC 27001:2022 certification for their solutions should consider both their cloud and on-premises environments.

### Connected cloud services

Azure Stack HCI provides deep integration with several Azure services, such as Azure Monitor, Azure Backup, and Azure Site Recovery, to deliver new capabilities to the hybrid environment. These cloud services undergo regular independent third-party audits for ISO/IEC 27001:2022 compliance. You can review the Azure ISO/IEC 27001:2022 certificate and audit report at [Azure compliance offerings – ISO/IEC 27001:2022](/azure/compliance/offerings/offering-iso-27001).

> [!IMPORTANT]
> Azure compliance status does not confer ISO/IEC 27001 accreditation for the services an organization builds or hosts on the Azure platform. Organizations are responsible for ensuring compliance of their operations with ISO/IEC 27001:2022 requirements.

### On-premises solutions

On premises, Azure Stack HCI provides an array of features that help organizations satisfy the security requirements of ISO/IEC 27001:2022. The following sections provide more information.

## Azure Stack HCI capabilities relevant for ISO/IEC 27001:2022

This section outlines how organizations can use Azure Stack HCI functionality to meet the security controls in Annex A of ISO/IEC 27001:2022. The following information covers technical requirements only. Requirements related to security operations are out of scope, as Azure Stack HCI can't affect them. The guidance is organized by the nine domains of Annex A:

- [Network security](#network-security)
- [Identity and access management](#identity-and-access-management)
- [Data protection](#data-protection)
- [Logging](#logging)
- [Monitoring](#monitoring)
- [Secure configuration](#secure-configuration)
- [Threat protection](#threat-protection)
- [Backup and recovery](#backup-and-recovery)
- [Scalability and availability](#scalability-and-availability)

The guidance in this article outlines how Azure Stack HCI platform capabilities can be utilized to meet the requirements of each domain. It's important to note that not all controls are mandatory. Organizations should analyze their environment and carry out risk assessment to determine which controls are necessary. For more information on the requirements, see [ISO/IEC 27001](https://www.iso.org/standard/27001).

### Network security

The network security functionality described in this section can assist you in meeting the following security controls specified in the ISO/IEC 27001 standard.

- 8.20 – Network security
- 8.21 – Security of network services
- 8.22 – Segregation of networks
- 8.23 – Web filtering

With Azure Stack HCI, you can apply network security controls to safeguard your platform and the workloads running on it from network threats outside and inside. The platform also guarantees fair network allocation on a host and improves workload performance and availability with load balancing capabilities. Learn more about network security in Azure Stack HCI at the following articles.

- [Datacenter Firewall overview](/azure-stack/hci/concepts/datacenter-firewall-overview)
- [Software Load Balancer (SLB) for Software Define Network (SDN)](/azure-stack/hci/concepts/software-load-balancer)
- [Remote Access Service (RAS) Gateway for SDN](/azure-stack/hci/concepts/gateway-overview)
- [Quality of Service policies for your workloads hosted on Azure Stack HCI](https://techcommunity.microsoft.com/t5/azure-stack-blog/quality-of-service-policies-for-your-workloads-hosted-on-azure/ba-p/2385379)

### Identity and access management

The identity and access management functionality described in this section can assist you in meeting the following security controls specified in the ISO/IEC 27001 standard.

- 8.2 – Privileged access rights
- 8.3 – Information access restrictions
- 8.5 – Secure authentication

The Azure Stack HCI platform provides full and direct access to the underlying system running on cluster nodes via multiple interfaces such as Azure Arc and Windows PowerShell. You can use either conventional Windows tools in local environments or cloud-based solutions like Microsoft Entra ID (formerly Azure Active Directory) to manage identity and access to the platform. In both cases, you can take advantage of built-in security features, such as multifactor authentication (MFA), conditional access, role-based access control (RBAC), and privileged identity management (PIM) to ensure your environment is secure and compliant.

Learn more about local identity and access management at [Microsoft Identity Manager](/microsoft-identity-manager/microsoft-identity-manager-2016) and [Privileged Access Management for Active Directory Domain Services](/microsoft-identity-manager/pam/privileged-identity-management-for-active-directory-domain-services). Learn more about cloud-based identity and access management at [Microsoft Entra ID](/entra/fundamentals/whatis).

### Data protection

The data protection functionality described in this section can assist you in meeting the following security controls specified in the ISO/IEC 27001 standard.

- 8.5 – Secure authentication
- 8.20 – Network security
- 8.21 - Security of network services
- 8.24 – Use of cryptography

#### Encrypting data with BitLocker

On Azure Stack HCI clusters, all data-at-rest can be encrypted via BitLocker XTS-AES 256-bit encryption. By default, the system will recommend you enable BitLocker to encrypt all the operating system (OS) volumes and cluster shared volumes (CSV) in your Azure Stack HCI deployment. For any new storage volumes added after the deployment, you need to manually turn-on BitLocker to encrypt the new storage volume. Using BitLocker to protect data can help organizations stay compliant with ISO/IEC 27001. Learn more at [Use BitLocker with Cluster Shared Volumes (CSV)](/windows-server/failover-clustering/bitlocker-on-csv-in-ws-2022).

#### Protecting external network traffic with TLS/DTLS

By default, all host communications to local and remote endpoints are encrypted using TLS1.2, TLS1.3, and DTLS 1.2. The platform disables the use of older protocols/hashes such as TLS/DTLS 1.1 SMB1. Azure Stack HCI also supports strong cipher suites like [SDL-compliant](https://www.microsoft.com/securityengineering/sdl/) elliptic curves limited to NIST curves P-256 and P-384 only.

#### Protecting internal network traffic with Server Message Block (SMB)

SMB signing is enabled by default for client connections in Azure Stack HCI cluster hosts. For intra-cluster traffic, SMB encryption is an option organizations may enable during or after deployment to protect data in transit between clusters. AES-256-GCM and AES-256-CCM cryptographic suites are now supported by the SMB 3.1.1 protocol used by client-server file traffic and the intra-cluster data fabric. The protocol continues to support the more broadly compatible AES-128 suite as well. Learn more at [SMB security enhancements](/windows-server/storage/file-server/smb-security).

### Logging

The logging functionality described in this section can assist you in meeting the following security controls specified in the ISO/IEC 27001 standard.

- 8.15 – Logging
- 8.17 – Clock synchronization

#### Local system logs

By default, all operations that are performed within the Azure Stack HCI platform are recorded so that you can track who did what, when, and where on the platform. Logs and alerts created by Windows Defender are also included to help you prevent, detect, and minimize the likelihood and impact of a data compromise. However, since the system log often contains a large volume of information, much of it extraneous to information security monitoring, you need to identify which events are relevant to be collected and utilized for security monitoring purposes. Azure monitoring capabilities help collect, store, alert, and analyze those logs. Reference the [Security Baseline for Azure Stack HCI](https://aka.ms/hci-securitybase) to learn more.

#### Local activity logs

Azure Stack HCI Lifecycle Manager creates and stores activity logs for any action plan executed. These logs support deeper investigation and monitoring.

#### Cloud activity logs

By registering your clusters with Azure, you can use [Azure Monitor activity logs](/azure/azure-monitor/essentials/activity-log) to record operations on each resource at the subscription layer to determine the what, who, and when for any write operations (put, post, or delete) taken on the resources in your subscription.

#### Cloud identity logs

If you're using Microsoft Entra ID to manage identity and access to the platform, you can view logs in [Azure AD reporting](/entra/identity/monitoring-health/concept-audit-logs) or integrate them with Azure Monitor, Microsoft Sentinel, or other SIEM/monitoring tools for sophisticated monitoring and analytics use cases. If you're using on-premises Active Directory, use the Microsoft Defender for Identity solution to consume your on-premises Active Directory signals to identify, detect, and investigate advanced threats, compromised identities, and malicious insider actions directed at your organization.

#### SIEM integration

Microsoft Defender for Cloud and Microsoft Sentinel is natively integrated with Arc-enabled Azure Stack HCI nodes. You can enable and onboard your logs to Microsoft Sentinel, which provides security information event management (SIEM) and security orchestration automated response (SOAR) capability. Microsoft Sentinel, like other Azure cloud services, also complies with many well-established security standards such as ISO/IEC 27001, which can help you with your certification process. Additionally, Azure Stack HCI provides a native syslog event forwarder to send the system events to the third party SIEM solutions.

### Monitoring

The monitoring functionality described in this section can assist you in meeting the following security controls specified in the ISO/IEC 27001 standard.

- 8.15 – Logging

#### Azure Stack HCI Insights

Azure Stack HCI Insights enables you to monitor health, performance, and usage information for clusters that are connected to Azure and are enrolled in monitoring. During Insights configuration, a data collection rule is created, which specifies the data to be collected. This data is stored in a Log Analytics workspace, which is then aggregated, filtered, and analyzed to provide prebuilt monitoring dashboards using Azure workbooks. You can view the monitoring data for a single cluster or multiple clusters from your Azure Stack HCI resource page or Azure Monitor. Learn more at [Monitor Azure Stack HCI with Insights](/azure-stack/hci/manage/monitor-hci-single?tabs=22h2-and-later).

#### Azure Stack HCI Metrics

Metrics stores numeric data from monitored resources into a time-series database. You can use [Azure Monitor metrics explorer](/azure/azure-monitor/essentials/analyze-metrics) to interactively analyze the data in your metric database and chart the values of multiple metrics over time. With Metrics, you can create charts from metric values and visually correlate trends.

#### Log alerts

To indicate problems in real time, you may set up alerts for Azure Stack HCI systems, using pre-existing sample log queries such as average server CPU, available memory, available volume capacity and more. Learn more at [Set up alerts for Azure Stack HCI systems](/azure-stack/hci/manage/setup-hci-system-alerts).

#### Metric alerts

A metric alert rule monitors a resource by evaluating conditions on the resource metrics at regular intervals. If the conditions are met, an alert is fired. A metric time-series is a series of metric values captured over a period of time. You can use these metrics to create alert rules. Learn more about how to create metric alerts at [Metric alerts](/azure/azure-monitor/alerts/alerts-types#metric-alerts).

#### Service and device alerts

Azure Stack HCI provides service-based alerts for connectivity, OS updates, Azure configuration and more. Device-based alerts for cluster health faults are available as well. You may also monitor Azure Stack HCI clusters and their underlying components using [PowerShell](/azure-stack/hci/manage/monitor-cluster#query-and-process-performance-history-with-powershell) or [Health Service](/azure-stack/hci/manage/health-service-overview).

### Secure Configuration

The secure configuration functionality described in this section can help you meet the following security control requirements of ISO/IEC 27001.

- 8.8 – Management of technical vulnerabilities
- 8.9 – Configuration management

#### Secure by Default

Azure Stack HCI is configured securely by default with security tools and technologies that defend against modern threats and align with the [Azure Compute Security baselines](/azure/governance/policy/samples/guest-configuration-baseline-windows). Learn more at [Manage security defaults for Azure Stack HCI](/azure-stack/hci/concepts/secure-baseline).

#### Drift protection

The default security configuration and secured-core settings of the platform are protected during both deployment and runtime with [drift control](/azure-stack/hci/concepts/secure-baseline#about-security-baseline-and-drift-control) protection. When enabled, drift control protection refreshes the security settings regularly every 90 minutes to ensure that any changes from the specified state are remediated. This continuous monitoring and autoremediation allows you to have a consistent and reliable security configuration throughout the lifecycle of the device. You can disable the drift protection during the deployment when you configure the security settings.

#### Security baseline for workload

For workloads running on the Azure Stack HCI, you can use the Azure recommended operating system baseline (for both [Windows](/azure/governance/policy/samples/guest-configuration-baseline-windows) and [Linux](/azure/governance/policy/samples/guest-configuration-baseline-linux)) as a benchmark to define your compute resource configuration baseline.

#### Platform update

All components of the Azure Stack HCI platform, including the operating system, core agents and services, and the solution extension, can be maintained easily with the Lifecycle Manager. This feature allows you to bundle different components into an update release and validates the combination of versions to ensure interoperability. Learn more at [Lifecycle Manager for Azure Stack HCI solution updates](/azure-stack/hci/update/update-azure-stack-hci-solution).

#### Workload update

For workloads running on top of the Azure Stack HCI platform, including Azure Kubernetes Service (AKS) hybrid, Azure Arc, and infrastructure virtual machines (VMs) that aren't integrated into the Lifecycle Manager, follow the methods explained in [Use Lifecycle Manager for updates](/azure-stack/hci/update/update-azure-stack-hci-solution#workload-updates) to keep them updated.

### Threat protection

The threat protection functionality in this section can help you meet the following security control requirements of ISO/IEC 27001.

- 8.7 – Protection against malware

#### Windows Defender Antivirus

Windows Defender Antivirus is a utility application providing the ability to enforce real-time system scanning and periodic scanning to protect platform and workloads against viruses, malware, spyware, and other threats. By default, Microsoft Defender Antivirus is enabled on Azure Stack HCI. Microsoft recommends using Microsoft Defender Antivirus with Azure Stack HCI rather than third-party antivirus and malware detection software and services as they may impact the operating system's ability to receive updates. Learn more at [Microsoft Defender Antivirus on Windows Server](/microsoft-365/security/defender-endpoint/microsoft-defender-antivirus-on-windows-server).

#### Windows Defender Application Control (WDAC)

Windows Defender Application Control (WDAC) is enabled by default on Azure Stack HCI to control which drivers and applications are allowed to run directly on each server, helping prevent malware from accessing the systems. Learn more about base policies included in Azure Stack HCI and how to create supplemental policies at [Windows Defender Application Control for Azure Stack HCI](/azure-stack/hci/concepts/security-windows-defender-application-control).

#### Microsoft Defender for Cloud

Microsoft Defender for Cloud with Endpoint Protection (enabled through the [Defender for Servers plan](/azure/defender-for-cloud/plan-defender-for-servers-select-plan)) provides a security management solution with advanced threat protection capabilities. It provides you with tools to assess the security status of your infrastructure, protect workloads, raise security alerts, and follow specific recommendations to remediate attacks and address future threats. It performs all these services at high speed in the cloud with no deployment overhead through autoprovisioning and protection with Azure services. Learn more at [Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud/).

### Backup and recovery

The backup and recovery functionality described in this section can help you meet the following security control requirements of ISO/IEC 27001.

- 8.7 – Protection against malware
- 8.13 – Information backup
- 8.14 – Redundancy of information

#### Stretched cluster

Azure Stack HCI provides built-in support for disaster recovery of virtualized workloads through stretched clustering. By deploying a stretched Azure Stack HCI cluster, you can synchronously replicate its virtualized workloads across two separate on-premises locations and automatically failover between them. Planned site failovers can happen with no downtime using Hyper-V live migration.

#### Kubernetes cluster nodes

If you use Azure Stack HCI to host container-based deployments, the platform helps you enhance the agility and resiliency inherent to Azure Kubernetes deployments. Azure Stack HCI manages automatic failover of VMs serving as Kubernetes cluster nodes if there's a localized failure of the underlying physical components. This configuration supplements the high availability built into Kubernetes, which automatically restarts failed containers on the same or another VM.

#### Azure Site Recovery

This service allows you to replicate workloads running on your on-premises Azure Stack HCI VMs to the cloud so that your information system can be restored if there's an incident, failure, or loss of storage media. Like other Azure cloud services, Azure Site Recovery has a long track record of security certificates including HITRUST, which you can use to support your accreditation process. Learn more at [Protect VM workloads with Azure Site Recovery on Azure Stack HCI](/azure-stack/hci/manage/azure-site-recovery).

#### Microsoft Azure Backup Server (MABS)

This service enables you to back up Azure Stack HCI virtual machines, specifying a desired frequency and retention period. You can use MABS to back up most of your resources across the environment, including:

- System State/Bare-Metal Recovery (BMR) of Azure Stack HCI host
- Guest VMs in a cluster that has local or directly attached storage
- Guest VMs on Azure Stack HCI cluster with CSV storage
- VM Move within a cluster

Learn more at [Back up Azure Stack HCI virtual machines with Azure Backup Server](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines).

### Scalability and availability

The scalability and availability functionality described in this section can help you meet the following security control requirements of ISO/IEC 27001.

- 8.6 – Capacity management
- 8.14 – Redundancy of information

#### Hyperconverged models

Azure Stack HCI uses hyperconverged models of Storage Spaces Direct to deploy workloads. This deployment model enables you to scale easily by adding new nodes that automatically expand compute and storage at the same time with zero downtime.

#### Failover clusters

Azure Stack HCI clusters are failover clusters. If a server that is part of an Azure Stack HCI fails or becomes unavailable, another server in the same failover cluster takes over the task of providing the services offered by the failed node. You create a failover cluster by enabling Storage Spaces Direct on multiple servers running Azure Stack HCI.
