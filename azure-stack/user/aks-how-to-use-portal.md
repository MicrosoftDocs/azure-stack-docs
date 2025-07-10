---
title: Use Azure Kubernetes Service on Azure Stack Hub in the portal
description: Learn how to use Azure Kubernetes Service (ASK) on Azure Stack Hub in the portal.
author: sethmanheim
ms.topic: install-set-up-deploy
ms.date: 1/3/2022
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 1/3/2022

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Use Azure Kubernetes Service on Azure Stack Hub in the portal

You can use the Azure Stack Hub user portal, in the Azure Kubernetes Service (AKS), to discover, create, scale, upgrade, and delete AKS clusters.

## Verify your resource providers

You will need to have the `Microsoft.ContainerService` resource provider available for your subscription. To find the services available in your subscription:

1. Sign in to the Azure Stack user portal. Select **All services** > **Resource Explorer** in the **General** group.

    ![Check for the Microsoft.ContainerService resource provider.](media/aks-how-to-use/check-for-container-step-1.png)

2. In the **Resource Explorer**, find the `Microsoft.ContainerService`.

    ![Check for the Microsoft.ContainerService in the Resource explorer.](media/aks-how-to-use/check-for-container-step-2.png)

3. If your subscription doesn't have `Microsoft.ContainerService`, you will need to have your cloud operator add the resource provider to your subscription, or you will need to subscribe to a subscription with the provider. Contact your cloud operator. 

## Discover available AKS clusters

1.  In the Azure Stack tenant portal, find **All Services**, and select **Kubernetes services**.

    ![This is the Azure Stack tenant portal.](media/aks-how-to-use/azure-stack-tenant-portal.png)

1.  Verify that all clusters that you have created appear in **Kubernetes service**:

    ![Verify the clusters that you have created in the portal.](media/aks-how-to-use/all-clusters-that-you-have-created.png)

1.  Verify that you can view the details of any of the clusters:

    ![The portal contains the details of the AKS clusters.](media/aks-how-to-use/details-of-any-of-the-clusters.png)

## Create cluster

1.  In Kubernetes services, select **Add**.

    ![You can select select add in the portal to add a cluster.](media/aks-how-to-use/select-add-cluster.png)

1.  Follow the steps to create an AKS cluster. The first step collects the basic cluster properties:

    ![Create an AKS cluster.](media/aks-how-to-use/create-an-aks-cluster.png)

    Use a version of Kubernetes 1.20 or greater. For more information, see [Applications deployed to AKS clusters fail to access persistent volumes](aks-known-issues.md#applications-deployed-to-aks-clusters-fail-to-access-persistent-volumes).

1.  In **Node pools** you can see that only a single node pool is allowed in Azure Stack Hub:

    ![Open the **Node pools** blade.](media/aks-how-to-use/open-the-node-pool-settings.png)

1. In **Authentication**, provide the service principal (SPN). The SPN won't be automatically generated as in Azure. Select the **Configure service principal** link and add the service principal. You can find [the instructions](../operator/give-app-access-to-resources.md) to create one.

    ![Add the service principle.](media/aks-how-to-use/add-service-principal-to-aks.png)


1.  In **Networking**, select **Azure CNI**, and then continue to create the cluster.

    ![Add Azure CNI for networking](media/aks-how-to-use/create-aks-network.png)


## Scale cluster

1. In cluster details, select **Node pools**, then select the node pool and select **Scale**

    ![Select scale cluster.](media/aks-how-to-use/select-scale.png)

2. In the scale panel on the right, select the new node count

    ![Select new node count.](media/aks-how-to-use/select-node-count.png)

## Delete cluster

1.  In the overview for the AKS cluster, find and select **Delete** as in the image below.

    ![You can review the details of your cluster in the portal.](media/aks-how-to-use/delete-cluster.png)

2.  Verify the cluster is deleted. Also, check that the associated resource group is deleted. In **Resource groups**, look for a resource group with the following pattern `<…>_clustername_location`. If a resource can't be found, it was properly deleted.


## Next steps

[Learn about AKS on Azure Stack Hub](aks-overview.md)
