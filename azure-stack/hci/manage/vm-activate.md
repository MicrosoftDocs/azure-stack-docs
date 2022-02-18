---
title: Activate Windows Server VMs using Automatic Virtual Machine Activation
description: This topic explains the benefits of using Automatic Virtual Machine Activation over other activation methods and provides instructions on setting up this optional feature on Azure Stack HCI.
author: jelei
ms.author: jelei
ms.topic: how-to
ms.date: 02/18/2021

---

# Activate Windows Server VMs using Automatic Virtual Machine Activation

>Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022, Windows Server 2019 Datacenter Edition and later

Automatic Virtual Machine Activation (AVMA) is an optional feature in Azure Stack HCI that you can use to activate Windows Server VMs running on Azure Stack HCI hosts. This article explains the advantages of using Automatic Virtual Machine Activation over other activation methods, and provides instructions on setting up this feature on Azure Stack HCI.

To use other methods to activate VMs, see [Key Management Services (KMS) activation](/windows-server/get-started/kms-activation-planning).

## Background: Why use Automatic Virtual Machine Activation?

Automatic Virtual Machine Activation allows properly activated host servers to activate VMs. The process binds VM activation to host servers, instead of to each individual VM.

:::image type="content" source="./media/vm-activation/avma-binding-process.png" alt-text="Conceptual figure showing how Automatic Virtual Machine Activation binds the VM activation key process to each host server instead of binding the process to each VM running on top of each host server." lightbox="./media/vm-activation/avma-binding-process.png":::

There are several benefits to this approach:

- Individual VMs don't have to be connected to the internet. Only licensed host servers with internet connectivity are required.
- License management is simplified. Instead of having to true-up key usage counts for individual VMs, you can activate any number of VMs with just a properly licensed server.
- Automatic Virtual Machine Activation acts as a proof-of-purchase mechanism. This capability helps to ensure that Windows products are used in accordance with Product Use Rights and Microsoft Software License Terms.

## Two ways to license for AVMA

There are two options for purchasing licensing for Automatic Virtual Machine Activation, although both use the same mechanism behind the scenes. Choose the option that best serves your needs:

:::image type="content" source="media/vm-activation/compare.png" alt-text="Two AVMA options":::

