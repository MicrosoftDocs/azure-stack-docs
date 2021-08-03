---
title: Using Azure Kubernetes Service on Azure Stack Hub in the portal
description: Learn how to use Azure Kubernetes Service (ASK) on Azure Stack Hub in the portal.
author: mattbriggs
ms.topic: article
ms.date: 08/15/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 08/15/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Using Azure Kubernetes Service on Azure Stack Hub in the portal

You can use the Azure Stack Hub user portal in the Azure Kubernetes Service (AKS) blade to discover, create, scale, upgrade, and delete AKS clusters.

## Discover available AKS clusters

1.  In the Azure Stack tenant portal find the "All Services" blade and select "Kubernetes services"

    ![This is the Azure Stack tenant portal.](media/aks-how-to-use/azure-stack-tenant-portal.png)

1.  Verify that all clusters that you have created appear in the "Kubernetes service" blade:

    ![Verify the clusters that you have created in the portal.](media/aks-how-to-use/all-clusters-that-you-have-created.png)

1.  Verify that you can view the details of any of the clusters:

    ![The portal contains the details of the AKS clusters.](media/aks-how-to-use/details-of-any-of-the-clusters.png)

## Create cluster

1.  In the Kubernetes services blade select **Add**.

    ![You can select select add in the portal to add a cluster.](media/aks-how-to-use/select-add-cluster.png)

2.  Follow the blades that guide you in the process of creating an AKS cluster.

## Upgrade cluster

1.  To upgrade the cluster's control plane, in the cluster's details blade select **Configuration**, then select the Kubernetes upgrade version to upgrade to and select save.

    !Upgrade and select save](media/aks-how-to-use/upgrade-to-and-select-save.png)

    ![Select version and select save in the portal.](media/aks-how-to-use/upgrade-to-select-version.png)

2. To upgrade the agent node pool, in the cluster's details blade select **Node pools**, then either select the node pool version link or on the **Upgrade** link at the top.

    ![Select version link in the portal.](media/aks-how-to-use/upgrade-agent-click-version.png)

3.  Select the node pool Kubernetes version

    ![Upgraded by checking the cluster.](media/aks-how-to-use/upgraded-by-checking-the-cluster.png)

## Scale cluster

1. In the cluster's details blade select **Node pools**, then select the node pool and select **Scale**

    ![Select scale cluster.](media/aks-how-to-use/select-scale.png)

2. In the scale panel on the right select the new node count

    ![Select new node count.](media/aks-how-to-use/select-node-count.png)

## Delete cluster

1.  In the overview blade for the AKS cluster, find and select **Delete** as in the image below.

    ![You can review the details of your cluster in the portal.](media/aks-how-to-use/delete-cluster.png)

2.  Verify the cluster is deleted. Also, check that the associated resource group is deleted, in the Resource groups blade, look for a resource group with this pattern `<…>_clustername_location`, if it is not found it was properly deleted.


## Next steps

[Learn about AKS on Azure Stack Hub](aks-overview.md)