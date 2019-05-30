---
title: Connect to Azure Stack using Azure Account Extension in Visual Studio Code | Microsoft Docs
description: As a developer, connect to Azure Stack using Azure Account Extension in Visual Studio Code
services: azure-stack
author: mattbriggs

ms.service: azure-stack
ms.topic: Howto
ms.date: 05/31/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 05/31/2019

# keywords:  Azure Stack VSCode
# Intent: I am a developer using Visual Studio Code and I would like to connect to Azure Stack. or Linux Ubuntu who would like to deploy an app to Azure Stack.
---

# Connect to Azure Stack using Azure Account Extension in Visual Studio Code

Visual Studio Code supplies developers with a light-weight and optimized code editor to build and debug modern web and cloud applications. The Azure Account extension provides a single Azure sign-in and subscription filtering experience for all other Azure extensions. It makes Azure's Cloud Shell service available in VS Code's integrated terminal. Using this extension, developers can connect to their Azure Stack subscription as well in both AAD and ADFS environments. This will allow developers to sign in to Azure Stack, select their subscription, and open new terminals in cloud shell. In this tutorial, we will walk developers how to connect to Azure Stack using the Azure Account extension, which involves updating the user-settings in Visual Studio Code.

## Pre-requisites

1.  Azure Stack environment 1904 build or later

2.  Visual Studio Code

3.  Azure Account Extension

4.  An Azure Stack subscription

## Steps to connect to Azure Stack

1.  Open Visual Studio Code.

2.  Click on Extensions on the left-side corner.

3.  In the search box, type Azure Account.

4.  Click on Azure Account and select Install.

    ![A screenshot of a cell phone Description automatically generated](media/azure-stack-dev-start-vscode-azure/image1.png)

1.  Once installed and Visual Studio Code is reloaded, use **Ctrl + Shift + P,** and select **Preferences: Open User Settings**.

2.  Select the brackets on the top right corner, as shown in the pic below.

    ![A screenshot of a cell phone
Description automatically generated](media/azure-stack-dev-start-vscode-azure/image2.png)

1.  In the code editor, paste the following code snippet and enter in the credentials for your Azure Stack subscription.

    ```JSON
    "azure.tenant": "tenant-ID",
    "azure.ppe": {
    "activeDirectoryEndpointUrl": "Login endpoint",
    "activeDirectoryResourceId": "graph audience",
    "resourceManagerEndpointUrl": "Management Endpoint",
    },
    "azure.cloud": "AzurePPE"
```

> [!Note]  
> To find the value of the activeDirectoryEndpointURL and activeDirectoryResourceID, use the link below and paste the values within the quotes. The resource manager endpoint URL is needed to be placed within the below link to gather the rest of the information.

```HTTP
https://management.location.xxxx.com/metadata/endpoints?api-version=1.0
```

8. Save the User Settings and use **Ctrl + Shift + P** once again. Select **Azure: Sign in to Azure Cloud**.

9. A new option will appear that says **Azure PPE**

10. Select this option and it will redirect you to your browser to login to the endpoint specified. Once you have entered your credentials, you will see the message that displays that you have been signed in to Visual Studio Code and can now close the window.

11. To test that you have successfully logged into your Azure Stack subscription, use Ctrl + Shift + P and select **Azure: Select Subscription** and see if the subscription you have is available.

The steps here can be replicated for AD FS environments as well and only requires a change to the user settings above with the correct values.

## Commands

| Azure: Sign In | Sign in to your Azure subscription |
| --- | --- |
| Azure: Sign In with Device Code | Sign in to your Azure subscription with a device code. Use this in setups where the Sign In command does not work.  |
| Azure: Sign In to Azure Cloud | Sign in to your Azure subscription in one of the sovereign clouds.  |
| Azure: Sign Out | Sign out of your Azure subscription.  |
| Azure: Select Subscriptions | Pick the set of subscriptions you want to work with. Extensions should respect this list and only show resources within the filtered subscriptions.  |
| Azure: Create an Account | If you don't have an Azure Account, you can [sign up](https://azure.microsoft.com/en-us/free/?utm_source=campaign&utm_campaign=vscode-azure-account&mktingSource=vscode-azure-account) for one today and receive \$200 in free credits.  |
| Azure: Open Bash in Cloud Shell^1^ | Open a new terminal running Bash in Cloud Shell.  |
| Azure: Open PowerShell in Cloud Shell^1^ | Open a new terminal running PowerShell in Cloud Shell.  |
| Azure: Upload to Cloud Shell^1^ | Upload a file to your Cloud Shell storage account. |

## Next steps

- 