---
title: Configure firewalls for Azure Stack HCI
description: This topic provides guidance on how to configure firewalls for the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 11/09/2020
---

# Configure firewalls for Azure Stack HCI

>Applies to: Azure Stack HCI, version 20H2

This topic provides guidance on how to configure firewalls for the Azure Stack HCI operating system.


<!---See Cosmos' RE: Firewall Endpoints for AAD App Registration mail for topic structure.
1 A polished-up version of my response to Matt in the attached thread, showing URLs and IP service tags we need.
2 See OneNote direction from Cosmos on adding link to related Overview topic.
2 See OneNote Jason's input on need to align enterprise firewall with Defender firewall ports for same access to updates. Step 5 to add to Cosmos' other 4 JSON steps.--->

## Connectivity requirements
Azure Stack HCI needs to periodically connect to the Azure public cloud. The connectivity requirements for this are far from unrestricted internet access. Access is limited to only:
- Well-known Azure IPs
- Outbound direction
- Port 443 (HTTPS)

The following diagram shows how the process works.
<!---See Cosmos's mail for table content--->

:::image type="content" source="./media/configure-firewalls/firewalls-diagram.png" alt-text="TBD TBD TBD." lightbox="./media/configure-firewalls/firewalls-diagram.png":::

## Required endpoint day-to-day access (after Azure registration)
Azure maintains well-known IP addresses that Azure services uses. Azure Stack HCI needs access to IP addresses and URLs that Azure maintains. The IP addresses are organized using what are called service tags.

Azure publishes a weekly JSON file of all the IP addresses for every service. The IP addresses don’t change often, but they do change a few times per year. The following table shows the service tag endpoints that Azure Stack HCI needs access to.

<!---See Cosmos's mail for table content--->
| Purpose                       | Service tag for IP range  | URL                                               |
| :-----------------------------| :-----------------------  | :------------------------------------------------ |
| Azure Active Directory        | AzureActiveDirectory      | right-aligned column                              |
| Azure Resource Manager        | AzureResourceManager      | $100                                              |
| Azure Stack HCI Cloud Service | AzureFrontDoor.Frontend   | $10                                               |
| Azure Arc                     | AzureArcInfrastructure<br> AzureTrafficManager | $10                          |


## Service tags and how they work
TBD

<!---See Cosmos' RE: Firewall Endpoints for AAD App Registration mail for topic structure. Virtual network service tags: https://docs.microsoft.com/en-us/azure/virtual-network/service-tags-overview

See OneNote direction from Cosmos on adding link to related Overview topic.--->


## How to update Microsoft Defender firewall
TBD
<!---See Cosmos' RE: Firewall Endpoints for AAD App Registration mail for JSON and PS steps for this section--->


## Additional endpoint for one-time Azure registration
<!---Cosmos's mail explains need for this--->

<!---Use note to explain how to get this without using a service tag.--->
   >[!NOTE]
   > TBD.


## Next steps
For more information, see also:
<!---Placeholders for format examples. Replace all before initial topic review.--->

- [TBD](../overview.md)
- [TBD](cache.md)
