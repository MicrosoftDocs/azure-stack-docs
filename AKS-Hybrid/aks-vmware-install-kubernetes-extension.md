---
title: Install and uninstall Kubernetes Extension for AKS Arc Operators (preview)
description: Learn how to install and uninstall the Kubernetes Extension for AKS Arc Operators.
ms.topic: how-to
ms.date: 03/18/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: leslielin
ms.lastreviewed: 03/18/2024

---

# Install and uninstall the Kubernetes Extension for AKS Arc Operators (preview)

To use the AKS Arc on VMware preview, you must first onboard [Arc-enabled VMware vSphere](/azure/azure-arc/vmware-vsphere/overview) by connecting vCenter to Azure through the [Arc Resource Bridge](/azure/azure-arc/resource-bridge/overview), with the Kubernetes Extension for AKS Arc Operators installed. If you already [deployed Arc-enabled VMware vSphere](/azure/azure-arc/vmware-vsphere/quick-start-connect-vcenter-to-arc-using-script) but didn't install the Kubernetes Extension for AKS Arc Operators, follow the instructions in this article.

## Install the Kubernetes Extension for AKS Arc Operators

1. Verify whether the Kubernetes Extension for AKS Arc Operators is installed on your Arc-enabled VMware vSphere by running the following command:

   ```azurecli
    az k8s-extension list --cluster-name <cluster-name> --resource-group <resource-group-name>
    ```

1. Install the Kubernetes extension. Use the [az extension add](/cli/azure/extension#az-extension-add) command to install the Kubernetes Extension for AKS Arc Operators:

    ```azurecli
    az extension add -n aksarc
    az extension add -n connectedk8s
    ```

## Clean up environment from deployments of AKS Arc on VMware

Once you complete the evaluation of the AKS Arc on VMware preview, you can follow these steps to clean up your environment:

1. Delete the AKS cluster. To delete the workload cluster, use the [az aksarc delete](/cli/azure/aksarc#az-aksarc-delete) command, or go to the Azure portal.

   ```azurecli
   az aksarc delete -n '<cluster name>' -g $applianceResourceGroupName
   ```

1. Uninstall the Kubernetes Extension. You can uninstall the Kubernetes Extension for AKS Arc Operators by using the [az extension remove](/cli/azure/extension#az-extension-remove) command:

   ```azurecli
   az extension remove -n aksarc
   az extension remove -n connectedk8s
   ```

## Next steps

- If you're beginning to evaluate the AKS Arc on VMware preview and finished installing the Kubernetes Extension for AKS Arc Operators, you can create an AKS cluster by following the instructions in the "Quickstart: Deploy an AKS cluster using Azure CLI."
- If you completed the evaluation of AKS Arc on VMware, please share your feedback with us through [GitHub](https://github.com/Azure/aksArc/issues).

