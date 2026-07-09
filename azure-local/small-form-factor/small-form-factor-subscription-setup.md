---
title: Set Up Your Azure Subscription for Small Form Factor Deployments of Azure Local (preview)
description: Set up your Azure subscription for small form factor deployments of Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.date: 05/04/2026
ms.topic: how-to
ms.service: azure-local
ms.subservice: small-form-factor
---

# Set up your Azure subscription for small form factor deployments of Azure Local (preview)

This article explains how to prepare your Azure subscription before deploying Azure Local on small form factor hardware.

You’ll register required features and resource providers, verify permissions, and confirm your directory and subscription settings.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Register the machine provisioning feature

Register the Azure Local zero-touch provisioning (ZTP) feature by running the following Azure CLI command:

```azurecli
az feature register --subscription <SUBSCRIPTION_ID> --namespace Microsoft.DeviceOnboarding --name AzureLocalZTP
```

## Register the required resource providers

Your subscription must have the following resource providers registered. Some providers are only needed for specific use cases.

| Resource provider | Necessary for | Resources provided |
| ----------------- | --- | ------------------ |
| `Microsoft.Edge` | All use cases | [Site, site configuration](/azure/templates/microsoft.edge/sites?pivots=deployment-language-bicep) |
| `Microsoft.AzureStackHCI` | All use cases | [Edge machine (also known as provisioned machine)](/azure/templates/microsoft.azurestackhci/edgemachines?pivots=deployment-language-bicep) |
| `Microsoft.HybridCompute` | All use cases | [Arc-connected machines in the managed resource group](/azure/templates/microsoft.hybridcompute/machines?pivots=deployment-language-bicep) |
| `Microsoft.Compute` | All use cases | [VM resources](https://learn.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines?pivots=deployment-language-bicep) |
| `Microsoft.GuestConfiguration` | All use cases | [Guest configuration assignments in the managed resource group](/azure/templates/microsoft.guestconfiguration/guestconfigurationassignments?pivots=deployment-language-bicep) |
| `Microsoft.HybridConnectivity` | All use cases | [Connectivity endpoints for Arc-connected machines](/azure/templates/microsoft.hybridconnectivity/endpoints?pivots=deployment-language-bicep) |
| `Microsoft.KeyVault` | All use cases | [Key vault for managing secrets](/azure/templates/microsoft.keyvault/vaults?pivots=deployment-language-bicep) |
| `Microsoft.Storage` | All use cases | [Storage account for holding ownership vouchers](/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep) |
| `Microsoft.Kubernetes` | Arc-enabled K3s | [Arc-connected cluster resources](/azure/templates/microsoft.kubernetes/connectedclusters?pivots=deployment-language-bicep) |
| `Microsoft.KubernetesConfiguration` | Arc-enabled K3s | [Configuration](/azure/templates/microsoft.kubernetesconfiguration/fluxconfigurations?pivots=deployment-language-bicep) and [extension](/azure/templates/microsoft.kubernetesconfiguration/extensions?pivots=deployment-language-bicep) resources |
| `Microsoft.ExtendedLocation` | Azure IoT Operations and/or AKS Arc | [Custom location and extended location resources](/azure/templates/microsoft.extendedlocation/customlocations?pivots=deployment-language-bicep) |
| `Microsoft.HybridContainerService` | AKS Arc | [Hybrid container service resources](/azure/templates/microsoft.hybridcontainerservice/provisionedclusters?pivots=deployment-language-bicep) |

To register a resource provider, run:

```azurecli
az provider register --namespace <RESOURCE_PROVIDER_NAME>
```

You can also register resource providers in the Azure portal. For step-by-step guidance, see [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider-1).

## Check subscription permissions

1. Go to the [Azure portal](https://portal.azure.com).
1. Search for and select your subscription.
1. In the subscription menu, select **Access control (IAM)**.
1. Verify that you have one of the following role combinations:
   - **Owner**
   - **Contributor** and **Role Based Access Control Administrator**
1. Confirm that the role assignment is both **Active** and **Permanent**.

> [!IMPORTANT]
> If your role assignment isn’t active and permanent, you might need to temporarily elevate your permissions before running deployment commands. These permissions must apply to the resource group where you’ll provision machines.

## Check directory and subscription settings

1. In the Azure portal, select **Settings** > **Directories + subscriptions**.
1. If you have more than one directory, select the directory you’re using for this deployment.
1. Make sure your default subscription filter includes the subscription you’re using for testing.

For more information, see:

- [Set subscription filters](/azure/azure-portal/set-preferences#subscription-filters)
- [Manage directories and subscriptions](/azure/azure-portal/set-preferences#directories--subscriptions)

## Prepare a Microsoft Entra ID security group

During machine provisioning, Azure uses a Microsoft Entra ID security group to authorize access to the provisioned machine and related Arc resources.

Before you start, identify or create an Entra ID security group that contains the users who need to manage, connect to, or troubleshoot the machines in this preview.

1. In the Azure portal, search for and select **Microsoft Entra ID**.
1. Select **Groups**.
1. Create a new security group, or choose an existing security group that you use for preview operators.
1. Add the users who need access to manage or connect to provisioned machines.
1. Keep the group name available for later provisioning steps.

> [!TIP]
> You can reuse an existing security group if it contains the right set of operators for your test environment. Avoid using broad groups unless everyone in the group should have access to the preview resources.

## Review your setup

Before you continue, confirm that:

- The machine provisioning feature is registered.
- All required resource providers are registered.
- You identified a Microsoft Entra ID security group for machine operators.
- Your directory and subscription settings are correct.

## Next steps

- If you have supported hardware, continue to [Machine installation](small-form-factor-installation.md).
