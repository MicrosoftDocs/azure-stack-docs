---
title: PowerShell cmdlets for Azure Container Registry on Azure Stack Hub 
description: Find the cmdlets for use with the Azure Container Registry on Azure Stack Hub.
author: mattbriggs
ms.topic: reference
ms.date: 08/20/2021
ms.author: mabrigg
ms.reviewer: chasat
ms.lastreviewed: 08/20/2021

# Intent: As an Azure Stack user, I want to XXX so I can XXX.
# Keyword: XXX

---

# PowerShell cmdlets for Azure Container Registry on Azure Stack Hub

To use the Azure Container Registry cmdlets for use with the registry and with the Azure Kubernetes Service (AKS) on Azure Stack Hub, you will need to install the most recent Az AzureStack module for Azure Stack Hub. You can find the instructions in [Install PowerShell Az module for Azure Stack Hub](powershell-install-az-module.md).

## Azs.ContainerRegistry.Admin

The following table lists common actions that you can perform with the PowerShell cmdlets in the Azs.ContainerRegistry.Admin module installed with the PowerShell Az module for Azure Stack Hub. 

|     PowerShell cmdlet   | Description |
|------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
|     Start-AzsContainerRegistrySetup            |     Start the Container Registry service setup process.                                                               |
|     Get-AzsContainerRegistrySetupStatus        |     Return the current status of the Container Registry service setup process.                                        |
|     Set-AzsContainerRegistryConfiguration      |     Set the maximum storage capacity used for container registries in GB.                                             |
|     Get-AzsContainerRegistryConfiguration      |     Return the current storage capacity used for container registries configuration value in GB.                      |
|     Get-AzsContainerRegistryCapacity           |     Return the current storage capacity used by all container registries in GB.                                       |
|     New-AzsContainerRegistryQuota              |     Create a new quota for Container Registry service.                                                                |
|     Set-AzsContainerRegistryQuota              |     Update a Container Registry quota.                                                                                |
|     Get-AzsContainerRegistryQuota              |     Return a list of Container Registry quotas (no arguments) or details of a specified container registry quota.     |
|     Remove-AzsContainerRegistryQuota           |     Delete an existing Container Registry quota.                                                                      |
|     Get-AzsContainerService                    |     Returns list of AKS clusters deployed in the system. Each cluster in the list contains the following attributes: `CreationDate`, `ID`, `Location`, `Name`, `OrchestratorVersion`, `PropertiesId`, `PropertiesName`, `ProvisioningState`, `SubscriptionId`, `Type`. |

You can find the reference documentation for the Az module for Azure Stack Hub at [Azure Stack Hub Module](/powershell/azure/azure-stack/overview).
v
## Next steps

[Azure Container Registries on Azure Stack Hub overview](container-registries-overview.md)

