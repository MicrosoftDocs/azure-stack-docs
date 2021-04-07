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

:::image type="content" source="./media/vm-activation/avma-binding-process.png" alt-text="Conceptual figure showing how AVMA binds the VM activation key process to the host server instead of binding the process to each VM running on top of the host server." lightbox="./media/vm-activation/avma-binding-process.png":::

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
TBD

<!---Video demo format > [!VIDEO https://www.youtube.com/embed/fw8RVqo9dcs]--->

### Before you start
TBD


### Set up AVMA
TBD


### Activate VMs against a host server
TBD


### Change or add keys later (optional)
TBD


### Troubleshooting
TBD


## Use AVMA in PowerShell
TBD

### Troubleshooting
TBD

### Activate VMs against a host server
TBD
<!---Verify that this same content in above section should also be here.--->


## FAQ
TBD


## Next steps
For more information, see also:
- [AVMA]()
- [VLSC]()
