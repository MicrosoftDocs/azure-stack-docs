---
title: Configure firewalls for Azure Stack HCI
description: This topic provides guidance on how to configure firewalls for the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 11/12/2020
---

# Configure firewalls for Azure Stack HCI

>Applies to: Azure Stack HCI, version 20H2

This topic provides guidance on how to configure firewalls for the Azure Stack HCI operating system. It includes connectivity requirements, and IP addresses and URLs in Azure that the operating system needs to access. The topic then briefly dicusses the concept of service tags, and concludes with steps to update Microsoft Defender Firewall and the external corporate firewall in your organization.

## Connectivity requirements
Azure Stack HCI needs to periodically connect to the Azure public cloud. The connectivity requirements are far from unrestricted internet access. Access is limited to only:
- Well-known Azure IPs
- Outbound direction
- Port 443 (HTTPS)

For more information, see the Azure Stack HCI connectivity section of the [Azure Stack HCI FAQ](../faq.md)

   >[!IMPORTANT]
   > If outbound connectivity is restricted by your external corporate firewall or proxy server, ensure that the URLs listed below are not blocked. For related information, see the "Networking configuration" section of [Overview of Azure Arc enabled servers agent](https://docs.microsoft.com/azure/azure-arc/servers/agent-overview#networking-configuration).


The following diagram shows how the process works.

:::image type="content" source="./media/configure-firewalls/firewalls-diagram.png" alt-text="Diagram shows Azure Stack HCI accessing service tag endpoints through Port 443 (HTTPS) of firewalls." lightbox="./media/configure-firewalls/firewalls-diagram.png":::

## Required endpoint day-to-day access (after Azure registration)
Azure maintains well-known IP addresses for Azure services. Azure Stack HCI needs access to IP addresses and URLs that Azure maintains. The IP addresses are organized using what are called service tags.

Azure publishes a weekly JSON file of all the IP addresses for every service. The IP addresses don’t change often, but they do change a few times per year. The following table shows the service tag endpoints that Azure Stack HCI needs to access.

| Description                   | Service tag for IP range  | URL                                                                                 |
| :-----------------------------| :-----------------------  | :---------------------------------------------------------------------------------- |
| Azure Active Directory        | AzureActiveDirectory      | `https://login.microsoftonline.com`<br> `https://graph.microsoft.com`                   |
| Azure Resource Manager        | AzureResourceManager      | `https://management.azure.com`                        |
| Azure Stack HCI Cloud Service | AzureFrontDoor.Frontend   | Depends on the region you registered with:<br> East US: `https://eus-azurestackhci-usage.azurewebsites.net`<br> West Europe: `https://weu-azurestackhci-usage.azurewebsites.net` |
| Azure Arc                     | AzureArcInfrastructure<br> AzureTrafficManager | Depends on the functionality you want to use:<br> Hybrid Identity Service: `*.his.arc.azure.com`<br> Guest Configuration: `*.guestconfiguration.azure.com`<br> **Note:** Expect more URLs as we enable more functionality. |

## Service tags and how they work
A *service tag* represents a group of IP addresses from a given Azure service. Microsoft manages the IP addresses included in the service tag, and automatically updates the service tag as IP addresses change to keep updates to a minimum. To learn more, see [Virtual network service tags](https://docs.microsoft.com/azure/virtual-network/service-tags-overview).

## How to update the firewalls
This section shows how to configure the Microsoft Defender Firewall and your external corporate firewall to allow IP addresses associated with a service tag to connect with the operating system:

1. Download the JSON file from the following resource to the target computer running the operating system: [Azure IP Ranges and Service Tags – Public Cloud](https://www.microsoft.com/download/details.aspx?id=56519).

1. Use the following PowerShell command to open the JSON file:

    ```powershell
    $json = Get-Content -Path .\ServiceTags_Public_20201012.json | ConvertFrom-Json
    ```

1. Get the list of IP address ranges for a given service tag, such as the “AzureResourceManager” service tag:

    ```powershell
    $IpList = ($json.values | where Name -Eq "AzureResourceManager").properties.addressPrefixes
    ```

1. Import the list of IP addresses to your external corporate firewall, if you're using an allow list with it.

1. Create a firewall rule for each server in the cluster to allow outbound 443 (HTTPS) traffic to the list of IP address ranges:

    ```powershell
    New-NetFirewallRule -DisplayName "Allow Azure Resource Manager" -RemoteAddress $IpList -Direction Outbound -LocalPort 443 -Protocol TCP -Action Allow -Profile Any -Enabled True
    ```

## Additional endpoint for one-time Azure registration
During the Azure registration process, when you run either `Register-AzStackHCI` or use Windows Admin Center, the cmdlet tries to contact the PowerShell Gallery to verify that you have the latest version of required PowerShell modules, such as Az and AzureAD. Although the PowerShell Gallery is hosted on Azure, currently there is not a service tag for it. If you can't run the cmdlet from a machine that has permissive outbound internet access, we recommend downloading the modules, and then manually transferring them to the node where you want to run the `Register-AzStackHCI` command.

## Next steps
For more information, see also:
- The connectivity section of the [Azure Stack HCI FAQ](../faq.md)
