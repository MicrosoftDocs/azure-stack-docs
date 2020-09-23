---
title: Azure Stack Hub help and support
description: Get support for Microsoft Azure Stack Hub.
author: justinha
ms.topic: article
ms.date: 02/26/2020
ms.author: justinha
ms.reviewer: shisab
ms.lastreviewed: 02/26/2020


# Intent: As an Azure Stack Hub user, I want to collect diagnostic logs and get expert help and support with Azure Stack.
# Keyword: azure stack hub help support

---
# Azure Stack Hub help and support

::: moniker range=">= azs-2002"

Azure Stack Hub operators can use **Help + support** to collect diagnostic logs and send them to Microsoft for troubleshooting. **Help + support** in the Azure Stack Hub portal can be accessed from the administrator portal. It has resources to help operators learn more about Azure Stack, check their support options, and get expert help.  

![How to access help and support in Azure Stack Hub administrator portal](media/azure-stack-help-and-support/help-and-support.png)

## Help resources

Operators can use **Help + support** to learn more about Azure Stack Hub, check their support options, and get expert help.

### Things to try first

At the top of **Help + support** are things you should try first, like read about new concepts, learn how billing works, or see which support options are available.

![Self-service support in Azure Stack Hub](media/azure-stack-help-and-support/get-support-tiles.png)

- **Documentation**. [Azure Stack Hub Operator Documentation](index.yml) includes concepts, how-to topics, and tutorials that show how to offer Azure Stack Hub services. These services include virtual machines, SQL databases, web apps, and more.

- **Learn about billing**. Get tips on [usage and billing](azure-stack-billing-and-chargeback.md).

- **Support options**. Azure Stack Hub operators can choose from a range of [Azure support options](https://aka.ms/azstacksupport) that can fit the needs of any enterprise.

### Get expert help

For an integrated system, there's a coordinated escalation and resolution process between Microsoft and our original equipment manufacturer (OEM) hardware partners.

If there's a cloud services issue, support is offered through Microsoft Support. You can select **Help** (question mark) in the upper-right corner of the administrator portal and then select **Help + support** to open **Help + Support Overview** and submit a new support request. Creating a support request will preselect Azure Stack Hub service. We highly recommend that customers use this experience to submit tickets rather than using the Global Azure portal.

If there's an issue with deployment, patch and update, hardware (including field replaceable units), and any hardware-branded software (like software running on the hardware lifecycle host), contact your OEM hardware vendor first. For anything else, contact Microsoft Support.

![Get expert help for integrated systems](media/azure-stack-help-and-support/get-support-integrated.png)

For the Azure Stack Development Kit (ASDK), you can ask support-related questions in the [Azure Stack Hub MSDN Forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack).

Select **Help** (question mark) in the upper-right corner of the administrator portal and then select **Help + support** to open **Help + Support Overview**, which has a link to the forum. MSDN forums are regularly monitored. Because the ASDK is an evaluation environment, there's no official support offered through Microsoft Support.

You can also reach out to the MSDN Forums to discuss an issue, or take online training and improve your own skills.

![Get expert help for Azure Stack Hub](media/azure-stack-help-and-support/get-support-cards.png)

### Get up to speed with Azure Stack Hub

This set of tutorials is customized depending on whether you're running the ASDK or integrated systems so you can quickly get up to speed with your environment.

![Get support tutorials for Azure Stack Hub](media/azure-stack-help-and-support/get-support-tutorials.png)

## Diagnostic log collection

You can send diagnostic logs to Microsoft in two ways:

- [Send logs proactively](./azure-stack-configure-automatic-diagnostic-log-collection.md?view=azs-2002): If enabled, log collection is triggered by specific health alerts.
- [Send logs now](./azure-stack-configure-on-demand-diagnostic-log-collection-portal.md?view=azs-2002): You can manually choose a specific sliding window as the time frame for log collection.

![Screenshot that shows how to start collecting diagnostic logs.](media/azure-stack-help-and-support/banner-enable-automatic-log-collection.png)

::: moniker-end
::: moniker range="<= azs-1910"

## Diagnostic log collection

Beginning with the 1907 release, there are two new ways to collect logs in **Help and support**:

- **Automatic collection**: If enabled, log collection is triggered by specific health alerts.
- **Collect logs now**: You can choose a 1-4 hour sliding window from the last seven days.

![Diagnostic log collection options](media/azure-stack-automatic-log-collection/azure-stack-log-collection-overview.png)

Integrated systems can share the diagnostic logs with Microsoft Support. Because Azure Stack Development Kit (ASDK) is an evaluation environment, it's not supported by Microsoft Support. For more information, see [Azure Stack Hub diagnostic log collection overview](azure-stack-diagnostic-log-collection-overview.md).

## Help and support for earlier releases Azure Stack Hub (pre-1905)

Previous Azure Stack Hub releases also have a link to **Help + support** that redirects to the [Azure Stack Hub Operator Documentation](https://aka.ms/adminportaldocs).

![Get support tutorials](media/azure-stack-help-and-support/get-support-previous.png)

If there's a cloud services issue, support is offered through Microsoft Support. You can select **Help** (question mark) in the upper-right corner of the administrator portal, select **Help and Support**, and then select **New support request** to directly submit a new support request with Microsoft Support.

For an integrated system, there's a coordinated escalation and resolution process between Microsoft and our OEM partners. If there's a cloud services issue, support is offered through Microsoft Support.

If there's an issue with deployment, patch and update, hardware (including field replaceable units), and any hardware-branded software, like software running on the hardware lifecycle host, contact your OEM hardware vendor first. For anything else, contact Microsoft Support.

For the ASDK, you can ask support-related questions in the [Azure Stack Hub MSDN Forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack).

Select **Help** (question mark) in the upper-right corner of the administrator portal and then select **New support request** to get help from experts in the Azure Stack Hub community. Because the ASDK is an evaluation environment, there's no official support offered through Microsoft Support.

::: moniker-end

## Next steps

- Learn about [diagnostic log collection](./azure-stack-diagnostic-log-collection-overview.md?view=azs-2002).
- Learn how to [find your Cloud ID](azure-stack-find-cloud-id.md).
- Learn about [troubleshooting Azure Stack Hub](azure-stack-troubleshooting.md).
