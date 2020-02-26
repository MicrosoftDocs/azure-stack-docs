---
title: Create a subscription with an offer in Azure Stack Hub 
description: Learn how to create a new subscription with an offer in Azure Stack Hub and then test the offer with a test VM.
author: bryanla

ms.topic: tutorial
ms.date: 06/04/2019
ms.author: bryanla
ms.reviewer: efemmano
ms.lastreviewed: 11/13/2019

# Intent: As an Azure Stack user, I want an example showing me how to create a subscription with an offer and then test it.
# Keyword: create subscription azure stack

---


# Tutorial: Create and test a subscription in Azure Stack Hub

This tutorial shows how to create a subscription containing an offer and then how to test it. For the test, you sign in to the Azure Stack Hub user portal as a cloud admin, subscribe to the offer, and then create a virtual machine (VM).

> [!TIP]
> For more a more advanced evaluation experience, you can [create a subscription for a particular user](../operator/azure-stack-subscribe-plan-provision-vm.md#create-a-subscription-as-a-cloud-operator) and then sign in as that user in the user portal.

This tutorial shows how to subscribe to an Azure Stack Hub offer.

What you'll learn:

> [!div class="checklist"]
> * Subscribe to an offer 
> * Test the offer

## Subscribe to an offer

To subscribe to an offer as a user, sign in to the Azure Stack Hub user portal to check the available services offered by the Azure Stack Hub operator.

1. Sign in to the user portal and select **Get a subscription**.

   ![Get a subscription](media/azure-stack-subscribe-services/get-subscription.png)

2. In the **Display Name** field, type a name for your subscription. Then select **Offer** to choose one of the available offers in the **Choose an offer** section. Then select **Create**.

   ![Create an offer](media/azure-stack-subscribe-services/create-subscription.png)

   > [!TIP]
   > Refresh the user portal to start using your subscription.

3. To view the subscription you created, select **All services**. Then, under the **GENERAL** category select **Subscriptions**, and then select your new subscription. After you subscribe to an offer, refresh the portal to see if new services have been included as part of the new subscription. In this example, **Virtual machines** has been added.

   ![View subscription](media/azure-stack-subscribe-services/view-subscription.png)

## Test the offer

While signed in to the user portal, test the offer by provisioning a VM using the new subscription capabilities.

> [!NOTE]
> This test requires that a Windows Server 2016 Datacenter VM first be added to the Azure Stack Hub Marketplace.

1. Sign in to the user portal.

2. In the user portal, select **Virtual Machines**, then **Add**, then **Windows Server 2016 Datacenter**, and then select **Create**.

3. In the **Basics** section, type a **Name**, **User name**, and **Password**, choose a **Subscription**, create a **Resource group** (or select an existing one), and then select **OK**.

4. In the **Choose a size** section, select **A1 Standard**, and then choose **Select**.  

5. In the **Settings** blade, accept the defaults and select **OK**.

6. In the **Summary** section, select **OK** to create the VM.  

7. To see your new VM, select **Virtual machines**, then search for the new VM, and select its name.

    ![All resources](media/azure-stack-subscribe-services/view-vm.png)

> [!NOTE]
> The VM deployment takes a few minutes to complete.

## Next steps

> [!div class="nextstepaction"]
> [Create a VM from a community template](azure-stack-create-vm-template.md)
