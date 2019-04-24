---
title: Delete quotas, plans, offers, and subscriptions | Microsoft Docs
description: Learn how to delete Azure Stack quotas, plans, offers, and subscriptions.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.assetid:  
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 04/25/2019
ms.author: sethm
ms.reviewer: ''
ms.lastreviewed: 04/25/2019
---

# Delete quotas, plans, offers, and subscriptions

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

This article describes how to delete quotas, plans, offers, and subscriptions that you no longer need. As a general principle, you can delete only what is not in use. For example, deleting an offer is only possible if there are no subscriptions that belong to that offer.

Subscriptions are the exception to this general principle: you can delete subscriptions that contain resources; and the resources will be deleted along with the subscription.

Therefore, if you want to delete a quota, you must work back through any plans and offers that use that quota: starting with the offers, ensure they have no subscriptions, delete each offer, then delete the plans that use the quota, and so on.

## Delete a subscription

To delete a subscription, select **All services**, then **User subscriptions**, to display a list of all subscriptions on the system. If you are working on an offer, you can also select **Subscriptions** from there.

You can delete subscriptions from this list, or you can use PowerShell to write a script that deletes all subscriptions for you, using the commands documented in the [Subscriptions - Delete reference](/rest/api/azurestack/subscriptions/delete).

> [!CAUTION]
> Deleting a subscription also deletes any data and resources it contains.

## Delete an offer

To delete an offer, in the Administrator portal, go to **All services**, then **Offers**. Select the offer you want to delete, then select **Delete**.

![delsub1](media/azure-stack-delete-offer/delsub1.png)

You can only delete an offer when there are no subscriptions using it. If subscriptions exist based on the offer, the **Delete** option is greyed out. In this case, see the [Delete a subscription](#delete-a-subscription) section.

## Delete a plan

To delete a plan, in the Administrator portal go to **All services**, then **Plans**. Select the plan you want to delete, then select **Delete**.

![delsub2](media/azure-stack-delete-offer/delsub2.png)

You can only delete a plan when there are no offers using it. If there are current offers that use the plan, delete the plan, allow it to fail, and you will receive an error message. You can select **Parent offers** to display a list of offers that use the plan. For more information about deleting offers, see [Delete an offer](#delete-an-offer).

## Edit and delete a quota

You can view and edit existing quotas using the Administrator portal: select **Region Management**, then select the relevant resource provider, and click on **Quotas**. You can also delete quotas for certain resource providers.

![delsub3](media/azure-stack-delete-offer/delsub3.png)

Alternatively, you can delete some quotas using these REST APIs:

- [Compute](/rest/api/azurestack/quotas%20(compute)/delete)
- [Network](/rest/api/azurestack/quotas%20(network)/delete)
- [Storage](/rest/api/azurestack/storagequotas/delete)

> [!NOTE]
> You cannot delete a quota if there are any current plans that use it. You must first delete the plan that references the quota.

## Next steps

- [Create subscriptions](azure-stack-subscribe-plan-provision-vm.md)
- [Provision a virtual machine](../user/azure-stack-create-vm-template.md)