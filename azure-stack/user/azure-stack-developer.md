---
title: Develop apps for Azure Stack | Microsoft Docs
description: Development considerations for prototyping apps on Azure Stack using Azure services.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.assetid: d3ebc6b1-0ffe-4d3e-ba4a-388239d6cdc3
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/01/2019
ms.author: sethm
ms.reviewer: unknown
ms.lastreviewed: 05/21/2019

---

# Develop for Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can get started developing apps today, even if you do not have access to an Azure Stack environment. Azure Stack delivers Microsoft Azure services that run in your datacenter, which means you can use the same Azure tools and processes to develop on Azure Stack.

## Development considerations

With some preparation, and using the guidance in the following topics, you can use Azure to emulate an Azure Stack environment.

* In Azure, you can create Azure Resource Manager templates that are deployable to Azure Stack. See [template considerations](azure-stack-develop-templates.md) for guidance on developing templates to ensure portability.
* There are differences in service availability and service versioning between Azure and Azure Stack. You can use the [Azure Stack policy module](azure-stack-policy-module.md) to restrict Azure service availability and resource types to what is available in Azure Stack. Constraining services ensures that your apps rely on services available to Azure Stack.
* The [Azure Stack Quickstart Templates](https://github.com/Azure/AzureStack-QuickStart-Templates) are common scenario examples that show how to develop templates deployable to both Azure and Azure Stack.

## Next steps

For more information about Azure Stack development, see the following articles:

* [Azure Resource Manager template best practices](azure-stack-develop-templates.md)
* [Azure Stack Quickstart Templates on GitHub](https://github.com/Azure/AzureStack-QuickStart-Templates)
