---
title: Modular Data Center  overview | 
description: The Modular Data Center  is a portable, rapidly deployable datacenter appropriate for supporting large-scale combat operations in temporary and fixed command posts.
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: overview
ms.date: 01/13/2020
ms.reviewer: prchint
ms.lastreviewed: 01/13/2020
---

# Modular Data Center overview 

The Modular Data Center (MDC) is based on Azure Stack Hub. The MDC is a portable, rapidly deployable datacenter appropriate for supporting large-scale combat operations in temporary and fixed command posts.

Azure Stack Hub is a horizontally and vertically scalable solution that provides multi-tenant, native hybrid cloud capabilities for IaaS and PaaS services to environments at the edge and supports a variety of modular scenarios for temporary and fixed command posts and expeditionary forces. Azure Stack Hub is an integrated hardware and software appliance that is commercially available in a variety of capacities based on scaling through node scale-units and is available with extensions, including General Purpose Graphics Processing Unit (GPU) enabled configurations and expandable external storage.

## How you can use the MDC

Azure Stack delivers on four core principles that are consistent with and extend Azure's capabilities for modular edge scenarios. 

### Develop and deliver apps with a common DevOps model including API symmetry with Azure

The consistency between Azure and Azure Stack means solutions for the war fighter are developed once, deployed to support a variety of use cases, and secured and sustained using a common set of tools like Azure Key Vault for key management and Azure Monitor for resource monitoring and management. Azure Stack is interoperable with on-premises data, apps, and tools for DevOps and secure operations, for example, key management.

### Deliver Azure services on-premises

Azure Stack runs in disadvantaged (contested, congested, or denied) communications environments as well as robust communications environments and isn't dependent on connectivity to Azure to execute mission apps and enable local operations. 

### Use Integrated hardware and software delivery experience

The modular edge requires a range of capabilities that provide not only baseline compute and storage services but also advanced capability for machine learning, AI, and analytics. The ability to connect to your secure cloud from the modular edge when able, or conversely, to operate independently from it in austere environments, is critical to provide war fighters access to data needed for decisions.

### Keep your datacenter secure and available with hybrid cloud security operations

The cloud native design of Azure Stack removes the operational complexities of traditional virtualization environments by allowing administrators to choose when to patch and orchestrating the entire operation through the installation process and the Azure Stack management fabric built natively into the system.

Remote assisted administration by Microsoft or a Microsoft-managed offering in the field for Azure Stack devices can be enabled by providing users with the appropriate access through RBAC to perform actions through the administrative portal, privileged management endpoint or command-line interface. This enables all patching and other administrative and monitoring activities to be performed by Microsoft. Azure Stack is field upgradable and updateable through secure administration portal or Command-Line Interface (CLI) commands that both apply security updates and IaaS and PaaS feature updates to maintain commercial parity with Azure where appropriate from local or remote networks. 

## Benefits of using the MDC

MDC supports a consistent environment with Azure in disadvantaged communications environments:
 - Static, modular, rapidly deployable data centers with Azure cloud services to power large analytics apps in Modular Operations Centers (TOC).
 - Azure's modular edge offerings maintain consistency between the cloud and the edge, through A singular approach for supporting IaaS primitives such as virtual machines, storage, and virtual networking
 - Azure Active Directory and role-based access control support
 - Common administrative interfaces
 - API symmetry and support for Microsoft, third party and open-source DevOps tools
 - Management and monitoring through Azure Log Analytics and Azure Security Center
 - Bring the agility of cloud computing to your on-premises environment and the edge, by enabling a hybrid cloud.<br>You can:
     - Reuse code and run cloud-native apps consistently across Azure and your on-premises environments.
     - Run traditional virtualized workloads with optional connections to Azure services.
     - Transfer data to the cloud, or keep it in your sovereign datacenter to maintain compliance.
     - Run hardware-accelerated machine-learning, containerized, or virtualized workloads, all at the intelligent edge.

## Next steps

[Azure Stack Hub capacity planning](../operator/azure-stack-capacity-planning-overview.md)
