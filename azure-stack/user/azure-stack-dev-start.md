--- 

title: Set up a development environment in Azure Stack | Microsoft Docs 
description: Get started developing applications for Azure Stack. 
services: azure-stack 
author: mattbriggs 
ms.service: azure-stack 
ms.topic: overview 
ms.date: 11/11/2019
ms.author: mabrigg 
ms.reviewer: sijuman 
ms.lastreviewed: 11/11/2019

# keywords: Develop apps on Azure Stack 
# Intent: I am a developer using Windows 10 or Linux Ubuntu who would like to develop an app for Azure Stack using the SDKs. 

--- 

# Set up a development environment in Azure Stack 

You can develop applications for Azure Stack by using a Windows 10, Linux, or macOS workstation. In this article, we look at: 

- The various contexts in which your app runs in Azure Stack. 
- The steps to follow to get you set up with a Windows 10, Linux, or macOS workstation. 
- The steps for creating resources in Azure Stack and deploy them to an app. 

## Azure Stack context and your code 

You can write scripts and apps to accomplish many tasks in Azure Stack. However, it's helpful to limit your scope to the following three modes: 

1. In the first mode, you can create apps that provision resources in Azure Stack by using Azure Resource Manager templates. For example, you might write a script that constructs an Azure Resource Manager template that in turn creates a virtual network and the VMs that will host your app. 

2. In the second mode, you work directly with endpoints by using the REST API and a REST client that were created in your code. In this mode, you would write a script that creates a virtual network and the VMs by sending requests to the APIs. 

3. In the third mode, you can use your code to create an app that's hosted in Azure Stack. After you've created the infrastructure in Azure Stack for hosting your app, you deploy your app to the infrastructure. Ordinarily, you'll prepare your environment and then deploy your app to it. 

###  Infrastructure as a service and platform as a service 

As a cloud platform product, Azure Stack supports both: 

- Infrastructure as a service (IaaS) 
- Platform as a service (PaaS) 

Both IaaS and PaaS inform how to set up your development machine. 

IaaS is the virtualization of the parts of the datacenter that come from network gear, the network, and servers. When you deploy an app to a VM that hosts the web server, you're working in an IaaS model. In this model, Azure Stack manages the virtual gear, and your app is on a virtual server. Azure Stack resource providers support network components and virtual servers. 

PaaS abstracts the infrastructure layer so that you deploy your app to an endpoint that then runs the app. In the PaaS model, you might use containers to host your app and then deploy the containerized app to a service that runs the container. Or you might push your app directly to a service that runs the app. You can use Azure Stack to run Azure App Service and Kubernetes. 

### Azure Stack Resource Manager 

The three previously mentioned modes, as well as PaaS or IaaS, are enabled by the Azure Stack version of Azure Resource Manager. This management framework allows you to deploy, manage, and monitor Azure Stack resources. It lets you work with the resources as a group in a single operation. For more information about working with the Azure Stack Resource Manager, see [Manage API version profiles in Azure Stack](azure-stack-version-profiles.md). 

### Azure Stack SDKs 

Azure Stack uses an Azure Stack version of Azure Resource Manager. To help you work with the Azure Stack Resource Manager by using your code of choice, we've provided a number of SDKs, including: 

