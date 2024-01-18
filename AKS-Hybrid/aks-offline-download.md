---
title: Use manual (offline) download in AKS enabled by Azure Arc
description: Learn how to use manual (offline) download in AKS enabled by Arc.
ms.topic: how-to
ms.date: 01/18/2024
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 01/18/2024
ms.reviewer: waltero

---
# Use manual (offline) download of AKS Arc images on Azure Stack HCI

If you have unreliable internet connectivity at your deployment location or need to scan files and images for security and compliance before you deploy, you can manually download images to use to create and update Kubernetes workload clusters. You can issue a command to download the images to a convenient computer with good internet connectivity, and then you can use your preferred tool to move them to the target Azure Stack system. You then save them for the system to use when you need to create or update a Kubernetes cluster.

## Before you begin

Before you begin the download process, the following prerequisites are required:

- The latest release of Azure CLI. For more information, see [how to update the Azure CLI](/cli/azure/update-azure-cli).
- The latest release of the Azure CLI AKS Arc extension.
- Make sure you satisfied all the [system requirement prerequisites](system-requirements.md).

## Use manual download to create or update a Kubernetes cluster

You can use the following procedure to create or update a Kubernetes cluster on AKS enabled by Arc.

1. If you have not installed the Azure CLI AKS Arc extension, run the following command:

   ```azurecli
   az extension add --name aksarc
   ```

1. If you already had the CLI installed, ensure it's running the latest version of the extension by issuing the following command:

   ```azurecli
   az extension update --name aksarc
   ```

1. On a computer with reliable internet connectivity, download the required files by running the following command:

   ```azurecli
   az aksarc release download --staging-folder 'C:\staging_folder'
   ```

1. Use your preferred tool move the file to the desired Azure Stack HCI system used for Kubernetes clusters.
1. Save the new files into the target Azure Stack HCI system by running the following command:

   ```azurecli
   az aksarc release save--staging-folder 'C:\staging_folder' --config-file <applica_config_file>
   ```

1. You can now [create a Kubernetes cluster by following these instructions](aks-create-clusters-cli.md).

## Next steps

[AKS enabled by Azure Arc overview](aks-overview.md)