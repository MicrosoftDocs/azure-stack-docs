---
title: Prerequisites for multi-rack deployments of Azure Local (Preview)
description: Review the prerequisites for multi-rack deployments of Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.service: azure-local
ms.date: 11/14/2025
ms.topic: conceptual
---

# Prerequisites for multi-rack deployments of Azure Local (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes the prerequisites for multi-rack deployments of Azure Local.

To get started with Azure Local multi-rack deployments, create a Network Fabric Controller (NFC) and then a Cluster Manager (CM) in your target Azure region. Create these resources before you create the Azure Local multi-rack cluster.

Each NFC is associated with a CM in the same Azure region and your subscription.

You need to complete the prerequisites before you can deploy the first multi-rack NFC and CM pair.
In subsequent multi-rack deployments, you only need to create the NFC and CM after reaching the quota of supported multi-rack clusters.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Install CLI extensions and sign into your Azure subscription

- Install the latest versions of the required [CLI extensions](multi-rack-cli-extensions.md).

- Sign in to your Azure subscription by running the following command:

  ```azurecli
  az login
  az account set --subscription $SUBSCRIPTION_ID
  az account show
  ```

  > [!NOTE]
  > Your account must have permissions to read, write, and publish in the subscription.

## Register resource providers

Ensure access to the necessary Azure resource providers for the Azure subscription for multi-rack resources. Register the following resource providers:

```azurecli
az provider register --namespace Microsoft.AzureArcData
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.AzureStackHCI
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.ExtendedLocation
az provider register --namespace Microsoft.GuestConfiguration
az provider register --namespace Microsoft.HybridCompute
az provider register --namespace Microsoft.HybridConnectivity
az provider register --namespace Microsoft.HybridContainerService
az provider register --namespace Microsoft.HybridNetwork
az provider register --namespace Microsoft.Insights
az provider register --namespace Microsoft.Keyvault
az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.KubernetesConfiguration
az provider register --namespace Microsoft.ManagedIdentity
az provider register --namespace Microsoft.ManagedNetworkFabric
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.NetworkCloud
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.Relay
az provider register --namespace Microsoft.ResourceConnector
az provider register --namespace Microsoft.Resources
az provider register --namespace Microsoft.Storage
az provider register --namespace Microsoft.NexusIdentity
```

## EncryptionAtHost feature registration

You must enable the [EncryptionAtHost](/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli) feature for your subscription. Use the following steps to enable the feature for your subscription.

1. Register the EncryptionAtHost feature.

  Execute the following command to register the feature for your subscription:

  ```azurecli
  az feature register --namespace Microsoft.Compute --name EncryptionAtHost
  ```

1. Verify the registration state.

  Confirm that the registration state is `Registered` (registration might take a few minutes) by using the following command before trying out the feature:

  ```Azure CLI
  az feature show --namespace Microsoft.Compute --name EncryptionAtHost
  ```

1. Register the resource provider.

  ```Azure CLI
  az provider register --namespace Microsoft.Compute
  ```

1. Check that the registration state is `Registered`.

## Set up dependent Azure resources

Create and set up the following resources:

- Establish [ExpressRoute](/azure/expressroute/expressroute-introduction) connectivity from your on-premises network to an Azure region:
  - [Create and verify an ExpressRoute circuit](/azure/expressroute/expressroute-howto-circuit-portal-resource-manager) via the Azure portal.
  - In the ExpressRoute blade, ensure Circuit status indicates the status of the circuit on the Microsoft side. Provider status indicates if the circuit is provisioned or not provisioned on the service-provider side. For an ExpressRoute circuit to be operational, circuit status must be **Enabled**, and provider status must be **Provisioned**.
- Set up an Azure Key Vault to store encryption and security tokens, passwords, certificates, and API keys.
- Set up a Log Analytics workspace to store logs and analytics data for multi-rack subcomponents, such as Network Fabric and cluster.
- Set up an Azure Storage account to store data objects for your resource in the Azure portal.
- The Azure Key Vault, Log Analytics workspace, and storage account require a managed identity to be granted the appropriate permissions. Both user-assigned managed identities and system-assigned managed identities are supported.
  - If using user-assigned managed identities, the resources can be configured in advance for managed identity support.
  - For system-assigned managed identities, configuration must be done after multi-rack cluster creation.
- Ensure Azure VM SKU availability in the targeted zones are met for the subscription.
