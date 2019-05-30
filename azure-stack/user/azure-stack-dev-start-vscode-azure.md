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

# keywords: Azure Stack VSCode
# Intent: I am a developer using Visual Studio Code and I would like to connect to Azure Stack. or Linux Ubuntu who would like to deploy an app to Azure Stack.
---

# Connect to Azure Stack using Azure Account Extension in Visual Studio Code

In this article, we will you through how to connect to Azure Stack using the Azure Account extension. You will need to update your Visual Studio Code settings.

You can use Visual Studio Code (VS Code), a light-weight editor, to build and debug modern web and cloud applications. With the Azure Account extension, you can use a single Azure sign-in with subscription filtering for additional Azure extensions. The extension makes the Azure Cloud Shell available in the VS Code-integrated terminal. Using the extension, you can connect to your Azure Stack subscription using both Azure AD (Azure AD) and Active Directory Federated Services (AD FS) for your identity manager. This allows you to sign in to Azure Stack, select your subscription, and open a new command line in a cloud shell. 

## Pre-requisites for the Azure Account Extension

1. Azure Stack environment 1904 build or later
2. Visual Studio Code
3. Azure Account Extension
4. An Azure Stack subscription

## Steps to connect to Azure Stack

1. Open Visual Studio Code.

2. Select **Extensions** on the left-side corner.

3. In the search box, enter `Azure Account`.

4. Select **Azure Account** and select **Install**.

  ![Azure accounts connecting to Azure Stack](media/azure-stack-dev-start-vscode-azure/image1.png)

1. Once installed and Visual Studio Code is reloaded, use **Ctrl + Shift + P,** and select **Preferences: Open User Settings**.

2. Select the brackets on the top-right corner.

  ![A screenshot of a cell phone
Description automatically generated](media/azure-stack-dev-start-vscode-azure/image2.png)

1. In the code editor, paste the following code snippet and enter  the credentials for your Azure Stack subscription.

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
> To find the value of the `activeDirectoryEndpointURL` and `activeDirectoryResourceID`, use the link below and paste the values within the quotes. The resource manager endpoint URL is needed to be placed within the below link to gather the rest of the information.

```HTTP
https://management.location.xxxx.com/metadata/endpoints?api-version=1.0
```

8. Save the User Settings and use **Ctrl + Shift + P** once again. Select **Azure: Sign in to Azure Cloud**.

9. A new option will appear that says **Azure PPE**

10. Select this option and it will redirect you to your browser to sign in to the endpoint specified. Once you have entered your credentials, you will see the message that shows that you have been signed in to Visual Studio Code and can now close the window.

11. To test that you have successfully logged into your Azure Stack subscription, use **Ctrl + Shift + P** and select **Azure: Select Subscription** and see if the subscription you have is available.

The steps here can be replicated for Active Directory Federated Services environments and only requires a change to the user settings above with the values for AD FS.

## Commands

| Azure: Sign In | Sign in to your Azure subscription |
| --- | --- |
| Azure: Sign In with Device Code | Sign in to your Azure subscription with a device code. Use this in setups where the Sign In command does not work. |
| Azure: Sign In to Azure Cloud | Sign in to your Azure subscription in one of the sovereign clouds. |
| Azure: Sign Out | Sign out of your Azure subscription. |
| Azure: Select Subscriptions | Pick the set of subscriptions you want to work with. Extensions respect this list and only show resources within the filtered subscriptions. |
| Azure: Create an Account | If you don't have an Azure Account, you can [sign up](https://azure.microsoft.com/free/?utm_source=campaign&utm_campaign=vscode-azure-account&mktingSource=vscode-azure-account) for one today and receive \$200 in free credits. |
| Azure: Open Bash in Cloud Shell | Open a new terminal running Bash in Cloud Shell. |
| Azure: Open PowerShell in Cloud Shell | Open a new terminal running PowerShell in Cloud Shell. |
| Azure: Upload to Cloud Shell | Upload a file to your Cloud Shell storage account. |

## Next steps

[Set up a development environment in Azure Stack ](azure-stack-dev-start.md)