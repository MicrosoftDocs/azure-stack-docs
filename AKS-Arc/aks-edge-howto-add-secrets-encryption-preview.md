---
title: Add secrets encryption to an AKS Edge Essentials cluster (preview)
description: Learn how to enable the KMS plugin for AKS Edge Essentials cluster
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 02/10/2025
ms.custom: template-how-to
---

# Add secrets encryption to an AKS Edge Essentials cluster (preview)
On AKS EE clusters, following Kubernetes security best practices, it is recommended to encrypt Kubernetes secret store. You can do this by activating the Key Management Service (KMS) Plugin for AKS EE, which enables encryption at rest for [secrets](https://kubernetes.io/docs/concepts/configuration/secret/)stored in the etcd key-value store. It does this by generating a Key Encryption Key (KEK) and automatically rotating it every 30 days. For more detailed information on using KMS, refer to the official guide at [KMS Provider Documentation](https://kubernetes.io/docs/tasks/administer-cluster/kms-provider/). This article demonstrates how to activate this KMS Plugin.

> [!IMPORTANT]
> KMS plugin for AKS EE is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.


## Requirements 
The KMS plugin will be supported for all AKS EE clusters version 1.10.xxx.0 and later


## Limitations
1. Disabling the KMS plugin once enabled is not supported. 
2. The plugin can be used for single node clusters. The KMS plugin cannot be used with the experimental multi-node features


## Enabling KMS Plugin on AKS EE 
> [!NOTE]
> You can only enable or disable the KMS Plugin when creating a new deployment. Once you set the flag, it can't be changed unless you remove the deployment or node.

1. Installing the KMS Plugin
- Install the single machine deployment using the [Single Machine Kubernetes guide](https://learn.microsoft.com/en-us/azure/aks/aksarc/aks-edge-howto-single-node-deployment#step-1-single-machine-configuration-parameters) guide
- During the first step in the single machine deployment process, create an **aksedge-config.json** file 
- Replace the value of KMS from 'false' to 'true'. 
- In your **aksedge-config file**, in the Init section, set Init.KmsPlugin.Enable to True as shown below:

   ```JSON
   "Init": {
    "KmsPlugin": {
        "Enable": true
     }
  }
   ```
A new deployment has been created when you see the following message:
    :::image type="content" source="media/aks-edge/aks-ee-successful-deployement.jpg" alt-text="Screenshot showing Visual Studio create new solution." lightbox="media/aks-edge/aks-ee-successful-deployement.jpg":::

2. Validating KMS Installation
The following sections describe how to validate the KMS plugin installation for AKS EE cluster 

**Create and retrieve a secret which is encrypted using KMS**
   ```powershell
   # Create a new secret encrypted by KMS
    kubectl create secret generic db-user-pass --from-literal=username=admin --from-literal=password='your-secret'
   ```

**Retrieve the secret which has been created**
   ```powershell
    # Retrieve secret to test decryption
    kubectl get secret db-user-pass -o jsonpath='{.data}'
   ```
If successful the terminal will show the following output:
    :::image type="content" source="media/aks-edge/aks-ee-successful-secret-create.jpg" alt-text="Screenshot showing Visual Studio create new solution." lightbox="media/aks-edge/aks-ee-successful-secret-create.jpg":::


## Troubleshooting
If there are errors with the KMS plugin, please run the following commands. 

1. Check that the AKS version is **1.10.xxx.0** and later
Use the following command to check for upgrades for Kubernetes Cluster. Please refer to [upgrade an AKS Cluster](https://learn.microsoft.com/en-us/azure/aks/upgrade-aks-cluster?tabs=azure-cli) for more information.

   ```shell
    az aks get-upgrades --resource-group myResourceGroup --name myAKSCluster --output table
   ```
2. View readyz api  
If the problem persists, then validate that installation succeeded and to check the health of the KMS plugin run the following command and ensure that the health status of kms-providers is "ok"
   ```powershell
    kubectl get --raw='/readyz?verbose'
   ```

:::image type="content" source="media/aks-edge/aks-ee-kms-plugin-ok.jpg" alt-text="Screenshot showing Visual Studio create new solution." lightbox="media/aks-edge/aks-ee-kms-plugin-ok.jpg":::

If you receive [-] before the output then collect Diagnostic Logs for debugging. Refer to the link instructions [here](https://learn.microsoft.com/en-us/azure/aks/aksarc/aks-edge-resources-logs) for more information. 

3. Repair KMS 
If there are still errors then the machine running the AKS EE cluster could have been paused or turned off for extended periods of time (over 30 days) the Repair-Kms command can be run to rehydrates any necessary tokens to get KMS back in a healthy state.
   ```powershell
    Repair-Kms
   ```
4. Contact Customer Support 
If you are still encountering errors contact [Customer Support](https://learn.microsoft.com/en-us/azure/aks/aks-support-help) and [collect logs](https://learn.microsoft.com/en-us/azure/aks/aksarc/aks-edge-resources-logs)


## Next steps

- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)