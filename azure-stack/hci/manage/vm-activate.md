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

Nested resiliency is a new capability of Storage Spaces Direct in Windows Server 2019 that enables a two-server cluster to withstand multiple hardware failures at the same time without loss of storage availability, so users, apps, and virtual machines continue to run without disruption. This topic explains how it works, provides step-by-step instructions to get started, and answers the most frequently asked questions.
<!---Looks like this para is for a different topic. Verify it should be here--->

Automatic Virtual Machine Activation (AVMA) is an *optional* feature in Azure Stack HCI that you can use to activate Windows Server VMs running on Azure Stack HCI hosts. This topic explains the benefits of using AVMA over other activation methods and provides instructions on setting up AVMA on Azure Stack HCI.

To use other methods to activate VMs, see [Windows Server 2019 Activation](/windows-server/get-started-19/activation-19).

## Why use AVMA?
AVMA allows properly activated host servers to activate VMs. The AVMA process binds VM activation to host servers, instead of to each individual VM.

<!---Example figure format--->
<!---:::image type="content" source="./media/network-controller/topology-option-1.png" alt-text="Option 1 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-1.png":::--->

There are multiple benefits to this approach:
- Individual VMs don't have to be connected to the internet. Only licensed host servers with internet connectivity are required.
- License management is simplified. There is no need to track how many times you entered keys in individual VMs, and maintain a count of activated VMs that is within the license limit. With AVMA, each host server uses just 1 key, regardless of how many VMs you run on top of the server.
- AVMA acts as a proof-of-purchase mechanism. This capability helps to ensure that Windows products are used in accordance with Product Use Rights and Microsoft Software License Terms.

## Supported keys and guest OS versions
TBD

<!---Example note format.--->
   >[!NOTE]
   > TBD.

<!---Example figure format--->
<!---:::image type="content" source="./media/network-controller/topology-option-1.png" alt-text="Option 1 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-1.png":::--->


### Where you can get keys
TBD

### Supported guest OS versions
TBD

<!---Example table format.--->
| Fun                                      | Table                                   |
| :--------------------------------------- | :-------------------------------------- |
| left-aligned column                      | right-aligned column                    |
| $100                                     | $100                                    |
| $10                                      | $10                                     |


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
