---
title: HIPAA guidance for Azure Stack HCI
description: Learn about HIPAA compliance using Azure Stack HCI.
ms.date: 2/5/2024
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.author: nguyenhung
author: dv00000
ms.reviewer: alkohli
---

# Azure Stack HCI and HIPAA

This article provides guidance on how organizations can most efficiently navigate HIPAA compliance for solutions built with Azure Stack HCI.

## Healthcare compliance

The [Health Insurance Portability and Accountability Act of 1996](https://www.cdc.gov/phlp/php/resources/health-insurance-portability-and-accountability-act-of-1996-hipaa.html) (HIPAA) and healthcare standards such as Health Information Technology for Economic and Clinical Health (HITECH) and [Health Information Trust Alliance](https://hitrustalliance.net/hitrust-csf/) (HITRUST) protect the confidentiality, integrity, and availability of patients' protected health information (PHI). These regulations and standards ensure that healthcare organizations such as doctors' offices, hospitals, and health insurers ("covered entities") create, receive, maintain, transmit, or access PHI appropriately. In addition, their requirements extend to business associates who provide services that involve PHI for the covered entities. Microsoft is an example of a business associate that provides information technology services like Azure Stack HCI to help healthcare companies store and process PHI more efficiently and securely. The following sections provide information on how Azure Stack HCI's platform capabilities help organizations meet these requirements.

## Shared responsibilities

### Microsoft customers

As a covered entity who is subject to HIPAA laws, healthcare organizations independently analyze their unique technology environments and use cases and then plan and implement policies and procedures that comply with the requirements of the regulations. Covered entities are responsible for ensuring compliance of their technology solutions. The guidance in this article and other resources provided by Microsoft may be used as a reference.

### Microsoft

Under HIPAA regulations, business associates do not assure HIPAA compliance, but instead enter into a Business Associate Agreement (BAA) with covered entities. Microsoft offers a [HIPAA BAA](https://aka.ms/baa) as part of the Microsoft [Product Terms](https://www.microsoft.com/licensing/docs/view/Product-Terms) (formerly Online Services Terms) to all customers who are covered entities or business associates under HIPAA for use with in-scope Azure services.

## Azure Stack HCI compliance offerings

Azure Stack HCI is a hybrid solution that hosts and stores virtualized workloads on both Azure cloud and your on-premises datacenter. This means that HIPAA requirements need to be satisfied in both the cloud and your local data center.

### Azure cloud services

As HIPAA legislation is designed for healthcare companies, cloud services such as Microsoft Azure can't be certified. However, Azure and Azure Stack HCI's connected cloud services comply with other established security frameworks and standards that are equivalent to or more stringent than HIPAA and HITECH. Learn more about the Azure compliance program for the healthcare industry at [Azure and HIPAA](/azure/compliance/offerings/offering-hipaa-us).

### On-premises environment

As a hybrid solution, Azure Stack HCI combines Azure cloud services with operating systems and infrastructure hosted on-premises by customer organizations. Microsoft provides an array of features that help organizations satisfy compliance with HIPAA and other healthcare industry standards, both in cloud and on-premises environments.

## Azure Stack HCI capabilities relevant for the HIPAA Security Rule

This section outlines how the features of Azure Stack HCI help you achieve the security control objectives of the HIPAA Security Rule, which comprises the following five control domains:

- [Identity and access management](#identity-and-access-management)
- [Data protection](#data-protection)
- [Logging and monitoring](#logging-and-monitoring)
- [Protection against malware](#protection-against-malware)
- [Backup and recovery](#backup-and-recovery)

> [!IMPORTANT]
> The following sections provide guidance focused on the platform layer. Information on specific workloads and application layers is out-of-scope.

### Identity and access management

The Azure Stack HCI platform provides full and direct access to the underlying system running on cluster nodes via multiple interfaces such as Azure Arc and Windows PowerShell. You can use either conventional Windows tools in local environments or cloud-based solutions like Microsoft Entra ID (formerly Azure Active Directory) to manage identity and access to the platform. In both cases, you can take advantage of built-in security features, such as multifactor authentication (MFA), conditional access, role-based access control (RBAC), and privileged identity management (PIM) to ensure your environment is secure and compliant.

Learn more about local identity and access management at [Microsoft Identity Manager](/microsoft-identity-manager/microsoft-identity-manager-2016) and [Privileged Access Management for Active Directory Domain Services](/microsoft-identity-manager/pam/privileged-identity-management-for-active-directory-domain-services). Learn more about cloud-based identity and access management at [Microsoft Entra ID](/entra/fundamentals/whatis).

### Data protection

#### Encrypting data with BitLocker

On Azure Stack HCI clusters, all data-at-rest can be encrypted via BitLocker XTS-AES 256-bit encryption. By default, the system will recommend you enable BitLocker to encrypt all the operating system (OS) volumes and cluster shared volumes (CSV) in your Azure Stack HCI deployment. For any new storage volumes added after the deployment, you need to manually enable BitLocker to encrypt the new storage volume. Using BitLocker to protect data can help organizations stay compliant with ISO/IEC 27001. Learn more at [Use BitLocker with Cluster Shared Volumes (CSV)](/windows-server/failover-clustering/bitlocker-on-csv-in-ws-2022).

#### Protecting external network traffic with TLS/DTLS

By default, all host communications to local and remote endpoints are encrypted using TLS1.2, TLS1.3, and DTLS 1.2. The platform disables the use of older protocols/hashes such as TLS/DTLS 1.1 SMB1. Azure Stack HCI also supports strong cipher suites like [SDL-compliant](https://www.microsoft.com/securityengineering/sdl/) elliptic curves, limited to NIST curves P-256 and P-384 only.

#### Protecting internal network traffic with Server Message Block (SMB)

SMB signing is enabled by default for client connections in Azure Stack HCI cluster hosts. For intra-cluster traffic, SMB encryption is an option organizations may enable during or after deployment to protect data in transit between clusters. AES-256-GCM and AES-256-CCM cryptographic suites are now supported by the SMB 3.1.1 protocol used by client-server file traffic and the intra-cluster data fabric. The protocol continues to support the more broadly compatible ES-128 suite as well. Learn more at [SMB security enhancements](/windows-server/storage/file-server/smb-security).

### Logging and monitoring

#### Local system logs

By default, all operations that are performed within the Azure Stack HCI platform are recorded so that you can track who did what, when, and where on the platform. Logs and alerts created by Windows Defender are also included to help you prevent, detect, and minimize the likelihood and impact of a data compromise. Since the system log often contains a large volume of information, much of it extraneous to information security monitoring, you need to identify which events are relevant to be collected and utilized for security monitoring purposes. Azure monitoring capabilities help collect, store, alert, and analyze those logs. Reference the [Security Baseline for Azure Stack HCI](https://aka.ms/hci-securitybase) to learn more.

#### Local activity logs

Azure Stack HCI Lifecycle Manager creates and stores activity logs for any action plan executed. These logs support deeper investigation and compliance monitoring.

#### Cloud activity logs

By registering your clusters with Azure, you can use [Azure Monitor activity logs](/azure/azure-monitor/essentials/activity-log) to record operations on each resource at the subscription layer to determine the what, who, and when for any write operations (put, post, or delete) taken on the resources in your subscription.

#### Cloud identity logs

If you're using Microsoft Entra ID to manage identity and access to the platform, you can view logs in [Azure AD reporting](/entra/identity/monitoring-health/concept-audit-logs) or integrate them with Azure Monitor, Microsoft Sentinel, or other SIEM/monitoring tools for sophisticated monitoring and analytics use cases. If you're using on-premises Active Directory, use the Microsoft Defender for Identity solution to consume your on-premises Active Directory signals to identify, detect, and investigate advanced threats, compromised identities, and malicious insider actions directed at your organization.

#### SIEM integration

Microsoft Defender for Cloud and Microsoft Sentinel is natively integrated with Arc-enabled Azure Stack HCI nodes. You can enable and onboard your logs to Microsoft Sentinel, which provides security information event management (SIEM) and security orchestration automated response (SOAR) capability. Microsoft Sentinel, like other Azure cloud services, complies with many well-established security standards such as HIPAA and HITRUST, which can help you with your accreditation process. Additionally, Azure Stack HCI provides a native syslog event forwarder to send the system events to third party SIEM solutions.

#### Azure Stack HCI Insights

Azure Stack HCI Insights enables you to monitor health, performance, and usage information for clusters that are connected to Azure and are enrolled in monitoring. During Insights configuration, a data collection rule is created, which specifies the data to be collected. This data is stored in a Log Analytics workspace, which is then aggregated, filtered, and analyzed to provide prebuilt monitoring dashboards using Azure workbooks. You can view the monitoring data for a single cluster or multiple clusters from your Azure Stack HCI resource page or Azure Monitor. Learn more at [Monitor Azure Stack HCI with Insights](/azure-stack/hci/manage/monitor-hci-single?tabs=22h2-and-later).

#### Azure Stack HCI Metrics

Metrics store numeric data from monitored resources into a time-series database. You can use [Azure Monitor metrics explorer](/azure/azure-monitor/essentials/analyze-metrics) to interactively analyze the data in your metric database and chart the values of multiple metrics over time. With Metrics, you can create charts from metric values and visually correlate trends.

#### Log alerts

To indicate problems in real time, you may set up alerts for Azure Stack HCI systems, using pre-existing sample log queries such as average server CPU, available memory, available volume capacity and more. Learn more at [Set up alerts for Azure Stack HCI systems](/azure-stack/hci/manage/setup-hci-system-alerts).

#### Metric alerts

A metric alert rule monitors a resource by evaluating conditions on the resource metrics at regular intervals. If the conditions are met, an alert is fired. A metric time-series is a series of metric values captured over a period of time. You can use these metrics to create alert rules. Learn more about how to create metric alerts at [Metric alerts](/azure/azure-monitor/alerts/alerts-types#metric-alerts).

#### Service and device alerts

Azure Stack HCI provides service-based alerts for connectivity, OS updates, Azure configuration and more. Device-based alerts for cluster health faults are available as well. You may also monitor Azure Stack HCI clusters and their underlying components using [PowerShell](/azure-stack/hci/manage/monitor-cluster#query-and-process-performance-history-with-powershell) or [Health Service](/azure-stack/hci/manage/health-service-overview).

### Protection against malware

#### Windows Defender Antivirus

Windows Defender Antivirus is a utility application that enables enforcement of real-time system scanning and periodic scanning to protect platform and workloads against viruses, malware, spyware, and other threats. By default, Microsoft Defender Antivirus is enabled on Azure Stack HCI. Microsoft recommends using Microsoft Defender Antivirus with Azure Stack HCI rather than third-party antivirus and malware detection software and services as they may impact the operating system's ability to receive updates. Learn more at [Microsoft Defender Antivirus on Windows Server](/microsoft-365/security/defender-endpoint/microsoft-defender-antivirus-on-windows-server).

#### Windows Defender Application Control

Windows Defender Application Control (WDAC) is enabled by default on Azure Stack HCI to control which drivers and applications are allowed to run directly on each server, helping prevent malware from accessing the system. Learn more about base policies included in Azure Stack HCI and how to create supplemental policies at [Manage Windows Defender Application Control for Azure Stack HCI](/azure-stack/hci/concepts/security-windows-defender-application-control).

#### Microsoft Defender for Cloud

Microsoft Defender for Cloud with Endpoint Protection (enabled through server plans) provides a security posture management solution with advanced threat protection capabilities. It provides you with tools to assess the security status of your infrastructure, protect workloads, raise security alerts, and follow specific recommendations to remediate attacks and address future threats. It performs all these services at high speed in the cloud with no deployment overhead through autoprovisioning and protection with Azure services. Learn more at [Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud/).

### Backup and recovery

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
