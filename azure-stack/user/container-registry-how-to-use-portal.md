---
title: Create and manage Azure Container Registry on Azure Stack Hub
description: Learn how to create and manage Azure Container Registry on Azure Stack Hub.
author: sethmanheim
ms.topic: how-to
ms.date: 07/25/2024
ms.author: sethm
ms.reviewer: dgarrity
ms.lastreviewed: 04/10/2024

# Intent: As an Azure Stack Hub user, I want to know how to create and manage Azure Container Registries on Azure Stack Hub so that I can store and manage container images and artifacts.

---

# Create and manage Azure Container Registry on Azure Stack Hub

You can use the Azure Stack Hub portal to create and manage Azure Container Registry on Azure Stack Hub. This article provides information on how to create a container registry using the portal.

## Create a registry

You can create a container registry using the Azure Stack Hub user portal by following these steps:

1. Open the Azure Stack Hub user portal, and then navigate to **All services**. Find **Container registries** in the **Containers** section.
1. Select **+Add** in **Container registries**.  
    ![Add a container registry.](media/container-registry-how-to-use-portal/add-a-container-registry.png)
1. Complete the required details, then select **Review and Create**. Review the details and select **Create**. Both the location and SKU are filled in and can't be modified.  
    ![Review container registry details.](media/container-registry-how-to-use-portal/review-container-registry-details.png)

## View a registry

Once a container registry is created, you can view details about the registry and repositories, as well as view and manage access, webhooks, metrics, and diagnostic settings. The portal doesn't display features and options that are not available for Azure Container Registry on Azure Stack Hub.

![View and manage container registry.](media/container-registry-how-to-use-portal/view-manage-container-registry.png)

## Next steps

Learn more about [Azure Container Registry on Azure Stack Hub](container-registry-overview.md)
