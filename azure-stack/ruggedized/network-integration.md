---
title: Azure Stack Hub ruggedized network integration
description: Learn about Azure Stack network integration for the Azure Stack Hub ruggedized device. 
author: PatAltimore
ms.author: patricka
ms.service: azure-stack
ms.topic: conceptual
ms.date: 10/14/2020
ms.lastreviewed: 10/14/2020
---

# Azure Stack Hub ruggedized network integration 

This topic covers Azure Stack network integration.

## Border connectivity (uplink)

Network integration planning is an important prerequisite for successful Azure
Stack integrated systems deployment, operation, and management. Border
connectivity planning begins by choosing if you want use dynamic routing with
border gateway protocol (BGP). This requires assigning a 16-bit BGP autonomous
system number (public or private) or using static routing, where a static
default route is assigned to the border devices.

The top of rack (TOR) switches require Layer 3 uplinks with Point-to-Point IPs (/30 networks) configured on the physical interfaces. Layer 2 uplinks with TOR switches supporting Azure Stack operations isn't supported. 

### BGP routing

Using a dynamic routing protocol like BGP guarantees that your system is always
aware of network changes and facilitates administration. For enhanced security,
a password may be set on the BGP peering between the TOR and the Border.

As shown in the following diagram, advertising of the private IP space on the
TOR switch is blocked using a prefix-list. The prefix list denies the
advertisement of the Private Network and it's applied as a route-map on the
connection between the TOR and the border.

The Software Load Balancer (SLB) running inside the Azure Stack solution peers
to the TOR devices so it can dynamically advertise the VIP addresses.

To ensure that user traffic immediately and transparently recovers from failure,
the VPC or MLAG configured between the TOR devices allows the use of
multi-chassis link aggregation to the hosts and HSRP or VRRP that provides
network redundancy for the IP networks.




### Static routing

Static routing requires additional configuration to the border devices. It
requires more manual intervention and management as well as thorough analysis
before any change. Issues caused by a configuration error may take more time to
rollback depending on the changes made. This routing method isn't recommended,
but it's supported.

To integrate Azure Stack into your networking environment using static routing,
all four physical links between the border and the TOR device must be connected.
High availability can't be guaranteed because of how static routing works.

The border device must be configured with static routes pointing to each one of
the four P2P IPs set between the TOR and the Border for traffic destined to any
network inside Azure Stack, but only the *External* or Public VIP network is
required for operation. Static routes to the *BMC* and the *External* networks
are required for initial deployment. Operators can choose to leave static routes
in the border to access management resources that reside on the *BMC* and
the *Infrastructure* network. Adding static routes to *switch
infrastructure* and *switch management* networks is optional.

The TOR devices are configured with a static default route sending all traffic
to the border devices. The one traffic exception to the default rule is for the
private space, which is blocked using an Access Control List applied on the TOR
to border connection.

Static routing applies only to the uplinks between the TOR and border switches.
BGP dynamic routing is used inside the rack because it's an essential tool for
the SLB and other components and can't be disabled or removed.




\* The BMC network is optional after deployment.

\*\* The Switch Infrastructure network is optional, as the whole network can be
included in the Switch Management network.

\*\*\* The Switch Management network is required and can be added separately
from the Switch Infrastructure network.

### Transparent proxy

If your datacenter requires all traffic to use a proxy, you must configure
a *transparent proxy* to process all traffic from the rack to handle it
according to policy, separating traffic between the zones on your network.

The Azure Stack solution doesn't support normal web proxies 


A transparent proxy (also known as an intercepting, inline, or forced proxy)
intercepts normal communication at the network layer without requiring any
special client configuration. Clients don't need to be aware of the existence of
the proxy.



SSL traffic interception is not supported and can lead to service failures when
accessing endpoints. The maximum supported timeout to communicate with endpoints
required for identity is 60s with 3 retry attempts.

## DNS


This section covers Domain Name System (DNS) configuration.

### Configure conditional DNS forwarding

This only applies to an AD FS deployment. 


To enable name resolution with your existing DNS infrastructure, configure
conditional forwarding.

To add a conditional forwarder, you must use the privileged endpoint.

For this procedure, use a computer in your datacenter network that can
communicate with the privileged endpoint in Azure Stack.

1.  Open an elevated Windows PowerShell session (run as administrator), and
    connect to the IP address of the privileged endpoint. Use the credentials
    for CloudAdmin authentication.

    ```powershell
    \$cred=Get-Credential Enter-PSSession -ComputerName \<IP Address of ERCS\> -ConfigurationName PrivilegedEndpoint -Credential \$cred 
    ```

2.  After you connect to the privileged endpoint, run the following PowerShell
    command. Substitute the sample values provided with your domain name and IP
    addresses of the DNS servers you want to use.

    ```powershell
    Register-CustomDnsServer -CustomDomainName "contoso.com" -CustomDnsIPAddresses "192.168.1.1","192.168.1.2" 
    ```

