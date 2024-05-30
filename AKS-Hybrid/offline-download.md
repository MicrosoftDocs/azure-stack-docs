
---
title: Use manual (offline) download in AKS enabled by Azure Arc
description: Learn how to use manual (offline) download in AKS enabled by Arc.
ms.topic: how-to
ms.date: 02/01/2024
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 01/31/2024
ms.reviewer: waltero

---

# Use manual (offline) download in AKS enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

> [!NOTE]
> This feature is currently in preview.

If you have unreliable internet connectivity at your deployment location or need to scan files and images for security and compliance before you deploy, you can manually download images to use to create and update Kubernetes workload clusters. You can issue a command to download the images to a convenient computer with good internet connectivity, and then you can use your preferred tool to move them to the target Azure Stack system. You then save them for the system to use when you need to create or update a Kubernetes cluster.

## Before you begin

Before you begin the download process, the following prerequisites are required:

- The latest release of Azure CLI. For more information, see [how to update the Azure CLI](/cli/azure/update-azure-cli).
- The latest release of the [Azure CLI AKS Arc extension](/cli/azure/aksarc).
- Make sure you satisfied all the [system requirement prerequisites](system-requirements.md).
- The name of the resource group that contains your system's Arc Resource Bridge (ARB) and the name of the ARB's resource instance. You can get this information by visiting the Azure portal, this information should be under your Azure subscription.

## Use manual download to create or update a Kubernetes cluster

You can use the following procedure to create or update a Kubernetes cluster on AKS enabled by Arc.

1. If you have not installed the Azure CLI AKS Arc extension, run the following command:

   ```azurecli
   az extension add --name aksarc
   ```

2. If you already had the CLI installed, ensure it's running the latest version of the extension by issuing the following command:

   ```azurecli
   az extension update --name aksarc
   ```

3. Login into your Azure subscription, the one that has access to Azure Resouce Bridge that corresponds to the target Azure Stack HCI. Run the following command:

   ```azurecli
   az login
   ```

4. Collect the name of the AKS extension from the Arc Resource Bridge by running the following command:

   ```azurecli
   $hybridAksExtensionName = az k8s-extension list -g "myResouceGroup" -c "myArcResourceBridge" --cluster-type appliances --query "[?extensionType=='microsoft.hybridaksoperator'].name" -o tsv
   ```

5. Update the configuration of the AKS extension to allow for "offline donwload" of the images, that is, keep it from the automatic dowload of the VM images used to create AKS Kubernetes clusters. Run the following command:

   ```azurecli
   az k8s-extension update -g $rgName -c "myArcResourceBridge" --name $hybridAksExtensionName -t appliances --config offline-download="true"
   ```

6. On a computer with reliable internet connectivity, download the required files by running the following command:

   ```azurecli
   az aksarc release download --staging-folder 'C:\staging_folder'
   ```

7. Use your preferred tool to move the file to the desired Azure Stack HCI system used for Kubernetes clusters.
8. Save the new files into the target Azure Stack HCI system by running the following command:

   ```azurecli
   az aksarc release save--staging-folder 'C:\staging_folder' --config-file <applica_config_file>
   ```

9. You can now [create a Kubernetes cluster by following these instructions](aks-create-clusters-cli.md).

## Next steps

- [Azure Kubernetes Service on Azure Stack HCI](overview.md)
- [Create Kubernetes clusters using Azure CLI](aks-create-clusters-cli.md)
