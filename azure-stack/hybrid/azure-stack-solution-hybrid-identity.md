---
title: Configure hybrid cloud identity with Azure and Azure Stack apps | Microsoft Docs
description: Learn how to configure hybrid cloud identity with Azure and Azure Stack apps.
author: BryanLa
ms.service: azure-stack
ms.topic: article
ms.date: 10/31/2019
ms.author: bryanla
ms.reviewer: anajod
ms.lastreviewed: 10/31/2019
---

# Configure hybrid cloud identity for Azure and Azure Stack applications

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

Learn how to configure a hybrid cloud identity for your Azure and Azure Stack apps.

You have two options for granting access to your apps in both global Azure and Azure Stack.

 * When Azure Stack has a continuous connection to the internet, you can use Azure Active Directory (Azure AD).
 * When Azure Stack is disconnected from the internet, you can use Azure Directory Federated Services (AD FS).

You use service principals to grant access to your Azure Stack apps for deployment or configuration using the Azure Resource Manager in Azure Stack.

In this solution, you'll build a sample environment to:

> [!div class="checklist"]
> - Establish a hybrid identity in global Azure and Azure Stack
> - Retrieve a token to access the Azure Stack API.

You must have Azure Stack operator permissions for the steps in this solution.

> [!Tip]  
> ![hybrid-pillars.png](./media/azure-stack-solution-cloud-burst/hybrid-pillars.png)  
> Microsoft Azure Stack is an extension of Azure. Azure Stack brings the agility and innovation of cloud computing to your on-premises environment, enabling the only hybrid cloud that allows you to build and deploy hybrid apps anywhere.  
> 
> The article [Design Considerations for Hybrid Applications](azure-stack-edge-pattern-overview.md) reviews pillars of software quality (placement, scalability, availability, resiliency, manageability, and security) for designing, deploying, and operating hybrid applications. The design considerations assist in optimizing hybrid app design, minimizing challenges in production environments.


## Create a service principal for Azure AD in the portal

If you deployed Azure Stack using Azure AD as the identity store, you can create service principals just like you do for Azure. [Use an app identity to access resources](../operator/azure-stack-create-service-principals.md#manage-an-azure-ad-service-principal) shows you how to perform the steps through the portal. Be sure you have the [required Azure AD permissions](/azure/azure-resource-manager/resource-group-create-service-principal-portal#required-permissions) before beginning.

## Create a service principal for AD FS using PowerShell

If you deployed Azure Stack with AD FS, you can use PowerShell to create a service principal, assign a role for access, and sign in from PowerShell using that identity. [Use an app identity to access resources](../operator/azure-stack-create-service-principals.md#manage-an-ad-fs-service-principal) shows you how to perform the required steps using PowerShell.

## Using the Azure Stack API

The [Azure Stack API](../user/azure-stack-rest-api-use.md)  solution walks you through the process of retrieving a token to access the Azure Stack API.

## Connect to Azure Stack using Powershell

The quickstart [to get up and running with PowerShell in Azure Stack](../operator/azure-stack-powershell-install.md)
walks you through the steps needed to install Azure PowerShell and connect to your Azure Stack installation.

### Prerequisites

You need an Azure Stack installation connected to Azure Active Directory with a subscription you can access. If you don't have an Azure Stack installation, you can use these instructions to set up an [Azure Stack Development Kit](../asdk/asdk-install.md).

#### Connect to Azure Stack using code

To connect to Azure Stack using code, use the Azure Resource Manager endpoints API to get the authentication and graph endpoints for your Azure Stack installation, and then authenticate using REST requests. You can find a sample client application on
[GitHub](https://github.com/shriramnat/HybridARMApplication).

>[!Note]
>Unless the Azure SDK for your language of choice supports Azure API Profiles, the SDK may not work with Azure Stack. To learn more about Azure API Profiles, see the [manage API version profiles](../user/azure-stack-version-profiles.md) article.

## Next steps

 - To learn more about how identity is handled in Azure Stack, see [Identity architecture for Azure Stack](../operator/azure-stack-identity-architecture.md).
 - To learn more about Azure Cloud Patterns, see [Cloud Design Patterns](https://docs.microsoft.com/azure/architecture/patterns).
