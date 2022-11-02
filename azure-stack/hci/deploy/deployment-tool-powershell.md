---
title: Deploy Azure Stack HCI using PowerShell (preview) 
description: Learn how to deploy Azure Stack HCI using PowerShell cmdlets (preview).
author: dansisson
ms.topic: how-to
ms.date: 10/27/2022
ms.author: v-dansisson
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Deploy Azure Stack HCI using PowerShell (preview)

> Applies to: Azure Stack HCI, version 22H2

In this article, learn how to deploy Azure Stack HCI using Windows PowerShell. Before you begin the deployment, make sure to first install the operating system.

You will use a configuration file you have created before you begin. For more information, see the [sample configuration file](deployment-tool-existing-file.md).

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you have done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md).
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
- [Install Azure Stack HCI version 22H2](deployment-tool-install-os.md) on each server.
- Create a Service Principal with the necessary permissions for Azure Stack HCI registration. For more information, see:
    - [Create an Azure AD app and service principal in the portal](/azure/active-directory/develop/howto-create-service-principal-portal).
    - [Assign permissions from the Azure portal](./register-with-azure.md#assign-permissions-from-azure-portal).

## Prepare the configuration file

1. Select the first server in the cluster to act as a staging server during deployment.

1. Use the [sample configuration file](deployment-tool-existing-file.md) as a template to create your file.

1. Review the configuration file to ensure the provided values match your environment details before you copy it to the first (staging) server.

1. Sign in to the staging server using local administrator credentials.

1. Copy the *config* file to the staging server by using the following command:

    ```powershell
    Copy-Item -path <Path for you source file> -destination C:\setup\config.json
    ```

## Set up the deployment tool

The following parameters are required to set up and run the deployment tool properly:

|Parameter|Description|
|----|----|
|`JSONFilePath`|Enter the path to your config file. For example, *C:\setup\config.json*.|
|`DeploymentUserCredential`|Specify the Active Directory account username. The username cannot be *Administrator*.|
|`LocalAdminCredential`|Specify the local administrator credentials.|

## Deploy a cluster

Follow these steps to deploy a multiple-node cluster or a single-server using PowerShell:

1. Sign in to the first (staging) server using local administrative credentials.

1. Copy content from the *Cloud* folder you downloaded previously to any drive other than the C:\ drive.

1. Run PowerShell as administrator.

1. Set the following parameters:

    ```powershell
    $DeploymentUserCred=Get-Credential
    $LocalAdminCred=Get-Credential
    $SPNAppID = "<Your App ID>"
    $SPNSecret= "<Your SPN Secret>"
    $SPNsecStringPassword = ConvertTo-SecureString $SPNSecret -AsPlainText -Force
    $SPNCred = New-Object System.Management.Automation.PSCredential ($SPNAppID, $SPNsecStringPassword)
    ```

1. Set up the deployment tool:

    ```powershell
    .\BootstrapCloudDeploymentTool.ps1
    ```

1. Change the directory to *C:\clouddeployment\setup*.

1. Specify the path to your configuration file and run the following to start the deployment:

    ```powershell
    .\Invoke-CloudDeployment -JSONFilePath <path_to_config_file.json> -DeploymentUserCredential  $DeploymentUserCred  -LocalAdminCredential -$LocalAdminCred -RegistrationSPCredential $SPNCred
    ```

## Next steps

- [Validate deployment](deployment-tool-validate.md).
- If needed, [troubleshoot deployment](deployment-tool-troubleshoot.md).