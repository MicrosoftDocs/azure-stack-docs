---
title: Deploy apps in Azure Kubernetes Service on Azure Stack HCI and Windows Server
description: In this Azure Kubernetes Service on Azure Stack HCI and Windows Server tutorial, learn how to deploy a multi-container application to a cluster using a custom image stored in Azure Container Registry.
services: container-service
ms.topic: tutorial
ms.date: 06/06/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
author: sethmanheim

# Intent: As an IT Pro, I want step-by-step instructions on how to deploy an application into a Kubernetes cluster so that the cluster manage the availability and connectivity.
# Keyword: deploy apps

---

# Tutorial: Deploy apps in Azure Kubernetes Service on Azure Stack HCI and Windows Server

You can build and deploy your own apps and services into a Kubernetes cluster on Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server. Kubernetes provides a distributed platform for containerized apps. You can let the cluster manage the availability and connectivity. This tutorial, part four of seven, describes how you can deploy a sample application into a Kubernetes cluster.

You will learn how to:

> [!div class="checklist"]
> * Update a Kubernetes manifest file
> * Deploy an application in Kubernetes
> * Test the application

Later tutorials describe how to scale and update this application.

This quickstart assumes a basic understanding of Kubernetes concepts.

## Before you begin

Previous tutorials described how to package an application into a container image, and then upload the image to the Azure Container Registry and create a Kubernetes cluster.

To complete this tutorial, you will need the pre-created `azure-vote-all-in-one-redis.yaml` Kubernetes manifest file. This file was downloaded with the application source code in a previous tutorial. Verify that you've cloned the repo, and that you have changed directories into the cloned repo. If you haven't done these steps, start with [Tutorial 1 - Create container images][aks-tutorial-prepare-application.md].

This tutorial requires Azure CLI version 2.0.53 or later. Run `az --version` to find the version. If you need to install it or upgrade, see [Install Azure CLI][azure-cli-install].

## Update the manifest file

In these tutorials, an Azure Container Registry (ACR) instance stores the container image for the sample application. To deploy the application, you must update the image name in the Kubernetes manifest file to include the ACR login server name.

Get the ACR login server name using the [az acr list][az-acr-list] command as follows:

```azurecli
az acr list --resource-group myResourceGroup --query "[].{acrLoginServer:loginServer}" --output table
```

The sample manifest file from the git repo cloned in the first tutorial uses the login server name of *microsoft*. Make sure that you're in the cloned *azure-voting-app-redis* directory, then open the manifest file with a text editor, such as `notepad`:

```console
notepad azure-vote-all-in-one-redis.yaml
```

Replace *microsoft* with your ACR login server name. The image name is found on line 60 of the manifest file. The following example shows the default image name:

```yaml
containers:
- name: azure-vote-front
  image: mcr.microsoft.com/azuredocs/azure-vote-front:v1
```

Provide your own ACR login server name so that your manifest file looks like the following example:

```yaml
containers:
- name: azure-vote-front
  image: <acrName>.azurecr.io/azure-vote-front:v1
```

Save and close the file.

## Deploy the application

To deploy your application, use the [kubectl apply][kubectl-apply] command. This command parses the manifest file and creates the defined Kubernetes objects. Specify the sample manifest file, as shown in the following example:

```console
kubectl apply -f azure-vote-all-in-one-redis.yaml
```

The following example output shows the resources successfully created in the AKS on Azure Stack HCI and Windows Server cluster:

```console
$ kubectl apply -f azure-vote-all-in-one-redis.yaml

deployment "azure-vote-back" created
service "azure-vote-back" created
deployment "azure-vote-front" created
service "azure-vote-front" created
```

## Test the application

When the application runs, a Kubernetes service exposes the application front end to the internet. This process can take a few minutes to complete.

To monitor progress, use the [kubectl get service][kubectl-get] command with the `--watch` argument.

```console
kubectl get service azure-vote-front --watch
```

Initially the *EXTERNAL-IP* for the *azure-vote-front* service is shown as *pending*:

```output
azure-vote-front   LoadBalancer   10.0.34.242   <pending>     80:30676/TCP   5s
```

When the *EXTERNAL-IP* address changes from *pending* to an actual public IP address, use `CTRL-C` to stop the `kubectl` watch process. The following example output shows a valid public IP address assigned to the service:

```output
azure-vote-front   LoadBalancer   10.0.34.242   52.179.23.131   80:30676/TCP   67s
```

To see the application in action, open a web browser to the external IP address of your service:

:::image type="content" source="./media/azure-vote.png" alt-text="Screenshot showing the container image Azure Voting App running in an AKS cluster opened in a local web browser" lightbox="./media/azure-vote.png":::

If the application didn't load, it might be due to an authorization problem with your image registry. To view the status of your containers, use the `kubectl get pods` command. If the container images can't be pulled, see [Authenticate with Azure Container Registry from Azure Kubernetes Service](/azure/aks/cluster-container-registry-integration?bc=%2fazure%2fcontainer-registry%2fbreadcrumb%2ftoc.json&toc=%2fazure%2fcontainer-registry%2ftoc.json).

## Next steps

In this tutorial, you deployed a sample Azure vote application to a Kubernetes cluster in AKS on Azure Stack HCI and Windows Server. You learned how to:

> [!div class="checklist"]
> * Update a Kubernetes manifest files
> * Run an application in Kubernetes
> * Test the application

Advance to the next tutorial to learn how to scale a Kubernetes application and the underlying Kubernetes infrastructure.

> [!div class="nextstepaction"]
> [Scale Kubernetes application and infrastructure](./tutorial-kubernetes-scale.md)

<!-- LINKS - external -->
[kubectl-apply]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply
[kubectl-create]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#create
[kubectl-get]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get

<!-- LINKS - internal -->
[aks-tutorial-prepare-app]: ./tutorial-kubernetes-prepare-app.md
[aks-tutorial-scale]: ./tutorial-kubernetes-scale.md
[az-acr-list]: /cli/azure/acr
[azure-cli-install]: /cli/azure/install-azure-cli
[kubernetes-concepts]: concepts-clusters-workloads.md
[kubernetes-service]: concepts-network.md#services