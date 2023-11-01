---
title: Create AKS hybrid clusters from the Azure portal
description: Create AKS hybrid clusters from the Azure portal
author: abha
ms.author: abha
ms.topic: how-to
ms.date: 09/29/2022
---

# How to deploy an Azure Kubernetes Service hybrid cluster using Azure portal

> Applies to: Windows Server 2019, Windows Server 2022, Azure Stack HCI, version 22H2

In this article, you'll learn the following:

- How to create an AKS hybrid cluster using the Azure portal. By default, the cluster is Azure Arc-connected.
- While creating the cluster, you provide a Microsoft Entra group that contains the list of Microsoft Entra users with Kubernetes cluster administrator access.

## Before you begin

- Before you begin, make sure you've got the following details from your on-premises infrastructure administrator:
    - **Azure subscription ID** - The Azure subscription ID where Azure Resource Bridge, AKS hybrid extensions, and custom location has been created.
    - **Custom Location ID** - Azure Resource Manager ID of the custom location. Your infrastructure admin should give you "Contributor" access to the custom location. Custom Location is a required parameter to create AKS hybrid clusters. 
    - **AKS hybrid vnet ID** - Azure Resource Manager ID of the Azure hybridaks vnet. Your infrastructure admin should give you "Contributor" access to an AKS hybrid vnet. AKS hybrid vnet ID is a required parameter to create AKS hybrid clusters. 
- In order to connect to the AKS hybrid cluster from anywhere, you must create a **Microsoft Entra group** and add members to it. All the members in the Microsoft Entra group have cluster administrator access to the AKS hybrid cluster. Make sure to add yourself to the Microsoft Entra group -- if you don't add yourself, you can't access the AKS hybrid cluster using `kubectl`. For more information about creating Microsoft Entra groups and adding users, see [create Microsoft Entra groups using Azure portal](/azure/active-directory/fundamentals/active-directory-groups-create-azure-portal).

## Create an AKS cluster

1. Sign in to the [Azure portal](https://portal.azure.com).

2. On the Azure portal search bar, type **Azure Arc Kubernetes clusters**.

3. Select **Add** > **Create an AKS hybrid cluster (preview)**.

4. On the **Basics** page, configure the following options:

    - **Project details**:
        * Select an Azure **Subscription**. This Azure subscription is where your infrastructure administrator has deployed the Arc Resource Bridge, AKS hybrid extension and custom location.
        * Select an Azure **Resource group**, such as **myResourceGroup**.
    - **Cluster details**:
        * Enter a **Kubernetes cluster name**, such as **myakshybridcluster**. The name of a Kubernetes cluster name must consist of lowercase alphanumeric characters.
        * Select a custom location where you want to deploy the AKS hybrid cluster. Make sure your infrastructure administrator has given you "Contributor" access on a custom location.
    - **Primary node pool**:
        * Leave the default values selected.
    - **SSH Keys**
        * Configure SSH access to the underlying VMs in your Kubernetes nodes for troubleshooting operations. For the preview, you must provide an existing SSH public key.
        * Provide an RSA public key in the single line format (starting with "ssh-rsa") or the multi-line PEM format. You can generate SSH keys using PuTTYGen on Windows.

5. Select **Next: Node pools** when complete.

6. On the **Node pools** page, you can configure the following options:

   - **Control plane nodes**:
        * ⁠Control plane nodes host Kubernetes components that make global decisions about the cluster, such as scheduling containers and detecting and responding to cluster events; for example, starting up a new pod. For simplicity and reliability, we run these important Kubernetes components in separate control plane nodes.
        * Leave the default values selected.
   - **Node pools**:
        * You can choose to add optional node pools in addition to the primary node pool you created on the **Basics** page.
        
7. At the bottom of the screen, click **Next: Access**.

8. On the **Access** page, configure the following options:

    - The default value for Kubernetes cluster authentication is **Local accounts with Kubernetes RBAC**. This option requires that you have a direct line of sight to your on-premises infrastructure, to access the AKS hybrid cluster using `kubectl`.
    - Select Microsoft Entra authentication with Kubernetes RBAC. This option lets you choose one or more Microsoft Entra groups. By default, all members of the specified Microsoft Entra groups have cluster administrator access to the AKS hybrid cluster. This option also enables you to connect to AKS hybrid from anywhere, without requiring a line of sight to the on-premises infrastructure. Make sure to add yourself to the Microsoft Entra group. If you don't add yourself, you cannot access the AKS hybrid cluster using kubectl.
    - Choose one or more Microsoft Entra groups and then at the bottom of the screen, select **Next: Networking**.
    
9. On the **Networking** page, select an AKS hybrid vnet. The Kubernetes nodes and services in your AKS hybrid cluster get IP addresses and networking configurations from this vnet. Make sure your infrastructure administrator has given you Contributor access on an AKS hybrid vnet.

10. Select **Review + create**. When you navigate to the **Review + create** tab, Azure runs validation on the settings that you chose. If validation passes, you can create the AKS hybrid cluster by selecting **Create**. If validation fails, it then indicates which settings you must modify.

11. It takes a few minutes to create the AKS cluster. When your deployment is complete, navigate to your resource by either:

    * Selecting **Go to resource**, or
    * Browsing to the AKS hybrid cluster resource group and selecting the **AKShybrid** resource.

## Next steps

- [Troubleshoot and known issues with AKS hybrid cluster provisioning from Azure](troubleshoot-aks-hybrid-preview.md)
