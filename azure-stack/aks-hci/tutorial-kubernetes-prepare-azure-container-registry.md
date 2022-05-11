---
title: Tutorial - Create a container registry in Azure Kubernetes Service on Azure Stack HCI and Windows Server
description: In this tutorial, you will learn how to create an Azure Container Registry instance and upload a sample application container image.
services: container-service
ms.topic: tutorial
ms.date: 04/14/2022
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
author: mattbriggs
# Intent: As an IT Pro, I need step-by-step instructions on how to create an Azure Container Registry instance so I can  upload an application container image.
# Keyword: container registry container images
---

# Tutorial: Deploy and use an Azure Container Registry

An Azure Container Registry (ACR) is a private registry for container images. A private container registry lets you securely build and deploy your applications and custom code. In this tutorial, part two of seven, you deploy an ACR instance and push a container image to it. You'll learn how to:

> [!div class="checklist"]
> * Create an Azure Container Registry (ACR) instance
> * Tag a container image for ACR
> * Upload the image to ACR
> * View images in your registry

In later tutorials, this ACR instance is integrated with a Kubernetes cluster in Azure Kubernetes Service (AKS)on Azure Stack HCI and Windows Server, and an application is deployed from the image.

## Before you begin

The [previous tutorial](tutorial-kubernetes-prepare-application.md) described how to create a container image for a simple Azure Voting application. If you have not created the Azure Voting app image, return to [Tutorial 1 – Create container images](tutorial-kubernetes-prepare-application.md).

This tutorial requires that you run the Azure CLI version 2.0.53 or later. Run `az --version` to find the version. If you need to install or upgrade, see [Install Azure CLI][azure-cli-install].

## Create an Azure Container Registry

To create an Azure Container Registry, you first need a *resource group*. An Azure resource group is a logical container into which Azure resources are deployed and managed.

Create a resource group with the [az group create][az-group-create] command. In the following example, a resource group named *myResourceGroup* is created in the *eastus* region:

```azurecli
az group create --name myResourceGroup --location eastus
```

Create an Azure Container Registry instance with the [az acr create][az-acr-create] command and provide your own registry name. The registry name must be unique within Azure, and contain 5-50 alphanumeric characters. In the rest of this tutorial, `<acrName>` is used as a placeholder for the container registry name. Provide your own unique registry name. The *Basic* SKU is a cost-optimized entry point for development purposes that provides a balance of storage and throughput.

```azurecli
az acr create --resource-group myResourceGroup --name <acrName> --sku Basic
```

## Log in to the container registry

To use the ACR instance, you must first log in. Use the [az acr login][az-acr-login] command and provide the unique name given to the container registry in the previous step.

```azurecli
az acr login --name <acrName>
```

The command returns a *Login Succeeded* message once completed.

## Tag a container image

To see a list of your current local images, use the [docker images][docker-images] command:

```console
docker images
```
The above command's output shows list of your current local images:

```output
REPOSITORY                                     TAG                 IMAGE ID            CREATED             SIZE
mcr.microsoft.com/azuredocs/azure-vote-front   v1                  84b41c268ad9        7 minutes ago       944MB
mcr.microsoft.com/oss/bitnami/redis            6.0.8               3a54a920bb6c        2 days ago          103MB
tiangolo/uwsgi-nginx-flask                     python3.6           a16ce562e863        6 weeks ago         944MB
```

To use the *azure-vote-front* container image with ACR, make sure you tag the image with the login server address of your registry. This tag is used for routing when pushing container images to an image registry.

To get the login server address, use the [az acr list][az-acr-list] command and query for the *loginServer* as follows:

```azurecli
az acr list --resource-group myResourceGroup --query "[].{acrLoginServer:loginServer}" --output table
```

Now, tag your local *azure-vote-front* image with the *acrLoginServer* address of the container registry. To indicate the image version, add *:v1* to the end of the image name:

```console
docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1 <acrLoginServer>/azure-vote-front:v1
```

To verify the tags are applied, run [docker images][docker-images] again.

```console
docker images
```

An image is tagged with the ACR instance address and a version number.

```
REPOSITORY                                      TAG                 IMAGE ID            CREATED             SIZE
mcr.microsoft.com/azuredocs/azure-vote-front    v1                  84b41c268ad9        16 minutes ago      944MB
mycontainerregistry.azurecr.io/azure-vote-front v1                  84b41c268ad9        16 minutes ago      944MB
mcr.microsoft.com/oss/bitnami/redis             6.0.8               3a54a920bb6c        2 days ago          103MB
tiangolo/uwsgi-nginx-flask                      python3.6           a16ce562e863        6 weeks ago         944MB
```

## Push images to registry

With your image built and tagged, push the *azure-vote-front* image to your ACR instance. Use [docker push][docker-push] and provide your own *acrLoginServer* address for the image name as follows:

```console
docker push <acrLoginServer>/azure-vote-front:v1
```

It may take a few minutes to complete the image push to ACR.

## List images in registry

To return a list of images that have been pushed to your ACR instance, use the [az acr repository list][az-acr-repository-list] command. Provide your own `<acrName>` as follows:

```azurecli
az acr repository list --name <acrName> --output table
```

The following example output lists the *azure-vote-front* image as available in the registry:

```output
Result
----------------
azure-vote-front
```

To see the tags for a specific image, use the [az acr repository show-tags][az-acr-repository-show-tags] command as follows:

```azurecli
az acr repository show-tags --name <acrName> --repository azure-vote-front --output table
```

The following example output shows the *v1* image tagged in a previous step:

```output
Result
--------
v1
```

You now have a container image that is stored in a private Azure Container Registry instance. This image is deployed from ACR to a Kubernetes cluster in the next tutorial.

## Next steps

In this tutorial, you created an Azure Container Registry and pushed an image for use in an AKS on Azure Stack HCI and Windows Server cluster. You learned how to:

> [!div class="checklist"]
> * Create an Azure Container Registry (ACR) instance
> * Tag a container image for ACR
> * Upload the image to ACR
> * View images in your registry

Advance to the next tutorial to learn how to deploy a Kubernetes cluster in Azure.

> [!div class="nextstepaction"]
> [Deploy Kubernetes cluster](./tutorial-kubernetes-deploy-cluster.md)

<!-- LINKS - external -->
[docker-images]: https://docs.docker.com/engine/reference/commandline/images/
[docker-push]: https://docs.docker.com/engine/reference/commandline/push/

<!-- LINKS - internal -->
[az-acr-create]: /cli/azure/acr
[az-acr-list]: /cli/azure/acr
[az-acr-login]: /cli/azure/acr#az-acr-login
[az-acr-list]: /cli/azure/acr#az-acr-list
[az-acr-repository-list]: /cli/azure/acr/repository
[az-acr-repository-show-tags]: /cli/azure/acr/repository
[az-group-create]: /cli/azure/group#az_group_create
[azure-cli-install]: /cli/azure/install-azure-cli
