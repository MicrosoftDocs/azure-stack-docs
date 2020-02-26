---
title: Microsoft Azure Stack Hub help and support overview 
description: Get support for Microsoft Azure Stack Hub.
author: justinha

ms.topic: article
ms.date: 07/24/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 07/24/2019

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

# Microsoft Azure Stack Hub help and support

**Help + support** in the Azure Stack Hub portal has resources to help operators learn more about Azure Stack Hub, check their support options, and get expert help. Beginning with the 1907 release, operators can also use Help + support to collect diagnostic logs for troubleshooting.  

## Help resources 

Operators can also use **Help + support** to learn more about Azure Stack Hub, check their support options, and get expert help. 

### Things to try first

At the top of **Help + support** are links to things you might try first, like read up about a new concept, understand how billing works, or see which support options are available. 

![Self-service support](media/azure-stack-help-and-support/get-support-tiles.png)

- **Documentation**. [Azure Stack Hub Operator Documentation](index.yml) includes concepts, how-to topics and tutorials that show how to offer Azure Stack Hub services such as virtual machines, SQL databases, web apps, and more. 

- **Learn about billing**. Get tips on [usage and billing](azure-stack-billing-and-chargeback.md).

- **Support options**. Azure Stack Hub operators can choose from a range of [Azure support options](https://aka.ms/azstacksupport) that can fit the needs of any enterprise. 

### Get expert help 

For an integrated system, there is a coordinated escalation and resolution process between Microsoft and our original equipment manufacturer (OEM) hardware partners.

If there is a cloud services issue, support is offered through Microsoft Customer Support Services (CSS). 
You can click **Help** (question mark) in the upper-right corner of the administrator portal and then click **Help + support** to open **Help + Support Overview** and submit a new support request. Creating a support request will preselect Azure Stack Hub service. We highly recommend that customers use this experience to submit tickets rather than using the public Azure portal. 

If there is an issue with deployment, patch and update, hardware (including field replaceable units), and any hardware-branded software, such as software running on the hardware lifecycle host, contact your OEM hardware vendor first. 
For anything else, contact Microsoft CSS.

![Get expert help for integrated systems](media/azure-stack-help-and-support/get-support-integrated.png)

For the ASDK, you can ask support-related questions in the [Azure Stack Hub MSDN Forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack). 

You can click **Help** (question mark) in the upper-right corner of the administrator portal and then click **Help + support** to open **Help + Support Overview**, which has a link to the forum. 
MSDN forums are regularly monitored.  
Because the development kit is an evaluation environment, there is no official support offered through Microsoft CSS.

![Get expert help for ASDK](media/azure-stack-help-and-support/get-support-asdk.png)

You can also reach out to the MSDN Forums to discuss an issue, or take online training and improve your own skills. 

![Get expert help](media/azure-stack-help-and-support/get-support-cards.png)

### Get up to speed with Azure Stack Hub

This set of tutorials is customized depending on whether you're running the ASDK or integrated systems so you can quickly get up to speed with your environment. 

![Get support tutorials](media/azure-stack-help-and-support/get-support-tutorials.png)

## Diagnostic log collection

Beginning with the 1907 release, there are two new ways to collect logs in **Help and support**:

- **Automatic collection**: If enabled, log collection is triggered by specific health alerts 
- **Collect logs now**: You can choose a 1-4 hour sliding window from the last seven days

![Screenshot of diagnostic log collection options](media/azure-stack-automatic-log-collection/azure-stack-log-collection-overview.png)

Integrated systems can share the diagnostic logs with Microsoft Customer Support Service (CSS). Because Azure Stack Development Kit (ASDK) is an evaluation environment, it is not supported by CSS. For more information, see [Azure Stack Hub diagnostic log collection overview](azure-stack-diagnostic-log-collection-overview.md).



## Help and support for earlier releases Azure Stack Hub (pre-1905)

Previous Azure Stack Hub releases also have a link to **Help + support** that redirects to the [Azure Stack Hub Operator Documentation](https://aka.ms/adminportaldocs).

![Get support tutorials](media/azure-stack-help-and-support/get-support-previous.png)

If there is a cloud services issue, support is offered through Microsoft Customer Support Services (CSS). 
You can click **Help** (question mark) in the upper-right corner of the administrator portal, click **Help and Support**, and then click **New support request** to directly submit a new support request with CSS.

For an integrated system, there is a coordinated escalation and resolution process between Microsoft and our OEM partners. 
If there is a cloud services issue, support is offered through Microsoft CSS. 

If there is an issue with deployment, patch and update, hardware (including field replaceable units), and any hardware-branded software, such as software running on the hardware lifecycle host, contact your OEM hardware vendor first. 
For anything else, contact Microsoft CSS.

For the development kit, you can ask support-related questions in the [Azure Stack Hub MSDN Forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack). 
You can click **Help** (question mark) in the upper-right corner of the administrator portal and then click **New support request** to get help from experts in the Azure Stack Hub community.
Because the development kit is an evaluation environment, there is no official support offered through Microsoft CSS.

## Next steps

- Learn about the [Troubleshooting Azure Stack Hub](azure-stack-troubleshooting.md)