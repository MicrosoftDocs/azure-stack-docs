--- 

title: Set up a development environment on Azure Stack | Microsoft Docs 
description: Get started developing applications for Azure Stack. 
services: azure-stack 
author: mattbriggs 
ms.service: azure-stack 
ms.topic: overview 
ms.date: 04/25/2019
ms.author: mabrigg 
ms.reviewer: sijuman 
ms.lastreviewed: 04/24/2019

# keywords: Develop apps on Azure Stack 
# Intent: I am developer using Windows 10 or Linux Ubuntu who would like to develop an app for Azure Stack using the SDKs. 

--- 

# Set up a development environment on Azure Stack 

You can develop applications for Azure Stack using a Windows 10, Linux, or macOS workstation. In this article we look at: 

- The various contexts in which your app runs on Azure Stack. 
- The steps you can follow to get you set up with a Windows 10, Linux, or macOS workstation. 
- Steps to create resource in Azure Stack and deployed an app. 

## Azure Stack context and your code 

You can write scripts and apps that can accomplish everything in Azure Stack. However, it can be helpful to limit what you are trying to accomplish into three different modes. 

1. In the first mode, you can create apps that will provision resources in Azure Stack using Azure Resource Manager templates. For example, you can create a script that will construction an Azure Resource Manager template that will create a virtual network and the VMs that will host your app. 

2. In the second mode, you work directly with endpoints using the REST API and a REST client created in your code. In this mode, you would create a script that creates a virtual network and the VMs by sending requests to the APIs. 

3. In the third mode, you can use your code to create an app that is hosted in Azure Stack. Once you have the infrastructure in Azure Stack to host your app,  deploy your app to the infrastructure. Typically, you will prepare your environment and then deploy your app to that environment. 

###  Infrastructure-as-a-Service and Platform-as-a-Service 

As a cloud, Azure Stack supports both: 

- Infrastructure-as-a-Service (IaaS) 
- Platform-as-a-Service (PaaS) 

Both IaaS and PaaS inform how you would like to set up your development machine. 

IaaS is the virtualization of the parts of the data center from network gear, the network, and servers. When you deploy an app to a VM that hosts the web server, you are working in an IaaS paradigm. In this paradigm, Azure Stack manages the virtual gear and your app is on a virtual server. Azure Stack resource providers support network components and virtual servers. 

PaaS abstracts the infrastructure layer so that you deploy your app to an endpoint that then runs your app. In the PaaS paradigm you might use containers to host your app, and then deploy your containerized app to a service that runs the container, or you might push your app directly to a service that runs your app. Azure Stack can be used to run Azure App service and Kubernetes. 

### Azure Stack Resource Manager 

These three modes as well as PaaS or IaaS are enabled by the Azure Stack version of the Azure Resource Manager. The management framework allows you to deploy, manage, and monitor Azure Stack resources. The manager lets you work with these items as a group in a single operation. For more information about the about working with the Azure Stack Resource Manger, see [Manage API version profiles in Azure Stack](azure-stack-version-profiles.md). 

### Azure Stack development kits 

Azure Stack uses an Azure Stack version of the Azure Resource Manager.  In order to help you work with the Azure Stack Resource Manager using your code of choice, we have provided a number of software development kits. These include: 

