---
title: Deploy test applications to Azure Kubernetes Service on Azure Stack Hub
description: Learn how to deploy Prometheus and Grafana test apps to AKS on Azure Stack Hub. Follow this step-by-step guide to configure your cluster.
author: sethmanheim
ms.topic: install-set-up-deploy
ms.date: 07/08/2026
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 10/26/2021
ms.custom: sfi-ropc-nochange

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Deploy test applications to Azure Kubernetes Service on Azure Stack Hub

This article helps you get started with Azure Kubernetes Service (AKS) on Azure Stack Hub. It describes how to deploy test apps to your cluster so that you can become familiar with AKS on Azure Stack Hub. The functionality available in Azure Stack Hub is a [subset](aks-overview.md) of what is available in global Azure.

Before you get started, make sure that you can create an AKS cluster on your Azure Stack Hub instance. For instructions on getting set up and creating your first cluster, see [Using Azure Kubernetes Service on Azure Stack Hub with the CLI](aks-how-to-use-cli.md).

## Deploy test apps

If your stamp is connected, follow these instructions to deploy Prometheus and Grafana to the cluster.

1.  Download and install Helm 3:

    ```bash  
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    ```

    > [!NOTE]  
    > For Windows users, use [Chocolatey](https://chocolatey.org/install) to install Helm:
    >```powershell  
    >choco install kubernetes-helm
    >```

1.  Ensure you have the latest stable Helm repository.

    ```bash  
    helm repo add stable https://charts.helm.sh/stable
    helm repo update
    ```

1.  Install Prometheus.

    ```bash  
    helm install my-prometheus stable/prometheus --set server.service.type=LoadBalancer --set rbac.create=false
    ```

1.  Give cluster administrative access to the Prometheus account. Lower permissions are better for security reasons.

    ```bash  
    kubectl create clusterrolebinding my-prometheus-server --clusterrole=cluster-admin --serviceaccount=default:my-prometheus-server
    ```

1.  Install Grafana.

    ```bash  
    helm install my-grafana stable/grafana --set service.type=LoadBalancer --set rbac.create=false
    ```

1.  Get the secret for the Grafana portal.

    ```bash  
    kubectl get secret --namespace default my-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    ```

> [!NOTE]  
> On Windows, use the following PowerShell cmdlets to get the secret:
> ```powershell  
> \$env:Path = \$env:Path + ";\$env:USERPROFILE\\.azure-kubectl"
> [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String(\$(kubectl get secret --namespace default my-grafana -o jsonpath="{.data.admin-password}")))
> ```

## Deploy apps to AKS using ACR

At this point, your client machine is connected to the cluster and you can use **kubectl** to configure the cluster and deploy your applications. If you're also testing the Azure Container Registry (ACR) service, follow the instructions in the next section.

### Docker registry secret for accessing local ACR

If you're deploying application images from a local ACR, you need to store a secret so the Kubernetes cluster can access and pull the images from the registry. To create this secret, provide a service principal ID (SPN) and secret, add the SPN as a contributor to the source registry, and create the Kubernetes secret. You also need to update your YAML file to reference the secret.

### Add the SPN to the ACR

Add the SPN as a contributor to the ACR. 

> [!NOTE]  
> This script is modified from the [Azure Container Registry site](/azure/container-registry/container-registry-auth-service-principal) (bash [sample](https://github.com/Azure-Samples/azure-cli-samples/blob/master/container-registry/create-registry/create-registry-service-principal-assign-role.sh)) as Azure Stack Hub doesn't yet have the ACRPULL role. This sample is a PowerShell script. You can write an equivalent script in bash. Be sure to add the values for your system.

```azurecli  
# Modify for your environment. The ACR_NAME is the name of your Azure Container
# Registry, and the SERVICE_PRINCIPAL_ID is the SPN's 'appId' or
# one of its 'servicePrincipalNames' values.
ACR_NAME=mycontainerregistry
SERVICE_PRINCIPAL_ID=<service-principal-ID>

# Populate value required for subsequent command args
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

# Assign the desired role to the SPN. 
az role assignment create --assignee $SERVICE_PRINCIPAL_ID --scope $ACR_REGISTRY_ID --role contributor

```

### Create the secret in Kubernetes

Use the following command to add the secret to the Kubernetes cluster. Be sure to add the values for your system in the code snippets.

```bash
kubectl create secret docker-registry <secret name> \
kubectl create secret docker-registry <secret name> \
    --docker-server=<ACR container registry URL> \
    --docker-username=<service principal ID> \
    --docker-password=<service principal secret> 

```

### Example of referencing the secret in your app YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment 
spec:
selector:
  matchLabels:
   app: nginx
replicas: 2
template:
  metadata:
   labels:
    app: nginx
  spec:
   containers:
   - name: nginx
     image: democr2.azsacr.redmond.ext-n31r1208.masd.stbtest.microsoft.com/library/nginx:1.17.3
     imagePullPolicy: Always
     ports: 
      - containerPort: 80
   imagePullSecrets:
     - name: democr2
 
 
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  selector:
    app: nginx
  ports:
  - protocol: "TCP"
    port: 80
    targetPort: 80
  type: LoadBalancer
```

## Next steps

[Using Azure Kubernetes Service on Azure Stack Hub with the CLI](aks-how-to-use-cli.md)
