---
title: Delegating offers in Azure Stack Hub 
description: Learn how to delegate tasks like creating offers and signing up users.
author: sethmanheim

ms.topic: how-to
ms.date: 10/11/2021
ms.author: sethm
ms.reviewer: alfredop
ms.lastreviewed: 05/07/2019

# Intent: As an Azure Stack operator, I want to know how to delegate tasks like creating offers so I can put other people in charge.
# Keyword: azure stack delegate offers

---

# Delegate offers in Azure Stack Hub

As an Azure Stack Hub operator, you might want to put other people in charge of signing up users and creating subscriptions. For example, if you're a service provider, you might want resellers to sign up customers and manage them on your behalf. Or, if you're part of a central IT group in an enterprise, you might want to delegate user sign-up to other IT staff.

Delegation makes it easier to reach and manage more users than you can by yourself, as shown in the following figure:

![Levels of delegation in Azure Stack Hub](media/azure-stack-delegated-provider/image1.png)

With delegation, the delegated provider manages an offer (called a *delegated offer*), and end customers obtain subscriptions under that offer without involvement from the system admin.

## Delegation roles

The following roles are part of delegation:

* The *Azure Stack Hub operator* manages the Azure Stack Hub infrastructure and creates an offer template. The operator delegates others to provide offers to their tenant.

* The delegated Azure Stack Hub operators are users with *Owner* or *Contributor* rights in the subscriptions called *delegated providers*. They can belong to other organizations, such as other Microsoft Entra tenants.

* *Users* sign up for the offers and use them for managing their workloads, creating VMs, storing data, and so on.

## Delegation steps

There are two steps to setting up delegation:

1. **Create a delegated provider subscription**: Subscribe a user to an offer containing only the subscription service. Users who subscribe to this offer can then extend the delegated offers to other users by signing them up for those offers.

2. **Delegate an offer to the delegated provider**: This offer enables the delegated provider to create subscriptions or to extend the offer to their users. The delegated provider can now take the offer and extend it to other users.

The following figure shows the steps for setting up delegation:

![Steps for creating the delegated provider and enabling them to sign up users in Azure Stack Hub](media/azure-stack-delegated-provider/image2.png)

### Delegated provider requirements

To act as a delegated provider, a user establishes a relationship with the main provider by creating a subscription. This subscription identifies the delegated provider as having the right to present the delegated offers on behalf of the main provider.

After this relationship is established, the Azure Stack Hub operator can delegate an offer to the delegated provider. The delegated provider can take the offer, rename it (but not change its substance), and offer it to its customers.

## Delegation walkthrough

The following sections describe the steps to set up a delegated provider, delegate an offer, and verify that users can sign up for the delegated offer.

### Set up roles

To use this walkthrough, you need two Microsoft Entra accounts in addition to your Azure Stack Hub operator account. If you don't have these two accounts, you must create them. The accounts can belong to any Microsoft Entra user and are referred to as the *delegated provider* and the *user*.

| **Role** | **Organizational rights** |
| --- | --- |
| Delegated provider |User |
| User |User |

 > [!NOTE]
 > In the case of a CSP-reseller, creating this delegated provider requires that these users are in the tenant directory (the user Microsoft Entra ID). The Azure Stack Hub operator must [first onboard](enable-multitenancy.md) that tenant Microsoft Entra ID, and then set up usage and billing by following [these steps](azure-stack-csp-howto-register-tenants.md).

### Identify the delegated provider

1. Sign in to the administrator portal as an Azure Stack Hub operator.

1. To create an offer that enables a user to become a delegated provider:

   a.  [Create a plan](azure-stack-create-plan.md).
       This plan should include only the subscription service. This article uses a plan named **PlanForDelegation** as an example.

   b.  [Create an offer](azure-stack-create-offer.md) based on this plan. This article uses an offer named **OfferToDP** as an example.

   c.  Add the delegated provider as a subscriber to this offer by selecting **Subscriptions**, then **Add**, then **New Tenant Subscription**.

   ![Add the delegated provider as a subscriber in Azure Stack Hub administrator portal](media/azure-stack-delegated-provider/image3.png)

   > [!NOTE]
   > As with all Azure Stack Hub offers, you have the option of making the offer public and letting users sign up for it, or keeping it private and letting the Azure Stack Hub operator manage the sign-up. Delegated providers are usually a small group. You want to control who is admitted to it, so keeping this offer private makes sense in most cases.