### Resolving Azure Stack DNS names from outside Azure Stack

The authoritative servers are the ones that hold the external DNS zone
information, and any user-created zones. Integrate with these servers to enable
zone delegation or conditional forwarding to resolve Azure Stack DNS names from
outside Azure Stack.

### Get DNS Server external endpoint information

To integrate your Azure Stack deployment with your DNS infrastructure, you need
the following information:

-   DNS server FQDNs

-   DNS server IP addresses

The FQDNs for the Azure Stack DNS servers have the following format:

\<NAMINGPREFIX\>-ns01.\<REGION\>.\<EXTERNALDOMAINNAME\>

\<NAMINGPREFIX\>-ns02.\<REGION\>.\<EXTERNALDOMAINNAME\>

Using the sample values, the FQDNs for the DNS servers are:

azs-ns01.east.cloud.fabrikam.com

azs-ns02.east.cloud.fabrikam.com

This information is available in the admin portal but also created at the end of
all Azure Stack deployments in a file named AzureStackStampInformation.json.
This file is located in the C:\\CloudDeployment\\logs folder of the Deployment
virtual machine. If you're not sure what values were used for your Azure Stack
deployment, you can get the values from here.

If the Deployment virtual machine is no longer available or is inaccessible, you
can obtain the values by connecting to the privileged endpoint and running
the Get-AzureStackStampInformation PowerShell cmdlet. For more information,
see privileged endpoint.

### Setting up conditional forwarding to Azure Stack

The simplest and most secure way to integrate Azure Stack with your DNS
infrastructure is to do conditional forwarding of the zone from the server that
hosts the parent zone. This approach is recommended if you have direct control
over the DNS servers that host the parent zone for your Azure Stack external DNS
namespace.

If you're not familiar with how to do conditional forwarding with DNS, see the
following TechNet article: Assign a Conditional Forwarder for a Domain Name, or
the documentation specific to your DNS solution.

In scenarios where you specified your external Azure Stack DNS Zone to look like
a child domain of your corporate domain name, conditional forwarding can't be
used. DNS delegation must be configured.

Example:

-   Corporate DNS Domain Name: contoso.com

-   Azure Stack External DNS Domain Name: azurestack.contoso.com

### Editing DNS Forwarder IPs

DNS Forwarder IPs are set during deployment of Azure Stack. However, if the
Forwarder IPs need to be updated for any reason, you can edit the values by
connecting to the privileged endpoint and running
the Get-AzSDnsForwarder and Set-AzSDnsForwarder [[-IPAddress]
\<IPAddress[]\>] PowerShell cmdlets. For more information, see privileged
endpoint.

### Delegating the external DNS zone to Azure Stack

For DNS names to be resolvable from outside an Azure Stack deployment, you need
to set up DNS delegation.

Each registrar has their own DNS management tools to change the name server
records for a domain. In the registrar's DNS management page, edit the NS
records and replace the NS records for the zone with the ones in Azure Stack.

Most DNS registrars require you to provide a minimum of two DNS servers to
complete the delegation.

## Firewall

Azure Stack sets up virtual IP addresses (VIPs) for its infrastructure roles.
These VIPs are allocated from the public IP address pool. Each VIP is secured
with an access control list (ACL) in the software-defined network layer. ACLs
are also used across the physical switches (TORs and BMC) to further harden the
solution. A DNS entry is created for each endpoint in the external DNS zone
that's specified at deployment time. For example, the user portal is assigned
the DNS host entry of portal.*\<region\>.\<fqdn\>*.

The following architectural diagram shows the different network layers and ACLs:

![architectural diagram shows the different network layers and ACLs](media/network-deployment/network-architecture.png) 


### Ports and URLs

To make Azure Stack services (like the portals, Azure Resource Manager, DNS, and
so on) available to external networks, you must allow inbound traffic to these
endpoints for specific URLs, ports, and protocols.

In a deployment where a transparent proxy uplinks to a traditional proxy server
or a firewall is protecting the solution, you must allow specific ports and URLs
for both inbound and outbound communication. These include ports and URLs for
identity, the marketplace, patch and update, registration, and usage data.

### Outbound communication

Azure Stack supports only transparent proxy servers. In a deployment with a
transparent proxy uplink to a traditional proxy server, you must allow the ports
and URLs in the following table for outbound communication when deploying in
connected mode.

SSL traffic interception is not supported and can lead to service failures when
accessing endpoints. The maximum supported timeout to communicate with endpoints
required for identity is 60s.

>[!NOTE] 
>Azure Stack doesn’t support using ExpressRoute to reach the Azure services listed in the following table because ExpressRoute may not be able to route traffic to all of the endpoints. 


