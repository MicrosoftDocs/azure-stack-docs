---
title: Deploy from a private container registry to on-premises Kubernetes using Azure Container Registry to  Azure Kubernetes Service on Azure Stack HCI and Windows Server
description: Learn how to deploy from a private container registry to on-premises Kubernetes using Azure Container Registry and AKS on Azure Stack HCI and Windows Server.
author: mattbriggs
ms.topic: how-to
ms.date: 03/16/2022
ms.author: mabrigg 
ms.lastreviewed: 03/16/2022
ms.reviewer: rbaziwane
ms.custom: contperf-fy22q3

# Intent: As a developer, I want to deploy a container image from a private container registry to AKS on Azure Stack HCI and Windows Server.
# Keyword: private container registry Kubernetes on-premises

---

# Deploy from a private container registry to on-premises Kubernetes using Azure Container Registry and Azure Kubernetes Service on Azure Stack HCI and Windows Server

In this guide, you'll learn how to deploy container images from a private container registry using Azure Container Registry (ACR). You'll deploy to your on-premises Kubernetes cluster hosted by Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server. ACR allows you to build, store, and manage container images and artifacts in a private registry for all types of container deployments. The guide walks you through creating a private container registry in Azure and then pushing your container image to the private container registry. You can then deploy from the private registry to your on-premises Kubernetes cluster hosted in AKS on Azure Stack HCI and Windows Server.

This guide looks at using ACR on Azure Stack HCI, which you can run in your own datacenter. If you're interested in learning more about ACR in Azure, see [Azure Container Registry documentation](/azure/container-registry/).
## Prerequisites

Verify that you've the following:
- A basic understanding of [Kubernetes concepts](kubernetes-concepts.md). 
- An AKS on Azure Stack HCI and Windows Server cluster that's up and running.
- [Azure CLI installed](/cli/azure/install-azure-cli)
- Your local `kubectl` environment configured to point to your AKS on Azure Stack HCI and Windows Server cluster. You can use the [Get-AksHciCredential](./reference/ps/get-akshcicredential.md) PowerShell command to configure your cluster for access using `kubectl`.

## Create a private container registry in Azure

