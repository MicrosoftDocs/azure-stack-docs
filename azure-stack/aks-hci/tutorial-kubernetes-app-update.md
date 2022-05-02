---
title:  Tutorial - Update an application in Azure Kubernetes Service on Azure Stack HCI
description: In this tutorial, learn how to update an existing application deployment with a new version of the application code.
services: container-service
ms.topic: tutorial
ms.date: 04/29/2022
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
author: mattbriggs
# Intent: As an IT Pro, I need step-by-step instructions on how to update an existing application deployment in order to use a new version of the application code.
# Keyword: update application tutorial container image
---

# Tutorial: Update an application in Azure Kubernetes Service on Azure Stack HCI

After you deploy an application in Kubernetes, you can update it by specifying a new container image or image version. You should stage an update so that only a portion of the deployment is updated at the same time. This staged update enables the application to keep running during the update. It also provides a rollback mechanism if a deployment failure occurs.

This tutorial, part six of seven, describes how to update the sample Azure Vote app. You will learn how to:

> [!div class="checklist"]
> * Update the front-end application code
> * Create an updated container image
> * Push the container image to Azure Container Registry
> * Deploy the updated container image

## Before you begin

In previous tutorials you learned how to:
- Package an application into a container image and upload the image to Azure Container Registry.
- Create an AKS on Azure Stack HCI cluster and deploy the application to the cluster.
-  Clone an application repository that includes the application source code and a pre-created Docker Compose file you can use in this tutorial. 

Verify that you've created a clone of the repo, and have changed directories into the cloned directory. If you haven't completed these steps, start with [Tutorial 1 – Create container images](tutorial-kubernetes-prepare-application.md).

This tutorial requires that you run the Azure CLI version 2.0.53 or later. Run `az --version` to find the version. If you need to install or upgrade, see [Install Azure CLI][azure-cli-install].

## Update an application

This section describes how to make a change to the sample application, and then update the version already deployed to your AKS on Azure Stack HCI cluster. Make sure that you're in the cloned *azure-voting-app-redis* directory. The sample application source code can then be found inside the *azure-vote* directory. Open the *config_file.cfg* file with an editor, such as `notepad`:

```console
notepad azure-vote/azure-vote/config_file.cfg
```

Change the values for *VOTE1VALUE* and *VOTE2VALUE* to different values, such as colors. The following example shows the updated values:

```
# UI Configurations
TITLE = 'Azure Voting App'
VOTE1VALUE = 'Blue'
VOTE2VALUE = 'Purple'
SHOWHOST = 'false'
```

Save and close the file.

## Update the container image

To re-create the front-end image and test the updated application, use [docker-compose][docker-compose]. The `--build` argument is used to S to re-create the application image:

```console
docker-compose up --build -d
```

## Test the application locally

To verify that the updated container image shows your changes, open a local web browser to `http://localhost:8080`.

:::image type="content" source="media/vote-app-updated.png" alt-text="Screenshot showing an example of the updated container image Azure Voting App running locally opened in a local web browser":::

The updated values provided in the *config_file.cfg* file are displayed in your running application.

## Tag and push the image

To correctly use the updated image, tag the *azure-vote-front* image with the login server name of your ACR registry. Get the login server name with the [az acr list](/cli/azure/acr) command:

```azurecli
az acr list --resource-group myResourceGroup --query "[].{acrLoginServer:loginServer}" --output table
```

Use [docker tag][docker-tag] to tag the image. Replace `<acrLoginServer>` with your ACR login server name or public registry hostname, and update the image version to *:v2* as follows:

```console
docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1 <acrLoginServer>/azure-vote-front:v2
```

Now use [docker push][docker-push] to upload the image to your registry. Replace `<acrLoginServer>` with your ACR login server name.

> [!NOTE]
> If you experience issues pushing to your ACR registry, make sure that you are still logged in. Run the [az acr login][az-acr-login] command using the name of your Azure Container Registry that you created in the [Create an Azure Container Registry](tutorial-kubernetes-prepare-azure-container-registry.md) step. For example, `az acr login --name <azure container registry name>`.

```console
docker push <acrLoginServer>/azure-vote-front:v2
```

## Deploy the updated application

To provide maximum uptime, you must run multiple instances of the application pod. Verify the number of running front-end instances with the [kubectl get pods][kubectl-get] command:

```
$ kubectl get pods

NAME                               READY     STATUS    RESTARTS   AGE
azure-vote-back-217588096-5w632    1/1       Running   0          10m
azure-vote-front-233282510-b5pkz   1/1       Running   0          10m
azure-vote-front-233282510-dhrtr   1/1       Running   0          10m
azure-vote-front-233282510-pqbfk   1/1       Running   0          10m
```

If you don't have multiple front-end pods, scale the *azure-vote-front* deployment as follows:

```console
kubectl scale --replicas=3 deployment/azure-vote-front
```

To update the application, use the [kubectl set][kubectl-set] command. Update `<acrLoginServer>` with the login server or host name of your container registry, and specify the *v2* application version:

```console
kubectl set image deployment azure-vote-front azure-vote-front=<acrLoginServer>/azure-vote-front:v2
```

To monitor the deployment, use the [kubectl get pod][kubectl-get] command. As the updated application is deployed, your pods are terminated and re-created with the new container image.

```console
kubectl get pods
```

The following example output shows pods terminating and new instances running as the deployment progresses:

```
$ kubectl get pods

NAME                               READY     STATUS        RESTARTS   AGE
azure-vote-back-2978095810-gq9g0   1/1       Running       0          5m
azure-vote-front-1297194256-tpjlg  1/1       Running       0          1m
azure-vote-front-1297194256-tptnx  1/1       Running       0          5m
azure-vote-front-1297194256-zktw9  1/1       Terminating   0          1m
```

## Test the updated application

To view the update application, first get the external IP address of the `azure-vote-front` service:

```console
kubectl get service azure-vote-front
```

Next, open a web browser to the IP address of your service:

:::image type="content" source="media/vote-app-updated-external.png" alt-text="Screenshot showing an example of the updated image Azure Voting App running in an AKS cluster opened in a local web browser.":::

## Next steps

In this tutorial, you updated an application and rolled out this update to your AKS cluster. You learned how to:

> [!div class="checklist"]
> * Update the front-end application code
> * Create an updated container image
> * Push the container image to Azure Container Registry
> * Deploy the updated container image

Advance to the next tutorial to learn how to upgrade an AKS cluster to a new version of Kubernetes.

> [!div class="nextstepaction"]
> [Upgrade Kubernetes](./tutorial-kubernetes-upgrade-cluster.md)

<!-- LINKS - external -->
[docker-compose]: https://docs.docker.com/compose/
[docker-push]: https://docs.docker.com/engine/reference/commandline/push/
[docker-tag]: https://docs.docker.com/engine/reference/commandline/tag/
[kubectl-get]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get
[kubectl-set]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#set

<!-- LINKS - internal -->
[az-acr-login]: /cli/azure/acr
[azure-cli-install]: /cli/azure/install-azure-cli
