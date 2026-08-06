---
title: Prepare to deploy Azure Local on small form factor devices (preview)
description: Learn about the deployment sequence and prepare your Azure subscription to deploy Azure Local on small form factor devices (preview).
author: sipastak
ms.author: sipastak
ms.date: 07/20/2026
ms.topic: how-to
ms.service: azure-local
ms.subservice: small-form-factor
---

# Prepare to deploy Azure Local on small form factor devices (preview)

This article provides an overview of the deployment process for small form factor deployments of Azure Local. It also explains how to prepare your Azure subscription by registering the required features and resource providers, verifying permissions, and confirming your directory and subscription settings.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Deployment sequence

Complete the following steps to deploy Azure Local on a small form factor device:

| Step | Description |
|--|--|
| 1. [Set up your Azure subscription](#set-up-your-azure-subscription) | Ensure that your subscription has the required features, resource providers, permissions, and Microsoft Entra ID security groups. |
| 2. [Install the maintenance environment on your hardware](./small-form-factor-installation.md) | Connect to your machine and image it with the maintenance environment. Prepare a USB drive with the maintenance environment image, and then boot from the USB drive to install the maintenance environment. The maintenance environment registers the machine with Azure and supports lifecycle operations. |
| 3. [Create a provisioned machine resource on Azure](./small-form-factor-connect-portal.md) | Create a provisioned machine resource in Azure. This resource is the Azure representation of the physical machine on your premises. |
| 4. [Wait for the machine to reach the Provisioned state](./small-form-factor-connect-portal.md#wait-for-the-machine-to-become-ready) | After the physical machine registers with Azure and associates with the provisioned machine resource, it downloads the selected operating system and boots into it. After the machine checks all required system configurations, its status changes to **Provisioned**. The machine is then ready for workloads. |
| 5. [Deploy your workloads](./small-form-factor-containerized-workloads.md) | Install your custom workloads, or install Azure workloads such as Azure IoT Operations or Foundry Local on the newly provisioned machine. |

## Set up your Azure subscription

### Register the machine provisioning feature

Register the Azure Local zero-touch provisioning (ZTP) feature by running the following Azure CLI command:

```azurecli
az feature register --subscription <SUBSCRIPTION_ID> --namespace Microsoft.DeviceOnboarding --name AzureLocalZTP
```

### Register the required resource providers

Your subscription must have the following resource providers registered. Some providers are necessary only for specific use cases.

| Resource provider | Necessary for | Resources provided |
| ----------------- | --- | ------------------ |
| `Microsoft.Edge` | All use cases | [Site, site configuration](/azure/templates/microsoft.edge/sites?pivots=deployment-language-bicep) |
| `Microsoft.AzureStackHCI` | All use cases | [Edge machine (also known as provisioned machine)](/azure/templates/microsoft.azurestackhci/edgemachines?pivots=deployment-language-bicep) |
| `Microsoft.HybridCompute` | All use cases | [Arc-connected machines in the managed resource group](/azure/templates/microsoft.hybridcompute/machines?pivots=deployment-language-bicep) |
| `Microsoft.Compute` | All use cases | [VM resources](/azure/templates/microsoft.compute/virtualmachines?pivots=deployment-language-bicep) |
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

### Check subscription permissions

1. Go to the [Azure portal](https://portal.azure.com).
1. Search for and select your subscription.
1. In the subscription menu, select **Access control (IAM)**.
1. Verify that you have one of the following role combinations:
   - **Owner**
   - **Contributor** and **Role Based Access Control Administrator**
1. Confirm that the role assignment is both **Active** and **Permanent**.
1. Verify that you have a tenant-level Microsoft Entra role. The minimum required role is **Directory Reader**. Higher-privileged roles, such as **Cloud Administrator**, also satisfy this requirement.

> [!IMPORTANT]
> If your role assignment isn't active and permanent, you might need to temporarily elevate your permissions before running deployment commands. These permissions must apply to the resource group where you'll provision machines.

### Check directory and subscription settings

1. In the Azure portal, select **Settings** > **Directories + subscriptions**.
1. If you have more than one directory, select the directory you're using for this deployment.
1. Make sure your default subscription filter includes the subscription you're using for testing.

For more information, see:

- [Set subscription filters](/azure/azure-portal/set-preferences#subscription-filters)
- [Manage directories and subscriptions](/azure/azure-portal/set-preferences#directories--subscriptions)

### Prepare a Microsoft Entra ID security group

During machine provisioning, Azure uses a Microsoft Entra ID security group to authorize access to the provisioned machine and related Arc resources.

Before you start, identify or create a Microsoft Entra ID security group that contains the users who need to manage, connect to, or troubleshoot the machines in this preview.

1. In the Azure portal, search for and select **Microsoft Entra ID**.
1. Select **Groups**.
1. Create a new security group, or choose an existing security group that you use for preview operators.
1. Add the users who need access to manage or connect to provisioned machines.
1. Keep the group name available for later provisioning steps.

> [!TIP]
> You can reuse an existing security group if it contains the right set of operators for your test environment. Avoid using broad groups unless everyone in the group should have access to the preview resources.

### Review your setup

Before you continue, confirm that:

- The machine provisioning feature is registered.
- All required resource providers are registered.
- You identified a Microsoft Entra ID security group for machine operators.
- Your directory and subscription settings are correct.

## Next step

> [!div class="nextstepaction"]
> [Install the maintenance environment on your hardware](./small-form-factor-installation.md)