To create an ACR, you first need a resource group. An Azure resource group is a logical container into which Azure resources are deployed and managed. Create a resource group with the [az group create](/cli/azure/group#az-group-create) command. In the following example, a resource group in the *eastus* region is created:

```azurecli
az group create --name <RESOURCE_GROUP_NAME> --location eastus
```

Create an ACR instance with the [az acr create](/cli/azure/acr) command and provide your own registry name. The registry name must be unique within Azure and contain 5-50 alphanumeric characters. In the rest of this article, `<acrName>` is used as a placeholder for the container registry name, and you'll provide your own unique registry name. The *Basic* SKU is a cost-optimized entry point for development purposes that provides a balance of storage and throughput.

```azurecli
az acr create --resource-group <RESOURCE_GROUP_NAME> --name <REGISTRY_NAME> --sku Basic
```

Once your container registry has been created, use the following command to create a service principal, so you can access your container registry from Kubernetes: 

```azurecli
az ad sp create-for-rbac
  --scopes /subscriptions/<SUBSCRIPTION_ID>/resourcegroups/<RG_NAME>/providers/Microsoft.ContainerRegistry/registries/<REGISTRY_NAME>
  --role Contributor
  --name <SERVICE_PRINCIPAL_NAME>
```

ACR supports three access roles. The **Contributor** role is the most common for application developers, however, in real world scenarios, you might need to create multiple service principals depending on the type of access needed:

- **Contributor**: This role offers push and pull access to the repository.
- **Reader**: This role only allows pull access to the repository.
- **Owner**: This role enables you to assign roles to other users, in addition to the push and pull access to the repository.

The above command should produce an output similar to the following:

```output
{
 "appId": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
 "displayName": "akshci-service-principal",
 "name": "http://akshci-service-principal",
 "password": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
 "tenant": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
```

Once the service principal has been successfully created, copy the `appId` and `password` in a safe location to use later in your deployment.

For more about working with service principals and ACR, see [Azure Container Registry authentication with service principals](/azure/container-registry/container-registry-auth-service-principal).

## Sign in to the private container registry

To use the ACR instance, you must first sign in. You can use either the Azure CLI or the Docker CLI to sign in.

### Option 1: Sign in from the Azure CLI

Use the [az acr sign in](/cli/azure/acr#az-acr-login) command and provide the unique name given to the container registry in the previous step.

```azurecli
az acr login --name <REGISTRY_NAME>
```

### Option 2: Sign in from the Docker CLI

To use the Docker CLI to access your container registry, type the following command in a Bash or PowerShell terminal:

```powershell
docker login <REGISTRY_NAME>.azurecr.io -u <appId> -p <password>
```

In either option, the command should return a *sign in Succeeded* message once completed.

## Push an image to the ACR

Once you're successfully logged in, you can start pushing the image to the ACR. First, let's run the `docker images` command to view the list of images on your local machine:

```output
REPOSITORY                               TAG                                      IMAGE ID       CREATED         SIZE
mcr.microsoft.com/azure-functions/dotnet 3.0                                      9f8ad1bdee67   5 months ago    540MB
poemfinder-app                           latest                                   2d9bef425603   6 months ago    208MB
```

To get started, you'll need to tag the image using the `docker tag` command, then use `docker push` to push it to the ACR. 

```powershell
docker tag poemfinder-app <REGISTRY_NAME>.azurecr.io/poemfinder-app:v1.0
```

Verify that the image has been correctly tagged by running the `docker images` command again. After confirming, run `docker push` to push to the ACR as shown below:

```powershell
docker push <REGISTRY_NAME>.azurecr.io/poemfinder-app:v1.0
```

To confirm that the image was successfully pushed to the ACR, you can run the following command:

```azurecli
az acr repository list --name <REGISTRY_NAME>.azurecr.io --output table
```

## Deploy an image from the ACR to AKS on Azure Stack HCI and Windows Server

To deploy your container image from the ACR to your Kubernetes cluster, you need to create *Kubernetes Secrets* to store your registry credentials. Kubernetes uses an *image pull secret* to store information needed to authenticate to your registry. To create the pull secret for an ACR, you provide the service principal ID, the password, and the registry URL.

```
kubectl create secret docker-registry <secret-name> \
    --namespace <namespace> \
    --docker-server=<REGISTRY_NAME>.azurecr.io \
    --docker-username=<appId> \
    --docker-password=<password>
```

where:

| Value             | Description                                                  |
| :---------------- | :----------------------------------------------------------- |
| `secret-name`     | Name of the image pulls secret, for example, *acr-secret*     |
| `namespace`       | Kubernetes namespace to put the secret into Only needed if you want to place the secret in a namespace other than the default namespace |
| `<REGISTRY_NAME>` | Name of your ACR, for example, *myregistry*  The `--docker-server` is the fully qualified name of the registry sign in server |
| `appId`           | ID of the service principal that will be used by Kubernetes to access your registry |
| `password`        | Service principal password                                   |

Once you've created the image pull secret, you can use it to create Kubernetes pods and deployments. Provide the name of the secret under `imagePullSecrets` in the deployment file as shown in the example below:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: poemfinder-app
  namespace: mydemoapps
spec:
  containers:
    - name: poemfinder-app
      image: <REGISTRY_NAME>.azurecr.io/poemfinder-app:v1.0
      imagePullPolicy: IfNotPresent
  imagePullSecrets:
    - name: acr-secret
```

In the preceding example, `poemfinder-app:v1.0` is the name of the image to pull from the ACR, and `acr-secret` is the name of the pull secret you created to access the registry. When you deploy the pod, Kubernetes automatically pulls the image from your registry, if it isn't already present on the cluster. 

You can save the above pod configuration in a file such as `pod-example.yaml`, and then deploy it to Kubernetes as shown below:

```powershell
kubectl create -f pod-example.yaml
```

To confirm that the pod was successfully created using the container image from the ACR, run `kubectl describe pod <POD_NAME>`, which should show the container image used to create the pod. 

## Next steps

In this article, you learned how to deploy a container image from the ACR to AKS on Azure Stack HCI and Windows Server. Next, you can:
- [Create and manage multiple node pools for a cluster in Azure Kubernetes Service on Azure Stack HCI](./use-node-pools.md)
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).