- [.NET/C#](azure-stack-version-profiles-net.md)
- [Java](azure-stack-version-profiles-java.md)
- [Go](azure-stack-version-profiles-go.md)
- [Ruby](azure-stack-version-profiles-ruby.md)
- [Python](azure-stack-version-profiles-python.md)
- [Node.js](azure-stack-version-profile-nodejs.md)

## Before you start 

Before you begin setting up your environment, you need: 

- Access to the Azure Stack user portal. 
- The name of your tenant. 
- To determine whether you're using Azure Active Directory (Azure AD) or Active Directory Federation Services (AD FS), as your identity manager. 

If you have any questions about Azure Stack, contact your cloud operator. 

## Windows 10 

If you're using a Windows 10 machine, you can work with PowerShell 5.0 and Visual Studio. And if you're working with an Azure Stack Development Kit (ASDK), you can connect to your environment with a VPN connection. 

### Set up your tools 

1. Get set up with PowerShell. For instructions, see [Install Azure Stack Powershell](../operator/azure-stack-powershell-install.md). 

2. Download Azure Stack Tools. For instructions, see [Download Azure Stack tools from GitHub](../operator/azure-stack-powershell-download.md). 

3. If you're using an ASDK, install and configure a [VPN connection to Azure Stack](azure-stack-connect-azure-stack.md#connect-to-azure-stack-with-vpn). 

4. Install and configure the Azure CLI. For instructions, see [Use API version profiles with the Azure CLI in Azure Stack](azure-stack-version-profiles-azurecli2.md). 

5. Install and configure Azure Storage Explorer. Storage Explorer is a standalone app that enables you to work with Azure Stack storage data. For instructions, see [Connect Storage Explorer to an Azure Stack subscription or a storage account](azure-stack-storage-connect-se.md). 

### Install your integrated development environment 

1. Install your integrated development environment (IDE), depending on your code base and preference. 

     - Visual Studio Code (Python, Go, NodeJS). Download Visual Studio Code for your machine from [code.visualstudio.com](https://code.visualstudio.com/Download). 
     - Visual Studio (.NET/C#). Download Visual Studio Community edition from [visualstudio.microsoft.com](https://visualstudio.microsoft.com/vs/community/). 
     - Eclipse (Java). Download Eclipse from [eclipse.org](https://www.eclipse.org/downloads/). 

2. Install the SDK for your code: 

     - [.NET/C#](azure-stack-version-profiles-net.md) 
     - [Java](azure-stack-version-profiles-java.md) 
     - [Go](azure-stack-version-profiles-go.md) 
     - [Ruby](azure-stack-version-profiles-python.md) 
     - [Python](azure-stack-version-profiles-python.md) 

## Linux 

If you're using a Linux machine, you can work with the Azure CLI, Visual Studio Code, or your own preferred integrated development environment. 

> [!Note]   
> If you're using a Linux machine with the ASDK, your remote machine needs to be in the same network as the ASDK. You won't be able to connect using a Virtual Private Network connection. 

### Set up your tools 

1. Install and configure the Azure CLI. For instructions, see [Use API version profiles with the Azure CLI in Azure Stack](azure-stack-version-profiles-azurecli2.md). 

2. Install and configure Azure Storage Explorer. Storage Explorer is a standalone app that enables you to work with Azure Stack storage data. For instructions, see [Connect Storage Explorer to an Azure Stack subscription or a storage account](azure-stack-storage-connect-se.md). 

### Install your integrated development environment 

1. Install your integrated development environment (IDE), depending on your code base and preference. 

     - Visual Studio Code (Python, Go, NodeJS). Download Visual Studio Code for your machine from [code.visualstudio.com](https://code.visualstudio.com/Download). 
     - Visual Studio (.NET/C#). Download Visual Studio Community edition from [visualstudio.microsoft.com](https://visualstudio.microsoft.com/vs/community/). 
     - Eclipse (Java). Download Eclipse from [eclipse.org](https://www.eclipse.org/downloads/). 

2. Install the SDK for your code: 

     - [.NET/C#](azure-stack-version-profiles-net.md) 
     - [Java](azure-stack-version-profiles-java.md) 
     - [Go](azure-stack-version-profiles-go.md) 
     - [Ruby](azure-stack-version-profiles-python.md) 
     - [Python](azure-stack-version-profiles-python.md) 

## macOS 

A macOS machine will allow you to work with the Azure CLI and Visual Studio Code, or your own preferred integrated development environment. 

> [!Note]   
> If you're using a macOS machine with the ASDK, your remote machine needs to be in the same network as the ASDK. You won't be able to connect using a Virtual Private Network connection. 

### Set up your tools 

1. Install and configure the Azure CLI. For instructions, see [Use API version profiles with the Azure CLI in Azure Stack](azure-stack-version-profiles-azurecli2.md). 

2. Install and configure Azure Storage Explorer. Storage Explorer is a standalone app that enables you to work with Azure Stack storage data. For instructions, see [Connect Storage Explorer to an Azure Stack subscription or a storage account](azure-stack-storage-connect-se.md). 

### Install your integrated development environment 

1. Install your integrated development environment (IDE), depending on your code base and preference. 

     - Visual Studio Code (Python, Go, NodeJS). Download Visual Studio Code for your machine from [code.visualstudio.com](https://code.visualstudio.com/Download). 
     - Visual Studio (.NET/C#). Download Visual Studio Community edition from [visualstudio.microsoft.com](https://visualstudio.microsoft.com/vs/community/). 
     - Eclipse (Java). Download Eclipse from [eclipse.org](https://www.eclipse.org/downloads/). 

2. Install the SDK for your code: 

     - [.NET/C#](azure-stack-version-profiles-net.md) 
     - [Java](azure-stack-version-profiles-java.md) 
     - [Go](azure-stack-version-profiles-go.md)
     - [Ruby](azure-stack-version-profiles-python.md) 
     - [Python](azure-stack-version-profiles-python.md) 

## Next steps 

To deploy an app to resources in Azure Stack, see [Common deployments for Azure Stack](azure-stack-dev-start-deploy-app.md).
