---
title: Activate Windows Server VMs using Automatic Virtual Machine Activation
description: This topic explains the benefits of using Automatic Virtual Machine Activation over other activation methods and provides instructions on setting up this optional feature on Azure Stack HCI.
author: jelei
ms.author: jelei
ms.topic: how-to
ms.date: 04/13/2021
---

# Activate Windows Server VMs using Automatic Virtual Machine Activation

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019 Datacenter Edition and later

Automatic Virtual Machine Activation (AVMA) is an *optional* feature in Azure Stack HCI that you can use to activate Windows Server VMs running on Azure Stack HCI hosts. This topic explains the benefits of using Automatic Virtual Machine Activation over other activation methods and provides instructions on setting up this feature on Azure Stack HCI.

To use other methods to activate VMs, see [Windows Server 2019 Activation](/windows-server/get-started-19/activation-19).

## Background: Why use Automatic Virtual Machine Activation?
Automatic Virtual Machine Activation allows properly activated host servers to activate VMs. The process binds VM activation to host servers, instead of to each individual VM.

:::image type="content" source="./media/vm-activation/avma-binding-process.png" alt-text="Conceptual figure showing how Automatic Virtual Machine Activation binds the VM activation key process to each host server instead of binding the process to each VM running on top of each host server." lightbox="./media/vm-activation/avma-binding-process.png":::

There are multiple benefits to this approach:
- Individual VMs don't have to be connected to the internet. Only licensed host servers with internet connectivity are required.
- License management is simplified. Instead of having to true-up key usage counts for individual VMs, you can activate any number of VMs with just a properly licensed server.
- Automatic Virtual Machine Activation acts as a proof-of-purchase mechanism. This capability helps to ensure that Windows products are used in accordance with Product Use Rights and Microsoft Software License Terms.

## Supported keys and guest OS versions
To use Automatic Virtual Machine Activation with Azure Stack HCI, each server in the cluster requires a valid product key for Windows Server 2019 Datacenter Edition or later.

### Where you can get keys
Choose from the following options to get a product key.

