---
title: Quickstart - Deploy an AKS cluster using Azure CLI (preview)
description: Learn how to deploy an AKS cluster in AKS on VMware. 
author: sethmanheim
ms.author: sethm
ms.topic: quickstart
ms.date: 03/18/2024
---

# Quickstart: Deploy an AKS cluster using Azure CLI (preview)

This quickstart shows you how to deploy an AKS cluster in AKS on VMware using the Azure CLI.

## Prerequisites

To complete this quickstart, you need the following:

- Make sure you review and satisfy all the requirements in "System requirements and support matrix." We recommend you reserve 36 GB memory, 10 vCPUs, and 300 GB storage for the AKS on VMware initial deployment.
- Make sure you [deploy Arc-enabled VMware vSphere](/azure/azure-arc/vmware-vsphere/quick-start-connect-vcenter-to-arc-using-script) by connecting vCenter to Azure with the Kubernetes Extension for AKS Arc Operators.
- If you have an existing Arc-enabled VMware vSphere deployment, follow the installation process to [install Kubernetes Extension for AKS Arc Operators](aks-vmware-install-kubernetes-extension.md).

### Azure parameters

| Parameter        | Details                                                                                                                                                                                                                                                           |
|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `$subscriptionID`  | Subscription ID used to deploy the Arc Resource Bridge.                                                                                                                                                                                                           |
| `$custom_location` | Custom location name or ID for deploying the Arc Resource Bridge.                                                                                                                                                                                                 |
| `$resource_Group`  | Resource Group name or ID for deploying the Arc Resource Bridge.                                                                                                                                                                                                  |
| `$aad_group_id`    | The ID of a group whose members manage the target cluster. This group should also have owner permissions on the resource group containing the custom location and target cluster. Usually, you can find your Microsoft Entra ID group here and get its object ID. |

### vCenter server information

|     Parameter            |     Details                                      |
|--------------------------|------------------------------------------------------------|
|     `$network_name`        |     Name of the VMware network segment.                   |
|     `$control_plane_ip`    |     Control Plane IP endpoint for your target cluster.    |

## Step 1: sign in to Azure

1. Sign in to Azure using the following command:

   ```azurecli
   az login --use-device-code
   ```

1. Set the Azure subscription ID to the subscription you used to deploy the Arc Resource Bridge and custom location:

   ```azurecli
   az account set -s $subscriptionID
   ```

## Step 2: Create vNet for your AKS cluster using VMware network segment

1. Define the network name as the name of the VMware network segment:

   ```azurecli
   $network_name = '<Name of the VMware Network segment>'
   ```

1. Create a vNet with the same `$resource_group` and `$custom_location` you used to deploy your Arc Resource Bridge:

   ```azurecli
   az aksarc vnet create -n '<name of the vNet>' -g $resource_group --custom-location $custom_location --vsphere-segment-name $network_name
   ```

1. Get the vNet ID:

   ```azurecli
   $vnet_id = az aksarc vnet show -n '<name of the vNET>'  -g $resource_group --query id -o tsv
   ```

1. Pass the Control Plane IP endpoint for your target cluster:

   ```azurecli
   $control_plane_ip = '<Control Plane IP endpoint for your target cluster>'
   ```

> [!NOTE]
> If the creation of the vNet times out, try running the commands again to recreate the vNet.

> [!NOTE]
> The control plane IP must be reserved/excluded in DHCP and different from the Arc Resource Bridge IP address.

## Step 3: Create the AKS cluster

Run the following command to create the cluster:

```azurecli
az aksarc create -n '<name of your cluster>' -g $resource_group --kubernetes-version 'v1.26.6' --custom-location $custom_location --aad-admin-group-object-ids $aad_group_id --vnet-ids $vnet_id --control-plane-ip $control_plane_ip --generate-ssh-keys --debug
```

## Next steps

