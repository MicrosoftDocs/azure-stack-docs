﻿---
title: Tutorial - Prepare an application for AKS hybrid 
description: In this tutorial, learn how to prepare and build a multi-container app with Docker Compose that you can then deploy to AKS hybrid.
services: container-service
ms.topic: tutorial
ms.date: 10/07/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
author: sethmanheim

# Intent: As an IT Pro, I want to learn how to prepare a multi-purpose application so I can add it to my AKS on Azure Stack HCI deployment.
# Keyword: multi-container Kubernetes service

---

# Tutorial: Prepare an application for AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

In this tutorial, part one of seven, a multi-container application is prepared for use on a Kubernetes cluster when you're using Azure Kubernetes Service hybrid deployment options (AKS hybrid). Existing development tools such as Docker Compose are used to locally build and test an application. 

You learn how to:

> [!div class="checklist"]
> * Clone a sample application source from GitHub
> * Create a container image from the sample application source
> * Test the multi-container application in a local Docker environment

Once completed, the following application runs in your local development environment:

:::image type="content" source="./media/azure-vote-local.png" alt-text="This image shows the container image that the Azure Voting App running locally opened in a local web browser" lightbox="./media/azure-vote-local.png":::

In later tutorials, the container image is uploaded to an Azure Container Registry, and then deployed into an AKS cluster.

## Before you begin

This tutorial assumes a basic understanding of core Docker concepts such as containers, container images, and `docker` commands. For a primer on container basics, see [Get started with Docker][docker-get-started].

To complete this tutorial, you need a local Docker development environment running Linux containers. Docker provides packages that configure Docker on [Windows][docker-for-windows].

> [!NOTE]
> AKS hybrid does not include the Docker components required to complete every step in these tutorials. Therefore, we recommend using a full Docker development environment.

## Get application code

The [sample application][sample-application] used in this tutorial is a basic voting app consisting of a front-end web component and a back-end Redis instance. The web component is packaged into a custom container image. The Redis instance uses an unmodified image from Docker Hub.

Use [git][] to clone the sample application to your development environment:

```console
git clone https://github.com/Azure-Samples/azure-voting-app-redis.git
```

Change into the cloned directory.

```console
cd azure-voting-app-redis
```

Inside the directory is the application source code, a pre-created Docker compose file, and a Kubernetes manifest file. These files are used throughout the tutorial set. The contents and structure of the directory are as follows:

```output
azure-voting-app-redis
│   azure-vote-all-in-one-redis.yaml
│   docker-compose.yaml
│   LICENSE
│   README.md
│
├───azure-vote
│   │   app_init.supervisord.conf
│   │   Dockerfile
│   │   Dockerfile-for-app-service
│   │   sshd_config
│   │
│   └───azure-vote
│       │   config_file.cfg
│       │   main.py
│       │
│       ├───static
│       │       default.css
│       │
│       └───templates
│               index.html
│
└───jenkins-tutorial
        config-jenkins.sh
        deploy-jenkins-vm.sh
```

## Create container images

[Docker Compose][docker-compose] can be used to automate building container images and the deployment of multi-container applications.

Use the sample `docker-compose.yaml` file to create the container image, download the Redis image, and start the application:

```console
docker-compose up -d
```

When completed, use the [docker images][docker-images] command to see the created images. Three images have been downloaded or created. The *azure-vote-front* image contains the front-end application and uses the *nginx-flask* image as a base. The *redis* image is used to start a Redis instance.

```
$ docker images

REPOSITORY                                     TAG                 IMAGE ID            CREATED             SIZE
mcr.microsoft.com/azuredocs/azure-vote-front   v1                  84b41c268ad9        9 seconds ago       944MB
mcr.microsoft.com/oss/bitnami/redis            6.0.8               3a54a920bb6c        2 days ago          103MB
tiangolo/uwsgi-nginx-flask                     python3.6           a16ce562e863        6 weeks ago         944MB
```

Run the [docker ps][docker-ps] command to see the running containers:

```
$ docker ps

CONTAINER ID        IMAGE                                             COMMAND                  CREATED             STATUS              PORTS                           NAMES
d10e5244f237        mcr.microsoft.com/azuredocs/azure-vote-front:v1   "/entrypoint.sh /sta…"   3 minutes ago       Up 3 minutes        443/tcp, 0.0.0.0:8080->80/tcp   azure-vote-front
21574cb38c1f        mcr.microsoft.com/oss/bitnami/redis:6.0.8         "/opt/bitnami/script…"   3 minutes ago       Up 3 minutes        0.0.0.0:6379->6379/tcp          azure-vote-back
```

## Test application locally

To see the running application, enter `http://localhost:8080` in a local web browser. The sample application loads, as shown in the following example:

:::image type="content" source="./media/azure-vote-local.png" alt-text="Screenshot showing the container image that the Azure Voting App running locally opened in a local web browser" lightbox="./media/azure-vote-local.png":::

## Clean up resources

Now that the application's functionality has been validated, the running containers can be stopped and removed. ***Do not delete the container images*** - in the next tutorial, the *azure-vote-front* image is uploaded to an Azure Container Registry instance.

Stop and remove the container instances and resources with the [docker-compose down][docker-compose-down] command:

```console
docker-compose down
```

When the local application has been removed, you have a Docker image that contains the Azure Vote application, *azure-vote-front*, for use with the next tutorial.

## Next steps

In this tutorial, an application was tested and container images created for the application. You learned how to:

> [!div class="checklist"]
> * Clone a sample application source from GitHub
> * Create a container image from the sample application source
> * Test the multi-container application in a local Docker environment

Advance to the next tutorial to learn how to store container images in Azure Container Registry.

> [!div class="nextstepaction"]
> [Push images to Azure Container Registry](./tutorial-kubernetes-prepare-azure-container-registry.md)

<!-- LINKS - external -->
[docker-compose]: https://docs.docker.com/compose/
[docker-for-linux]: https://docs.docker.com/engine/installation/#supported-platforms
[docker-for-mac]: https://docs.docker.com/docker-for-mac/
[docker-for-windows]: https://docs.docker.com/docker-for-windows/
[docker-get-started]: https://docs.docker.com/get-started/
[docker-images]: https://docs.docker.com/engine/reference/commandline/images/
[docker-ps]: https://docs.docker.com/engine/reference/commandline/ps/
[docker-compose-down]: https://docs.docker.com/compose/reference/down
[git]: https://git-scm.com/downloads
[sample-application]: https://github.com/Azure-Samples/azure-voting-app-redis

<!-- LINKS - internal -->