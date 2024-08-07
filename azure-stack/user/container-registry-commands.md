---
title: Azure Container Registries supported commands 
description: Review the list of supported commands for CLI and PowerShell for Azure Container Registries on Azure Stack Hub.
author: sethmanheim
ms.topic: reference
ms.date: 07/25/2024
ms.author: sethm
ms.reviewer: dgarrity
ms.lastreviewed: 04/10/2024

# Intent: As an Azure Stack Hub user, I want to know about the supported commands for Azure Container Registries on Azure Stack Hub so that I can manage my container images and artifacts.

---

# Azure Container Registry supported commands on Azure Stack Hub

Azure Container Registry on Azure Stack Hub supports a subset of the global Azure features. For more information, see the [overview](container-registry-overview.md).

## Supported Azure Container Registry CLI commands

| Command | Description |
|---|---|
| `az acr check-health` | Gets health information on the environment and optionally a target registry. |
| `az acr check-name` | Checks if an Azure Container Registry name is valid and available for use. |
| `az acr create` | Creates an Azure Container Registry instance. |
| `az acr credential renew` | Regenerates login credentials for an Azure Container Registry instance. |
| `az acr credential show` | Gets the login credentials for an Azure Container Registry instance. |
| `az acr delete` | Deletes an Azure Container Registry instance. |
| `az acr import` | Imports an image to an Azure Container Registry from another Container Registry. Import removes the need to docker pull, docker tag, docker push. |
| `az acr list` | Lists all the container registries under the current subscription. |
| `az acr login` | Logs in to an Azure Container Registry through the Docker CLI. |
| `az acr manifest list-metadata` | Lists manifests of a repository in an Azure Container Registry. |
| `az acr repository delete` | Deletes a repository or image in an Azure Container Registry. |
| `az acr repository list` | Lists repositories in an Azure Container Registry. |
| `az acr repository show` | Gets the attributes of a repository or image in an Azure Container Registry. |
| `az acr repository show-tags` | Shows tags for a repository in an Azure Container Registry. |
| `az acr repository untag` | Untags an image in an Azure Container Registry. |
| `az acr repository update` | Updates the attributes of a repository or image in an Azure Container Registry. |
| `az acr show` | Gets the details of an Azure Container Registry. |
| `az acr show-usage` | Gets the storage usage for an Azure Container Registry. |
| `az acr update` | Updates an Azure Container Registry. |
| `az acr webhook create` | Creates a webhook for an Azure Container Registry. |
| `az acr webhook delete` | Deletes a webhook from an Azure Container Registry. |
| `az acr webhook get-config` | Gets the service URI and custom headers for the webhook. |
| `az acr webhook list` | Lists all of the webhooks for an Azure Container Registry. |
| `az acr webhook list-events` | Lists recent events for a webhook. |
| `az acr webhook ping` | Triggers a ping event for a webhook. |
| `az acr webhook show` | Gets the details of a webhook. |
| `az acr webhook update` | Updates a webhook. |

### Unsupported optional parameters

Some supported commands have optional parameters that are not supported on Azure Stack Hub. The unsupported parameters are as follows:

`az acr create`
- `--allow-trusted-services`  
- `--default-action`  
- `--identity`  
- `--key-encryption-key`  
- `--public-network-enabled`  
- `--workspace`  
- `--zone-redundancy`  

`az acr update`
- `--allow-trusted-services`
- `--anonymous-pull-enabled`
- `--data-endpoint-enabled`
- `--default-action`
- `--public-network-enabled`
- `--sku`

## Supported Azure Container Registry PowerShell commands

