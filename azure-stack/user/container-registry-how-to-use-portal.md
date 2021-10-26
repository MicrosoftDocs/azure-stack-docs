---
title: Create and manage Azure Container Registries on Azure Stack Hub
description: Learn how to create and manage Azure Container Registries on Azure Stack Hub.
author: mattbriggs
ms.topic: how-to
ms.date: 10/26/2021
ms.author: mabrigg
ms.reviewer: chasat
ms.lastreviewed: 10/26/2021

# Intent: As an Azure Stack user, I want to XXX so I can XXX.
# Keyword: XXX

---
# Create and manage Azure Container Registries on Azure Stack Hub

You can use the Azure Stack Hub portal to create and manage Azure Container Registries (ACR) on Azure Stack Hub. This document provides basic information on how to create a container registry using the portal.

## Create a registry

You can create a registry using the Azure Stack Hub user portal by following these steps.

1.  Open the Azure Stack Hub user portal, and then navigate to **All services**. Find **Container registries** in the **Containers** section.
2.  Select **+Add** in Container registries.  
    ![Add a container registry.](media/container-registry-how-to-use-portal/add-a-container-registry.png)
3.  Complete the required details and select **Review** and **Create**. Review the details and select **Create**. Both the location and SKU will get filled in and can't be modified.  
    ![Review container registry details.](media/container-registry-how-to-use-portal/review-container-registry-details.png)

## View a registry

One a container registry has been created you can view details about the registry and repositories, as well as view and manage access, webhooks, metrics, and diagnostic settings. The portal doesn't display features and options not available for ACR on Azure Stack Hub.

![View and manage container registry.](media/container-registry-how-to-use-portal/view-manage-container-registry.png)

## Next steps

Learn more about the [Azure Container Registry on Azure Stack Hub](container-registry-overview.md).