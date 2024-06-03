---

title: Use manual (offline) download in AKS enabled by Azure Arc (preview)
description: Learn how to use manual (offline) download in AKS enabled by Arc.
ms.topic: how-to
ms.date: 05/30/2024
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 05/17/2024
ms.reviewer: waltero

---

# Use manual (offline) download in AKS enabled by Azure Arc (preview)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

> [!NOTE]
> This feature is currently in limited preview. If you want to try it, contact your Microsoft account representative.

If you have unreliable internet connectivity at your deployment location or need to scan files and images for security and compliance before you deploy, you can manually download images to use to create and update Kubernetes clusters. You can issue a command to download the images to a convenient computer with good internet connectivity, and then you can use your preferred tool to move them to the target Azure Stack system. You then save them for the system to use when you need to create or update a Kubernetes cluster.

## Before you begin

Before you begin the download process, the following prerequisites are required:

- The latest release of Azure CLI. For more information, see [how to update the Azure CLI](/cli/azure/update-azure-cli).
- Make sure you satisfied all the [system requirement prerequisites](aks-hci-network-system-requirements).
- The name of the resource group that contains your system's Arc Resource Bridge and the name of the Resource Bridge resource instance. You can get this information by visiting the Azure portal. This information should be under your Azure subscription.

## Use manual download to create or update a Kubernetes cluster

1. If you haven't installed the AKS enabled by Azure Arc extension, run the following command:

   ```azurecli
   az extension add --name aksarc
   ```

1. If you already had the extension installed, ensure it's running the latest version by issuing the following command:

   ```azurecli
   az extension update --name aksarc
   ```

1. Sign in into your Azure subscription that has access to Azure Resource Bridge, and that corresponds to the target Azure Stack HCI. Run the following command:

   ```azurecli
   az login
   ```

1. Retrieve the name of the AKS extension from the Arc Resource Bridge by running the following command:

   ```azurecli
   $hybridAksExtensionName = az k8s-extension list -g "myResouceGroup" -c "myArcResourceBridge" --cluster-type appliances --query "[?extensionType=='microsoft.hybridaksoperator'].name" -o tsv
   ```

1. Update the configuration of the AKS extension to enable "offline download" of the images. Keep it separate from the automatic download of the VM images used to create Kubernetes clusters. Run the following command:

   ```azurecli
   az k8s-extension update -g "myResouceGroup" -c "myArcResourceBridge" --name $hybridAksExtensionName -t appliances --config offline-download="true"
   ```

1. On a computer with reliable internet connectivity, download the required files by running the following command:

   ```azurecli
   az aksarc release download --staging-folder 'C:\staging_folder'
   ```

1. Use your preferred tool to move the file to the desired Azure Stack HCI system used for Kubernetes clusters.

1. Save the new files into the target Azure Stack HCI system by running the following command:

   ```azurecli
   az aksarc release save--staging-folder 'C:\staging_folder' --config-file <applica_config_file>
   ```

1. You can now [create a Kubernetes cluster by following these instructions](aks-create-clusters-cli.md).

## Next steps

- [Create Kubernetes clusters on Azure Stack HCI using the Azure portal](aks-create-clusters-portal.md)
- [Create node pools on AKS clusters](manage-node-pools.md)
