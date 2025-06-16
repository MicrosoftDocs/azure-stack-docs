---
title: Deploy Azure Container Registry with disconnected operations on Azure Local (preview)
description: Learn how to deploy and manage Azure Container Registry with disconnected operations for Azure Local (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 06/16/2025
ai-usage: ai-assisted
---

# Deploy Azure Container Registry with disconnected operations on Azure Local (preview)

::: moniker range=">=azloc-24112"

This article explains how to deploy and manage Azure Container Registry on disconnected operations running on Azure Local.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## About Azure Container Registry

Azure Container Registry on disconnected operations is a managed registry service. This service lets you build, store, and manage container images and artifacts in a private registry for all types of container deployments. With Azure Container Registry, you can:

- Create and manage container registries by using these interfaces:
  - User portal (disconnected operations)
  - PowerShell
  - Azure Command-Line Interface (CLI)
  - Docker Command Line Interface (CLI).
- Store and retrieve Open Container Initiative (OCI) images.
- Assign role-based access control (RBAC) permissions.
- Create webhooks.
- Manage a local repository of images via a local container registry.
  - This registry is part of a continuous integration and continuous delivery (CI/CD) pipeline.
  - It's designed for deployment to Azure Kubernetes Service or other supported container orchestrators on disconnected operations.

Key features of Azure Container Registry on disconnected operations include:

| Feature | Description |
|---------|-------------|
| OCI artifact repository | Add Helm charts, support singularity, and use new OCI artifact-supported formats. |
| Integrated security | Connect with Microsoft Entra authentication or Microsoft Entra ID Federated Services, and RBAC. |
| Webhooks | Trigger events when actions occur in one of your registry repositories. |

## Prerequisites

- Make sure that the disconnected operations virtual machine is deployed.
- Check that you can access the disconnected operations portal.
- Register the *Microsoft.ContainerRegistry* resource provider with disconnected operations.
- [Install the Azure CLI](disconnected-operations-cli.md#install-cli) (supported up to version 2.54.0.).
- (Optional) [Install Docker Desktop](https://www.docker.com/get-started/) on your disconnected operations host or client machine for testing.

## Deploy Azure Container Registry

To deploy an Azure Container Registry for disconnected operations, follow these steps:

1. Sign in to the Azure Local portal and navigate to the **Create a resource** page.
2. Select **Create a resource** > **Containers** > **Container Registry**.

   :::image type="content" source="./media/disconnected-operations/azure-container-registry/create-container-registry.png" alt-text="Screenshot showing how to create a container registry from the portal." lightbox=" ./media/disconnected-operations/azure-container-registry/create-container-registry.png":::

3. On the **Basics** tab, enter values for **Subscription**, **Resource group**, **Registry name**, **Location**, and **Pricing plan**.
    - The registry name must be unique in Azure and have 5-50 alphanumeric characters.
    - For **Location**, select **Autonomous** and for **Pricing plan**, select **Standard**.

   :::image type="content" source="./media/disconnected-operations/azure-container-registry/basic-info.png" alt-text="Screenshot showing the basic information needed when creating a container registry." lightbox=" ./media/disconnected-operations/azure-container-registry/basic-info.png":::

4. Select **Review + create**. Review your settings and select **Create**.

5. When the **Your deployment is complete** message appears, select the container registry in the portal.

6. Note your registry name and the value of the **Login server**.
    - In Azure cloud, the login server is a fully qualified name ending with `azurecr.io`.
    - You need these values to push and pull images with Docker.

   :::image type="content" source="./media/disconnected-operations/azure-container-registry/login-server.png" alt-text="Screenshot showing the login server name for the container registry." lightbox=" ./media/disconnected-operations/azure-container-registry/login-server.png":::

## Assign RBAC to a container registry

In this section, you assign RBAC to a container registry on disconnected operations. For more information, see [Registry roles and permissions - Azure Container Registry](/azure/container-registry/container-registry-roles).

To assign the **AcrPull** role to a user and check the role assignment using the Docker CLI, follow these steps:

1. Navigate to your container registry and select **Access Control (IAM)**.

2. Select **Add role assignment** in the **Grant access to this resource** box.

   :::image type="content" source="./media/disconnected-operations/azure-container-registry/access-control.png" alt-text="Screenshot showing how to grant access to the resource using Access Control (IAM). " lightbox=" ./media/disconnected-operations/azure-container-registry/access-control.png":::

3. Filter the list of roles by **Category = Containers**. Select the appropriate role, then select **Next**.

   :::image type="content" source="./media/disconnected-operations/azure-container-registry/filter-category.png" alt-text="Screenshot showing how to filter a category for containers." lightbox=" ./media/disconnected-operations/azure-container-registry/filter-category.png":::

4. Select **+Select members**, choose the member you want to add to the role, select the **Select** button, and select **Next**.

   :::image type="content" source="./media/disconnected-operations/azure-container-registry/select-members.png" alt-text="Screenshot showing how to add a specific member or members to a role." lightbox=" ./media/disconnected-operations/azure-container-registry/select-members.png":::

5. Review your settings, then select **Review + Assign**.

## Manage images in Azure Container Registry

### Sign into the registry

> [!NOTE]
> You must sign into the registry instance before you push and pull container images. When you sign in with Azure CLI, specify only the registry resource name. Don't use the fully qualified login server name.

On your local machine, run the `az acr login` command.

```azurecli
az acr login --name <registry-name>
```

### Import a container image using Azure CLI

Import a container image to your container registry on disconnected operations using Azure CLI. In this example, we import the `mcr.microsoft.com/hello-world:latest` image into a registry.

To return a list of registries in your resource group, use the `az acr list` command.

```azurecli
az acr list -g <ResourceGroupName> -o table
```

To import a container image from a public repository to your container registry, use the `az acr import` command.

```azurecli
az acr import --name <registry-name> --source mcr.microsoft.com/hello-world:latest --image hello-world:latest
```

## Supported Azure Container Registry CLI commands

The following table lists supported Azure Container Registry CLI commands.

| Command | Description |  
|---------|-------------|  
| az acr check-name | Checks if an Azure Container Registry name is valid and available for use. |  
| az acr create | Creates an Azure Container Registry instance. |  
| az acr credential renew | Regenerates login credentials for an Azure Container Registry instance. |  
| az acr credential show | Gets the login credentials for an Azure Container Registry instance. |  
| az acr delete | Deletes an Azure Container Registry instance. |  
| az acr import | Imports an image to an Azure Container Registry from another Container Registry. Import removes the need to docker pull, docker tag, and docker push. |  
| az acr list | Lists all the container registries under the current subscription. |  
| az acr login | Logs in to an Azure Container Registry through the Docker CLI. |  
| az acr manifest list-metadata | Lists manifests of a repository in an Azure Container Registry. |  
| az acr repository delete | Deletes a repository or image in an Azure Container Registry. |  
| az acr repository list | Lists repositories in an Azure Container Registry. |  
| az acr repository show | Gets the attributes of a repository or image in an Azure Container Registry. |  
| az acr repository show-tags | Shows tags for a repository in an Azure Container Registry. |  
| az acr repository untag | Untags an image in an Azure Container Registry. |  
| az acr repository update | Updates the attributes of a repository or image in an Azure Container Registry. |  
| az acr show | Gets the details of an Azure Container Registry. |  
| az acr show-usage | Gets the storage usage for an Azure Container Registry. |  
| az acr update | Updates an Azure Container Registry. |  

## Unsupported capabilities

In this preview, viewing metrics for a container registry isn't supported.

::: moniker-end

::: moniker range="<=azloc-24111"

This feature is available only in Azure Local 2411.2.

::: moniker-end