Your OEM:
- Find a Certificates of Authenticity (COA) key label on the outside of OEM boxed software. You can use this key once per server in the cluster. To learn more, see [Packaged Software](https://www.microsoft.com/howtotell/software-packaged).

The Volume Licensing Service Center (VLSC):
- From the VLSC, you can download a Multiple Activation Key (MAK) that you may reuse up to a predetermined number of allowed activations. To learn more, see the [Microsoft Volume Licensing Service Center](https://www.microsoft.com/Licensing/servicecenter/default.aspx).

Other retail channels:
- You can also find a retail key on a retail box label. You can only use this key once per server in the cluster.

### Supported guest OS versions
Automatic Virtual Machine Activation activates all editions (Datacenter, Standard, or Essentials) of the following guest OS versions.

| Guest OS version                         | Host server key version                 |
| :--------------------------------------- | :-------------------------------------- |
|                                          | Windows Server 2019 Datacenter          |
| Windows Server 2019                      | X                                       |
| Windows Server 2016                      | X                                       |
| Windows Server 2012 R2                   | X                                       |

   >[!NOTE]
   > For VMs to stay activated regardless of which server they run on, Automatic Virtual Machine Activation must be set up for each server in the cluster. Servers also must be activated with keys from the same operating system version.

## Use Automatic Virtual Machine Activation in Windows Admin Center
You can use Windows Admin Center to set up and manage Automatic Virtual Machine Activation for your Azure Stack HCI cluster.

### Before you start
The following is required to use Automatic Virtual Machine Activation in Windows Admin Center:
- An Azure Stack HCI cluster (version 20H2, with the April 14, 2021 security update or later)
- Windows Admin Center (version 2103 or later)
- The Cluster Manager extension for Windows Admin Center (version 1.491.1 or later)
- A Windows Server Datacenter key (version 2019 or later)

### Set up Automatic Virtual Machine Activation
To use Automatic Virtual Machine Activation in Windows Admin Center:
<!---[resource link]()--->
<!---Add resource and supporting screenshot after first step--->

1. Download and install the Cluster Manager extension update for Windows Admin Center from this resource.

1. Select **Cluster Manager** from the top drop-down arrow, navigate to the cluster that you want to activate, then under **Settings**, select **Activate Windows Server VMs**.

1. In the **Automatically activate VMs** pane, select **Set up** and then in the **Apply activation keys to each server** pane, enter your Windows Server Datacenter keys.

    When you have finished entering keys for each host server in the cluster, select **Apply**. The process will take a few moments to complete.

   >[!NOTE]
   > Each server requires a unique key, unless you have a valid volume license key.

   After Automatic Virtual Machine Activation is successfully set up, you can view and manage the feature for your cluster.

### Activate VMs against a host server
You can also install Automatic Virtual Machine Activation keys in VMs against a host server in a cluster. To learn more, see [Automatic virtual machine activation](/windows-server/get-started-19/vm-activation-19).

### Change or add keys later (optional)
You might want to either change or add keys when your cluster host servers change. Examples for doing this include adding a server to the cluster, using new Windows Server VM versions, or after updating the servers.
<!---supporting screenshot here--->

To change or add keys to host servers in a cluster:
1. In the **Automatically activate VMs** pane, select the servers that you want to manage, and then select **Manage activation keys**.

1.	In the **Manage activation keys** pane, enter the new keys for the affected host servers, and then select **Apply**.

   >[!NOTE]
   > Overwriting keys does not reduce activation count for used keys. Ensure that you're using the right keys before applying them to the servers.

### Troubleshooting
If you receive the following Automatic Virtual Machine Activation error messages, try using the verification steps in this section to resolve them.

`Error 1: “The key you entered didn’t work”`

This error might be due to any of the following issues:
- A key submitted to activate a server in the cluster was not accepted.
- A disruption of the activation process prevented a server in the cluster from being activated.
- A valid key hasn’t yet been applied to a server that was added to the cluster.

To resolve such issues, on the **Activate Windows Server VMs** tab, select the server with the warning, and then select **Manage activation keys** to enter a new key.

`Error 2: “Some servers use keys for an older version of Windows Server.”`

All servers must use the same version of keys. Update the keys to the same version to ensure that the VMs stay activated regardless of which server they run on.

`Error 3: “Server is down” or “Bring all servers online and then try again”`

Your server is offline and cannot be reached. Bring all servers online and then refresh the page.

`Error 4: “Couldn’t check the status on this server.” or “To use this feature, install the latest update”`

One or more of your servers is not updated and does not have the required packages to set up Automatic Virtual Machine Activation. Ensure that your cluster is updated, and then refresh the page. To learn more, see [Update Azure Stack HCI clusters](./update-cluster.md).

## Use Automatic Virtual Machine Activation in PowerShell
You can use the following PowerShell commands to set up and manage Automatic Virtual Machine Activation for your Azure Stack HCI cluster.

1.  Right-click **Windows PowerShell**, select **Run as administrator**, and then from each Azure Stack HCI server in your cluster, use the following command to import the Automatic Virtual Machine Activation PowerShell module:

    ```powershell
     Import-module "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\ServerAVMAManager\ServerAVMAMAnager.psm1"
    ```
1. Apply Windows Server Datacenter keys to each server:

    ```powershell
     Set-VMAutomaticActivation <product key>
    ```
1. View and confirm Automatic Virtual Machine Activation status:

    ```powershell
     Get-VMAutomaticActivation
    ```
1. Repeat steps 1-3 on each of the other servers in your Azure Stack HCI cluster.

### Activate VMs against a host server
You can also install Automatic Virtual Machine Activation keys in VMs against a host server in a cluster. To learn more, see [Automatic virtual machine activation](/windows-server/get-started-19/vm-activation-19).

## FAQ
This FAQ provides answers to some questions about using Automatic Virtual Machine Activation:
- What happens if I add or remove a new server?
    - You'll need to [add activation keys](#change-or-add-keys-later-optional) for each new server, so that the Windows Server VMs may be activated against the new server.
    - Removing a server does not impact how Automatic Virtual Machine Activation is set up for the remaining servers in the cluster.
- Does Automatic Virtual Machine Activation work in disconnected scenarios?
    - Only the host server needs to be connected to the internet for Automatic Virtual Machine Activation to work. VMs running on top of the host server do not require internet connectivity to be activated.
- Can I run Windows Server 2016 VMs on Azure Stack HCI? I have a license for it.
    - Absolutely! While Automatic Virtual Machine Activation cannot be set up with Windows Server 2016 keys (requires Windows Server 2019 or later), you can run Windows Server 2016 VMs on Azure Stack HCI by using [other activation methods](/windows-server/get-started/server-2016-activation). For example, you can enter a Windows Server 2016 key into your VM directly.
    - Windows Server 2019 keys also support running Windows Server 2016 guests ([see the full list of supported versions](#supported-guest-os-versions)), and you can set this up through Automatic Virtual Machine Activation.
- Previously I purchased a Windows Server Software-Defined Datacenter (WSSD) solution with a Windows Server 2019 key. Can I use that key for Azure Stack HCI?
    - Yes! First ensure that you are not using the key on another system, then go ahead and apply the key on the host server running Azure Stack HCI (unless your key is a multi-use volume key).
- I'm excited about Windows Server 2022. If I follow the instructions in this article, will my Windows Server 2022 guests activate on Azure Stack HCI?
    - Yes, but you’ll need to use keys for Windows Server 2022 or later, which will be available after the general availability of Windows Server 2022.

## Next steps
For more information, see also:
- [Automatic virtual machine activation](/windows-server/get-started-19/vm-activation-19)
- [Microsoft Volume Licensing Service Center](https://www.microsoft.com/Licensing/servicecenter/default.aspx)
