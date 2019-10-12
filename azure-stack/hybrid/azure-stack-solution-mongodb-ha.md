---
title: Deploy a highly available MongoDB solution to Azure and Azure Stack | Microsoft Docs
description: Learn how to deploy a highly available MongoDB solution to Azure and Azure Stack
author: BryanLa
ms.service: azure-stack
ms.topic: article
ms.date: 10/31/2019
ms.author: bryanla
ms.reviewer: anajod
ms.lastreviewed: 10/31/2019
---

# Deploy a highly available MongoDB solution to Azure and Azure Stack

This article will step you through an automated deployment of a basic highly available (HA) MongoDB cluster with a disaster recovery (DR) site
across two Azure Stack environments. To learn more about MongoDB and high availability, see [Replica Set Members](https://docs.mongodb.com/manual/core/replica-set-members/).

In this solution, you'll create a sample environment to:

> [!div class="checklist"]
> - Orchestrate a deployment across two Azure Stacks
> - Use Docker to minimize dependency issues with Azure API Profiles
> - Deploy a basic highly available MongoDB cluster with a disaster recovery site


> [!Tip]  
> ![hybrid-pillars.png](./media/azure-stack-solution-cloud-burst/hybrid-pillars.png)  
> Microsoft Azure Stack is an extension of Azure. Azure Stack brings the agility and innovation of cloud computing to your on-premises environment, enabling the only hybrid cloud that allows you to build and deploy hybrid apps anywhere.  
> 
> The article [Design Considerations for Hybrid Applications](azure-stack-edge-pattern-overview.md) reviews pillars of software quality (placement, scalability, availability, resiliency, manageability, and security) for designing, deploying, and operating hybrid applications. The design considerations assist in optimizing hybrid app design, minimizing challenges in production environments.



## Architecture for MongoDB with Azure Stack

![highly available MongoDB in Azure Stack](media/azure-stack-solution-mongdb-ha/image1.png)

## Prerequisites for MongoDB with Azure Stack

  - Two connected Azure Stack Integrated Systems (Azure Stack), this deployment does not work on Azure Stack Development Kits (ASDKs). To
    learn more about Azure Stack, see [What is Azure Stack?](https://azure.microsoft.com/overview/azure-stack/)
      - A tenant subscription on each Azure Stack.    
      - **Make a note of each subscription ID and the Azure Resource Manager endpoint for each Azure Stack.**
  - An Azure Active Directory (Azure AD) service principal that has permissions to the tenant subscription on each Azure Stack. You may need to create two service principals if the Azure Stacks are deployed against different Azure AD tenants. To learn how to create a service principal for Azure Stack, see [Create service principals to give applications access to Azure Stack resources](https://docs.microsoft.com/azure-stack/user/azure-stack-create-service-principals).    
      - **Make a note of each service principal's application ID, client secret, and tenant name (xxxxx.onmicrosoft.com).**
  - Ubuntu 16.04 syndicated to each Azure Stack's Marketplace. To learn more about marketplace syndication, see [Download marketplace items from Azure to Azure Stack](https://docs.microsoft.com/azure-stack/operator/azure-stack-download-azure-marketplace-item).
  - [Docker for Windows](https://docs.docker.com/docker-for-windows/) installed on your local machine.

## Get the Docker image

Docker images for each deployment eliminate dependency issues between
different versions of Azure PowerShell.
1.  Make sure that Docker for Windows is using Windows containers.
2.  Run the following in an elevated command prompt to get the Docker container with the deployment scripts.
```powershell  
docker pull intelligentedge/mongodb-hadr:1.0.0
```

## Deploy the clusters

1.  Once the container image has been successfully pulled, start the image.\

    ```powershell  
    docker run -it intelligentedge/mongodb-hadr:1.0.0 powershell
    ```

2.  Once the container has started, you will be given an elevated PowerShell terminal in the container. Change directories to get to the deployment script.

    ```powershell  
    cd .\MongoHADRDemo\
    ```

3.  Run the deployment. Provide credentials and resource names where needed. HA refers to the Azure Stack where the HA cluster will be deployed, and DR to the Azure Stack where the DR cluster will be deployed.

    ```powershell
    .\Deploy-AzureResourceGroup.ps1 `
    -AzureStackApplicationId_HA "applicationIDforHAServicePrincipal" `
    -AzureStackApplicationSercet_HA "clientSecretforHAServicePrincipal" `
    -AADTenantName_HA "hatenantname.onmicrosoft.com" `
    -AzureStackResourceGroup_HA "haresourcegroupname" `
    -AzureStackArmEndpoint_HA "https://management.haazurestack.com" `
    -AzureStackSubscriptionId_HA "haSubscriptionId" `
    -AzureStackApplicationId_DR "applicationIDforDRServicePrincipal" `
    -AzureStackApplicationSercet_DR "ClientSecretforDRServicePrincipal" `
    -AADTenantName_DR "drtenantname.onmicrosoft.com" `
    -AzureStackResourceGroup_DR "drresourcegroupname" `
    -AzureStackArmEndpoint_DR "https://management.drazurestack.com" `
    -AzureStackSubscriptionId_DR "drSubscriptionId"
    ```

4.  Type `Y` to allow the NuGet provider to be installed, which will kick off the API Profile "2018-03-01-hybrid" modules to be installed.

5.  The HA resources will deploy first. Monitor the deployment and wait for it to complete. Once you have the message stating that the HA deployment is complete, you can check the HA Azure Stack's portal to see the resources deployed. 

6.  Continue with the deployment of DR resources and decide if you'd like to enable a jump box on the DR Azure Stack to interact with the cluster.

7.  Wait for DR resource deployment to complete.

8.  Once DR resource deployment has completed, exit the container.

  ```powershell
  exit
  ```

## Next steps

  - If you enabled the jump box VM on the DR Azure Stack, you can connect via SSH and interact with the MongoDB cluster by installing the mongo CLI. To learn more about interacting with MongoDB, see [The mongo Shell](https://docs.mongodb.com/manual/mongo/).

  - Learn more about hybrid cloud applications, see [Hybrid Cloud Solutions.](https://aka.ms/azsdevtutorials)

  - Modify the code to this sample on [GitHub](https://github.com/Azure-Samples/azure-intelligent-edge-patterns).
