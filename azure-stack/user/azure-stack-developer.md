---
title: Develop apps for Azure Stack Hub 
description: Development considerations for prototyping apps on Azure Stack Hub using Azure services.
author: sethmanheim

ms.topic: article
ms.date: 01/24/2020
ms.author: sethm
ms.reviewer: unknown
ms.lastreviewed: 05/21/2019

---

# Develop for Azure Stack Hub

You can get started developing apps today, even if you do not have access to an Azure Stack Hub environment. Azure Stack Hub delivers Microsoft Azure services that run in your datacenter, which means you can use the same Azure tools and processes to develop on Azure Stack Hub.

## Development considerations

With some preparation, and using the guidance in the following topics, you can use Azure to emulate an Azure Stack Hub environment.

* In Azure, you can create Azure Resource Manager templates that are deployable to Azure Stack Hub. See [template considerations](azure-stack-develop-templates.md) for guidance on developing templates to ensure portability.
* There are differences in service availability and service versioning between Azure and Azure Stack Hub. You can use the [Azure Stack Hub policy module](azure-stack-policy-module.md) to restrict Azure service availability and resource types to what is available in Azure Stack Hub. Constraining services ensures that your apps rely on services available to Azure Stack Hub.
* The [Azure Stack Hub quickstart templates](https://github.com/Azure/AzureStack-QuickStart-Templates) are common scenario examples that show how to develop templates deployable to both Azure and Azure Stack Hub.

## Next steps

For more information about Azure Stack development, see the following articles:

* [Azure Resource Manager template best practices](azure-stack-develop-templates.md)
* [Azure Stack Hub quickstart templates on GitHub](https://github.com/Azure/AzureStack-QuickStart-Templates)
