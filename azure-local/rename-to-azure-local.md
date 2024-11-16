---
title: Renaming Azure Stack HCI to Azure Local
description: This article provides the renaming information for Azure Stack HCI to Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-stack-hci
ms.date: 11/16/2024
---

# New name for Azure Stack HCI

[!INCLUDE [hci-applies-to-23h2-22h2](includes/hci-applies-to-23h2-22h2.md)]

Azure Stack HCI is now a part of Azure Local. Microsoft has renamed Azure Stack HCI to Azure Local to communicate a single brand that unifies the entire distributed infrastructure portfolio. This article describes Azure Local as the new name for Azure Stack HCI and answers commonly asked questions related to this rename.

## No interruptions to usage or service

If you're currently using Azure Stack HCI today or previously deployed Azure Stack HCI in your organizations, you can continue to use the service without interruption. All existing deployments, configurations, and integrations continue to function as they do today without any action from you.

All features and capabilities are still available in the product. Pricing, licensing, service-level agreements, product certifications, and support remain the same. Details on pricing and what’s included are available on the [Pricing page](https://aka.ms/azloc-pricing).

The product terms for existing Azure Stack HCI are the same but new terms will apply for Azure Local. Microsoft will publish the new terms later this year.

To make the transition seamless, all existing sign in URLs, APIs, PowerShell cmdlets, and Azure Command-line Interface (CLI) stay the same, as do developer experiences and tooling.

<!--For self-service support, look for the topic path of Azure Local. - verify with CSS -->

The product name is changing, and features are now branded as Azure Local instead of Azure Stack HCI. If you're updating the name to Azure Local in your own content or experiences, see [Naming changes and exceptions](#naming-changes-and-exceptions).

## Naming changes and exceptions

### Product name

Here are the naming changes:

- Azure Local is the new name for Azure Stack HCI. Azure Local doesn’t have an acronym.
- Azure Stack HCI clusters are renamed as Azure Local instances.
- Azure Stack HCI servers are renamed as Azure Local machines.

### Logo and icons

Azure Local product logo and icons continue to be the same as those for Azure Stack HCI.

### What names aren't changing?

The following table lists what isn't impacted by the rename.

| Components/Terms | Details |
|---------------------|---------|
| Azure Stack HCI APIs/namespace  | The Azure Stack HCI APIs/namespaces continue to remain the same. No breaking changes were made and you won’t be required to update the code. |
| Azure Stack HCI resource provider        | The `Microsoft.AzureStackHCI` resource provider name remains the same. |
| Azure Stack HCI PowerShell cmdlets | The Azure Stack HCI PowerShell cmdlets remain the same. |
| Azure Stack HCI CLI | The Azure CLI commands for Azure Stack HCI and Arc VM management continue to remain the same.  |
| Azure Stack HCI OS  | The Azure Stack HCI Operating System (OS) which is a component of the Azure Local, will remain the same. |
| Azure Stack HCI OEM License | The license name remains the same. |
| Azure Stack HCI documentation | The text changes for Azure Stack HCI documentation (on Learn) were made for the entire portfolio. Screenshots and conceptual diagrams are a work in progress and will be finished in coming months. <br><br> Documentation for older versions of Azure Stack HCI, for example, 22H2 only, will continue to reference Azure Stack HCI and not reflect the name change. <br><br> Release notes and security updates that are more than 6 months older, will also not reflect the name change.|


## Frequently asked questions

### When is the name change happening?

The name change across the text strings in Microsoft experiences such as product page, pricing page, and Azure Stack HCI and AKS-HCI Learn pages is effective from November 19, 2024. The names in the text strings in the Azure portal will be completed by early 2025. Screenshot changes across the Learn pages will be completed by early 2025.

### Why is the name being changed?

The Azure Local name more accurately represents the entire unified distributed infrastructure portfolio. As part of our ongoing commitment to simplify experiences for everyone, the renaming of Azure Stack HCI to Azure Local is designed to make it easier to use and navigate the unified and expanded capabilities of Azure Local.


### Where can I manage Azure Local?

You can continue to manage Azure Local in the [Azure portal](https://portal.azure.com).

### Is Azure Stack HCI going away?

No, only the name Azure Stack HCI is going away. The product capabilities remain the same and continue to expand.

### Are licenses changing? Are there any changes to pricing?

No. Prices and service level agreements (SLAs) remain the same.

The product terms for existing Azure Stack HCI remain the same. A new set of product terms for Azure Local will be published later this year. The new terms will apply to the customers who will update to 2411 release.

The Azure billing meters for Azure Stack HCI will be renamed with meter ID updates. This change will be completed by early 2025. The meter name and ID changes don’t affect prices. However, you might notice some changes in how your Azure consumption is shown on your invoice, price sheet, API, usage details file, and **Cost Management + Billing** experiences.

### Are PowerShell cmdlets and Azure CLI commands being renamed?

No. Both the PowerShell cmdlets and Azure CLI commands for Arc VM management and for Azure Stack HCI system, service, and management continue to remain the same.

### How and when are customers being notified?

The name changes were publicly announced on November 19, 2024.

Banners, alerts, and message center posts will notify users of the name change. The change will also be displayed on the Azure Local overview page in the Azure portal, Azure Local Catalog pages, and Microsoft Learn.

### What if I use the Azure Local name in my content?

We'd like your help spreading the word about the name change and implementing it in your own experiences. If you're a content creator, author of internal documentation for IT or Azure Local IT admin, independent software vendor, or Microsoft partner, you can use the naming guidance outlined in this document to make the name change in your content and product experiences.

## Next steps

- [Learn more about Azure Local](./overview.md)
- [Get started using Azure Local](./deploy/deployment-introduction.md)

