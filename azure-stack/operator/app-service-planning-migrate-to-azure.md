---
title:  Plan a Migration to Azure App Service from Azure Stack Hub
description: Plan your migration from Azure App Service on Azure Stack Hub to Azure App Service in Azure
author: apwestgarth
ms.topic: upgrade-and-migration-article
ms.date: 07/13/2026
ms.author: anwestg
ms.reviewer: anwestg
ms.custom: sfi-image-nochange

---

# Plan migration to Azure App Service from Azure Stack Hub


To successfully migrate from Azure App Service on Azure Stack Hub to Azure App Service, start with a comprehensive assessment of your existing environment. Evaluate application architecture, platform dependencies, operational requirements, compliance constraints, and business objectives before selecting a migration strategy.

## Assess application suitability

Identify all applications hosted on Azure App Service on Azure Stack Hub and classify them according to complexity and criticality.

For each application, document:

- Application owners and stakeholders
- Business criticality
- Runtime and framework versions
- External service dependencies
- Authentication providers
- Network connectivity requirements
- Performance and scale requirements
- Availability and disaster recovery requirements

Applications with minimal dependencies might be suitable for direct migration. Applications that rely on platform-specific integrations or legacy infrastructure might require modernization activities before migration.

## Evaluate application dependencies

Many applications depend on services outside of App Service itself. Understanding these dependencies is critical to migration planning.

Assess:

- SQL Server databases
- File shares and storage systems
- Internal APIs
- Active Directory or Microsoft Entra ID integrations
- Message queues and event systems
- SMTP services
- Third-party services
- Monitoring and logging platforms

Determine whether dependencies:

- Remain on-premises
- Remain on Azure Stack Hub
- Are migrated to Azure
- Are replaced with Azure-native services

Applications with significant on-premises dependencies might require VPN, ExpressRoute, private endpoint, or hybrid networking configurations following migration.

## Evaluate hosting model options

Migration provides an opportunity to reassess how you host applications.

The recommended migration approach depends on application type and complexity.

| Application Type | Recommended Target |
|-----------------|-------------------|
| ASP.NET Core applications | Azure App Service (Windows or Linux) |
| Java applications | Azure App Service for Linux |
| Node.js applications | Azure App Service for Linux |
| Python applications | Azure App Service for Linux |
| PHP applications | Azure App Service for Linux |
| Existing Windows-based ASP.NET Framework applications | Azure App Service (Windows) |
| Applications with OS-level dependencies, COM components, registry dependencies, Windows Services, or custom runtimes | Managed Instance on Azure App Service |
| Containerized applications | Azure App Service Containers, Azure Container Apps, or Azure Kubernetes Service (AKS) |

Applications that previously required virtual machines due to significant Windows Server dependencies may be suitable candidates for Managed Instance on Azure App Service, which supports scenarios that traditionally blocked migration to App Service.  Managed Instance on Azure App Service reduces modernization effort and provides the operational capabilities of Azure App Service.

## Plan for networking changes

Networking architecture in Azure can differ significantly from Azure Stack Hub deployments.

Review requirements for:

- Private application access
- Inbound internet traffic
- Hybrid connectivity
- Internal DNS resolution
- Network isolation
- Regulatory requirements

Determine whether Azure networking capabilities such as:

- Virtual Network integration
- Private endpoints
- Azure Application Gateway
- Azure Front Door
- Azure Firewall

are required as part of the target architecture.

## Review identity and security requirements

When you migrate to Azure App Service, you get access to more identity and security capabilities. You might be able to simplify your existing security architectures.

Consider adopting:

- Microsoft Entra ID authentication
- Managed identities
- Azure Key Vault references
- Azure RBAC
- Private endpoints
- Conditional access policies
- Microsoft Defender for Cloud

Organizations should also review certificate management, secrets management, and compliance requirements before designing the target environment.

## Select an appropriate migration strategy

Different applications might need different migration approaches.

| Strategy | Description | Typical Use Case |
|-----------|-------------|------------------|
| Rehost | Move application with minimal modification | Modern applications already compatible with Azure App Service |
| Replatform | Update configuration or supporting services during migration | Applications requiring infrastructure modernization |
| Refactor | Modify application architecture to take advantage of Azure services | Strategic applications with long-term investment plans |
| Modernize | Rebuild portions of the application using cloud-native services | Applications requiring significant transformation |

Not every workload requires modernization during migration. Some organizations choose to migrate first, then modernize incrementally after the application is operating successfully in Azure.

## Validate regional deployment requirements

You can deploy Azure App Service across a broad range of Azure regions. By using multiple regions, your organization can improve latency, resiliency, and compliance outcomes compared to a single Azure Stack Hub deployment.

Evaluate:

- Data residency requirements
- User proximity
- Disaster recovery requirements
- Availability zone support
- Service availability by region

For business-critical workloads, consider multi-region or zone-redundant architectures where appropriate.

## Assess scale and capacity requirements

Migration should include a review of current and future growth requirements.

Document:

- Current instance counts
- Peak traffic patterns
- CPU and memory utilization
- Seasonal demand fluctuations
- Growth forecasts

This assessment helps determine the appropriate Azure App Service plan and whether advanced capabilities such as Premium v4 should be incorporated into the target architecture.

## Establish a migration approach and timeline

Define the following elements for your migration project:

- Migration waves
- Testing milestones
- Rollback procedures
- User acceptance criteria
- Production cutover plans

For large estates, use a phased migration approach:

1. Pilot applications
1. Non-production environments
1. Low-risk production applications
1. Business-critical production workloads

This approach helps your team gain operational experience with Azure App Service before migrating mission-critical applications.

## Define success criteria

Before migration begins, establish measurable success criteria.

Examples include:

- Successful deployment to Azure App Service
- No critical functionality regressions
- Performance equal to or better than the source environment
- Security and compliance validation completed
- Monitoring and alerting configured
- Operational runbooks updated

Clearly defined success criteria help ensure migration activities stay aligned with business objectives and reduce deployment risk.

> [!TIP]
> View migration as both a platform transition and a modernization opportunity. While you can often migrate applications with minimal changes, evaluating capabilities such as Linux hosting, Premium v4, private endpoints, managed identities, Azure Front Door, availability zones, and Managed Instance on Azure App Service can provide significant long-term operational and architectural benefits.

## Next steps

[Migrate to Azure App Service from Azure App Service on Azure Stack Hub](app-service-migrate-to-azure.md)