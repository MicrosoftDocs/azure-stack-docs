---
title: Azure Stack Hub datacenter DNS integration | Microsoft Docs
description: Learn how to integrate Azure Stack Hub DNS with your datacenter DNS.
services: azure-stack
author: mattbriggs
manager: femila
ms.service: azure-stack
ms.topic: article
ms.date: 08/21/2019
ms.author: mabrigg
ms.reviewer: wfayed
ms.lastreviewed: 08/21/2019
keywords:
---

# Azure Stack Hub datacenter DNS integration

To be able to access Azure Stack Hub endpoints such as **portal**, **adminportal**, **management**, and **adminmanagement** from outside Azure Stack Hub, you need to integrate the Azure Stack Hub DNS services with the DNS servers that host the DNS zones you want to use in Azure Stack Hub.

## Azure Stack Hub DNS namespace

You're required to provide some important information related to DNS when you deploy Azure Stack Hub.


|Field  |Description  |Example|
|---------|---------|---------|
|Region|The geographic location of your Azure Stack Hub deployment.|`east`|
|External Domain Name|The name of the zone you want to use for your Azure Stack Hub deployment.|`cloud.fabrikam.com`|
|Internal Domain Name|The name of the internal zone that's used for infrastructure services in Azure Stack Hub. It's Directory Service-integrated and private (not reachable from outside the Azure Stack Hub deployment).|`azurestack.local`|
|DNS Forwarders|DNS servers that are used to forward DNS queries, DNS zones, and records that are hosted outside Azure Stack Hub, either on the corporate intranet or public internet. You can edit the DNS Forwarder value with the [**Set-AzSDnsForwarder** cmdlet](#editing-dns-forwarder-ips) after deployment. 
|Naming Prefix (Optional)|The naming prefix you want your Azure Stack Hub infrastructure role instance machine names to have.  If not provided, the default is `azs`.|`azs`|

The fully qualified domain name (FQDN) of your Azure Stack Hub deployment and endpoints is the combination of the Region parameter and the External Domain Name parameter. Using the values from the examples in the previous table, the FQDN for this Azure Stack Hub deployment would be the following name:

`east.cloud.fabrikam.com`

As such, examples of some of the endpoints for this deployment would look like the following URLs:

`https://portal.east.cloud.fabrikam.com`

`https://adminportal.east.cloud.fabrikam.com`

To use this example DNS namespace for an Azure Stack Hub deployment, the following conditions are required:

- The zone `fabrikam.com` is registered either with a domain registrar, an internal corporate DNS server, or both, depending on your name resolution requirements.
- The child domain `cloud.fabrikam.com` exists under the zone `fabrikam.com`.
- The DNS servers that host the zones `fabrikam.com` and `cloud.fabrikam.com` can be reached from the Azure Stack Hub deployment.

To be able to resolve DNS names for Azure Stack Hub endpoints and instances from outside Azure Stack Hub, you need to integrate the DNS servers that host the external DNS zone for Azure Stack Hub with the DNS servers that host the parent zone you want to use.

### DNS name labels

Azure Stack Hub supports adding a DNS name label to a public IP address to allow name resolution for public IP addresses. DNS labels are a convenient way for users to reach apps and services hosted in Azure Stack Hub by name. The DNS name label uses a slightly different namespace than the infrastructure endpoints. Following the previous example namespace, the namespace for DNS name labels appears as follows:

`*.east.cloudapp.cloud.fabrikam.com`

Therefore, if a tenant indicates a value **Myapp** in the DNS name label field of a public IP address resource, it creates an A record for **myapp** in the zone **east.cloudapp.cloud.fabrikam.com** on the Azure Stack Hub external DNS server. The resulting fully qualified domain name appears as follows:

`myapp.east.cloudapp.cloud.fabrikam.com`

If you want to leverage this functionality and use this namespace, you must integrate the DNS servers that host the external DNS zone for Azure Stack Hub with the DNS servers that host the parent zone you want to use as well. This is a different namespace than the namespace for the Azure Stack Hub service endpoints, so you must create an additional delegation or conditional forwarding rule.

For more information about how the DNS Name label works, see [Using DNS in Azure Stack Hub](../user/azure-stack-dns.md).

## Resolution and delegation

There are two types of DNS servers:

- An authoritative DNS server hosts DNS zones. It answers DNS queries for records in those zones only.
- A recursive DNS server doesn't host DNS zones. It answers all DNS queries by calling authoritative DNS servers to gather the data it needs.

Azure Stack Hub includes both authoritative and recursive DNS servers. The recursive servers are used to resolve names of everything except for the internal private zone and the external public DNS zone for that Azure Stack Hub deployment.

![Azure Stack Hub DNS architecture](media/azure-stack-integrate-dns/Integrate-DNS-01.png)

## Resolving external DNS names from Azure Stack Hub

To resolve DNS names for endpoints outside Azure Stack Hub (for example: www\.bing.com), you need to provide DNS servers that Azure Stack Hub can use to forward DNS requests for which Azure Stack Hub isn't authoritative. For deployment, DNS servers that Azure Stack Hub forwards requests to are required in the Deployment Worksheet (in the DNS Forwarder field). Provide at least two servers in this field for fault tolerance. Without these values, Azure Stack Hub deployment fails. You can edit the DNS Forwarder values with the [**Set-AzSDnsForwarder** cmdlet](#editing-dns-forwarder-ips) after deployment. 



### Configure conditional DNS forwarding

> [!IMPORTANT]
> This only applies to an AD FS deployment.

To enable name resolution with your existing DNS infrastructure, configure conditional forwarding.

To add a conditional forwarder, you must use the privileged endpoint.

For this procedure, use a computer in your datacenter network that can communicate with the privileged endpoint in Azure Stack Hub.

1. Open an elevated Windows PowerShell session (run as administrator), and connect to the IP address of the privileged endpoint. Use the credentials for CloudAdmin authentication.

   ```
   $cred=Get-Credential 
   Enter-PSSession -ComputerName <IP Address of ERCS> -ConfigurationName PrivilegedEndpoint -Credential $cred
   ```

2. After you connect to the privileged endpoint, run the following PowerShell command. Substitute the sample values provided with your domain name and IP addresses of the DNS servers you want to use.

   ```
   Register-CustomDnsServer -CustomDomainName "contoso.com" -CustomDnsIPAddresses "192.168.1.1","192.168.1.2"
   ```

## Resolving Azure Stack Hub DNS names from outside Azure Stack Hub
The authoritative servers are the ones that hold the external DNS zone information, and any user-created zones. Integrate with these servers to enable zone delegation or conditional forwarding to resolve Azure Stack Hub DNS names from outside Azure Stack Hub.

## Get DNS Server external endpoint information

To integrate your Azure Stack Hub deployment with your DNS infrastructure, you need the following information:

- DNS server FQDNs
- DNS server IP addresses

The FQDNs for the Azure Stack Hub DNS servers have the following format:

`<NAMINGPREFIX>-ns01.<REGION>.<EXTERNALDOMAINNAME>`

`<NAMINGPREFIX>-ns02.<REGION>.<EXTERNALDOMAINNAME>`

Using the sample values, the FQDNs for the DNS servers are:

`azs-ns01.east.cloud.fabrikam.com`

`azs-ns02.east.cloud.fabrikam.com`


This information is also created at the end of all Azure Stack Hub deployments in a file named `AzureStackStampInformation.json`. This file is located in the `C:\CloudDeployment\logs` folder of the Deployment virtual machine. If you're not sure what values were used for your Azure Stack Hub deployment, you can get the values from here.

If the Deployment virtual machine is no longer available or is inaccessible, you can obtain the values by connecting to the privileged endpoint and running the `Get-AzureStackStampInformation` PowerShell cmdlet. For more information, see [privileged endpoint](azure-stack-privileged-endpoint.md).

## Setting up conditional forwarding to Azure Stack Hub

The simplest and most secure way to integrate Azure Stack Hub with your DNS infrastructure is to do conditional forwarding of the zone from the server that hosts the parent zone. This approach is recommended if you have direct control over the DNS servers that host the parent zone for your Azure Stack Hub external DNS namespace.

If you're not familiar with how to do conditional forwarding with DNS, see the following TechNet article: [Assign a Conditional Forwarder for a Domain Name](https://technet.microsoft.com/library/cc794735), or the documentation specific to your DNS solution.

In scenarios where you specified your external Azure Stack Hub DNS Zone to look like a child domain of your corporate domain name, conditional forwarding can't be used. DNS delegation must be configured.

Example:

- Corporate DNS Domain Name: `contoso.com`
- Azure Stack Hub External DNS Domain Name: `azurestack.contoso.com`

## Editing DNS Forwarder IPs

DNS Forwarder IPs are set during deployment of Azure Stack Hub. However, if the Forwarder IPs need to be updated for any reason, you can edit the values by connecting to the privileged endpoint and running the `Get-AzSDnsForwarder` and `Set-AzSDnsForwarder [[-IPAddress] <IPAddress[]>]` PowerShell cmdlets. For more information, see [privileged endpoint](azure-stack-privileged-endpoint.md).

## Delegating the external DNS zone to Azure Stack Hub

For DNS names to be resolvable from outside an Azure Stack Hub deployment, you need to set up DNS delegation.

Each registrar has their own DNS management tools to change the name server records for a domain. In the registrar's DNS management page, edit the NS records and replace the NS records for the zone with the ones in Azure Stack Hub.

Most DNS registrars require you to provide a minimum of two DNS servers to complete the delegation.

## Next steps

[Firewall integration](azure-stack-firewall.md)
