---
title: Create AKS hybrid clusters from the Azure Portal
description: Create AKS hybrid clusters from the Azure Portal
author: abha
ms.author: abha
ms.topic: how-to
ms.date: 09/29/2022
---

# How to deploy an Azure Kubernetes Service hybrid cluster using Azure Portal

> Applies to: Windows Server 2019, Windows Server 2022, Azure Stack HCI

In this how-to guide, you'll

- Create an AKS hybrid cluster using Azure Portal. The cluster will be Azure Arc-connected by default
- While creating the cluster, you will provide an Azure AD group that contains the list of Azure AD users with Kubernetes cluster administrator access


## Before you begin

- Before you begin, make sure you've got the following details from your on-premises infrastructure administrator:
    - **Azure subscription ID** - The Azure subscription ID where Azure Resource Bridge, AKS hybrid extension and Custom Location has been created.
    - **Custom Location ID** - Azure Resource Manager ID of the custom location. Your infrastructure admin should give you "Contributor" access to the custom location. This is a required parameter to create AKS hybrid clusters. 
    - **AKS hybrid vnet ID** - Azure Resource Manager ID of the Azure hybridaks vnet. Your infrastructure admin should give you "Contributor" access to an AKS hybrid vnet. This is a required parameter to create AKS hybrid clusters. 

- In order to connect to the AKS hybrid cluster from anywhere, you need to create an **Azure AD group** and add members to it. All the members in the Azure AD group will have cluster administrator access to the AKS hybrid cluster. **Make sure to add yourself to the Azure AD group.** If you do not add yourself, you will not be able to access the AKS hybrid cluster using `kubectl`. To learn more about creating Azure AD groups and adding users, read [create Azure AD groups using Azure Portal](/azure/active-directory/fundamentals/active-directory-groups-create-azure-portal).

## Create an AKS cluster

1. Sign in to the [Azure portal](https://portal.azure.com).

2. On the Azure portal search bar, type "Azure Arc Kubernetes clusters"

3. Select **Add** > **Create an AKS hybrid cluster (preview)**.

4. On the **Basics** page, configure the following options:

    - **Project details**:
        * Select an Azure **Subscription**. This Azure subscription is where your infrastructure administrator has deployed the Arc Resource Bridge, AKS hybrid extension and Custom Location.
        * Select an Azure **Resource group**, such as *myResourceGroup*.
    - **Cluster details**:
        * Enter a **Kubernetes cluster name**, such as *myAKSHybridCluster*.
        * Select a Custom Location where you want to deploy the AKS hybrid cluster. Make sure your infrastructure administrator has given you Contributor access on a Custom Location.
    - **Primary node pool**:
        * Leave the default values selected.
    - **SSH Keys**
        * You need to configure SSH access to the underlying VMs in your Kubernetes nodes for troubleshooting operations. Right now for the preview, you have to provide an existing SSH public key.
        * Provide an RSA public key in the single line format (starting with "ssh-rsa") or the multi-line PEM format. You can generate SSH keys using PuTTYGen on Windows.

5. Select **Next: Node pools** when complete.

6. On the **Node pools** page, you can configure the following options:

   - **Control plane nodes**:
        * ⁠Control plane nodes host Kubernetes components that make global decisions about the cluster, such as scheduling containers, as well as detecting and responding to cluster events, for example, starting up a new pod. For simplicity and reliability, we run these important Kubernetes components in seperate control plane nodes.
        * Leave the default values selected.
   - **Node pools**:
        * You can choose to add optional node pools in addition to the primary node pool you created on the Basics page.
        
7. At the bottom of the screen, click **Next: Access**.

8. On the **Access** page, configure the following options:

    - The default value for Kubernetes cluster authentication is **Local accounts with Kubernetes RBAC**. This option requires you to have direct line of sight to your on-premises infrastructure, to access the AKS hybrid cluster using `kubectl`.
    - Select Azure AD authentication with Kubernetes RBAC. This option lets you choose one or more Azure AD groups. All members of the chosen Azure AD groups will have cluster administrator access by default to the AKS hybrid cluster. This options also enables you to connect to the AKS hybrid from anywhere, without requiring line of sight to the on-premises infrastructure. Make sure to add yourself to the Azure AD group. If you do not add yourself, you will not be able to access the AKS hybrid cluster using kubectl. 
    - Choose 1 or more Azure AD groups and then at the bottom of the screen, click Next: Networking
    
9. On the **Networking** page, select an AKS hybrid vnet. The Kubernetes nodes and services in your AKS hybrid cluster will get IP addresses and networking configurations from this vnet. Make sure your infrastructure administrator has given you Contributor access on an AKS hybrid vnet.

10. Click **Review + create**. When you navigate to the **Review + create** tab, Azure runs validation on the settings that you have chosen. If validation passes, you can proceed to create the AKS hybrid cluster by selecting **Create**. If validation fails, then it indicates which settings need to be modified.

11. It takes a few minutes to create the AKS cluster. When your deployment is complete, navigate to your resource by either:
    * Selecting **Go to resource**, or
    * Browsing to the AKS hybrid cluster resource group and selecting the AKShybrid resource.

## Next steps
- [Troubleshoot and known issues with AKS hybrid cluster provisioning from Azure](troubleshoot-aks-hybrid-preview.md)
