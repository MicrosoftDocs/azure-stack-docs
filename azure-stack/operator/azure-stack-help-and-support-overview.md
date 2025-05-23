---
title: Azure Stack Hub help and support
description: Get support for Microsoft Azure Stack Hub.
author: sethmanheim
ms.topic: article
ms.date: 01/28/2025
ms.author: sethm
ms.lastreviewed: 01/19/2021


# Intent: As an Azure Stack Hub user, I want to collect diagnostic logs and get expert help and support with Azure Stack.
# Keyword: azure stack hub help support

---
# Azure Stack Hub help and support

Azure Stack Hub operators can use the **Help + support** option to collect diagnostic logs and send them to Microsoft for troubleshooting. **Help + support** in the Azure Stack Hub portal can be accessed from the administrator portal. It has resources to help operators learn more about Azure Stack, check their support options, and get expert help.  

![How to access help and support in Azure Stack Hub administrator portal](media/azure-stack-help-and-support/help-and-support.png)

## Help resources

Operators can use **Help + support** to learn more about Azure Stack Hub, check their support options, and get expert help.

### Things to try first

At the top of **Help + support** are things you should try first, like read about new concepts, learn how billing works, or see which support options are available.

![Self-service support in Azure Stack Hub](media/azure-stack-help-and-support/get-support-tiles.png)

- **Documentation**. The [Azure Stack Hub Operator Documentation](index.yml) includes concepts, how-to instructions, and tutorials that show how to offer Azure Stack Hub services. These services include virtual machines, SQL databases, web apps, and more.
- **Learn about billing**. Get tips on [usage and billing](azure-stack-billing-and-chargeback.md).
- **Support options**. Azure Stack Hub operators can choose from a range of [Azure support options](./azure-stack-manage-basics.md) that can fit the needs of any enterprise.

### Get expert help

For an integrated system, there's a coordinated escalation and resolution process between Microsoft and our original equipment manufacturer (OEM) hardware partners.

If there's a cloud services issue, support is offered through Microsoft Support. You can select **Help** (question mark) in the upper-right corner of the administrator portal and then select **Help + support** to open **Help + Support Overview** and submit a new support request. Creating a support request will preselect the Azure Stack Hub service. We highly recommend that customers use this experience to submit tickets rather than using the Global Azure portal.

If there's an issue with deployment, patch and update, hardware (including field replaceable units), and any hardware-branded software (like software running on the hardware lifecycle host), contact your OEM hardware vendor first. For anything else, contact Microsoft Support.

![Get expert help for integrated systems](media/azure-stack-help-and-support/get-support-integrated.png)

You can also reach out to the MSDN forums to discuss an issue, or take online training and improve your own skills.

![Get expert help for Azure Stack Hub](media/azure-stack-help-and-support/get-support-cards.png)

### Information for a support request

To speed up your support experience, have the following information:

- Are you an Azure Stack Hub hardware partner?
- How many Azure Stack Hub nodes are you in your system?
- What is the current patch level for your system?
- What build number is your system currently running?
- What is the name of your cloud's region?
- Is a connected or disconnected system?
- When did the problem start?
- Can you provide the exact time when the last backup failed?
- For what roles is the backup failing?
- Did you perform any recent changes? For example, did you perform an update, make a hardware change, or apply an OEM update?
- Are you able to provide logs in order to investigate the issue?

### Get up to speed with Azure Stack Hub

This set of tutorials is customized depending on whether you're running the ASDK or integrated systems so you can quickly get up to speed with your environment.

![Get support tutorials for Azure Stack Hub](media/azure-stack-help-and-support/get-support-tutorials.png)

## Diagnostic log collection

You can send diagnostic logs to Microsoft in two ways:

- [Send logs proactively](./diagnostic-log-collection.md#send-logs-proactively): If enabled, log collection is triggered by specific health alerts.
- [Send logs now](./diagnostic-log-collection.md#send-logs-now-with-the-administrator-portal): You can manually choose a specific sliding window as the time frame for log collection.

![Screenshot that shows how to start collecting diagnostic logs.](media/azure-stack-help-and-support/banner-enable-automatic-log-collection.png)

## Next steps

- Learn about [diagnostic log collection](./diagnostic-log-collection.md)
- Learn how to [find your Cloud ID](azure-stack-find-cloud-id.md)
- Learn how to [troubleshoot Azure Stack Hub](azure-stack-troubleshooting.md)
