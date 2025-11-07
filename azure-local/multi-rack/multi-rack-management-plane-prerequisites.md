---
title: "Azure Local multi-rack deployments: Network Fabric Controller and Cluster Manager creation (Preview)"
description: Prepare to create the Azure Local multi-rack Network Fabric Controller and Cluster Manager (Preview).
author: sipastak
ms.author: sipastak
ms.service: azure-local
ms.date: 11/07/2025
ms.topic: conceptual
---

# Management plane prerequisites for Azure Local multi-rack deployments (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

To get started with Azure Local multi-rack deployments, you need to create a Network Fabric Controller (NFC) and then a Cluster Manager (CM) in your target Azure region.

Each NFC is associated with a CM in the same Azure region and your subscription.

You need to complete the prerequisites before you can deploy the first multi-rack NFC and CM pair.
In subsequent multi-rack deployments, you'll only need to create the NFC and CM after reaching the quota of supported multi-rack instances.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Install CLI extensions and sign into your Azure subscription

Install latest version of the necessary CLI extensions.

### Azure subscription sign-in

```azurecli
  az login
  az account set --subscription $SUBSCRIPTION_ID
  az account show
```

>[!NOTE]
>Your account must have permissions to read, write, and publish in the subscription.

## Resource provider registration

Ensure access to the necessary Azure resource providers for the Azure subscription for multi-rack resources. Register the following providers:

```Azure CLI
az provider register --namespace Microsoft.AzureArcData
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.ExtendedLocation
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
az provider register --namespace Microsoft.ResourceConnector
az provider register --namespace Microsoft.Resources
az provider register --namespace Microsoft.Storage
az provider register --namespace Microsoft.NexusIdentity
```

## EncryptionAtHost feature registration

You must enable the [EncryptionAtHost](/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli) feature for your subscription. Use the following steps to enable the feature for your subscription:

### Register the EncryptionAtHost feature

Execute the following command to register the feature for your subscription

```Azure CLI
az feature register --namespace Microsoft.Compute --name EncryptionAtHost
```

### Verify the registration state

Confirm that the registration state is `Registered` (registration might take a few minutes) using the following command before trying out the feature.

```Azure CLI
az feature show --namespace Microsoft.Compute --name EncryptionAtHost
```

### Register the resource provider

```Azure CLI
az provider register --namespace Microsoft.Compute
```

Ensure that the registration state is `Registered`.

## Dependent Azure resources setup

- Establish [ExpressRoute](/azure/expressroute/expressroute-introduction) connectivity from your on-premises network to an Azure region:
  - [Create and verify an ExpressRoute circuit](/azure/expressroute/expressroute-howto-circuit-portal-resource-manager) via the Azure portal.
  - In the ExpressRoute blade, ensure Circuit status indicates the status of the circuit on the Microsoft side. Provider status indicates if the circuit is provisioned or not provisioned on the service-provider side. For an ExpressRoute circuit to be operational, circuit status must be **Enabled**, and provider status must be **Provisioned**.
- Set up an Azure Key Vault to store encryption and security tokens, passwords, certificates, and API keys.
- Set up a Log Analytics workspace to store logs and analytics data for multi-rack subcomponents (Network Fabric, Cluster, etc.).
- Set up an Azure Storage account to store data objects for your resource in the Azure portal:
  - Azure Storage supports blobs and files accessible from anywhere in the world over HTTP or HTTPS.
  - This storage isn't for user or consumer data.