---
title: Publish Azure Stack Hub services in your datacenter
description: Learn how to publish Azure Stack Hub services in your datacenter.
author: sethmanheim
ms.topic: article
ms.date: 01/10/2022
ms.author: sethm
ms.reviewer: wamota
ms.lastreviewed: 09/30/2021

# Intent: As an Azure Stack operator, I want to publish Azure Stack services to my datacenter so they can be available to external networks.
# Keyword: publish azure stack services

---

# Publish Azure Stack Hub services in your datacenter

Azure Stack Hub sets up virtual IP addresses (VIPs) for its infrastructure roles. These VIPs are allocated from the public IP address pool. Each VIP is secured with an access control list (ACL) in the software-defined network layer. ACLs are also used across the physical switches (TORs and BMC) to further harden the solution. A DNS entry is created for each endpoint in the external DNS zone that's specified at deployment time. For example, the user portal is assigned the DNS host entry of portal.*&lt;region>.&lt;fqdn>*.

The following architectural diagram shows the different network layers and ACLs:

![Diagram showing different network layers and ACLs](media/azure-stack-integrate-endpoints/integrate-endpoints-01.svg)

## Ports and URLs

To make Azure Stack Hub services (like the portals, Azure Resource Manager, DNS, and so on) available to external networks, you must allow inbound traffic to these endpoints for specific URLs, ports, and protocols.

