---
title: Deploy an image to an Azure Kubernetes Service (AKS) Cluster on Azure Stack Hub 
description: Learn how to deploy an image to an AKS Cluster on Azure Stack Hub.
author: sethmanheim
ms.topic: how-to
ms.date: 07/26/2024
ms.author: sethm
ms.reviewer: dgarrity
ms.lastreviewed: 04/10/2024

# Intent: As an Azure Stack Hub user, I want to deploy an image to an AKS cluster on Azure Stack Hub so that I can run my containerized applications.
---

# Deploy an image to an Azure Kubernetes Service cluster on Azure Stack Hub

You can use your Azure Stack Hub Azure Container Registry to store images. You can use these images when you deploy to an Azure Kubernetes Service (AKS) cluster in the same environment.

## Deploy an app to your cluster

To deploy a sample app to your AKS cluster, see [Tutorial: Prepare an application for Azure Kubernetes Service (AKS)](/azure/aks/tutorial-kubernetes-prepare-app).

> [!NOTE]  
> The `-attach-acr` option when creating an Azure Kubernetes Service cluster is not yet supported.
> You must use a service principal (SPN) ID and corresponding secret, and use the same ID and secret in Kubernetes. For more information, see
> [Azure Container Registry authentication with service principals](/azure/container-registry/container-registry-auth-service-principal).

## Considerations

The following considerations to remember from the online guidance are:

- You need an SPN and must grant AcrPull access to the subscription, resource group, or container registry resource.
- You must create a secret in Kubernetes using that same SPN:

   ```powershell  
   $userSPNID = "<SPN GUID>"
   $userSPNSecret = "<SPN Secret GUID>"

   kubectl create secret docker-registry <secret name> `
       --docker-server=<myregistry>.azsacr.<region>.<fqdn> `
       --docker-username=$userSPNID `
       --docker-password=$userSPNSecret
   ```

- Update your YAML to reference the secret as part of the deployment:

   ```powershell  
   imagePullSecrets: `
     - name: <secret name>
   ```

## Next steps

Learn more about [Azure Container Registry on Azure Stack Hub](container-registry-overview.md)
