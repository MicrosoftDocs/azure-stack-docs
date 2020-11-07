---
title: Configure firewalls for Azure Stack HCI
description: This topic provides guidance on how to configure firewalls for the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 11/06/2020
---

# Configure firewalls for Azure Stack HCI

>Applies to: Azure Stack HCI, version 20H2

This topic provides guidance on how to configure firewalls for the Azure Stack HCI operating system.


<!---See Cosmos' RE: Firewall Endpoints for AAD App Registration mail for topic structure.
1 A polished-up version of my response to Matt in the attached thread, showing URLs and IP service tags we need.
2 See above for Jason's input on enterprise firewall step.--->



## Connectivity requirements
TBD

<!---Set up concept diagram here.--->
<!---:::image type="content" source="./media/network-controller/topology-option-1.png" alt-text="Option 1 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-1.png":::--->

## Required endpoints day-to-day (after registration)
The table below summarizes the IP addresses and URLs that Azure Stack HCI needs access to.

For the IP addresses: Azure maintains the list of well-known IP addresses used by Azure services, organized using what are called service tags. In summary, Azure publishes a weekly JSON file of all the IP addresses for every service. They don’t change often (certainly not weekly) but they do change occasionally, maybe a few times per year. The table below shows the service tag endpoints that Azure Stack HCI needs access to. This is also illustrated in the attached diagram.

<!---See Cosmos's mail for table content--->
| Purpose                       | Service tag for IP range | URL                                               |
| :-----------------------------| :----------------------- | :------------------------------------------------ |
| Azure Active Directory        | AzureActiveDirectory     | right-aligned column                              |
| Azure Resource Manager        | AzureResourceManager     | $100                                              |
| Azure Stack HCI Cloud Service | AzureFrontDoor.Frontend  | $10                                               |
| Azure Arc                     | AzureArcInfrastructure<br> AzureTrafficManager | $10                         |


## Service tags and how they work
TBD

## How to update Microsoft Defender firewall
TBD
<!---See Cosmos's mail for PS steps--->

<!---Example note format.--->
   >[!NOTE]
   > TBD.

<!---Example figure format--->
<!---:::image type="content" source="./media/network-controller/topology-option-1.png" alt-text="Option 1 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-1.png":::--->

## Next steps
For more information, see also:
<!---Placeholders for format examples. Replace all before initial topic review.--->

- [TBD](../overview.md)
- [TBD](cache.md)