In a deployment where a transparent proxy uplinks to a traditional proxy server or a firewall is protecting the solution, you must allow specific ports and URLs for both [inbound](azure-stack-integrate-endpoints.md#ports-and-protocols-inbound) and [outbound](azure-stack-integrate-endpoints.md#ports-and-urls-outbound) communication. These include ports and URLs for identity, the marketplace, patch and update, registration, and usage data.

SSL traffic interception is [not supported](azure-stack-firewall.md#ssl-interception) and can lead to service failures when accessing endpoints.

## Ports and protocols (inbound)

A set of infrastructure VIPs is required for publishing Azure Stack Hub endpoints to external networks. The *Endpoint (VIP)* table shows each endpoint, the required port, and protocol. Refer to the specific resource provider deployment documentation for endpoints that require additional resource providers, like the SQL resource provider.

Internal infrastructure VIPs aren't listed because they're not required for publishing Azure Stack Hub. User VIPs are dynamic and defined by the users themselves, with no control by the Azure Stack Hub operator.

With the addition of the [Extension Host](azure-stack-extension-host-prepare.md), ports in the range of 12495-30015 aren't required.

|Endpoint (VIP)|DNS host A record|Protocol|Ports|
|---------|---------|---------|---------|
|AD FS|Adfs.*&lt;region>.&lt;fqdn>*|HTTPS|443|
|Portal (administrator)|Adminportal.*&lt;region>.&lt;fqdn>*|HTTPS|443|
|Adminhosting | *.adminhosting.\<region>.\<fqdn> | HTTPS | 443 |
|Azure Resource Manager (administrator)|Adminmanagement.*&lt;region>.&lt;fqdn>*|HTTPS|443|
|Portal (user)|Portal.*&lt;region>.&lt;fqdn>*|HTTPS|443|
|Azure Resource Manager (user)|Management.*&lt;region>.&lt;fqdn>*|HTTPS|443|
|Graph|Graph.*&lt;region>.&lt;fqdn>*|HTTPS|443|
|Certificate revocation list|Crl.*&lt;region>.&lt;fqdn>*|HTTP|80|
|DNS|&#42;.*&lt;region>.&lt;fqdn>*|TCP & UDP|53|
|Hosting | *.hosting.\<region>.\<fqdn> | HTTPS | 443 |
|Key Vault (user)|&#42;.vault.*&lt;region>.&lt;fqdn>*|HTTPS|443|
|Key Vault (administrator)|&#42;.adminvault.*&lt;region>.&lt;fqdn>*|HTTPS|443|
|Storage Queue|&#42;.queue.*&lt;region>.&lt;fqdn>*|HTTP<br>HTTPS|80<br>443|
|Storage Table|&#42;.table.*&lt;region>.&lt;fqdn>*|HTTP<br>HTTPS|80<br>443|
|Storage Blob|&#42;.blob.*&lt;region>.&lt;fqdn>*|HTTP<br>HTTPS|80<br>443|
|SQL Resource Provider|sqladapter.dbadapter.*&lt;region>.&lt;fqdn>*|HTTPS|44300-44304|
|MySQL Resource Provider|mysqladapter.dbadapter.*&lt;region>.&lt;fqdn>*|HTTPS|44300-44304|
|App Service|&#42;.appservice.*&lt;region>.&lt;fqdn>*|TCP|80 (HTTP)<br>443 (HTTPS)<br>8172 (MSDeploy)|
|  |&#42;.scm.appservice.*&lt;region>.&lt;fqdn>*|TCP|443 (HTTPS)|
|  |api.appservice.*&lt;region>.&lt;fqdn>*|TCP|443 (HTTPS)<br>44300 (Azure Resource Manager)|
|  |ftp.appservice.*&lt;region>.&lt;fqdn>*|TCP, UDP|21, 1021, 10001-10100 (FTP)<br>990 (FTPS)|
|VPN Gateways|     |  IP Protocol 50 & UDP| Encapsulation Security Payload (ESP) IPSec & UDP 500 and 4500


## Ports and URLs (outbound)

Azure Stack Hub supports only transparent proxy servers. In a deployment with a transparent proxy uplink to a traditional proxy server, you must allow the ports and URLs in the following table for outbound communication. For more information on configuring transparent proxy servers, see [Transparent proxy for Azure Stack Hub](azure-stack-transparent-proxy.md).

SSL traffic interception is [not supported](azure-stack-firewall.md#ssl-interception) and can lead to service failures when accessing endpoints. The maximum supported timeout to communicate with endpoints required for identity is 60s.

> [!Note]
> Azure Stack Hub doesn't support using ExpressRoute to reach the Azure services listed in the following table because ExpressRoute may not be able to route traffic to all of the endpoints.

|Purpose|Destination URL|Protocol / Ports|Source Network|Requirement|
|---------|---------|---------|---------|---------|
|**Identity**<br>Allows Azure Stack Hub to connect to Microsoft Entra ID for User & Service authentication.|**Azure**<br>`login.windows.net`<br>`login.microsoftonline.com`<br>`graph.windows.net`<br>`https://secure.aadcdn.microsoftonline-p.com`<br>`www.office.com`<br>ManagementServiceUri = `https://management.core.windows.net`<br>ARMUri = `https://management.azure.com`<br>`https://*.msftauth.net`<br>`https://*.msauth.net`<br>`https://*.msocdn.com`<br>**Azure Government**<br>`https://login.microsoftonline.us/`<br>`https://graph.windows.net/`<br>**Azure China 21Vianet**<br>`https://login.chinacloudapi.cn/`<br>`https://graph.chinacloudapi.cn/`<br>**Azure Germany**<br>`https://login.microsoftonline.de/`<br>`https://graph.cloudapi.de/`|HTTP 80,<br>HTTPS 443|Public VIP - /27<br>Public infrastructure Network|Mandatory for a connected deployment.|
|**Marketplace syndication**<br>Allows you to download items to Azure Stack Hub from the Marketplace and make them available to all users using the Azure Stack Hub environment.|**Azure**<br>`https://management.azure.com`<br>`https://*.blob.core.windows.net`<br>`https://*.azureedge.net`<br>**Azure Government**<br>`https://management.usgovcloudapi.net/`<br>`https://*.blob.core.usgovcloudapi.net/`<br>**Azure China 21Vianet**<br>`https://management.chinacloudapi.cn/`<br>`http://*.blob.core.chinacloudapi.cn`|HTTPS 443|Public VIP - /27|Not required. Use the [disconnected scenario instructions](azure-stack-download-azure-marketplace-item.md) to upload images to Azure Stack Hub.|
|**Patch & Update**<br>When connected to update endpoints, Azure Stack Hub software updates and hotfixes are displayed as available for download.|`https://*.azureedge.net`<br>`https://aka.ms/azurestackautomaticupdate`|HTTPS 443|Public VIP - /27|Not required. Use the [disconnected deployment connection instructions](azure-stack-update-prepare-package.md) to manually download and prepare the update.|
|**Registration**<br>Allows you to register Azure Stack Hub with Azure to download Azure Marketplace items and set up commerce data reporting back to Microsoft. |**Azure**<br>`https://management.azure.com`<br>**Azure Government**<br>`https://management.usgovcloudapi.net/`<br>**Azure China 21Vianet**<br>`https://management.chinacloudapi.cn`|HTTPS 443|Public VIP - /27|Not required. You can use the disconnected scenario for [offline registration](azure-stack-registration.md).|
|**Usage**<br>Allows Azure Stack Hub operators to configure their Azure Stack Hub instance to report usage data to Azure.|**Azure**<br>`https://*.trafficmanager.net`<br>`https://*.cloudapp.azure.com`<br>**Azure Government**<br>`https://*.usgovtrafficmanager.net`<br>`https://*.cloudapp.usgovcloudapi.net`<br>**Azure China 21Vianet**<br>`https://*.trafficmanager.cn`<br>`https://*.cloudapp.chinacloudapi.cn`|HTTPS 443|Public VIP - /27|Required for Azure Stack Hub consumption based licensing model.|
|**Windows Defender**<br>Allows the update resource provider to download antimalware definitions and engine updates multiple times per day.|`*.wdcp.microsoft.com`<br>`*.wdcpalt.microsoft.com`<br>`*.wd.microsoft.com`<br>`*.update.microsoft.com`<br>`*.download.microsoft.com`<br><br>`https://secure.aadcdn.microsoftonline-p.com`<br>|HTTPS 80, 443|Public VIP - /27<br>Public infrastructure Network|Not required. You can use the [disconnected scenario to update antivirus signature files](azure-stack-security-av.md#disconnected-scenario).|
|**NTP**<br>Allows Azure Stack Hub to connect to time servers.|(IP of NTP server provided for deployment)|UDP 123|Public VIP - /27|Required|
|**DNS**<br>Allows Azure Stack Hub to connect to the DNS server forwarder.|(IP of DNS server provided for deployment)|TCP & UDP 53|Public VIP - /27|Required|
|**SYSLOG**<br>Allows Azure Stack Hub to send syslog message for monitoring or security purposes.|(IP of SYSLOG server provided for deployment)|TCP 6514,<br>UDP 514|Public VIP - /27|Optional|
| **CRL**<br/>Allows Azure Stack Hub to validate certificates and check for revoked certificates.|URL under CRL Distribution Points on your certificates|HTTP 80|Public VIP - /27|Required|
|**CRL**<br>Allows Azure Stack Hub to validate certificates and check for revoked certificates.|`http://crl.microsoft.com/pki/crl/products`<br>`http://mscrl.microsoft.com/pki/mscorp`<br>`http://www.microsoft.com/pki/certs`<br>`http://www.microsoft.com/pki/mscorp`<br>`http://www.microsoft.com/pkiops/crl`<br>`http://www.microsoft.com/pkiops/certs`<br>|HTTP 80|Public VIP - /27|Not required. Highly recommended security best practice.|
|**LDAP**<br>Allows Azure Stack Hub to communicate with Microsoft Active Directory on-premises.|Active Directory Forest provided for Graph integration|TCP & UDP 389|Public VIP - /27|Required when Azure Stack Hub is deployed using AD FS.|
|**LDAP SSL**<br>Allows Azure Stack Hub to communicate encrypted with Microsoft Active Directory on-premises.|Active Directory Forest provided for Graph integration|TCP 636|Public VIP - /27|Required when Azure Stack Hub is deployed using AD FS.|
|**LDAP GC**<br>Allows Azure Stack Hub to communicate with Microsoft Active Global Catalog Servers.|Active Directory Forest provided for Graph integration|TCP 3268|Public VIP - /27|Required when Azure Stack Hub is deployed using AD FS.|
|**LDAP GC SSL**<br>Allows Azure Stack Hub to communicate encrypted with Microsoft Active Directory Global Catalog Servers.|Active Directory Forest provided for Graph integration|TCP 3269|Public VIP - /27|Required when Azure Stack Hub is deployed using AD FS.|
|**AD FS**<br>Allows Azure Stack Hub to communicate with on-premise AD FS.|AD FS metadata endpoint provided for AD FS integration|TCP 443|Public VIP - /27|Optional. The AD FS claims provider trust can be created using a [metadata file](azure-stack-integrate-identity.md#setting-up-ad-fs-integration-by-providing-federation-metadata-file).|
|**Diagnostic log collection**<br>Allows Azure Stack Hub to send logs either proactively or manually by an operator to Microsoft support.|`https://*.blob.core.windows.net`<br>`https://azsdiagprdlocalwestus02.blob.core.windows.net`<br>`https://azsdiagprdwestusfrontend.westus.cloudapp.azure.com`<br>`https://azsdiagprdwestusfrontend.westus.cloudapp.azure.com` | HTTPS 443 | Public VIP - /27 |Not required. You can [save logs locally](diagnostic-log-collection.md#save-logs-locally).|
|**Remote support**<br>Allows Microsoft support professionals to solve support case faster by permitting access to the device remotely to performing limited troubleshooting and repair operations. | `https://edgesupprd.trafficmanager.net`<br>`https://edgesupprdwestusfrontend.westus2.cloudapp.azure.com`<br>`https://edgesupprdwesteufrontend.westeurope.cloudapp.azure.com`<br>`https://edgesupprdeastusfrontend.eastus.cloudapp.azure.com`<br>`https://edgesupprdwestcufrontend.westcentralus.cloudapp.azure.com`<br>`https://edgesupprdasiasefrontend.southeastasia.cloudapp.azure.com`<br>`*.servicebus.windows.net` | HTTPS 443 | Public VIP - /27 | Not required. |
|**Telemetry**<br>Allows Azure Stack Hub to send telemetry data to Microsoft.|`https://settings-win.data.microsoft.com`<br>`https://login.live.com`<br>`*.events.data.microsoft.com`<br>Beginning with version 2108, the following endpoints are also required:<br>`https://*.blob.core.windows.net/`<br>`https://azsdiagprdwestusfrontend.westus.cloudapp.azure.com/` | HTTPS 443 | Public VIP - /27 | Required when Azure Stack Hub telemetry is enabled. |

Outbound URLs are load balanced using Azure traffic manager to provide the best possible connectivity based on geographic location. With load balanced URLs, Microsoft can update and change backend endpoints without affecting customers. Microsoft doesn't share the list of IP addresses for the load balanced URLs. Use a device that supports filtering by URL rather than by IP.

Outbound DNS is required at all times; what varies is the source querying the external DNS and what type of identity integration was chosen. During deployment for a connected scenario, the DVM that sits on the BMC network needs outbound access. But after deployment, the DNS service moves to an internal component that will send queries through a Public VIP. At that time, the outbound DNS access through the BMC network can be removed, but the Public VIP access to that DNS server must remain or else authentication will fail.

## Next steps

[Azure Stack Hub PKI requirements](azure-stack-pki-certs.md)
