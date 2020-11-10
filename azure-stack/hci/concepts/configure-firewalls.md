---
title: Configure firewalls for Azure Stack HCI
description: This topic provides guidance on how to configure firewalls for the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 11/10/2020
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

For more information, see the Azure Stack HCI connectivity section of [Azure Stack HCI FAQ](faq.md)

The following diagram shows how the process works.

:::image type="content" source="./media/configure-firewalls/firewalls-diagram.png" alt-text="Diagram shows Azure Stack HCI accessing service tag endpoints through Port 443 (HTTPS) of firewalls." lightbox="./media/configure-firewalls/firewalls-diagram.png":::

## Required endpoint day-to-day access (after Azure registration)
Azure maintains well-known IP addresses that Azure services uses. Azure Stack HCI needs access to IP addresses and URLs that Azure maintains. The IP addresses are organized using what are called service tags.

Azure publishes a weekly JSON file of all the IP addresses for every service. The IP addresses don’t change often, but they do change a few times per year. The following table shows the service tag endpoints that Azure Stack HCI needs to access.

| Purpose                       | Service tag for IP range  | URL                                                                                 |
| :-----------------------------| :-----------------------  | :---------------------------------------------------------------------------------- |
| Azure Active Directory        | AzureActiveDirectory      | [https://login.microsoftonline.com](https://login.microsoftonline.com)<br> [https://graph.microsoft.com](https://graph.microsoft.com)               |
| Azure Resource Manager        | AzureResourceManager      | [https://management.azure.com](https://management.azure.com)                        |
| Azure Stack HCI Cloud Service | AzureFrontDoor.Frontend   | Depends on the region you registered with:<br> East US: [https://eus-azurestackhci-usage.azurewebsites.net](https://eus-azurestackhci-usage.azurewebsites.net)<br> West Europe: [https://weu-azurestackhci-usage.azurewebsites.net](https://weu-azurestackhci-usage.azurewebsites.net) |
| Azure Arc                     | AzureArcInfrastructure<br> AzureTrafficManager | Depends on the functionality you want to use:<br> Hybrid Identity Service: [*.his.arc.azure.com](*.his.arc.azure.com)<br> Guest Configuration: [*.guestconfiguration.azure.com](*.guestconfiguration.azure.com)<br> **Note:** Please expect more URLs as we enable more functionality. |

## Service tags and how they work
A *service tag* represents a group of IP addresses from a given Azure service. Microsoft manages the IP addresses included in the service tag, and automatically updates the service tag as IP addresses change to keep updates to a minimum. To learn more, see [Virtual network service tags](https://docs.microsoft.com/azure/virtual-network/service-tags-overview).

<!---See OneNote direction from Cosmos on adding link to related Overview topic.--->


## How to update Microsoft Defender firewall
This section provides an example of how to use Windows PowerShell to configure the Microsoft Defender firewall in the operating system to allow the IP addresses associated with a service tag:

1. Download the JSON file from the following resource to the target computer running the operating system: [Azure IP Ranges and Service Tags – Public Cloud](https://www.microsoft.com/download/details.aspx?id=56519).

<!---See Dan's latest topic for PS formate. See Cosmos' RE: Firewall Endpoints for AAD App Registration mail for JSON and PS steps for this section--->


## Additional endpoint for one-time Azure registration
<!---Cosmos's mail explains need for this--->

<!---Use note to explain how to get this without using a service tag.--->
   >[!NOTE]
   > TBD.


## Next steps
For more information, see also:
- The connectivity section of the [Azure Stack HCI FAQ](faq.md)
