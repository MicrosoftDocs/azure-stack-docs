---
title: Manage SAN storage appliances for multi-rack deployments of Azure Local
description: Learn how to view SAN storage appliances and understand storage management and maintenance for multi-rack deployments of Azure Local.
author: perfectchaos
ms.author: chaoschhapi
ms.service: azure-local
ms.date: 10/12/2026
ms.topic: how-to
ms.subservice: multi-rack
---

# Manage SAN storage appliances for multi-rack deployments of Azure Local

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to view storage appliances and understand how Azure Local manages storage after deployment.

For supported appliance models, software versions, and deployment preparation, see [SAN storage deployment and preparation](multi-rack-san-storage-deployment.md).

## View storage appliances

Each onboarded appliance is represented by a Storage Appliance resource in Azure. You can view these resources through the Azure portal or Azure CLI.

To use Azure CLI, install the [required CLI extensions](multi-rack-cli-extensions.md) and sign in to the subscription containing your deployment. Your account must have permission to read the Storage Appliance resources.

List the appliances in a resource group:

```azurecli
az networkcloud storageappliance list \
  --resource-group "<resource-group>" \
  --subscription "<subscription-id>"
```

View a specific appliance:

```azurecli
az networkcloud storageappliance show \
  --name "<storage-appliance-name>" \
  --resource-group "<resource-group>" \
  --subscription "<subscription-id>"
```

For the command reference, see [az networkcloud storageappliance](/cli/azure/networkcloud/storageappliance). This reference covers commands across supported storage vendors. Not every command is supported for every vendor.

For appliance status, capacity, performance metrics, and troubleshooting guidance, see [Monitor and troubleshoot SAN storage appliances](multi-rack-monitor-san-storage.md).

## Platform-managed storage

Azure Local manages workload volume provisioning and attachment, along with rotation of the credentials and management certificates used to communicate with storage appliances. You don't need to perform these activities directly on the appliance.

For NetApp and Dell PowerStore, appliance lifecycle management is limited to platform-used credential and management certificate rotation. For Pure Storage, Azure Local also manages the appliance user accounts required for platform operations.

## Manage storage for workloads

Use the supported [Azure Local VM](multi-rack-manage-arc-virtual-machine-resources.md) or [Kubernetes](/azure/aks/aksarc/multi-rack/cluster-architecture) workflows to provision and manage workload storage. Azure Local performs the corresponding operations on the backing appliance.

Don't use appliance-native tools to modify or delete volumes, host mappings, or other storage objects that Azure Local manages unless Microsoft support directs you to do so.

## Appliance maintenance

Azure Local doesn't initiate or manage storage-appliance software upgrades. For appliance software upgrades, hardware servicing, or changes to appliance configuration, contact the storage vendor for your appliance.
