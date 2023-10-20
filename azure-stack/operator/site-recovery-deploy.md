---
title: Deploy virtual machines in Azure Site Recovery on Azure Stack Hub (preview)
description: Learn how to deploy virtual machines in Azure Site Recovery on Azure Stack Hub. 
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 05/05/2023
---


# Deployment overview (preview)

> [!IMPORTANT]
> During the public preview of Azure Site Recovery on Azure Stack Hub, updates might require a complete re-installation (a complete removal and then re-add) of the service.

To enable replication of virtual machines (VMs) across two Azure Stack Hub environments, you must configure the following environments:

- The **source** environment. The Azure Stack Hub environment in which user VMs (the actual workloads you want to protect) are running.
- The **target** environment. The environment in which the Azure Site Recovery resource provider and dependencies run.

  :::image type="content" source="media/site-recovery-deploy/target-source.png" alt-text="Diagram showing target and source architecture." lightbox="media/site-recovery-deploy/target-source.png":::
  
During the public preview, Microsoft will release several versions for both the service RPs and the extensions. The following is the complete list of currently available images:

| Service                                   | Image name                                                          | Image version       |
| :---------------------------------- | :------------------------------------------------------------- | :------------- |
| [target] ASR RP                    | Microsoft.SiteRecovery                                        | 1.2301.2216.2287 |
| [target] ASR DependencyService     | microsoft.servicebus                                          | 1.2210.4.0    |
| [source] Appliance VM              | microsoft.asrazsappliance                                     | 1.8.7         |
| [source] Extension (Windows)       | microsoft.azure-recoveryservices-siterecovery-windows         | 1.1.31.388    |
| [source] Extension (Linux general) | microsoft.azure-recoveryservices-siterecovery-linux           | 1.0.31.559    |
| [source] Extension (RHEL 6)        | microsoft.azure-recoveryservices-siterecovery-linuxRHEL6      | 1.0.31.559    |
| [source] Extension (RHEL 7)        | microsoft.azure-recoveryservices-siterecovery-linuxRHEL7      | 1.0.31.559    |
| [source] Extension (RHEL 8)        | microsoft.azure-recoveryservices-siterecovery-linuxRHEL8      | 1.0.31.559    |
| [source] Extension (Debian 8)      | microsoft.azure-recoveryservices-siterecovery-linuxdebian8    | 1.0.31.559    |
| [source] Extension (Debian 9)      | microsoft.azure-recoveryservices-siterecovery-linuxDEBIAN9    | 1.0.31.559    |
| [source] Extension (Debian 10)     | microsoft.azure-recoveryservices-siterecovery-linuxdebian10   | 1.0.31.559    |
| [source] Extension (Debian 11)     | microsoft.azure-recoveryservices-siterecovery-linuxdebian11   | 1.0.31.559    |
| [source] Extension (Ubuntu 1604)   | microsoft.azure-recoveryservices-siterecovery-linuxubuntu1604 | 1.0.31.559    |
| [source] Extension (Ubuntu 1804)   | microsoft.azure-recoveryservices-siterecovery-linuxUBUNTU1804 | 1.0.31.559    |
| [source] Extension (Ubuntu 1404)   | microsoft.azure-recoveryservices-siterecovery-linuxUBUNTU1404 | 1.0.31.559    |
| [source] Extension (OL7)           | microsoft.azure-recoveryservices-siterecovery-linuxOL7        | 1.0.31.559    |
| [source] Extension (OL8)           | microsoft.azure-recoveryservices-siterecovery-linuxOL8        | 1.0.31.559    |
| [source] Extension (SLES 12)       | microsoft.azure-recoveryservices-siterecovery-linuxSLES12     | 1.0.31.559    |
| [source] Extension (SLES 15)       | microsoft.azure-recoveryservices-siterecovery-linuxSLES15     | 1.0.31.559    |

The process to install Azure Site Recovery includes actions from both the Azure Stack Hub operator and the Azure Stack Hub user:

## Operators

Operators must perform the following steps:

- Ensure that required networking requirements are in place for both **source** and **target** environments.
- Source: prepare the environment.
  - Download the **Azure Site Recovery appliance on AzureStack Hub** VM image and the respective **Azure Site Recovery – extensions** in the Azure Stack Hub Marketplace Management.
  - Ensure that Azure Stack Hub users can deploy the **ASR appliance on AzureStack Hub** VM image in their respective Azure Stack Hub user subscriptions (where the VM workloads run).
- Target: prepare the environment by installing Site Recovery services and dependencies, ensuring the right quotas are assigned to the respective plans and offers where Site Recovery will be used.

## Users

Users must perform the following steps:

- Source:
  - Deploy the **Azure Site Recovery appliance on AzureStack Hub** VM image in the Azure Stack Hub user subscription.
  - The user must have owner rights on each Azure Stack Hub user subscription in which they protect VM workloads.
- Target:
  - Deploy the Azure Site Recovery Vault.
  - Create the protection policies and enable the protection of the workloads.

## Networking requirements

Because the source and target Azure Stack Hubs might be in different datacenters, regions, or security boundaries, the Azure Stack Hub operator must make sure the networking connectivity is in place and configured in order for the Azure Site Recovery services to function:

- Name resolution
  - The Azure Site Recovery appliance running on the **source** Azure Stack Hub instance must be able to resolve the FQDN of the **target** Azure Stack Hub instance.
- The Azure Site Recovery appliance running on the **source** Azure Stack Hub instance should be able to access the following ports on the source site:
  - (When in use) Microsoft Entra ID: *.microsoftonline.com:443
  - (When in use) AD FS: adfs.< external-FQDN >:443
  - Azure Resource Manager: management.< external-FQDN >:443
- The Azure Site Recovery appliance must be able to access the following ports of the **target** Azure Stack Hub instance:
  - (When in use) Microsoft Entra ID: *.microsoftonline.com:443
  - (When in use) AD FS: adfs.< external-FQDN >:443
  - Azure Resource Manager: management.< external-FQDN >:443
  - Blob: *.blob.< external-FQDN >:443
  - Azure Site Recovery: rp.asr.< external-FQDN >:8478,8479,44307


## Next steps

For more information about configuring the source and target environments, see the following articles:

- [Deploy for source environments](site-recovery-deploy-source.md)
- [Deploy for target environments](site-recovery-deploy-target.md)
- Check the [Known issues](known-issues.md).
