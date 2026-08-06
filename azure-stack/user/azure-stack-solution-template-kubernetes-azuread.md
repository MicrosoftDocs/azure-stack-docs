---
title: Deploy Kubernetes to Azure Stack Hub using Microsoft Entra ID
description: Learn how to deploy Kubernetes on Azure Stack Hub with Microsoft Entra ID. Set up service principals, configure cluster settings, and deploy in one operation.
author: sethmanheim

ms.topic: install-set-up-deploy
ms.date: 07/08/2026
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 3/12/2020
ms.custom: sfi-image-nochange

# Intent: As an Azure Stack user, I want to deploy Kubernetes using Microsoft Entra ID so I can use Kubernetes with the Microsoft Entra identity management system.
# Keyword: deploy kubernetes Microsoft Entra ID

---


# Deploy Kubernetes to Azure Stack Hub using Microsoft Entra ID

> [!NOTE]  
> Use the Kubernetes Azure Stack Marketplace item only to deploy clusters as a proof of concept. For supported Kubernetes clusters on Azure Stack Hub, use [the AKS engine](azure-stack-kubernetes-aks-engine-overview.md).

You can follow the steps in this article to deploy and set up the resources for Kubernetes when using Microsoft Entra ID as your identity management service, in a single, coordinated operation.

## Prerequisites

To get started, make sure you have the right permissions and that your Azure Stack Hub is ready.

1. Verify that you can create applications in your Microsoft Entra ID tenant. You need these permissions for the Kubernetes deployment.

    For instructions on checking your permissions, see [Check Microsoft Entra permissions](/azure/azure-resource-manager/resource-group-create-service-principal-portal).

1. Check that you have a valid subscription in your Azure Stack Hub tenant portal, and that you have enough public IP addresses available to add new applications.

    For instructions on generating a key, see [SSH Key Generation](azure-stack-dev-start-howto-ssh-public-key.md).

1. Check that you have a valid subscription in your Azure Stack Hub tenant portal, and that you have enough public IP addresses available to add new applications.

    You can't deploy the cluster to an Azure Stack Hub **Administrator** subscription. You must use a **User** subscription. 

1. If you don't have Kubernetes Cluster in your marketplace, contact your Azure Stack Hub administrator.

## Create a service principal

Set up a service principal in Azure Stack Hub. The service principal gives your application access to Azure Stack Hub resources.

1. Sign in to the global [Azure portal](https://portal.azure.com).

1. Check that you signed in by using the Microsoft Entra tenant associated with the Azure Stack Hub instance. You can switch your sign-in by selecting the filter icon in the Azure toolbar.

    :::image type="content" source="media/azure-stack-solution-template-kubernetes-deploy/tenantselector.png" alt-text="Screenshot that shows the option to select you AD tenant.":::

1. Create a Entra application.

    a. Sign in to your Azure Account through the [Azure portal](https://portal.azure.com).  
    b. Select **Entra ID** > **App registrations** > **New registration**.  
    c. Provide a name and URL for the application.  
    d. Select the **Supported account types**.  
    e.  Add `http://localhost` for the URI for the application. Select **Web**  for the type of application you want to create. After setting the values, select **Register**.

1. Make note of the **Application ID**. You need the ID when creating the cluster. The ID is referenced as **Service Principal Client ID**.

1. In the page for the service principal, select **New client secret**. **Settings** > **Keys**. You need to generate an authentication key for the service principal.

    a. Enter the **Description**.

    b. Select **Never expires** for **Expires**.

    c. Select **Add**. Make note of the key string. You need the key string when creating the cluster. The key is referenced as the **Service Principal Client Secret**.

## Give the service principal access

Give the service principal access to your subscription so that the principal can create resources.

1.  Sign in to the Azure Stack Hub portal `https://portal.local.azurestack.external/`.

1. Select **All services** > **Subscriptions**.

1. Select the subscription created by your operator for using the Kubernetes Cluster.

1. Select **Access control (IAM)** > Select **Add role assignment**.

1. Select the **Contributor** role.

1. Select the application name created for your service principal. You might need to type the name in the search box.

1. Select **Save**.

## Deploy Kubernetes

1. Open the Azure Stack Hub portal `https://portal.local.azurestack.external`.

1. Select **+ Create a resource** > **Compute** > **Kubernetes Cluster**. Select **Create**.

    :::image type="content" source="media/azure-stack-solution-template-kubernetes-deploy/01_kub_market_item.png" alt-text="Screenshot that shows how to create a Kubernetes cluster.":::

### 1. Basics

1. Select **Basics** in Create Kubernetes Cluster.

    :::image type="content" source="media/azure-stack-solution-template-kubernetes-deploy/02_kub_config_basic.png" alt-text="Screenshot that shows how to add basic information about your Kubernetes cluster.":::

1. Select your **Subscription** ID.

1. Enter the name of a new resource group or select an existing resource group. The resource name needs to be alphanumeric and lowercase.

1. Select the **Location** of the resource group. This region is the region you choose for your Azure Stack Hub installation.

### 2. Kubernetes cluster settings

1. Select **Kubernetes Cluster Settings** in **Create Kubernetes Cluster**.

    :::image type="content" source="media/azure-stack-solution-template-kubernetes-deploy/03_kub_config_settings-aad.png" alt-text="Screenshot that shows where to provide information about your Kubernetes cluster settings.":::

1. Enter the **Linux VM admin username**. This user name is for the Linux virtual machines that are part of the Kubernetes cluster and DVM.

1. Enter the **SSH Public Key** used for authorization to all Linux machines created as part of the Kubernetes cluster and DVM.

1. Enter the **Master Profile DNS Prefix** that is unique to the region. This prefix must be a region-unique name, such as `k8s-12345`. Try to choose the same prefix as the resource group name as best practice.

    > [!NOTE]  
    > For each cluster, use a new and unique master profile DNS prefix.

1. Select the **Kubernetes master pool profile count**. The count contains the number of nodes in the master pool. The value can be from 1 to 7. This value should be an odd number.

1. Select **The VMSize of the Kubernetes master VMs**. This selection specifies the VM size of Kubernetes master VMs. 

1. Select the **Kubernetes node pool profile count**. The count contains the number of agents in the cluster. 

1. Select the **VMSize of the Kubernetes node VMs**. This selection specifies the VM size of Kubernetes node VMs. 

1. Select **Entra ID** for the **Azure Stack Hub identity system** for your Azure Stack Hub installation.

1. Enter the **Service principal clientId**. The Kubernetes Azure provider uses this value. The Client ID is identified as the Application ID when your Azure Stack Hub administrator created the service principal.

1. Enter the **Service principal client secret**. This value is the client secret you set up when creating your service.

1. Enter the **Kubernetes version**. This version is for the Kubernetes Azure provider. Azure Stack Hub releases a custom Kubernetes build for each Azure Stack Hub version.

### 3. Summary

1. Select **Summary**. The portal displays a validation message for your Kubernetes Cluster configurations settings.

    :::image type="content" source="media/azure-stack-solution-template-kubernetes-deploy/04_preview.png" alt-text="Screenshot that shows the Deploy Solution Template.":::

1. Review your settings.

1. Select **OK** to deploy your cluster.

> [!TIP]  
> If you have questions about your deployment, post your question or see if someone already answered the question in the [Azure Stack Hub Forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack).


## Next steps

[Connect to your cluster](azure-stack-solution-template-kubernetes-deploy.md#connect-to-your-cluster)

[Enable the Kubernetes Dashboard](azure-stack-solution-template-kubernetes-dashboard.md)
