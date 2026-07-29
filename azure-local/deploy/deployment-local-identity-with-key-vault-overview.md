---
title: Overview of Azure Local Deployment Using Local Identity with Azure Key Vault
description: Learn about local identity with Azure Key Vault for Azure Local deployments, including benefits, supported tools, compatibility considerations, and supported services.
author: ronmiab
ms.topic: overview
ms.date: 07/21/2026
ms.author: robess
ms.service: azure-local
ms.custom: sfi-image-nochange
ms.subservice: hyperconverged
---

# Overview of Azure Local deployment using local identity with Azure Key Vault

::: moniker range=">=azloc-2510"

This article provides an overview of using local identity with Azure Key Vault for Azure Local deployments. It describes the benefits, supported tools and services, and compatibility considerations for environments that don't use Active Directory.

## Overview

In addition to Active Directory (AD) based deployment, Azure Local supports deployment through local identity with Azure Key Vault, previously known as AD-less deployment.

When you use local identity with a Local Administrator Account, the deployment process configures cluster-level integration with certificate-based authentication. This setup ensures secure communication during deployment and ongoing operations.

As part of this configuration, an Azure Key Vault in the Azure Cloud is provisioned during deployment to serve as a secure backup for Azure Local secrets, including BitLocker keys and other critical configuration data.

## Benefits

Using local identity with Key Vault on Azure Local offers several benefits, particularly for environments that don't rely on AD. Here are some key benefits:

- **Minimal edge infrastructure.** For environments that don't use AD, local identity with Key Vault provides a secure and efficient way to manage user identities and secrets.

- **Secret store.** Key Vault securely manages and stores secrets, such as BitLocker keys, node passwords, and other sensitive information. This reduces the risk of unauthorized access and enhances the overall security posture.

- **Maintain simplified management.** By integrating with Key Vault, organizations can streamline the management of secrets and credentials. This integration includes storing deployment and local identity secrets in a single vault, making it easier to manage and access these secrets.

- **Simplified deployment.** During the system deployment via the Azure portal, you can select a local identity provider integrated with Key Vault. This option streamlines the deployment process by ensuring all necessary secrets are securely stored within Key Vault. The deployment becomes more efficient by reducing dependencies on existing AD systems or other systems that run AD, which require ongoing maintenance. Additionally, this approach simplifies firewall configurations for Operational Technology networks, making it easier to manage and secure these environments.

## Tool compatibility in Azure Local environments configured with Azure Key Vault

Tooling support in Azure Local environments configured with Azure Key Vault for identity management varies across the ecosystem. Use the following guidance to plan and operate effectively in these configurations.

### Supported tools

- **PowerShell.** Fully supported for both AD and Azure Key Vault-based identity environments. PowerShell is the primary interface for managing and automating Azure Local clusters across identity configurations.

- **Azure Monitor.** Supported for monitoring the health and performance of hosts and virtual machines. Integration with Azure Monitor enables visibility into system health, alerts, and telemetry.

- **Azure portal.** Supported for managing Azure Local clusters.

### Unsupported or limited support tools

- **Windows Admin Center.** Not supported in Azure Key Vault-based identity environments. Use PowerShell or other supported tools for administrative tasks.
- **System Center Virtual Machine Manager (SCVMM).** Expected to have limited or no support in Azure Key Vault-based identity environments. Validate specific use cases before relying on SCVMM.

### Mixed compatibility

- **Microsoft Management Consoles (MMCs).** Compatibility varies. Tools such as Hyper-V Manager and Failover Cluster Manager might not be functional in all scenarios. Test critical workflows before relying on MMCs for production use.

### Generally available or supported services

- [Rack aware clustering](../concepts/rack-aware-cluster-overview.md). Supports fault domain awareness and improved resiliency for Azure Local clusters configured with local identity and Azure Key Vault.
- [Azure Virtual Desktop (AVD)](/azure/virtual-desktop/deploy-azure-virtual-desktop?tabs=portal-standard%2Cportal-session-host-configuration%2Cportal&pivots=host-pool-standard). AVD workloads are supported on Azure Local clusters using local identity with Azure Key Vault, enabling secure virtual desktop deployments without a dependency on Active Directory.

### Third-party compatibility

Commvault is a third‑party data protection and backup solution that's compatible with Azure Local deployments using local identity and Azure Key Vault. In supported scenarios, you can use Commvault for backup and recovery without requiring a dependency on Active Directory.

## Next steps

- [Deploy Azure Local using local identity with Azure Key Vault](./deployment-local-identity-with-key-vault-template.md).
- [Get support for Azure Local deployment issues](../manage/get-support-for-deployment-issues.md).

::: moniker-end

::: moniker range="<azloc-2510"

This feature is available only in Azure Local 2510 or later.

::: moniker-end
