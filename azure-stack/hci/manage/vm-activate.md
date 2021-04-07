---
title: Activate Windows Server VMs using Automatic Virtual Machine Activation (AVMA)
description: This topic explains the benefits of using AVMA over other activation methods and provides instructions on setting up AVMA on Azure Stack HCI.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 04/06/2021
---

# Activate Windows Server VMs using Automatic Virtual Machine Activation (AVMA)

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019 Datacenter Edition and later

Automatic Virtual Machine Activation (AVMA) is an *optional* feature in Azure Stack HCI that you can use to activate Windows Server VMs running on Azure Stack HCI hosts. This topic explains the benefits of using AVMA over other activation methods and provides instructions on setting up AVMA on Azure Stack HCI.

To use other methods to activate VMs, see [Windows Server 2019 Activation](/windows-server/get-started-19/activation-19).

## Why use AVMA?
AVMA allows properly activated host servers to activate VMs. The AVMA process binds VM activation to host servers, instead of to each individual VM.

:::image type="content" source="./media/vm-activation/avma-binding-process.png" alt-text="Conceptual figure showing how AVMA binds the VM activation key process to each host server instead of binding the process to each VM running on top of each host server." lightbox="./media/vm-activation/avma-binding-process.png":::

There are multiple benefits to this approach:
- Individual VMs don't have to be connected to the internet. Only licensed host servers with internet connectivity are required.
- License management is simplified. There is no need to track how many times you entered keys in individual VMs, and maintain a count of activated VMs that is within the license limit. With AVMA, each host server uses just 1 key, regardless of how many VMs you run on top of the server.
- AVMA acts as a proof-of-purchase mechanism. This capability helps to ensure that Windows products are used in accordance with Product Use Rights and Microsoft Software License Terms.

## Supported keys and guest OS versions
To use AVMA with Azure Stack HCI, each server in the cluster requires a valid product key for Windows Server 2019 Datacenter Edition or later.

### Where you can get keys
Choose from the following options to get a product key.

Your OEM:
- Find a Certificates of Authenticity (COA) key label on the outside of OEM boxed software. You can use this key once per server in the cluster. To learn more, see [Packaged Software](https://www.microsoft.com/howtotell/software-packaged).

The Volume Licensing Service Center (VLSC):
- From the VLSC, you can download a Multiple Activation Key (MAK) that you may reuse up to a predetermined number of allowed activations. To learn more, see the [Microsoft Volume Licensing Service Center](https://www.microsoft.com/Licensing/servicecenter/default.aspx).

Other retail channels:
- You can also find a retail key on a retail box label. You can only use this key once per server in the cluster.

### Supported guest OS versions
AVMA activates all editions (Datacenter, Standard, or Essentials) of the following guest OS versions.

| Guest OS version                         | Host server key version                 |
| :--------------------------------------- | :-------------------------------------- |
|                                          | Windows Server 2019 Datacenter          |
| Windows Server 2019                      | X                                       |
| Windows Server 2016                      | X                                       |
| Windows Server 2012 R2                   | X                                       |

   >[!NOTE]
   > For VMs to stay activated regardless of which server they run on, AVMA must be set up for each server in the cluster. Servers also must be activated with keys from the same operating system version.

## Use AVMA in Windows Admin Center
You can use Windows Admin Center to set up and manage AVMA for your Azure Stack HCI cluster.

Take a few minutes to watch the video on the using the AVMA feature in Windows Admin Center:
<!---Video demo format > [!VIDEO https://www.youtube.com/embed/fw8RVqo9dcs]--->

### Before you start
Before using the the AVMA feature in Windows Admin Center, the following is required:
- An Azure Stack HCI cluster (version 20H2, with the April 14, 2021 security update or later)
- Windows Admin Center (version 2103 or later)
- The Cluster Manager extension for Windows Admin Center (version 1.491.5 or later)
- A Windows Server Datacenter key (version 2019 or later)

### Set up AVMA
To use AVMA in Windows Admin Center:
<!---[resource]()--->
<!---Add resource and supporting screenshot after first step--->

1. Download and install the Cluster Manager extension update for Windows Admin Center from this resource.

1. Select **Cluster Manager** from the top drop-down arrow, navigate to the cluster that you want to activate, then under **Settings**, select **Activate Windows Server VMs**.

1. In the **Automatically activate VMs** pane, select **Set up** and then in the **Apply activation keys to each server** pane, enter your Windows Server Datacenter keys.

    When you have finished entering keys for each host server in the cluster, select **Apply**. The process will take a few moments to complete.

   >[!NOTE]
   > Each server requires a unique key, unless you have a valid volume license key.

   After the AVMA feature is successfully set up, you can view and manage the feature for your cluster.

### Activate VMs against a host server
You can also install AVMA keys in VMs against a host server in a cluster. To learn more, see [Automatic virtual machine activation](/windows-server/get-started-19/vm-activation-19).

### Change or add keys later (optional)
You might want to either change or add keys when your cluster host servers change. Examples for doing this include adding a server to the cluster, using new Windows Server VM versions, or after updating the servers.
<!---supporting screenshot here--->

To change or add keys to host servers in a cluster:
1. In the **Automatically activate VMs** pane, select the servers that you want to manage, and then select **Manage activation keys**.

1.	In the **Manage activation keys** pane, enter the new keys for the affected host servers, and then select **Apply**.

   >[!NOTE]
   > Overwriting keys does not reduce activation count for used keys. Ensure that you're using the right keys before applying them to the servers.

### Troubleshooting
TBD

`Error 1: AVMA setup fails because “the key you entered didn’t work”`





## Use AVMA in PowerShell
TBD

<!---see deck for supporting examples--->



### Activate VMs against a host server
You can also install AVMA keys in VMs against a host server in a cluster. To learn more, see [Automatic virtual machine activation](/windows-server/get-started-19/vm-activation-19).

## FAQ
TBD


## Next steps
For more information, see also:
- [AVMA]()
- [VLSC]()
