---
title: Microsoft Azure Stack Hub help and support overview 
description: Get support for Microsoft Azure Stack Hub.
author: justinha

ms.topic: article
ms.date: 02/26/2020
ms.author: justinha
ms.reviewer: shisab
ms.lastreviewed: 02/26/2020

---
# Microsoft Azure Stack Hub help and support

Azure Stack Hub operators can use **Help + support** to collect diagnostic logs and send them to Microsoft for troubleshooting. **Help + support** in the Azure Stack Hub portal can be accessed from the Administrator portal. It has resources to help operators learn more about Azure Stack, check their support options, and get expert help.  

![Screenshot of how to access Help and Support in the Administrator portal](media/azure-stack-help-and-support/help-and-support.png)

## Help resources 

Operators can use **Help + support** to learn more about Azure Stack Hub, check their support options, and get expert help. 

### Things to try first

At the top of **Help + support** are links to things you might try first, like read up about a new concept, understand how billing works, or see which support options are available. 

![Self-service support](media/azure-stack-help-and-support/get-support-tiles.png)

- **Documentation**. [Azure Stack Hub Operator Documentation](index.yml) includes concepts, how-to topics, and tutorials that show how to offer Azure Stack Hub services such as virtual machines, SQL databases, web apps, and more. 

- **Learn about billing**. Get tips on [usage and billing](azure-stack-billing-and-chargeback.md).

- **Support options**. Azure Stack Hub operators can choose from a range of [Azure support options](https://aka.ms/azstacksupport) that can fit the needs of any enterprise. 


### Get expert help 

For an integrated system, there is a coordinated escalation and resolution process between Microsoft and our original equipment manufacturer (OEM) hardware partners.

If there is a cloud services issue, support is offered through Microsoft Customer Support Services (CSS). 
You can click **Help** (question mark) in the upper-right corner of the administrator portal and then click **Help + support** to open **Help + Support Overview** and submit a new support request. Creating a support request will preselect Azure Stack Hub service. We highly recommend that customers use this experience to submit tickets rather than using the Global Azure portal. 

If there is an issue with deployment, patch and update, hardware (including field replaceable units), and any hardware-branded software, such as software running on the hardware lifecycle host, contact your OEM hardware vendor first. 
For anything else, contact Microsoft CSS.

![Get expert help for integrated systems](media/azure-stack-help-and-support/get-support-integrated.png)

For the ASDK, you can ask support-related questions in the [Azure Stack Hub MSDN Forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack). 

You can click **Help** (question mark) in the upper-right corner of the administrator portal and then click **Help + support** to open **Help + Support Overview**, which has a link to the forum. 
MSDN forums are regularly monitored.  
Because the development kit is an evaluation environment, there is no official support offered through Microsoft CSS.

You can also reach out to the MSDN Forums to discuss an issue, or take online training and improve your own skills. 

![Get expert help](media/azure-stack-help-and-support/get-support-cards.png)

### Get up to speed with Azure Stack Hub

This set of tutorials is customized depending on whether you're running the ASDK or integrated systems so you can quickly get up to speed with your environment. 

![Get support tutorials](media/azure-stack-help-and-support/get-support-tutorials.png)

## Diagnostic log collection

There are two ways to send diagnostic logs to Microsoft: 

- [Send logs proactively](azure-stack-configure-automatic-diagnostic-log-collection-tzl.md): If enabled, log collection is triggered by specific health alerts 
- [Send logs now](azure-stack-configure-on-demand-diagnostic-log-collection-portal-tzl.md): You can manually choose a specific sliding window as the time frame for log collection

![Screenshot of diagnostic log collection options](media/azure-stack-help-and-support/banner-enable-automatic-log-collection.png)


## Next steps

- Learn about [diagnostic log collection](azure-stack-diagnostic-log-collection-overview-tzl.md)
- Learn how to [find your Cloud ID](azure-stack-find-cloud-id.md)
- Learn about [troubleshooting Azure Stack Hub](azure-stack-troubleshooting.md)
