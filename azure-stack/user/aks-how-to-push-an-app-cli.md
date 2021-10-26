---
title: Deploy test applications to Azure Kubernetes Service on Azure Stack Hub
description: Learn how to deploy test applications to Azure Kubernetes Service on Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 10/26/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 10/26/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Deploy test applications to Azure Kubernetes Service on Azure Stack Hub

This is a guide to get you started using the Azure Kubernetes Service (AKS) service on Azure Stack Hub. This article describes how to deploy some test apps to your cluster so that you can get familiarized with AKS on Azure Stack Hub. The functionality available in Azure Stack Hub is a [subset](aks-overview.md) of what is available in global Azure.

Before you get started, make sure that can create an AKS cluster on your Azure Stack Hub instance. For instruction on getting set-up and creating your first cluster, see [Using Azure Kubernetes Service on Azure Stack Hub with the CLI](aks-how-to-use-cli.md).

## Deploy test apps

If your stamp is connected, you can follow these instructions to deploy Prometheus and Grafana to the cluster.

1.  Download and install Helm 3:

    ```bash  
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    ```

    > [!NOTE]  
    > For Windows user use [Chocolatey](https://chocolatey.org/install) to install Helm:
    >```powershell  
    >choco install kubernetes-helm
    >```

1.  Ensure you have the latest stabled helm repository:

    ```bash  
    helm repo add stable https://charts.helm.sh/stable
    helm repo update
    ```

1.  Install Prometheus.

    ```bash  
    helm install my-prometheus stable/prometheus --set server.service.type=LoadBalancer --set rbac.create=false
    ```

1.  Give cluster administrative access to Prometheus account. Lower permissions are better for security reasons.

    ```bash  
    kubectl create clusterrolebinding my-prometheus-server --clusterrole=cluster-admin --serviceaccount=default:my-prometheus-server
    ```

1.  Install Grafana.

    ```bash  
    helm install my-grafana stable/grafana --set service.type=LoadBalancer --set rbac.create=false
    ```

1.  Get secret for Grafana portal.

    ```bash  
    kubectl get secret --namespace default my-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    ```

> [!NOTE]  
> On Windows use the following PowerShell cmdlets to get the secret:
> ```powershell  
> \$env:Path = \$env:Path + ";\$env:USERPROFILE\\.azure-kubectl"
> [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String(\$(kubectl get secret --namespace default my-grafana -o jsonpath="{.data.admin-password}")))
> ```

## Deploy apps to AKS using ACR

At this point, your client machine is connected to the cluster and you can proceed to use **kubectl** to configure the cluster and deploy your applications. If you are also testing the Azure Container Registry (ACR) service, you can follow the instructions below. Otherwise, you can skip to the section title [Upgrade the cluster](aks-how-to-use-cli.md#upgrade-cluster).

### Docker registry secret for accessing local ACR

If you are deploying application images from a local ACR, you will need to store a secret in order for the Kubernetes cluster to have access to pull the images from the registry. To do this you will need to provide a service principal ID (SPN) and Secret, add the SPN as a contributor to the source registry and create the Kubernetes secret. You will also need to update your YAML file to reference the secret.

### Add the SPN to the ACR

Add the SPN as a contributor to the ACR. 

> [!NOTE]  
> This script has been modified from the [Azure Container Registry site](/azure/container-registry/container-registry-auth-service-principal) (bash [sample](https://github.com/Azure-Samples/azure-cli-samples/blob/master/container-registry/service-principal-assign-role/service-principal-assign-role.sh)) as Azure Stack Hub does not yet have the ACRPULL role. This sample is a PowerShell script, equivalent can be written in bash. Be sure to add the values for your system.

```powershell  
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