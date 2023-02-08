---
title: Deploy Azure Stack HCI using PowerShell (preview) 
description: Learn how to deploy Azure Stack HCI using PowerShell cmdlets (preview).
author: dansisson
ms.topic: how-to
ms.date: 2/1/2023
ms.author: v-dansisson
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Deploy Azure Stack HCI using PowerShell (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

In this article, learn how to deploy Azure Stack HCI using PowerShell. Before you begin the deployment, make sure to first install the operating system.

You will use a configuration file you have created before you begin. For more information, see the [sample configuration file](deployment-tool-existing-file.md).

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you have done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md).
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
- [Install Azure Stack HCI version 22H2](deployment-tool-install-os.md) on each server.
- [Set up the first server](deployment-tool-set-up-first-server.md) in your Azure Stack HCI cluster.

## Create the configuration file

[!INCLUDE [configuration file](../../includes/hci-deployment-tool-configuration-file.md)]

## Prepare the configuration file

1. Select the first server in the cluster to act as a staging server during deployment.

1. Review the [configuration file created previously](#create-the-configuration-file) to ensure the provided values match your environment details before you copy it to the first (staging) server.

1. Sign in to the staging server using local administrator credentials.

1. Copy the configuration file to the staging server by using the following command:

    ```powershell
    Copy-Item -path <Path for you source file> -destination C:\setup\config.json
    ```

## Reference: Configuration file settings

[!INCLUDE [configuration file reference](../../includes/hci-deployment-tool-configuration-file-reference.md)]

## Next steps

- [Validate deployment](deployment-tool-validate.md).
- If needed, [troubleshoot deployment](deployment-tool-troubleshoot.md).