- [Pricing details for Windows Server subscription](https://azure.microsoft.com/pricing/details/azure-stack/hci/)
- [Pricing details for Windows Server licenses](https://www.microsoft.com/windows-server/pricing)

> [!NOTE]
> This article describes how to activate and set up Automatic Virtual Machine Activation on the host cluster. To complete end-to-end activation, activate VMs against the activated hosts by [following the steps here](/windows-server/get-started/automatic-vm-activation).

## Windows Server subscription

Windows Server subscription is a simple and flexible option for Windows Server guest licensing, exclusively for Azure Stack HCI customers.

### How does Windows Server subscription work?

When Windows Server subscription is turned on, Azure Stack HCI servers retrieve licenses from the cloud and automatically set up Automatic Virtual Machine Activation. In other words, you simply enroll in the subscription – there are no other steps required to set up Automatic Virtual Machine Activation, and you can start activating Windows Server VMs right away.

:::image type="content" source="media/vm-activation/windows-server-subscription.png" alt-text="Windows Server subscription":::

### What guest versions does Windows Server subscription activate?

Windows Server subscription always enables you to get the latest Windows Server version, all previous editions, and Windows Server Azure Edition. Currently, the versions include:

|     Guest versions activated    |     BYO 2019 key    |     BYO 2022 key    |     Subscription    |
|---------------------------------|---------------------|---------------------|---------------------|
|     2012                        |     Y               |     Y               |     Y               |
|     2012 R2                     |     Y               |     Y               |     Y               |
|     2016                        |     Y               |     Y               |     Y               |
|     2019                        |     Y               |     Y               |     Y               |
|     2022                        |                     |     Y               |     Y               |
|     Azure Edition               |                     |                     |     Y               |

For more information about product key requirements, see the [Bring your own license](#bring-your-own-license) section.

### Prerequisites

- An Azure Stack HCI cluster
  - [Install updates](update-cluster.md): Version 21H2, with at least the December 14, 2021 security update KB5008210 or later.
  - [Register Azure Stack HCI](../deploy/register-with-azure.md#register-a-cluster-using-windows-admin-center): All servers must be online and registered to Azure.

- If using Windows Admin Center:
  - Windows Admin Center (version 2103 or later) with the Cluster Manager extension (version 2.41.0 or later).

### Enable Windows Server subscription using the Azure portal

1. In your Azure Stack HCI cluster resource page, navigate to the **Configuration** tab.
2. Under the feature **Windows Server subscription add-on**, click **Purchase.** In the context pane, click **Purchase** again to confirm.
3. When Windows Server subscription has been successfully purchased, you can start using Windows Server VMs on your cluster. Note that licenses will take a few minutes to be applied on your cluster. You can wait for the next cluster sync with Azure, or use Windows Admin Center or PowerShell to prompt an immediate sync from your cluster.

   :::image type="content" source="media/vm-activation/portal-purchase.png" alt-text="Purchase confirmation" lightbox="media/vm-activation/portal-purchase-expanded.png":::

### Troubleshooting

**Error**: One or more servers in the cluster does not have the latest changes to this setting. We'll apply the changes as soon as the servers sync again.

Your cluster does not yet have the latest status on Windows Server subscription (that is, just enrolled or just canceled), and therefore might not have retrieved the licenses to set up Automatic Virtual Machine Activation yet. In most cases, this will get automatically resolved with the next cloud sync, or you can choose to
manually sync: [Syncing Azure Stack HCI](../faq.yml#how-often-does-azure-stack-hci-sync-with-the-cloud).

### Enable Windows Server subscription using Windows Admin Center

1. Select Cluster Manager from the top drop-down, navigate to the cluster that you want to activate, then under **Settings**, select **Activate Windows Server VMs**.
2. In the **Automatically activate VMs** pane, select **Set up**, and then select **Purchase Windows Server subscription.** Click **Next** and confirm details, then click **Purchase.**
3. When the purchase is completed successfully, the cluster retrieves licenses from the cloud and sets up Automatic Virtual Machine Activation on your cluster.

   :::image type="content" source="media/vm-activation/confirm-purchase.gif" alt-text="Confirm purchase":::

### Enable Windows Server subscription using PowerShell

- **Purchase Windows Server subscription**: From your cluster, run the following command:

   ```powershell
   Set-AzStackHCI -EnableWSsubscription $true
   ```

- **Check status**: To check subscription status for each server, run the following command on each server:

   ```powershell
   Get-AzureStackHCISubscriptionStatus
   ```

- To check that Automatic Virtual Machine Activation has been set up with Windows Server subscription, run the following command on each server:

  ```powershell
  Get-VMAutomaticActivation
  ```

## Bring your own license

Setting up Automatic Virtual Machine Activation using your Datacenter license requires you to enter product keys. Check that you have the right keys for Azure Stack HCI:

- **Key editions:** Windows Server 2019 Datacenter or later.
- **Number of keys:** One key for each host server you are activating. Each server requires a unique key, unless you have a valid volume license key.
- **Consistency across cluster:** All servers in a cluster need to use the same edition of keys, so that VMs may stay activated regardless of which server they run on.

> [!NOTE]
> For VMs to stay activated regardless of which server they run on, Automatic Virtual Machine Activation must be set up for each server in the cluster.

:::image type="content" source="media/vm-activation/datacenter-license.png" alt-text="License architecture":::

### Where you can get keys

Choose from the following options to get a product key:

- **OEM provider:** Find a Certificates of Authenticity (COA) key label on the outside of OEM hardware. You can use this key once per server in the cluster.
- **Volume Licensing Service Center (VLSC):** From the VLSC, you can download a Multiple Activation Key (MAK) that you can reuse up to a predetermined number of allowed activations. To learn more, see [MAK keys](/licensing/products-keys-faq#what-is-a-multiple-activation-key-mak).
- **Retail channels:** You can also find a retail key on a retail box label. You can only use this key once per server in the cluster. To learn more, see [Packaged Software](https://www.microsoft.com/howtotell/software-packaged).

Product-key based Automatic Virtual Machine Activation activates all editions (Datacenter, Standard, or Essentials). For information about what guest versions your key activates, see the [What guest versions does Windows Server subscription activate?](#what-guest-versions-does-windows-server-subscription-activate) section.

### Bring your own license in Windows Admin Center

You can use Windows Admin Center to set up and manage product keys for your Azure Stack HCI cluster.

Take a few minutes to watch the video on using Automatic Virtual Machine Activation in Windows Admin Center:

> [!VIDEO https://www.microsoft.com/videoplayer/embed/RWFdsF]

### Before you start

The following is required:

- An Azure Stack HCI cluster (version 21H2 or version 20H2 with the June 8, 2021 cumulative update or later)
- Windows Admin Center (version 2103 or later)
- The Cluster Manager extension for Windows Admin Center (version 1.523.0 or later)
- Windows Server Datacenter key(s) (version 2019 or later)

### Apply activation keys

To use Automatic Virtual Machine Activation in Windows Admin Center:

1. Select **Cluster Manager** from the top drop-down arrow, navigate to the cluster that you want to activate, then under **Settings**, select **Activate Windows Server VMs**.

   :::image type="content" source="media/vm-activation/apply-keys.gif" alt-text="Apply keys":::

1. In the **Automatically activate VMs** pane, select **Set up** and then select **Use existing Windows Server licenses**. In the **Apply activation keys to each server** pane, enter your Windows Server Datacenter keys.

   When you have finished entering keys for each host server in the cluster, select **Apply**. The process will take a few moments to complete.

>[!NOTE]
> Each server requires a unique key, unless you have a valid volume license key.

After Automatic Virtual Machine Activation is successfully set up, you can view and manage the feature for your cluster.

### Change or add keys later (optional)

You might want to either change or add keys when your needs change. Examples for doing this include adding a server to the cluster, or using new Windows Server VM versions.

To change or add keys to host servers in a cluster:

1. In the **Activate Windows Server VMs** pane, select the servers that you want to manage, and then select **Manage activation keys**.

   :::image type="content" source="./media/vm-activation/change.gif" alt-text="Short demonstration showing how to change or add keys in Windows Admin Center." lightbox="./media/vm-activation/change.gif":::

2. In the **Manage activation keys** pane, enter the new keys for the selected host servers, and then select **Apply**.

>[!NOTE]
> Overwriting keys does not reset the activation count for used keys. Ensure that you're using the right keys before applying them to the servers.

### Troubleshooting - Windows Admin Center

If you receive the following Automatic Virtual Machine Activation error messages, try using the verification steps in this section to resolve them.

`Error 1: "The key you entered didn't work"`

This error might be due to any of the following issues:

- A key submitted to activate a server in the cluster was not accepted.
- A disruption of the activation process prevented a server in the cluster from being activated.
- A valid key hasn't yet been applied to a server that was added to the cluster.

To resolve such issues, on the **Activate Windows Server VMs** tab, select the server with the warning, and then select **Manage activation keys** to enter a new key.

`Error 2: "Some servers use keys for an older version of Windows Server."`

All servers must use the same version of keys. Update the keys to the same version to ensure that the VMs stay activated regardless of which server they run on.

`Error 3: "Server is down"`

Your server is offline and cannot be reached. Bring all servers online and then refresh the page.

`Error 4: "Couldn't check the status on this server." or "To use this feature, install the latest update"`

One or more of your servers is not updated and does not have the required packages to set up Automatic Virtual Machine Activation. Ensure that your cluster is updated, and then refresh the page. To learn more, see [Update Azure Stack HCI clusters](./update-cluster.md).

### Bring your own license in PowerShell

You can also use PowerShell to set up and manage key-based Automatic Virtual Machine Activation for your Azure Stack HCI cluster.

### Apply activation keys - PowerShell

Open PowerShell as an administrator and run the following commands.

1. Apply Windows Server Datacenter keys to each server:

    ```powershell
     Set-VMAutomaticActivation <product key>
    ```

1. View and confirm Automatic Virtual Machine Activation status:

    ```powershell
     Get-VMAutomaticActivation
    ```

1. Repeat these steps on each of the other servers in your Azure Stack HCI cluster.

## Activate VMs against a host server

Now that you have set up Automatic Virtual Machine Activation, you can activate VMs against the host server by [following the steps here](/windows-server/get-started/automatic-vm-activation).

## FAQ

This FAQ provides answers to some questions about using Automatic Virtual Machine Activation:

### I can't decide between Windows Server subscription and bringing my own license – is one better than the other?

- These are both good licensing options! It depends on your needs:
  - Do you need the flexibility of a monthly licensing model and billing through Azure? Do you want ease of management and not having to deal with keys? Do you want to be able to keep up to date with the latest Windows innovations? Then Windows Server subscription is probably best for you.
  - Or do you already have an existing license? Is the cost-effectiveness of long-term perpetual licensing for specific editions most important to you? Do you have broad-spanning deployments? Then bring your own license is most suited for you.

### How does Windows Server subscription billing work?

Windows Server subscription is an optional add-on to Azure Stack HCI, and therefore is aligned to the billing model of Azure Stack HCI:

- Simplified billing through Azure, and charged to the same subscription and resource as base Azure Stack HCI.
- Charged monthly, based on the number of physical cores in your Azure Stack HCI cluster. Enabling Windows Server subscription will therefore turn on Automatic Virtual Machine Activation for your entire Azure Stack HCI cluster.
- Follows the same 60-day free trial period as Azure Stack HCI. If Azure Stack HCI and Windows Server subscription are both enrolled on day 0, both will have the same 60-day free trial. If Azure Stack HCI is in day 40 of its free trial when Windows Server subscription is purchased, both will still have the same 20 remaining days of free trial.
- You can sign up or cancel your Windows Server subscription at any time.

### I want to change an existing key. What happens to the previous key if the overwrite is successful/unsuccessful?

- Once a product key is associated with a device, that association is permanent. Overwriting keys does not reduce activation count for used keys. If you successfully apply another key, both keys would be considered to have been "used" once. If you unsuccessfully apply a key, your host server activation state remains unchanged and defaults to the last successfully added key.

### I want to change to another key *of a different version*. Is it possible to switch keys between versions?

- You can update to newer versions of keys, or replace existing keys with the same version, but you may not downgrade to a previous version.

### What happens if I add or remove a new server?

- For Windows Server subscription, no action is needed, as new servers automatically retrieve licenses from the cloud.
- For Bring your own license, you'll need to [add activation keys](#change-or-add-keys-later-optional) for each new server, so that the Windows Server VMs may be activated against the new server. Removing a server does not impact how Automatic Virtual Machine Activation is set up for the remaining servers in the cluster.

### Does Automatic Virtual Machine Activation work in disconnected scenarios?

- Only the host server needs to be connected to the internet for Automatic Virtual Machine Activation to work. VMs running on top of the host server do not require internet connectivity to be activated.

### Can I run Windows Server 2016 VMs on Azure Stack HCI? I have a license for it.

- Yes. While Windows Server 2016 keys cannot be used to set up Automatic Virtual Machine Activation on Azure Stack HCI, they may still be applied using [other activation methods](/windows-server/get-started/server-2016-activation). For example, you can enter a Windows Server 2016 key into your Windows Server 2016 VM directly.
- Windows Server subscription and Windows Server 2022 and 2019 keys also support running Windows Server 2016 guests ([see the full list of supported versions](#what-guest-versions-does-windows-server-subscription-activate)), and you can set this up through Automatic Virtual Machine Activation.

### I previously purchased a Windows Server Software-Defined Datacenter (WSSD) solution with a Windows Server 2019 key. Can I use that key for Azure Stack HCI?

- First ensure that you are not using the key on another system, then go ahead and apply the key on the host server running Azure Stack HCI (unless your key is a multi-use volume key).

### I'm excited about using Windows Server 2022 Datacenter Azure Edition. If I follow the instructions in this article, will my Windows Server 2022 Datacenter Azure Edition guests activate on Azure Stack HCI?

- Yes, but you'll need to use either Windows Server subscription-based AVMA, or else bring Windows Server 2022 Datacenter keys with Software Assurance. Please look forward to the general availability of Windows Server 2022 Datacenter Azure Edition on Azure Stack HCI.

## Next steps

- [Automatic virtual machine activation](/windows-server/get-started-19/vm-activation-19)
- [Key Management Services (KMS) activation planning for Windows Server](/windows-server/get-started/kms-activation-planning)
