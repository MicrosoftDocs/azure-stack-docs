---
title:  Migrate from Azure App Service on Azure Stack Hub to Azure App Service
description: How to migrate to Azure App Service from Azure App Service on Azure Stack Hub
author: apwestgarth
ms.topic: upgrade-and-migration-article
ms.date: 07/13/2026
ms.author: anwestg
ms.reviewer: anwestg
ms.custom: sfi-image-nochange

---

# Migrate from Azure App Service on Azure Stack Hub to Azure App Service

After reviewing the [benefits of migration](app-service-benefits-migrate-to-azure.md) and [planning your migration](app-service-planning-migrate-to-azure.md) to Azure App Service from Azure App Service on Azure Stack Hub, it's time to focus on how to migrate.

## Choose a migration landing zone

While planning your migration you will have identified your applications and chosen a migration landing zone for each application:

### Azure App Service

Choose [Azure App Service](/azure/app-service/overview) when:

- Applications are cloud-ready.
- Minimal operating system dependencies exist.
- The application can run within Azure App Service sandbox constraints.

### Managed Instance on Azure App Service

Choose [Managed Instance on Azure App Service](/azure/app-service/overview-managed-instance) when:

- Applications require registry access.
- Applications depend on COM components.
- Applications require custom runtimes.
- Applications rely on Windows-specific capabilities not available in standard App Service.
- The objective is rapid migration with minimal code changes.

Managed Instance on Azure App Service is designed to provide a lift-and-modernize path for complex Windows applications while retaining the benefits of a managed PaaS platform.

## Create the Azure environment

### Step 1: Create resource groups

Create resource groups for:

- Production
- Non-production
- Shared services

### Step 2: Configure networking

Create the required networking resources:

- Virtual Networks
- Subnets
- Private Endpoints
- DNS zones
- VPN or ExpressRoute connectivity

### Step 3: Provision App Service infrastructure

Provision:

- [App Service Plans](/azure/app-service/overview-hosting-plans)
- [Managed Instance App Service resources](/azure/app-service/quickstart-managed-instance) (if required)
- [App Service Environments](/azure/app-service/environment/overview) (if required)

### Step 4: Configure supporting services

Create and configure:

- Azure SQL Database or Azure SQL Managed Instance
- Azure Storage
- Azure Key Vault
- Application Insights
- Azure Monitor

---

## Migrate application code

### Option 1: Source-code deployment

Deploy applications using:

- [GitHub Actions](/azure/app-service/deploy-github-actions)
- [Azure Pipelines](/azure/app-service/deploy-azure-pipelines)
- Visual Studio publishing
- [ZIP deployment](/azure/app-service/deploy-zip)

These approaches are recommended for modern applications that already have access to source code.

### Option 2: Lift-and-modernize

For complex IIS applications:

1. Assess the application.
2. Identify dependencies.
3. Create Managed Instance resources.
4. Deploy using source-code deployment, FTP or Web Deploy.
5. Validate functionality.

This approach minimizes application changes while moving workloads to Azure App Service. 

---

## Migrate application configuration

Review and migrate the following settings.

### Application settings

- Connection strings
- API keys
- Environment variables

### Authentication

Implement authentication using:

- Microsoft Entra ID
- Managed identities
- OAuth or OpenID Connect providers

### Secrets management

Store secrets in:

- Azure Key Vault

### Certificates

Import and validate:

- TLS certificates
- Custom domain certificates

---

## Migrate data

### Databases

Recommended targets include:

- Azure SQL Database
- Azure SQL Managed Instance
- SQL Server on Azure Virtual Machines

Validate:

- Database compatibility
- Connection strings
- Firewall and networking rules

### File storage

Replace Azure Stack Hub file-share dependencies with:

- Azure Files
- Azure Blob Storage

### Backup and recovery

Configure:

- Database backups
- Storage redundancy
- Geo-recovery policies

---

## Validate the migrated application

### Functional validation

Verify:

- Authentication and sign-in experiences
- Business workflows
- Data operations
- API integrations

### Performance validation

Verify:

- Load characteristics
- Scaling behavior
- Startup performance

### Security validation

Verify:

- Authentication
- Authorization
- Certificate configuration
- Network access controls

---

## Perform production cutover

### Recommended approach

1. Deploy the application to Azure.
2. Complete validation testing.
3. Synchronize final data changes.
4. Freeze changes to the Azure Stack Hub deployment.
5. Update DNS records.
6. Monitor production traffic.
7. Retain rollback options until migration validation is complete.

Using deployment slots is recommended to reduce deployment risk and provide rollback capabilities during cutover.

---

## Post-migration activities

After migration:

- Enable Application Insights.
- Configure Azure Monitor alerts.
- Enable automatic scale or autoscale by rules.
- Configure backup policies.
- Review cost optimization opportunities.
- Review security recommendations.
- Implement CI/CD pipelines.
- Enable managed identities where applicable.

---

## Migration checklist

### Assessment

[ ] Inventory all applications.
[ ] Document application dependencies.
[ ] Assess compatibility with Azure App Service.
[ ] Select the appropriate Azure target service.

### Planning

[ ] Design the Azure landing zone.
[ ] Design networking requirements.
[ ] Define migration waves.
[ ] Define rollback procedures.

### Migration

[ ] Provision Azure resources.
[ ] Migrate application code.
[ ] Migrate databases.
[ ] Migrate certificates.
[ ] Migrate application settings and configuration.

### Validation

[ ] Complete functional testing.
[ ] Complete performance testing.
[ ] Complete security testing.
[ ] Obtain business sign-off.

### Cutover

[ ] Update DNS records.
[ ] Validate production workloads.
[ ] Enable monitoring and alerting.
[ ] Retire the Azure Stack Hub deployment.

---

## Next steps

After successfully migrating to Azure App Service, consider adopting additional platform capabilities such as:

- [Deployment slots](/azure/app-service/deploy-best-practices#use-deployment-slots)
- [Managed identities](/azure/app-service/overview-security#identity-and-access-management)
- [App Service Environment](/azure/app-service/environment/overview)
- [Azure AI integration](/azure/app-service/overview-ai-integration)
- [GitHub Actions](/azure/app-service/deploy-github-actions) and [Azure Pipelines](/azure/app-service/deploy-azure-pipelines)
- [Managed Instance on Azure App Service](/azure/app-service/overview-managed-instance)
- [Autoscaling](/azure/app-service/manage-automatic-scaling) and [advanced monitoring](/azure/app-service/monitor-app-service)

These capabilities can help further modernize applications, reduce operational overhead, and accelerate cloud-native adoption.