### Azure Stack Hub operator creates the delegated offer

The next step is to create the plan and offer that you're going to delegate, and that your users will use. It's a good idea to define this offer as you want users to see it because the delegated provider can't change the plans and quotas it includes.

1. As an Azure Stack Hub operator, [create a plan](azure-stack-create-plan.md) and [an offer](azure-stack-create-offer.md) based on the plan. This article uses an offer named **DelegatedOffer** as an example.

   > [!NOTE]
   > This offer doesn't have to be public, but you can make it public. However, in most cases, you only want delegated providers to have access to the offer. After you delegate a private offer as described in the following steps, the delegated provider has access to it.

2. Delegate the offer. Go to **DelegatedOffer**. Under **Settings**, select **Delegated Providers**, then select **Add**.

3. Select the subscription for the delegated provider from the drop-down list, and then select **Delegate**.

   ![Add a delegated provider in Azure Stack Hub administrator portal](media/azure-stack-delegated-provider/image4.png)

### Delegated provider customizes the offer

Sign in to the user portal as the delegated provider and then create a new offer by using the delegated offer as a template.

1. Select **+ Create a resource**, then **Tenant Offers + Plans**, then select **Offer**.

    ![Create a new offer in Azure Stack Hub user portal](media/azure-stack-delegated-provider/image5.png)

2. Assign a name to the offer. This example uses **ResellerOffer**. Select the delegated offer on which to base it, and then select **Create**.

   ![Assign a name in Azure Stack Hub user portal](media/azure-stack-delegated-provider/image6.png)

   >[!IMPORTANT]
   >Delegated providers can only choose offers that are delegated to them. They cannot make changes to those offers; only an Azure Stack Hub operator can change these offers. For example, only an operator can change their plans and quotas. A delegated provider does not construct an offer from base plans and add-on plans.

3. The delegated provider can make these offers public through their own portal URL. To make the offer public, select **Browse**, and then **Offers**. Select the offer, and then select **Change State**.

4. The public delegated offers are now visible only through the delegated portal. To find and change this URL:

    a.  Select **Browse**, then **All services**, and then under the **GENERAL** category, select **Subscriptions**. Select the delegated provider subscription (for example, **DPSubscription**), then **Properties**.

    b.  Copy the portal URL to a separate location, such as Notepad.

    ![Select the delegated provider subscription in Azure Stack Hub user portal](media/azure-stack-delegated-provider/dpportaluri.png)  

   You've finished creating a delegated offer as a delegated provider. Sign out as the delegated provider and close the browser window.

### Sign up for the offer

1. In a new browser window, go to the delegated portal URL that you saved in the previous step. Sign in to the portal as a user.

   >[!NOTE]
   >The delegated offers are not visible unless you use the delegated portal.

1. In the dashboard, select **Get a subscription**. You'll see that only the delegated offers that were created by the delegated provider are presented to the user.

   ![View and select offers in Azure Stack Hub user portal](media/azure-stack-delegated-provider/image8.png)

The process of delegating an offer is finished. Now a user can sign up for this offer by getting a subscription to it.

## Move subscriptions between delegated providers

If needed, a subscription can be moved between new or existing delegated provider subscriptions that belong to the same directory tenant. You can move them using the PowerShell cmdlet [Move-AzsSubscription](/powershell/module/azs.subscriptions.admin).

Moving subscriptions is useful when:

* You onboard a new team member that will take on the delegated provider role and you want to assign to this team member user subscriptions that were previously created in the default provider subscription.
* You have multiple delegated providers subscriptions in the same directory tenant (Microsoft Entra ID) and need to move user subscriptions between them. This scenario could occur when a team member moves between teams and their subscription must be allocated to the new team.

## Next steps

* [Provision a VM](../user/azure-stack-create-vm-template.md)
