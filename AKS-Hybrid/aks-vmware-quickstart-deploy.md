---
title: Quickstart - Deploy an AKS cluster using Azure CLI (preview)
description: Learn how to deploy an AKS cluster in AKS on VMware. 
author: sethmanheim
ms.author: sethm
ms.topic: quickstart
ms.custom: devx-track-azurecli
ms.date: 03/22/2024
ms.lastreviewed: 03/22/2024
ms.reviewer: leslielin
---

# Quickstart: Deploy an AKS cluster using Azure CLI (preview)

[!INCLUDE [aks-applies-to-vmware](includes/aks-hci-applies-to-skus/aks-applies-to-vmware.md)]

This quickstart shows you how to deploy an AKS cluster in AKS enabled by Azure Arc on VMware using the Azure CLI.

## Prerequisites

To complete this quickstart, you need to do these things:

- Make sure you review and satisfy all the requirements in [System requirements and support matrix](aks-vmware-system-requirements.md) and [networking requirements](aks-vmware-networking-concepts.md).
- Make sure you [deploy Arc-enabled VMware vSphere](/azure/azure-arc/vmware-vsphere/quick-start-connect-vcenter-to-arc-using-script) by connecting vCenter to Azure with the Kubernetes Extension for AKS Arc Operators.
- If you have an existing Arc-enabled VMware vSphere deployment, follow the process to [enable Kubernetes Extension for AKS Arc Operators](aks-vmware-install-kubernetes-extension.md).

### Azure parameters

| Parameter                     | Parameter details  |
|-------------------------------|--------------------|
| `$aad_Group_Id`                 | The ID of a group whose members manage the target cluster. This group should also have owner permissions on the resource group containing the custom location and target cluster.  |
| `$appliance_Name`               | Name of the Arc Resource Bridge created to connect vCenter with Azure.  |
| `$custom_Location`              | Custom location name or ID. If you choose to **Enable Kubernetes Service on VMware [preview]** when you **Connect vCenter to Azure** [from the Azure portal](/azure/azure-arc/vmware-vsphere/quick-start-connect-vcenter-to-arc-using-script), a custom location with the prefix **AKS-**, and a default namespace, are created for you to deploy AKS on VMware. If you **Enable Kubernetes Service on VMware [preview]** using the [Azure CLI process](aks-vmware-install-kubernetes-extension.md), you can specify the name of the custom location of your choice with the default namespace. You must use the **default** namespace.  |
| `$resource_Group`               | Resource Group name or ID for deploying the Arc Resource Bridge.  |
 
### vCenter server information

| Parameter                     | Parameter details  |
|-------------------------------|--------------------|
| `$network_name`                 | Name of the VMware network resource enabled in Azure.  | 
| `$control_plane_ip`             | The control plane IP for your target cluster. This control plane IP must be reserved/excluded in DHCP and different from the Arc Resource Bridge IP address  | 

## Step 1: Sign in to Azure

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

1. Create a vNet with the same `$resource_group` you used to deploy your Arc Resource Bridge and `$custom_location` with the default namespace.

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

Run the following command to create the cluster. 

```azurecli
az aksarc create -n '<name of your cluster>' -g $resource_group --kubernetes-version '<Kubernetes version from the Arc Resource Bridge>' --custom-location $custom_location --aad-admin-group-object-ids $aad_group_id --vnet-ids $vnet_id --control-plane-ip $control_plane_ip --generate-ssh-keys --debug
```

   > [!NOTE]
   > In this preview release, you can only deploy the same Kubernetes version that the Arc Resource Bridge supports. The Kubernetes version you provide in the command must align with the Arc Resource Bridge version. You can find the Arc Resource Bridge version in the Azure portal under **Azure Arc > Management > Resource Bridge**. To determine the corresponding Kubernetes version, see [What's new with Azure Arc resource bridge](/azure/azure-arc/resource-bridge/release-notes).


## Next steps

- See [Supported deployment scale](aks-vmware-scale-requirements.md) for the different configuration options.
- [Prepare an application](/azure/aks/hybrid/tutorial-kubernetes-prepare-application)
