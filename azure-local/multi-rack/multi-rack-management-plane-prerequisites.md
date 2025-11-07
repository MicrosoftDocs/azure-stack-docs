---
title: "Azure Local multi-rack deployments: Network Fabric Controller and Cluster Manager creation (Preview)"
description: Prepare to create the Azure Local multi-rack Network Fabric Controller and Cluster Manager (Preview).
author: sipastak
ms.author: sipastak
ms.service: azure-local
ms.date: 11/07/2025
ms.topic: conceptual
---

# Azure Local multi-rack management plane prerequisites

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

To get started with Azure Local multi-rack deployments, you need to create a Network Fabric Controller (NFC) and then a Cluster Manager (CM) in your target Azure region.

Each NFC is associated with a CM in the same Azure region and your subscription.

You need to complete the prerequisites before you can deploy the first multi-rack NFC and CM pair.
In subsequent multi-rack deployments, you'll only need to create the NFC and CM after reaching the [quota](../index.yml)<!--update link: (../../operator-nexus/reference-limits-and-quotas.md#network-fabric)--> of supported multi-rack instances.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Install CLI extensions and sign-in to your Azure subscription

Install latest version of the [necessary CLI extensions](../index.yml)<!--update link: (../../operator-nexus/howto-install-cli-extensions.md)-->.

### Azure subscription sign-in

```azurecli
  az login
  az account set --subscription $SUBSCRIPTION_ID
  az account show
```

>[!NOTE]
>Your account must have permissions to read/write/publish in the subscription.

## Resource provider registration

Ensure access to the necessary Azure Resource Providers for the Azure Subscription for multi-rack resources. Register the following providers:

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

### Register the EncryptionAtHost feature:

Execute the following command to register the feature for your subscription

```Azure CLI
az feature register --namespace Microsoft.Compute --name EncryptionAtHost
```

### Verify the registration state:

Confirm that the registration state is Registered (registration might take a few minutes) using the following command before trying out the feature.

```Azure CLI
az feature show --namespace Microsoft.Compute --name EncryptionAtHost
```
### Register the resource provider:

```Azure CLI
az provider register --namespace Microsoft.Compute
```

Ensure that the registration state is Registered.

## Dependent Azure resources setup

- Establish [ExpressRoute](/azure/expressroute/expressroute-introduction) connectivity
  from your on-premises network to an Azure Region:
  - ExpressRoute circuit [creation and verification](/azure/expressroute/expressroute-howto-circuit-portal-resource-manager)
    can be performed via the Azure portal
  - In the ExpressRoute blade, ensure Circuit status indicates the status
    of the circuit on the Microsoft side. Provider status indicates if
    the circuit is provisioned or not provisioned on the
    service-provider side. For an ExpressRoute circuit to be operational,
    Circuit status must be Enabled, and Provider status must be
    Provisioned
- Set up Azure Key Vault to store encryption and security tokens,
  passwords, certificates, and API keys
- Set up Log Analytics WorkSpace (LAW) to store logs and analytics data for
  Operator Nexus subcomponents (Network Fabric, Cluster, etc.)
- Set up Azure Storage account to store Operator Nexus data objects:
  - Azure Storage supports blobs and files accessible from anywhere in the world over HTTP or HTTPS
  - this storage isn't for user/consumer data.

## Create steps

- Step 1: [Create Network Fabric Controller](../index.yml)<!--update link: (../../operator-nexus/howto-configure-network-fabric-controller.md)-->
- Step 2: [Create Cluster Manager](../index.yml)<!--update link: (../../operator-nexus/howto-cluster-manager.md)-->