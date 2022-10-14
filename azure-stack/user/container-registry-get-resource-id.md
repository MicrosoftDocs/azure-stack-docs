---
title: Get the resource ID for Azure Container Registry (ACR) and Azure Kubernetes Service (AKS) for Azure Stack Hub 
description: Learn how to get the resource ID for Azure Container Registry (ACR) and Azure Kubernetes Service (AKS) for Azure Stack Hub
author: sethmanheim
ms.topic: how-to
ms.date: 10/26/2021
ms.author: sethm
ms.reviewer: chasat
ms.lastreviewed: 10/26/2021

# Intent: As an Azure Stack user, I want to get the resource ID for ACR and AKS from the portal in Azure public so I can provide this to support.
# Keyword: resource ID for ACR and AKS

---

# Get the resource ID for Azure Container Registry (ACR) and Azure Kubernetes Service (AKS) for Azure Stack Hub

You may need to use the resource ID for our container registry to help resolve
issues. You may need to provide the ID to your cloud operator or to Microsoft 
support. This article walks you through the steps to get your resource ID.

## Get the resource ID for ACR

1. Open the Azure Stack Hub user portal.
2. Navigate to your container registry.
3. Select **JSON view**.  
    ![get the resource id string for ACR](.\media\container-registry-get-resource-id\acs-resource-id.png)

4. Find the resource ID. Select **copy**.

## Get the resource ID for AKS

1. Open the Azure Stack Hub user portal.
2. Navigate to your Azure Stack Hub AKS cluster.
3. Select **JSON view**.  
    ![get the resource id string for AKS](.\media\container-registry-get-resource-id\acs-resource-id.png)

4. Find the resource ID. Select **copy**.

## Next steps

Learn more about the [Azure Container Registry on Azure Stack Hub](container-registry-overview.md)
