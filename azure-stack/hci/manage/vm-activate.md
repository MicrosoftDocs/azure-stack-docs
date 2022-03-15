---
title: Activate Windows Server VMs using Automatic Virtual Machine Activation
description: This topic explains the benefits of using Automatic Virtual Machine Activation over other activation methods and provides instructions on setting up this optional feature on Azure Stack HCI.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 03/14/2022

---

# License Windows Server VMs on Azure Stack HCI

>Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022, Windows Server 2019 Datacenter Edition and later

Windows Server virtual machines (VMs) must be licensed and activated before you can use them on Azure Stack HCI. You can use any existing Windows Server licenses and activation methods that you already have; or optionally, Azure Stack HCI offers new licensing models and tools to help simplify this process. This article describes general licensing concepts and the new options that are available on Azure Stack HCI.

## Summary

The following figure shows the different Windows Server VM licensing options:

:::image type="content" source="media/vm-activation/vm-activation-server.png" alt-text="VM licensing":::

First, choose one of two licensing options:

- Windows Server subscription – subscribe to Windows Server guest licenses through Azure. Available for Azure Stack HCI only.
- Bring your own license (BYOL) – apply your existing Windows Server licenses.

For more information, see [Compare licensing options](#compare-licensing-options).

Next, activate your Windows Server VMs. If you are using Windows Server subscription, activation is handled automatically for you. If you are using BYOL, you must use the corresponding keys associated with your license in order to activate. The most convenient way to activate VMs on Azure Stack HCI is to use Automatic VM Activation (AVMA).

To use other methods to activate VMs, see Key [Management Services (KMS) activation planning](/windows-server/get-started/kms-activation-planning).

## Compare licensing options

The two licensing options for VM activation address different customer needs:

|                                                           |     Windows Server subscription                                                                                    |     Bring your own license (BYOL)                                         |
|-----------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------|
|     Where do I want to deploy my Windows Server (WS) VMs?               |     Azure Stack HCI only.                                                                                           |     Can be applied anywhere.                                               |
|     What versions of WS VMs do you want to use?         |     Evergreen – all versions up to the latest version.                                                                  |     Version-specific.                                                      |
|     Does this also allow me to use Windows Server: Azure edition?    |     Yes.                                                                                                            |     Need to have both Software Assurance (SA) and WS volume license keys.    |
|     How do I activate my WS VMs?                          |     Automatically handled – no keys/true-up.                                                                        |     Key based – for example, KMS/AVMA/enter keys in VM.                            |
|     What are the CAL requirements?                        |     No CAL required – included in WS subscription.                                                                  |     Windows Server CAL.                                                    |
|     What is the pricing model?                            |     Per physical core/per month (free trial within the first 60 days of registering your Azure Stack HCI).    |     Core licenses.                                                         |

### Guest versions

|                                    | BYO Windows Server 2019 license | BYO Windows Server 2022 license | Windows Server subscription |
|------------------------------------|---------------------------------|---------------------------------|-----------------------------|
| Windows Server 2012/R2             | X                               | X                               | X                           |
| Windows Server 2016                | X                               | X                               | X                           |
| Windows Server 2019                | X                               | X                               | X                           |
| Windows Server 2022                |                                 | X                               | X                           |
| Windows Server 2022: Azure Edition | Require Software Assurance      | Require Software Assurance      |                             |
| Future editions (evergreen)        | Require Software Assurance      | Require Software Assurance      | X                           |

## Pricing and purchasing

Windows Server subscription is purchased and billed monthly through Azure, with a free trial within the first 60 days of registering your Azure Stack HCI. For specific pricing information, see the [pricing details for Windows Server subscription](https://azure.microsoft.com/pricing/details/azure-stack/hci/). To get started, see [Tutorial: Windows Server subscription](#tutorial-windows-server-subscription).

Purchasing a Windows Server license for BYOL works the same way on Azure Stack HCI as it does on other platforms. For more information, see [Licensing Windows Server](https://www.microsoft.com/licensing/product-licensing/windows-server) and [Pricing details for Windows Server licenses](https://www.microsoft.com/windows-server/pricing?rtc=1).

## Tutorial: Windows Server subscription

Windows Server subscription is a simple and flexible option for Windows Server guest licensing, exclusively for Azure Stack HCI customers.

### How does Windows Server subscription work?

When Windows Server subscription is activated, Azure Stack HCI servers retrieve licenses from the cloud and automatically set up Automatic VM Activation (AVMA). In other words, you simply enroll in the subscription; there are no other steps required for activation.

:::image type="content" source="media/vm-activation/windows-server-subscription.png" alt-text="Windows Server subscription":::

### Prerequisites

- An Azure Stack HCI cluster
  - [Install updates](update-cluster.md): Version 21H2, with at least the December 14, 2021 security update KB5008210 or later.
  - [Register Azure Stack HCI](../deploy/register-with-azure.md#register-a-cluster-using-windows-admin-center): All servers must be online and registered to Azure.

- If using Windows Admin Center:
  - Windows Admin Center (version 2103 or later) with the Cluster Manager extension (version 2.41.0 or later).

### Enable Windows Server subscription using the Azure portal

1. In your Azure Stack HCI cluster resource page, navigate to the **Configuration** tab.
2. Under the feature **Windows Server subscription add-on**, click **Purchase.** In the context pane, click **Purchase** again to confirm.
3. When Windows Server subscription has been successfully purchased, you can start using Windows Server VMs on your cluster. Note that licenses will take a few minutes to be applied on your cluster.

   :::image type="content" source="media/vm-activation/portal-purchase.png" alt-text="Purchase confirmation" lightbox="media/vm-activation/portal-purchase-expanded.png":::

### Troubleshooting - Windows Server subscription

**Error**: One or more servers in the cluster does not have the latest changes to this setting. We'll apply the changes as soon as the servers sync again.

**Remediation**: Your cluster does not yet have the latest status on Windows Server subscription (that is, just enrolled or just canceled), and therefore might not have retrieved the licenses to set up AVMA yet. In most cases, this will get automatically resolved with the next cloud sync, or you can sync manually. See [Syncing Azure Stack HCI](../faq.yml#how-often-does-azure-stack-hci-sync-with-the-cloud).

### Enable Windows Server subscription using Windows Admin Center

1. Select **Cluster Manager** from the top drop-down, navigate to the cluster that you want to activate, then under **Settings**, select **Activate Windows Server VMs**.
2. In the **Automatically activate VMs** pane, select **Set up**, and then select **Purchase Windows Server subscription.** Click **Next** and confirm details, then click **Purchase.**
3. When the purchase is completed successfully, the cluster retrieves licenses from the cloud and sets up AVMA on your cluster.

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

- To check that AVMA has been set up with Windows Server subscription, run the following command on each server:

  ```powershell
  Get-VMAutomaticActivation
  ```

## Tutorial: Bring your own license (BYOL) activation through AVMA

You can use any existing method to activate VMs on Azure Stack HCI. Optionally, you can use AVMA, which enables activated host servers to automatically activate VMs running on them. For more information, see [AVMA in Windows Server](/windows-server/get-started/automatic-vm-activation).

:::image type="content" source="media/vm-activation/vm-activate.png" alt-text="Activate VMs":::

### Benefits of AVMA

Because VM activation can be done through host servers, this presents several benefits:

- Individual VMs don't have to be connected to the internet. Only licensed host servers with internet connectivity are required.
- License management is simplified. Instead of having to true-up key usage counts for individual VMs, you can activate any number of VMs with just a properly licensed server.
- AVMA acts as a proof-of-purchase mechanism. This capability helps to ensure that Windows products are used in accordance with product use rights and Microsoft software license terms.

### AVMA prerequisites

The following prerequisites are required in order to get the Windows Server Datacenter keys needed for activation:

- Get the required Windows Server Datacenter key(s):
  - **Key editions:** Windows Server 2019 Datacenter or later. For information about what guest versions your key activates, see [Guest versions](#guest-versions).
  - **Number of keys:** One unique key for each host server you are activating, unless you have a valid volume license key.
  - **Consistency across cluster:** All servers in a cluster need to use the same edition of keys, so that VMs may stay activated regardless of which server they run on.

- An Azure Stack HCI cluster (version 21H2 or version 20H2 with the June 8, 2021 cumulative update or later).
- Windows Admin Center (version 2103 or later).
- The Cluster Manager extension for Windows Admin Center (version 1.523.0 or later).

> [!NOTE]
> For VMs to stay activated regardless of which server they run on, AVMA must be set up for each server in the cluster.

### AVMA using Windows Admin Center

You can use Windows Admin Center to set up and manage product keys for your Azure Stack HCI cluster.

Take a few minutes to watch the video on using Automatic Virtual Machine Activation in Windows Admin Center:

> [!VIDEO https://www.microsoft.com/videoplayer/embed/RWFdsF]

#### Apply activation keys

To use AVMA in Windows Admin Center:

1. Select **Cluster Manager** from the top drop-down arrow, navigate to the cluster that you want to activate, then under **Settings**, select **Activate Windows Server VMs**.

   :::image type="content" source="media/vm-activation/apply-keys.gif" alt-text="Apply keys":::

1. In the **Automatically activate VMs** pane, select **Set up** and then select **Use existing Windows Server licenses**. In the **Apply activation keys to each server** pane, enter your Windows Server Datacenter keys.

   When you have finished entering keys for each host server in the cluster, select **Apply**. The process will take a few moments to complete.

> [!NOTE]
> Each server requires a unique key, unless you have a valid volume license key.

After AVMA is successfully set up, you can view and manage the feature for your cluster.

### Change or add keys later (optional)

You might want to either change or add keys when your needs change. Examples for doing this include adding a server to the cluster, or using new Windows Server VM versions.

To change or add keys to host servers in a cluster:

1. In the **Activate Windows Server VMs** pane, select the servers that you want to manage, and then select **Manage activation keys**.

   :::image type="content" source="./media/vm-activation/change.gif" alt-text="Short demonstration showing how to change or add keys in Windows Admin Center." lightbox="./media/vm-activation/change.gif":::

2. In the **Manage activation keys** pane, enter the new keys for the selected host servers, and then select **Apply**.

> [!NOTE]
> Overwriting keys does not reset the activation count for used keys. Ensure that you're using the right keys before applying them to the servers.

### Troubleshooting - Windows Admin Center

If you receive the following AVMA error messages, try using the verification steps in this section to resolve them.

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

One or more of your servers is not updated and does not have the required packages to set up AVMA. Ensure that your cluster is updated, and then refresh the page. For more information, see [Update Azure Stack HCI clusters](./update-cluster.md).

### AVMA using PowerShell

You can also use PowerShell to set up and manage key-based AVMA for your Azure Stack HCI cluster.

Open PowerShell as an administrator, and run the following commands:

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

Now that you have set up AVMA, you can activate VMs against the host server by [following the steps here](/windows-server/get-started/automatic-vm-activation).

## FAQ

This FAQ provides answers to some questions about licensing Windows Server.

### I'm excited about using Windows Server 2022 Datacenter Azure Edition. If I follow the instructions in this article, will my Windows Server 2022 Datacenter Azure Edition guests activate on Azure Stack HCI?

- Yes, but you'll need to use either Windows Server subscription-based AVMA, or else bring Windows Server 2022 Datacenter keys with Software Assurance. Please look forward to the general availability of Windows Server 2022 Datacenter Azure Edition on Azure Stack HCI.

### Do I still need Windows Server CALs?

Yes, you still need Windows Server CALs for BYOL, but not for Windows Server subscription.

### Do I need to be connected to the internet?

You do need internet connectivity:

- To sync host servers to Azure at least once every 30 days, in order to maintain Azure Stack HCI 30-day connectivity requirements and to sync host licenses for AVMA.
- When purchasing or cancelling Windows Server subscription.

You do not need internet connectivity:

- When VMs do not require internet connectivity to be activated via Windows Server subscription or BYOL-based AVMA.

See the [Windows Server documentation](/windows-server/get-started/server-2016-activation) for other forms of activation.

### When does Windows Server subscription start/end billing?

Windows Server subscription starts billing and activating Windows Server VMs immediately upon purchase. If you enable Windows Server subscription within the first 60 days of activating Azure Stack HCI, you will automatically have a free trial for the duration of that period.

You can sign up or cancel your Windows Server subscription at any time. Upon cancellation, billing and activation via Azure stops immediately. Make sure you have an alternate form of licensing if you continue to run Windows Server VMs on your cluster.

### I have a license for Windows Server, can I run Windows Server 2016 VMs on Azure Stack HCI?

Yes. Although you cannot use Windows Server 2016 keys to set up AVMA on Azure Stack HCI, they can still be applied using [other activation methods](/windows-server/get-started/server-2016-activation). For example, you can enter a Windows Server 2016 key into your Windows Server 2016 VM directly.

Windows Server subscription and Windows Server 2022 and 2019 keys also support running Windows Server 2016 guests ([see the full list of supported versions](#guest-versions)), and you can set this up through AVMA.

### Where can I get BYOL keys for AVMA?

To get a product key, choose from the following options:

- **OEM provider**: Find a Certificates of Authenticity (COA) key label on the outside of the OEM hardware. You can use this key once per server in the cluster.
- **Volume Licensing Service Center (VLSC)**: From the VLSC, you can download a Multiple Activation Key (MAK) that you can reuse up to a predetermined number of allowed activations. For more information, see [MAK keys](/licensing/products-keys-faq#what-is-a-multiple-activation-key-mak).
- **Retail channels**: You can also find a retail key on a retail box label. You can only use this key once per server in the cluster. For more information, see [Packaged Software](https://www.microsoft.com/howtotell/software-packaged).

### I want to change an existing key. What happens to the previous key if the overwrite is successful/unsuccessful?

Once a product key is associated with a device, that association is permanent. Overwriting keys does not reduce the activation count for used keys. If you successfully apply another key, both keys would be considered to have been "used" once. If you unsuccessfully apply a key, your host server activation state remains unchanged and defaults to the last successfully added key.

### I want to change to another key *of a different version*. Is it possible to switch keys between versions?

You can update to newer versions of keys, or replace existing keys with the same version, but you cannot downgrade to a previous version.

### What happens if I add or remove a new server?

You'll need to [add activation keys](#change-or-add-keys-later-optional) for each new server, so that the Windows Server VMs can be activated against the new server. Removing a server does not impact how AVMA is set up for the remaining servers in the cluster.

### I previously purchased a Windows Server Software-Defined Datacenter (WSSD) solution with a Windows Server 2019 key. Can I use that key for Azure Stack HCI?

First, ensure that you are not using the key on another system (unless your key is a multi-use volume key), then apply this key on the host server running Azure Stack HCI.

## Next steps

- [Automatic virtual machine activation](/windows-server/get-started-19/vm-activation-19)
- [Key Management Services (KMS) activation planning for Windows Server](/windows-server/get-started/kms-activation-planning)
