---
title:  Azure Local security book ongoing compliance
description: Ongoing compliance for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/16/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Ongoing compliance

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]


## Configuration monitoring and drift protection

With Azure Local, you can apply the recommended Azure Local security baseline and Secured-core settings, monitor, and perform drift protection from desired state during both deployment and run-time, using the built-in configuration management stack in the operating system. You can choose if you want drift protection to be turned on or off during deployment time or after deployment using Windows Admin Center or PowerShell.

Once drift protection is applied, the security settings will be refreshed at regular intervals, thus ensuring any change from desired state is remediated. This continuous monitoring and auto-remediation allows you to have consistent and reliable security posture throughout the lifecycle of the system.

For those who need to adjust or update security settings based on their own business requirements, in addition to keeping a balanced security posture based on Microsoft’s recommendation, you can still leverage the initial security baseline, stop the drift control, and make any modification over any of the 300+ settings initially defined. To learn more, see [Security baseline and drift control](../manage/manage-secure-baseline.md).
 
## Azure security baseline compliance assessment

[Azure Policy](/azure/governance/policy/overview) helps to enforce organizational standards and to assess compliance at-scale. Through its compliance dashboard, it provides an aggregated view to evaluate the overall state of the environment, with the ability to drill down to the per-resource, perpolicy granularity.

During run-time, you can use Azure Policy to audit Azure Local host machine configuration and perform compliance assessments based on Azure security baseline policies. In the future, we will also have the capability to remediate the security settings via Azure Policy and [Azure Automanage](https://azure.microsoft.com/products/azure-automanage/). 

## SIEM integration

Security compliance requires strict logging and auditing of security events. In Azure Local, we recommend customers to use our Cloud SIEM [Azure Sentinel](https://www.microsoft.com/security/business/siem-and-xdr/microsoft-sentinel/) service. For those organizations that use their own SIEM, Azure Local comes with an [integrated syslog forwarder](/azure/azure-local/manage/manage-syslog-forwarding?tabs=syslog-message-schema) mechanism which can be used to forward security related events to a SIEM.
  
The integrated syslog forwarder, once configured, emits syslog messages as defined in RFC 3164, with the payload in Common Event Format (CEF).  All audits and security events are collected on each host and exported via syslog with CEF payload to a Syslog Server endpoint.  

## Microsoft Defender for Cloud regulatory compliance

Microsoft Defender for Cloud streamlines the process for meeting [regulatory compliance requirements](/azure/defender-for-cloud/update-regulatory-compliance-packages#what-regulatory-compliance-standards-are-available-in-defender-for-cloud), using the regulatory compliance dashboard. Defender for Cloud continuously assesses your hybrid cloud environment to analyze the risk factors according to the controls and best practices in the regulatory standards that you have applied to your subscriptions. The dashboard reflects the status of your compliance with those standards. The regulatory compliance dashboard provides insights into your compliance posture based on how you are meeting specific compliance requirements such as ISO 27001:2013, PCI DSS v4, and NIST SP 800-53 R5. 

## Related content

- [Ongoing operations](operational-security-operations.md)
- [Updates](operational-security-updates.md)
