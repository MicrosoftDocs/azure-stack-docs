---
title: Remove the SQL resource provider
titleSuffix: Azure Stack Hub
description: Learn how to remove the SQL resource provider from your Azure Stack Hub deployment.
author: bryanla

ms.topic: article
ms.date: 10/02/2019
ms.author: bryanla
ms.reviewer: xiaofmao
ms.lastreviewed: 11/20/2

# Intent: As an Azure Stack operator, I want to remove the SQL resource provider.
# Keyword: remove sql resource provider azure stack

---


# Remove the SQL resource provider

Before you remove the SQL resource provider, you must remove all the provider dependencies. You'll also need a copy of the deployment package that was used to install the resource provider.

> [!NOTE]
> You can find the download links for the resource provider installers in [Deploy the resource provider prerequisites](./azure-stack-sql-resource-provider-deploy.md#prerequisites).

Removing the SQL resource provider will delete the associated plans and quotas managed by operator. But it doesn't delete tenant databases from hosting servers.

## To remove the SQL resource provider

1. Verify that you've removed all the existing SQL resource provider dependencies.

   > [!NOTE]
   > Uninstalling the SQL resource provider will proceed even if dependent resources are currently using the resource provider.
  
2. Get a copy of the SQL resource provider installation package and then run the self-extractor to extract the contents to a temporary directory.

3. Open a new elevated PowerShell console window and change to the directory where you extracted the SQL resource provider installation files.

4. Run the DeploySqlProvider.ps1 script using the following parameters:

    * **Uninstall**: Removes the resource provider and all associated resources.
    * **PrivilegedEndpoint**: The IP address or DNS name of the privileged endpoint.
    * **AzureEnvironment**: The Azure environment used for deploying Azure Stack Hub. Required only for Azure AD deployments.
    * **CloudAdminCredential**: The credential for the cloud admin, necessary to access the privileged endpoint.
    * **AzCredential**: The credential for the Azure Stack Hub service admin account. Use the same credentials that you used for deploying Azure Stack Hub.

## Next steps

[Offer App Services as PaaS](azure-stack-app-service-overview.md)