- [.Net/C#](azure-stack-version-profiles-net.md)
- [Java](azure-stack-version-profiles-java.md)
- [Go](azure-stack-version-profiles-go.md)
- [Ruby](azure-stack-version-profiles-ruby.md)
- [Python](azure-stack-version-profiles-python.md)

## Before you start 

You will need: 

- Access to the Azure Stack user portal. 
- The name of your tenant. 
- To know if you're using Azure Active directory (Azure AD) or Active Directory Federated Services (AD FS) as your identity manger. 

If you have any questions about your Azure Stack, contact your cloud operator. 

## Windows 10 

A Windows 10 machine will allow you to work with PowerShell 5.0, Visual Studio, and if you are working with an ASDK connect to your environment with a VPN connection. 

### Set up your tools 

1. Get set up with PowerShell. For instruction, follow the steps in [Install Azure Stack Powershell](../operator/azure-stack-powershell-install.md). 

2. Download Azure Stack Tools. For instructions, follow the steps in [Download Azure Stack tools from GitHub](../operator/azure-stack-powershell-download.md). 

3. If you are using an ASDK, install and configure a [VPN connection to the Azure Stack](azure-stack-connect-azure-stack.md#connect-to-azure-stack-with-vpn). 

4. Install and configure Azure CLI. For instructions, follow the steps in [Use API version profiles with Azure CLI in Azure Stack](azure-stack-version-profiles-azurecli2.md). 

5. Install and configure Azure storage explorer. Azure storage explorer is a standalone app that enables you to work with Azure Stack storage data.  For instructions, follow the steps in [Connect storage explorer to an Azure Stack subscription or a storage account](azure-stack-storage-connect-se.md). 

### Install your integrated development environment 

1. Install your integrated development environment (IDE), depending on your code base and preference. 

     - Visual Studio Code (Python, Go, NodeJS). Download Visual Studio Code for your machine from [code.visualstudio.com](https://code.visualstudio.com/Download). 
     - Visual Studio (.Net/C#). Download Visual Studio Community edition from [visualstudio.microsoft.com](https://visualstudio.microsoft.com/vs/community/). 
     - Eclipse (Java). Download Eclipse from [eclipse.org](https://www.eclipse.org/downloads/). 

2. Install the software development kit (SDK) for your code. 

     - [.Net/C#](azure-stack-version-profiles-net.md) 
     - [Java](azure-stack-version-profiles-java.md) 
     - [Go](azure-stack-version-profiles-go.md) 
     - [Ruby](azure-stack-version-profiles-python.md) 
     - [Python](azure-stack-version-profiles-python.md) 

## Linux 

A Linux machine will allow you to work with Azure CLI and Visual Studio Code, or your own preferred integrated development environment. 

> [!Note]   
> If you're using a Linux machine with the ASDK, your remote machine will need to be in the same network as the ASDK. You will not be able to connect using a Virtual Private Network connection. 

### Set up your tools 

1. Install and configure Azure CLI. For instructions, follow the steps in [Use API version profiles with Azure CLI in Azure Stack](azure-stack-version-profiles-azurecli2.md). 

2. Install and configure Azure storage explorer. Azure storage explorer is a standalone app that enables you to work with Azure Stack storage data.  For instructions, follow the steps in [Connect storage explorer to an Azure Stack subscription or a storage account](azure-stack-storage-connect-se.md). 

### Install your integrated development environment 

1. Install your integrated development environment (IDE), depending on your code base and preference. 

     - Visual Studio Code (Python, Go, NodeJS). Download Visual Studio Code for your machine from [code.visualstudio.com](https://code.visualstudio.com/Download). 
     - Visual Studio (.Net/C#). Download Visual Studio Community edition from [visualstudio.microsoft.com](https://visualstudio.microsoft.com/vs/community/). 
     - Eclipse (Java). Download Eclipse from [eclipse.org](https://www.eclipse.org/downloads/). 

2. Install the software development kit (SDK) for your code. 

     - [.Net/C#](azure-stack-version-profiles-net.md) 
     - [Java](azure-stack-version-profiles-java.md) 
     - [Go](azure-stack-version-profiles-go.md) 
     - [Ruby](azure-stack-version-profiles-python.md) 
     - [Python](azure-stack-version-profiles-python.md) 

## macOs 

A macOS machine will allow you to work with Azure CLI and Visual Studio Code, or your own preferred integrated development environment. 

> [!Note]   
> If you're using a macOS machine with the ASDK, your remote machine will need to be in the same network as the ASDK. You will not be able to connect using a Virtual Private Network connection. 

### Set up your tools 

1. Install and configure Azure CLI. For instructions, follow the steps in [Use API version profiles with Azure CLI in Azure Stack](azure-stack-version-profiles-azurecli2.md). 

2. Install and configure Azure storage explorer. Azure storage explorer is a standalone app that enables you to work with Azure Stack storage data. For instructions, follow the steps in [Connect storage explorer to an Azure Stack subscription or a storage account](azure-stack-storage-connect-se.md). 

### Install your integrated development environment 

1. Install your integrated development environment (IDE), depending on your code base and preference. 

     - Visual Studio Code (Python, Go, NodeJS). Download Visual Studio Code for your machine from [code.visualstudio.com](https://code.visualstudio.com/Download). 
     - Visual Studio (.Net/C#). Download Visual Studio Community edition from [visualstudio.microsoft.com](https://visualstudio.microsoft.com/vs/community/). 
     - Eclipse (Java). Download Eclipse from [eclipse.org](https://www.eclipse.org/downloads/). 

2. Install the software development kit (SDK) for your code. 

     - [.Net/C#](azure-stack-version-profiles-net.md) 
     - [Java](azure-stack-version-profiles-java.md) 
     - [Go](azure-stack-version-profiles-go.md) 
     - [Ruby](azure-stack-version-profiles-python.md) 
     - [Python](azure-stack-version-profiles-python.md) 

## Next steps 

Deploy an app to resources in Azure Stack. You can find the steps in [Common deployments for Azure Stack](azure-stack-dev-start-deploy-app.md).