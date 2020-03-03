---
title: Azure Stack Hub log and customer data handling 
description: Learn how Azure Stack Hub collects customer data and information. 
author: JustinHall

ms.topic: article
ms.date: 06/10/2019
ms.author: justinha
ms.reviewer: chengwei
ms.lastreviewed: 06/10/2019

# Intent: As an Azure Stack operator, I want to know how Azure Stack handles my customer data.
# Keyword: azure stack customer data

---

# Azure Stack Hub log and customer data handling 

To the extent Microsoft is a processor or subprocessor of personal data in connection with Azure Stack Hub, Microsoft makes to all customers, effective May 25, 2018, the following commitments:

- The "Processing of Personal Data; GDPR" provision in the "Data Protection Terms" section of the [Online Services Terms](http://www.microsoftvolumelicensing.com/DocumentSearch.aspx?Mode=3&DocumentTypeId=31).
- The European Union General Data Protection Regulation Terms in Attachment 4 of the [Online Services Terms](http://www.microsoftvolumelicensing.com/DocumentSearch.aspx?Mode=3&DocumentTypeId=31).

As Azure Stack Hub resides in customer datacenters, Microsoft is the Data Controller solely of the data that is shared with Microsoft through [Diagnostics](azure-stack-configure-on-demand-diagnostic-log-collection.md#use-the-privileged-endpoint-pep-to-collect-diagnostic-logs), [Telemetry](azure-stack-telemetry.md), and [Billing](azure-stack-usage-reporting.md).  

## Data access controls 
Microsoft employees, who are assigned to investigate a specific support case, will be granted read-only access to the encrypted data. Microsoft employees also have access to tools used to delete the data if needed. All access to the customer data is audited and logged.  

Data access controls:
- Data is only kept for a maximum of 90 days after case close.
- The customer always has the choice to have the data removed at any time in that 90-day period.
- Microsoft employees are given access to the data on a case-by-case basis and only as needed to help resolve the support issue.
- In the event where Microsoft must share customer data with OEM partners, customer consent is mandatory.  

### What Data Subject Requests (DSR) controls do customers have?
Microsoft supports on-demand data deletion per customer request. Customers can request that one of our support engineers delete all their logs for a given case at any time, before the data is permanently erased.  

### Does Microsoft notify customers when the data is deleted?
For the automated data deletion action (90 days after case close), we don't proactively contact customers and notify them about the deletion.

For the on-demand data deletion action, Microsoft support engineers have access to the tool that lets them delete data on demand. They can provide confirmation on the phone with the customer when it's done.

## Diagnostic data
As part of the support process, Azure Stack Hub Operators can [share diagnostic logs](azure-stack-configure-on-demand-diagnostic-log-collection.md#use-the-privileged-endpoint-pep-to-collect-diagnostic-logs) with Azure Stack Hub support and engineering teams to help with troubleshooting.

Microsoft provides a tool and script for customers to collect and upload requested diagnostic log files. Once collected, the log files are transferred over an HTTPS protected encrypted connection to Microsoft. Because HTTPS provides the encryption over the wire, there's no password needed for the encryption in transit. After they're received, logs are encrypted and stored until they're automatically deleted 90 days after the support case is closed.

## Telemetry data
[Azure Stack Hub telemetry](azure-stack-telemetry.md) automatically uploads system data to Microsoft via the Connected User Experience. Azure Stack Hub Operators have controls to customize telemetry features and privacy settings at any time.

Microsoft doesn't intend to gather sensitive data, such as credit card numbers, usernames and passwords, email addresses, and so on. If we determine that sensitive information has been inadvertently received, we delete it.

## Billing data
[Azure Stack Hub Billing](azure-stack-usage-reporting.md) leverages global Azure's Billing and Usage pipeline and is therefore in alignment with Microsoft compliance guidelines.

Azure Stack Hub Operators can configure Azure Stack Hub to forward usage information to Azure for billing. This configuration is required for Azure Stack Hub integrated systems customers who choose the pay-as-you-use billing model. Usage reporting is controlled independently from telemetry and isn't required for integrated systems customers who choose the capacity model or for Azure Stack Development Kit users. For these scenarios, usage reporting can be turned off using [the registration script](azure-stack-usage-reporting.md).


## Next steps 
[Learn more about Azure Stack Hub security](azure-stack-security-foundations.md) 