| Command | Description |
|---|---|
| [Connect-AzContainerRegistry](/powershell/module/az.containerregistry/connect-azcontainerregistry)                           | Log in to an Azure container registry.                                     |
| [Get-AzContainerRegistry](/powershell/module/az.containerregistry/get-azcontainerregistry)                                   | Gets a container registry.                                                |
| [Get-AzContainerRegistryCredential](/powershell/module/az.containerregistry/get-azcontainerregistrycredential)               | Gets the login credentials for a container registry.                      |
| [Get-AzContainerRegistryManifest](/powershell/module/az.containerregistry/get-azcontainerregistrymanifest)                   | Get or list ACR manifest.                                                 |
| [Get-AzContainerRegistryRepository](/powershell/module/az.containerregistry/get-azcontainerregistryrepository)               | Get or list ACR repositories.                                             |
| [Get-AzContainerRegistryTag](/powershell/module/az.containerregistry/get-azcontainerregistrytag)                             | Get or list ACR tag.                                                      |
| [Get-AzContainerRegistryUsage](/powershell/module/az.containerregistry/get-azcontainerregistryusage)                         | Get Usage of an Azure container registry.                                 |
| [Get-AzContainerRegistryWebhook](/powershell/module/az.containerregistry/get-azcontainerregistrywebhook)                     | Gets a container registry webhook.                                        |
| [Get-AzContainerRegistryWebhookEvent](/powershell/module/az.containerregistry/get-azcontainerregistrywebhookevent)           | Gets events of a container registry webhook.                              |
| [Import-AzContainerRegistryImage](/powershell/module/az.containerregistry/import-azcontainerregistryimage)                   | Import image from a global Azure registry to an Azure container registry. |
| [New-AzContainerRegistry](/powershell/module/az.containerregistry/new-azcontainerregistry)                                   | Creates a container registry.                                             |
| [New-AzContainerRegistryWebhook](/powershell/module/az.containerregistry/new-azcontainerregistrywebhook)                     | Creates a container registry webhook.                                     |
| [Remove-AzContainerRegistry](/powershell/module/az.containerregistry/remove-azcontainerregistry)                             | Removes a container registry.                                             |
| [Remove-AzContainerRegistryManifest](/powershell/module/az.containerregistry/remove-azcontainerregistrymanifest)             | Delete ACR manifest.                                                      |
| [Remove-AzContainerRegistryRepository](/powershell/module/az.containerregistry/remove-azcontainerregistryrepository)         | Delete repository from ACR.                                               |
| [Remove-AzContainerRegistryTag](/powershell/module/az.containerregistry/remove-azcontainerregistrytag)                       | Untag ACR tag.                                                            |
| [Remove-AzContainerRegistryWebhook](/powershell/module/az.containerregistry/remove-azcontainerregistrywebhook)               | Removes a container registry webhook.                                     |
| [Test-AzContainerRegistryNameAvailability](/powershell/module/az.containerregistry/test-azcontainerregistrynameavailability) | Checks the availability of a container registry name.                     |
| [Test-AzContainerRegistryWebhook](/powershell/module/az.containerregistry/test-azcontainerregistrywebhook)                   | Triggers a webhook ping event.                                            |
| [Update-AzContainerRegistry](/powershell/module/az.containerregistry/update-azcontainerregistry)                             | Updates a container registry.                                             |
| [Update-AzContainerRegistryCredential](/powershell/module/az.containerregistry/update-azcontainerregistrycredential)         | Regenerates a login credential for a container registry.                  |
| [Update-AzContainerRegistryManifest](/powershell/module/az.containerregistry/update-azcontainerregistrymanifest)             | Update ACR manifest.                                                      |
| [Update-AzContainerRegistryRepository](/powershell/module/az.containerregistry/update-azcontainerregistryrepository)         | Update ACR repository.                                                    |
| [Update-AzContainerRegistryTag](/powershell/module/az.containerregistry/update-azcontainerregistrytag)                       | Update ACR tag.                                                           |
| [Update-AzContainerRegistryWebhook](/powershell/module/az.containerregistry/update-azcontainerregistrywebhook)               | Updates a container registry webhook.                                     |

## Next steps

Learn more about [Azure Container Registry on Azure Stack Hub](container-registry-overview.md)
