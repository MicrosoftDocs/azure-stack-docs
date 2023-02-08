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

1. Review the [configuration file that you created previously](#create-the-configuration-file) to ensure the provided values match your environment details before you copy it to the first (staging) server.

1. Sign in to the staging server using local administrator credentials.

1. Copy the configuration file to the staging server by using the following command:

    ```powershell
    Copy-Item -path <Path for you source file> -destination C:\setup\config.json
    ```

## Set up parameters

To deploy Azure Stack HCI using PowerShell, the following parameters are required to set up and run the deployment tool properly:

|Parameter|Description|
|----|----|
|`JSONFilePath`|Enter the path to your config file. For example, *C:\setup\config.json*.|
|`DeploymentUserCredential`|Specify the Active Directory account username. The username cannot be *Administrator*.|
|`LocalAdminCredential`|Specify the local administrator credentials.|
|`RegistrationCloudName`|Specify the cloud against which you'll authenticate your cluster. In this release, only the `AzureCloud` corresponding to public Azure is supported.|
|`RegistrationRegion`|(Optional) Specify the region that should be used when registering the system with Azure Arc.|
|`RegistrationResourceGroupName`|(Optional) Specify the resource group that will be used to hold the resource objects for the system.|
|`RegistrationResourceName`|(Optional) Specify the name used for the resource object of the Arc resource name for the cluster.|
|`RegistrationSubscriptionID`|Specify the ID for the subscription used to authenticate the cluster to Azure.|
|`RegistrationSPCredential`|Specify the credentials including the App ID and the secret for the Service Principal used to authenticate the cluster to Azure.|

## Run the deployment tool

Follow these steps to deploy Azure Stack HCI via PowerShell:

1. Change the directory to *C:\clouddeployment\setup*.

1. Set the following parameters:

    ```powershell
    $DeploymentUserCred=Get-Credential
    $LocalAdminCred=Get-Credential
    $SubscriptionID="<Your subscription ID>"
    $CloudName="AzureCloud"   
    $SPNAppID = "<Your App ID>"
    $SPNSecret= "<Your SPN Secret>"
    $SPNsecStringPassword = ConvertTo-SecureString $SPNSecret -AsPlainText -Force
    $SPNCred = New-Object System.Management.Automation.PSCredential ($SPNAppID, $SPNsecStringPassword)
    ```

1. Specify the path to your configuration file and run the following to start the deployment:

    ```powershell
    .\Invoke-CloudDeployment -JSONFilePath <path_to_config_file.json> -DeploymentUserCredential  $DeploymentUserCred  -LocalAdminCredential -$LocalAdminCred -RegistrationSPCredential $SPNCred -RegistrationCloudName $CloudName -RegistrationSubscriptionID $SubscriptionID
    ```

## Reference: Configuration file settings

[!INCLUDE [configuration file reference](../../includes/hci-deployment-tool-configuration-file-reference.md)]

## Next steps

- [Validate deployment](deployment-tool-validate.md).
- If needed, [troubleshoot deployment](deployment-tool-troubleshoot.md).