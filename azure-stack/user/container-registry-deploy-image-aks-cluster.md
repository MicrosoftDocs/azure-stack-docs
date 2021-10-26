---
title: Deploy an image to an Azure Kubernetes Service (AKS) Cluster on Azure Stack Hub 
description: Learn how to deploy an image to an AKS Cluster on Azure Stack Hub.
author: mattbriggs
ms.topic: how-to
ms.date: 10/26/201
ms.author: mabrigg
ms.reviewer: chasat
ms.lastreviewed: 10/26/201

# Intent: As an Azure Stack user, I want to XXX so I can XXX.
# Keyword: XXX

---

# Deploy an image to an Azure Kubernetes Service Cluster on Azure Stack Hub

You can use your Azure Stack Hub Azure Container Registry (ACR) to store images. You can use these images when you deploy to an Azure Kubernetes Service (AKS) cluster in the same environment.

## Deploy an app to your cluster

For steps on deploying a sample app to your AKS cluster, you can refer to the following tutorial, [Tutorial: Prepare an application for Azure Kubernetes Service (AKS)](/azure/aks/tutorial-kubernetes-prepare-app).

> [!NOTE]  
> The `-attach-acr` option when creating an Azure Kubernetes Service cluster is not yet supported. 
> You'll need to use a service principal (SPN) ID and corresponding secret, and use the same ID 
> and secret in Kubernetes, which is documented in the article, 
> "[Azure Container Registry authentication with service principals](/azure/container-registry/container-registry-auth-service-principal)."

## Key points

Two key points to remember from the online guidance are:

1. You'll need an SPN and will need to grant AcrPull access to the subscription, resource group, or container registry resource.
2. You'll need to create a secret in Kubernetes using that same SPN.

    ```powershell  
    $userSPNID = "<SPN GUID>"
    $userSPNSecret = "<SPN Secret GUID>"

    kubectl create secret docker-registry <Secret Name> `
        --docker-server=<myregistry>.azsacr.<region>.<fqdn> `
        --docker-username=$userSPNID `
        --docker-password=$userSPNSecret
    ```

1.  You'll need to update your YAML to reference the secret as part of the deployment, example:

```powershell  
   imagePullSecrets: `
     - name: <Secret Name>
```
## Next steps

Learn more about the [Azure Container Registry on Azure Stack Hub](container-registry-overview.md)
