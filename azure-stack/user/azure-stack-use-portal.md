---
title: Use the Azure Stack Hub user portal 
description: Learn how to access and use the user portal in Azure Stack Hub.
author: sethmanheim

ms.topic: how-to
ms.date: 2/1/2021
ms.author: sethm
ms.reviewer: efemmano
ms.lastreviewed: 01/25/2019

# Intent: As an Azure Stack user, I want to use the portal so I can subscribe to offers and use the services the offers provide.
# Keyword: azure stack portal 

---

# Use the Azure Stack Hub user portal

Use the Azure Stack Hub portal to subscribe to public offers and use the services that these offers provide. If you've used the global Azure portal, you're already familiar with how the site works.

## Access the portal

Your Azure Stack Hub operator (either a service provider or an admin in your organization), will let you know the correct URL to access the portal.

- For an integrated system, the URL varies based on your operator's region and external domain name, and will be in the format https://portal.&lt;*region*&gt;.&lt;*FQDN*&gt;.
- If you're using the Azure Stack Development Kit (ASDK), the portal address is `https://portal.local.azurestack.external`.
- The default time zone for all Azure Stack Hub deployments is set to Coordinated Universal Time (UTC). You can select a time zone when installing Azure Stack Hub but it automatically reverts to UTC as the default during installation.

## Customize the dashboard

The dashboard contains a default set of tiles. Select **Edit dashboard** to modify the default dashboard, or select **New dashboard** to create a custom dashboard. You can easily customize a dashboard by adding or removing tiles. For example, to add a Compute tile, select **+ Create a resource**. right-click **Compute**, and then select **Pin to dashboard**.

![Screen capture of the Azure Stack Hub user portal](media/azure-stack-use-portal/userportal.png)

To restore the dashboard to the original settings:
1.  Select **Edit Dashboard**. 
2.  Right-click and select **Reset to default state**.

## Create subscription and browse available resources

If you don't already have a subscription, you need to subscribe to an offer. After that, you can browse the available resources. To browse and create resources, use any of the following approaches:

- Select the **Marketplace** tile on the dashboard.
- On the **All resources** tile, select **Create resources**.
- On the left navigation pane, select **+ Create a resource**.

## Learn how to use available services

If you need guidance for how to use available services, there may be different options available to you.

- Your organization or service provider may provide their own documentation, which is typically the case if they offer customized services or apps.
- Third-party apps have their own documentation.
- For Azure-consistent services, we strongly recommend that you first review the Azure Stack Hub documentation. To access the Azure Stack Hub user documentation, select the help icon (**?**), and then select **Help + support**.

    ![Help and support option in the UI](media/azure-stack-use-portal/HelpAndSupport.png)

    In particular, we suggest that you review the following articles to get started:

    - [Key considerations: Using services or building apps for Azure Stack Hub](azure-stack-considerations.md).
    - In the **Use services** section of the documentation, there's a considerations article for each service. The considerations page describes the differences between the service offered in Azure, and the same service offered in Azure Stack Hub. For an example, see [VM considerations](azure-stack-vm-considerations.md). There may be other information in the **Use services** section that's unique to Azure Stack Hub.

      You can use the Azure documentation as general reference for a service, but you must be aware of these differences. Understand that the documentation links on the **Quickstart tutorials** tile point to Azure documentation.

## Get support

If you need support, contact your organization or service provider for help.

If you're using the Azure Stack Development Kit (ASDK), the [Azure Stack Hub forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack) is the only source of support.

## Next steps

[Key considerations: Using services or building apps for Azure Stack Hub](azure-stack-considerations.md)
