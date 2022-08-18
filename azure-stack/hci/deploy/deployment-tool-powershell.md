---
title: Deploy Azure Stack HCI version 22H2 (preview) using PowerShell
description: Learn how to deploy Azure Stack HCI version 22H2 (preview) using Windows PowerShell
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Deploy Azure Stack HCI version 22H2 (preview) using PowerShell

> Applies to: Azure Stack HCI, version 22H2 (preview)

In this article, learn how to deploy Azure Stack HCI, version 22H2 using Windows PowerShell. Before you begin the deployment, make sure to first install the operating system.

You will use a configuration file you have created before you begin. For more information, see the [sample configuration file](deployment-tool-existing-file.md).

> [!IMPORTANT]
 > Please review the [Terms of Use](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) and agree to the terms before you deploy this solution.

## Prerequisites

Before you begin, make sure you have done the following:

- Read the [prerequisites for Azure Stack HCI version 22H2](deployment-tool-prerequisites.md).
- From a local VHDX file, [install Azure Stack HCI version 22H2](deployment-tool-install-os.md) on each server.

## Prepare the configuration file

1. Select the first server in the cluster to act as a staging server during deployment.

1. Use the [sample configuration file](deployment-tool-existing-file.md) as a template to create your file.

1. Review the configuration file to ensure the provided values match your environment details before you copy it to the first (staging) server.

1. Log in to the staging server using local administrator credentials.

1. Copy the config file to the staging server by using the following command:
```Copy-item -path <source> -destination c:\setup\config.json```

## Set up the deployment tool

The following parameters are required to set up the deployment tool properly:

|Parameter|Description|
|----|----|
|`JSONFilePath`|Enter the path to your config file. For example, *C:\setup\config.json*.|
|`DomainAdminCredentials`|Specify the Active Directoru account username. The username cannot be *Administrator*.|
|`LocalAdminCredential`|Specify the local administrator credentials.|
|`RegistrationCloudName`|Specify the Azure Cloud to use.|
|`RegistrationSubscriptionID`|Provide the Azure Subscription ID used to register the cluster with Arc.|
|`RegistrationAccountCredential`|Specify credentials to access your Azure Subscription. Multi-factor authentication (MFA) is not supported.|

1. Log on to the first (staging) server using local administrative credentials.

1. Copy content from the *Cloud* folder you downloaded previously to any drive other than the C:\ drive.

1. Enter your Azure subscription ID and the Azure Cloud name and run the following PowerShell commands from an administrative prompt:

    ```powershell
    $SubscriptionID="Azure_subscription_ID"
    $AzureCred=get-credential
    $AzureCloud="AzureCloud_name"
    $DomainAdminCred=get-credential
    $LocalAdminCred=get-credential
    ```

1. Set up the deployment tool:

    ```powershell
    .\BootstrapCloudDeploymentTool.ps1 -RegistrationCloudName $AzureCloud – RegistrationSubscriptionID $SubscriptionID – RegistrationAccountCredential $AzureCred
    ```

1. Change the directory to *C:\clouddeployment\setup*.

1. Enter your configuration file and run the following commands to start the deployment:

    ```powershell
    .\InstallAzureStack-AsZ.ps1 -RegistrationCloudName $AzureCloud -RegistrationSubscriptionID $SubscriptionID -RegistrationAccountCredential $AzureCred -DomainAdminCredential $DomainAdminCred -LocalAdminCredential $LocalAdminCred -JSONFilePath <path_to_config_file.json>
    ```

## Deploy a single-node cluster

To deploy a single-node or multi-node Azure Stack HCI version 22H2 cluster using PowerShell, use the following procedure:

1. Open the configuration file in a text editor.

1. Search for *PhysicalNodes*.

1. Remove all physical nodes except one. Here’s an example of the *PhysicalNodes* section before the configuration file is modified:

    ```powershell
    "PhysicalNodes": [
                  {
                      "Name": "Server1"
                  },
                  {
                      "Name": "Server2"
                  }
              ]
    ```

    Here’s an example of the configuration file after it is modified:

    ```powershell
    "PhysicalNodes": [
                  {
                    "Name": "Server1"
                  }               
                  ]
    ```

1. Deploy Azure Stack HCI, version 22H2 with PowerShell using the modified config file. For details, see **ADD Deploy using PowerShell LINK**.
