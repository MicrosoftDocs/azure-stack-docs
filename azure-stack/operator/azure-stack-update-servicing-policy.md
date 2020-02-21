---
title: Apply an original equipment manufacturer (OEM) update to Azure Stack Hub 
description: Learn to apply an original equipment manufacturer (OEM) update to Azure Stack Hub.
author: IngridAtMicrosoft

ms.topic: article
ms.date: 1/22/2020
ms.author: inhenkel
ms.lastreviewed: 09/10/2019
ms.reviewer: ppacent 

---

# Azure Stack Hub servicing policy

This article describes the servicing policy for Azure Stack Hub integrated systems, what you must do to keep your system in a supported state, and how to get support.

## Keep your system under support

To continue to receive support, you must keep the updates on your Azure Stack Hub current.

For your Azure Stack Hub system to remain in a supported state, the instance must run the most recently released update version or run either of the two preceding update versions.

Hotfixes are not considered major update versions. If your Azure Stack Hub system is behind by *more than two updates*, it's considered out of compliance. You must update to at least the minimum supported version to receive support.

For example, if the most recently available update version is 1904, and the previous two update packages were versions 1903 and 1902, both 1902 and 1903 remain in support. However, 1901 is out of support. The policy holds true when there is no release for a month or two. For example, if the current release is 1807 and there was no 1806 release, the previous two update packages of 1805 and 1804 remain in support.

Microsoft software update packages are non-cumulative and require the previous update package or hotfix as a prerequisite. If you decide to defer one or more updates, consider the overall runtime if you want to get to the latest version.

## Get support

Azure Stack Hub follows the same support process as Azure. Enterprise customers can follow the process described in [How to create an Azure support request](https://docs.microsoft.com/azure/azure-supportability/how-to-create-azure-support-request). If you are a customer of a Cloud Solution Provider (CSP), contact your CSP for support. For more information, see the [Azure Support FAQs](https://azure.microsoft.com/support/faq/).

## Next steps

[Manage updates in Azure Stack Hub](azure-stack-updates.md)