|Purpose|Destination URL|Protocol|Ports|Source Network|
|---------|---------|---------|---------|---------|
|Identity|**Azure**<br>login.windows.net<br>login.microsoftonline.com<br>graph.windows.net<br>https:\//secure.aadcdn.microsoftonline-p.com<br>www.office.com<br>ManagementServiceUri = https:\//management.core.windows.net<br>ARMUri = https:\//management.azure.com<br>https:\//\*.msftauth.net<br>https:\//\*.msauth.net<br>https:\//\*.msocdn.com<br>**Azure Government**<br>https:\//login.microsoftonline.us/<br>https:\//graph.windows.net/<br>**Azure China 21Vianet**<br>https:\//login.chinacloudapi.cn/<br>https:\//graph.chinacloudapi.cn/<br>**Azure Germany**<br>https:\//login.microsoftonline.de/<br>https:\//graph.cloudapi.de/|HTTP<br>HTTPS|80<br>443|Public VIP - /27<br>Public infrastructure Network|
|Marketplace syndication|**Azure**<br>https:\//management.azure.com<br>https://&#42;.blob.core.windows.net<br>https://&#42;.azureedge.net<br>**Azure Government**<br>https:\//management.usgovcloudapi.net/<br>https://&#42;.blob.core.usgovcloudapi.net/<br>**Azure China 21Vianet**<br>https:\//management.chinacloudapi.cn/<br>http://&#42;.blob.core.chinacloudapi.cn|HTTPS|443|Public VIP - /27|
|Patch & Update|https://&#42;.azureedge.net<br>https:\//aka.ms/azurestackautomaticupdate|HTTPS|443|Public VIP - /27|
|Registration|**Azure**<br>https:\//management.azure.com<br>**Azure Government**<br>https:\//management.usgovcloudapi.net/<br>**Azure China 21Vianet**<br>https:\//management.chinacloudapi.cn|HTTPS|443|Public VIP - /27|
|Usage|**Azure**<br>https://&#42;.trafficmanager.net<br>**Azure Government**<br>https://&#42;.usgovtrafficmanager.net<br>**Azure China 21Vianet**<br>https://&#42;.trafficmanager.cn|HTTPS|443|Public VIP - /27|
|Windows Defender|&#42;.wdcp.microsoft.com<br>&#42;.wdcpalt.microsoft.com<br>&#42;.wd.microsoft.com<br>&#42;.update.microsoft.com<br>&#42;.download.microsoft.com<br>https:\//www.microsoft.com/pkiops/crl<br>https:\//www.microsoft.com/pkiops/certs<br>https:\//crl.microsoft.com/pki/crl/products<br>https:\//www.microsoft.com/pki/certs<br>https:\//secure.aadcdn.microsoftonline-p.com<br>|HTTPS|80<br>443|Public VIP - /27<br>Public infrastructure Network|
|NTP|(IP of NTP server provided for deployment)|UDP|123|Public VIP - /27|
|DNS|(IP of DNS server provided for deployment)|TCP<br>UDP|53|Public VIP - /27|
|CRL|(URL under CRL Distribution Points on your certificate)|HTTP|80|Public VIP - /27|
|LDAP|Active Directory Forest provided for Graph integration|TCP<br>UDP|389|Public VIP - /27|
|LDAP SSL|Active Directory Forest provided for Graph integration|TCP|636|Public VIP - /27|
|LDAP GC|Active Directory Forest provided for Graph integration|TCP|3268|Public VIP - /27|
|LDAP GC SSL|Active Directory Forest provided for Graph integration|TCP|3269|Public VIP - /27|
|AD FS|AD FS metadata endpoint provided for AD FS integration|TCP|443|Public VIP - /27|
|Diagnostic Log collection service|Azure Storage provided Blob SAS URL|HTTPS|443|Public VIP - /27|
|     |     |     |     |     |
                                  
                                  
### Inbound communication

A set of infrastructure VIPs is required for publishing Azure Stack endpoints to
external networks. The *Endpoint (VIP)* table shows each endpoint, the required
port, and protocol. Refer to the specific resource provider deployment
documentation for endpoints that require additional resource providers, like the
SQL resource provider.

Internal infrastructure VIPs aren't listed because they're not required for
publishing Azure Stack. User VIPs are dynamic and defined by the users
themselves, with no control by the Azure Stack operator


>[!NOTE] 
>IKEv2 VPN is a standards-based IPsec VPN solution that uses UDP port 500 and 4500 and TCP port 50. Firewalls don’t always open these ports, so an IKEv2 VPN might not be able to traverse proxies and firewalls. 


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
|VPN Gateways|     |     |[See the VPN gateway FAQ](/azure/vpn-gateway/vpn-gateway-vpn-faq#can-i-traverse-proxies-and-firewalls-using-point-to-site-capability).|
|     |     |     |     |