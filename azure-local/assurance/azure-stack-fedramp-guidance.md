---
title: FedRAMP guidance for Azure Local
description: Learn about FedRAMP compliance using Azure Local.
ms.date: 12/27/2024
ms.topic: article
ms.service: azure-local
ms.author: nguyenhung
author: dv00000
ms.reviewer: alkohli
---

# Azure Local and FedRAMP

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article explains the relationship between Azure Local and FedRAMP and how organizations can stay compliant with FedRAMP with Azure Local solutions.

## What is FedRAMP?

The US Federal Risk and Authorization Management Program (FedRAMP) provides a standard approach for assessing, monitoring, and authorizing cloud computing products and services. FedRAMP eases US federal agencies’ ability to adopt secure cloud solutions and facilitates Microsoft and other cloud services providers’ ability to offer services to federal agencies.

For more information about FedRAMP, see [Azure & FedRAMP](/azure/compliance/offerings/offering-fedramp).

## Azure Local compliance obligations

Azure Local is a hybrid infrastructure solution that hosts and operates workloads on the edge; and deploys, manages, and operates at scale with Azure cloud services. Therefore, from the lens of compliance obligations, we can segment Azure Local integrated systems into two categories: cloud services and on-premises systems.

### On-premises solutions

As FedRAMP is designed for cloud service offerings (CSOs), the hardware device and operating system of Azure Local is not applicable for FedRAMP. Customers are responsible for the authorization package that covers the physical devices. Other standards, such as  [Federal Information Processing Standard (FIPS) 140](/azure-stack/hci/assurance/azure-stack-security-standards#federal-information-processing-standard-fips-140) and [Common Criteria (CC)](/azure-stack/hci/assurance/azure-stack-security-standards#common-criteria-for-information-technology-security-evaluation-cc), are applicable to on-premises which may be useful for your accreditation processes.

### Connected cloud services

For cloud services that support Azure Local infrastructure and workloads on site, Azure has a rich portfolio of FedRAMP accreditation which you can utilize to support your compliance journey. Below are some commonly used cloud services for deploying, operating, and managing Azure Local which are in scope for the Azure FedRAMP High P-ATO.

- Azure Arc-enabled Kubernetes
- Azure Arc-enabled servers
- Azure Backup
- Azure Key Vault
- Azure Monitor
- Azure Policy
- Azure Site Recovery
- Azure Resource Manager
- Azure Virtual Desktop
- Microsoft Entra ID

To learn more about other services in scope, refer to [Azure and other Microsoft cloud services compliance scope](/azure/azure-government/compliance/azure-services-in-fedramp-auditscope).
