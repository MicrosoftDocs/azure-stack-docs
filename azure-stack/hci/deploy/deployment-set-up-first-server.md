--- 
title: Set up the first server for new Azure Stack HCI 23H2 deployments (preview) 
description: Learn how to set up the first server before you deploy Azure Stack HCI 23H2 (preview).
author: alkohli
ms.topic: how-to
ms.date: 10/04/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Set up the first server for new Azure Stack HCI 23H2 deployment (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to set up the first server in the cluster for a new Azure Stack HCI version 23H2 deployment. The first server listed for the cluster acts as a staging server in the deployment.

The deployment is part of the preview package that you have downloaded. You need to install and set up the deployment only on the first server in the cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md).
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment. Make sure to use the [version 10.2306 of the AsHciADArtifactsPreCreationTool](https://www.powershellgallery.com/packages/AsHciADArtifactsPreCreationTool/10.2306) to prepare your Active Directory.
- [Install version 23H2 OS](deployment-tool-install-os.md) on each server.
- Register your subscription against the `Microsoft.ResourceConnector` resource provider. Run the following PowerShell cmdlet to register your subscription:

    ```powershell
    Register-AzResourceProvider -ProviderNamespace Microsoft.ResourceConnector
    ```

- Before you start the deployment, run the following command to check for any mapped drives and then remove those:

    ```powershell
    (Get-PSDrive -PSProvider FileSystem).Root 
    ```

The installation could potentially fail if there are mapped drives other than the drive where the package is being installed.

## Download 23H2 preview

[!INCLUDE [hci-deployment-23h2](../../includes/hci-deployment-23h2.md)]

## Connect to the first server

Follow these steps to connect to the first server:

1. Select the first server listed for the cluster to act as a staging server during deployment.

1. Sign in to the first server using local administrative credentials.

1. Copy the preview package that you downloaded previously from the Microsoft Collaborate site.

## Assign Azure permissions for deployment

This section describes how to assign Azure permissions for deployment from the Azure portal or using PowerShell.

### Assign Azure permissions from Azure portal

If your Azure subscription is through an Enterprise Agreement (EA) or Cloud Solution Provider (CSP), ask your Azure subscription admin to assign Azure subscription level privileges of:

- **User Access Administrator** role: Required to Arc-enable each server of an Azure Stack HCI cluster.
- **Contributor** role: Required to register and unregister the Azure Stack HCI cluster.

   :::image type="content" source="media/deployment-tool/first-server/access-control.png" alt-text="Screenshot of assign permissions screen." lightbox="media/deployment-tool/first-server/access-control.png":::

### Assign Azure permissions using PowerShell


## Next steps

After setting up the first server in your cluster, you're ready to deploy using Azure portal:

- [Deploy using Azure portal](deployment-set-up-first-server.md).
