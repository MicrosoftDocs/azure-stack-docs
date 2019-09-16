---
title: Use iDNS in Azure Stack | Microsoft Docs
description: Learn how to use iDNS features and capabilities in Azure Stack.
services: azure-stack
documentationcenter: ''
author: Justinha
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: conceptual
ms.date: 09/16/2019
ms.author: Justinha
ms.reviewer: scottnap
ms.lastreviewed: 01/14/2019

---
# Use iDNS in Azure Stack 

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

iDNS is an Azure Stack networking feature that enables you to resolve external DNS names (for example, https:\//www.bing.com.) It also allows you to register internal virtual network names. By doing so, you can resolve virtual machines (VMs) on the same virtual network by name rather than IP address. This approach removes the need to provide custom DNS server entries. For more information about DNS, see the [Azure DNS Overview](https://docs.microsoft.com/azure/dns/dns-overview).

## What does iDNS do?

With iDNS in Azure Stack, you get the following capabilities, without having to specify custom DNS server entries:

- Shared DNS name resolution services for tenant workloads.
- Authoritative DNS service for name resolution and DNS registration within the tenant virtual network.
- Recursive DNS service for resolution of internet names from tenant VMs. Tenants no longer need to specify custom DNS entries to resolve internet names (for example, www\.bing.com.)

You can still bring your own DNS and use custom DNS servers. However, by using iDNS, you can resolve internet DNS names and connect to other VMs in the same virtual network without needing to create custom DNS entries.

## What doesn't iDNS do?

iDNS doesn't allow you to create a DNS record for a name that can be resolved from outside the virtual network.

In Azure, you have the option of specifying a DNS name label that is associated with a public IP address. You can choose the label (prefix), but Azure chooses the suffix, which is based on the region in which you create the public IP address.

![Example of a DNS name label](media/azure-stack-understanding-dns-in-tp2/image3.png)

As the previous image shows, Azure will create an "A" record in DNS for the DNS name label specified under the zone **westus.cloudapp.azure.com**. The prefix and the suffix are combined to compose a [fully qualified domain name](https://en.wikipedia.org/wiki/Fully_qualified_domain_name) (FQDN) that can be resolved from anywhere on the public internet.

Azure Stack only supports iDNS for internal name
registration, so it can't do the following things:

- Create a DNS record under an existing hosted DNS zone (for example, local.azurestack.external.)
- Create a DNS zone (such as Contoso.com.)
- Create a record under your own custom DNS zone.
- Support the purchase of domain names.

## Demo of how iDNS works

All of the host names for VMs on Virtual Networks are stored as DNS Resource Records under the same zone, however under their own unique compartment defined as a GUID that correlates to the VNET ID in the SDN infrastructure that the VM was deployed against. 
Tenant VM Fully Qualified Domain Names (FQDNs) consist of the computer name and the DNS suffix string for the Virtual Network, in GUID format.

<!--- what does compartment mean? Add a screenshot? can we clarify what we mean by host name and computer name. the description doesn't match the example in the table.--->
 
Following is a simple lab to demonstrate how this works. We've created 3 VMs on one VNet and another VM on a separate VNet:

<!--- Is DNS Label the right term? If so, we should define it. The column lists FQDNs, afaik. Where does the domain suffix come from? --->
 
|VM    |vNet    |Private IP   |Public IP    | DNS Label                                |
|------|--------|-------------|-------------|------------------------------------------|
|VM-A1 |VNetA   | 10.0.0.5    |172.31.12.68 |VM-A1-Label.lnv1.cloudapp.azscss.external |
|VM-A2 |VNetA   | 10.0.0.6    |172.31.12.76 |VM-A2-Label.lnv1.cloudapp.azscss.external |
|VM-A3 |VNetA   | 10.0.0.7    |172.31.12.49 |VM-A3-Label.lnv1.cloudapp.azscss.external |
|VM-B1 |VNetB   | 10.0.0.4    |172.31.12.57 |VM-B1-Label.lnv1.cloudapp.azscss.external |
 
 
|VNet  |GUID                                 |DNS suffix string                                                  |
|------|-------------------------------------|-------------------------------------------------------------------|
|VNetA |e71e1db5-0a38-460d-8539-705457a4cf75 |e71e1db5-0a38-460d-8539-705457a4cf75.internal.lnv1.azurestack.local|
|VNetB |e8a6e386-bc7a-43e1-a640-61591b5c76dd |e8a6e386-bc7a-43e1-a640-61591b5c76dd.internal.lnv1.azurestack.local|
 
 
You can do some name resolution tests to better understand how iDNS works:

<!--- why Linux?--->

From VM-A1 (Linux VM):
Looking up VM-A2. You can see that the DNS suffix for VNetA is added and the name is resolved to the Private IP:
 
```console
carlos@VM-A1:~$ nslookup VM-A2
Server:         127.0.0.53
Address:        127.0.0.53#53
 
Non-authoritative answer:
Name:   VM-A2.e71e1db5-0a38-460d-8539-705457a4cf75.internal.lnv1.azurestack.local
Address: 10.0.0.6
```
 
Looking up VM-A2-Label without providing the FQDN fails, as expected:

```console 
carlos@VM-A1:~$ nslookup VM-A2-Label
Server:         127.0.0.53
Address:        127.0.0.53#53
 
** server can't find VM-A2-Label: SERVFAIL
```

If you provide the FQDN for the DNS label, the name is resolved to the Public IP:

```console
carlos@VM-A1:~$ nslookup VM-A2-Label.lnv1.cloudapp.azscss.external
Server:         127.0.0.53
Address:        127.0.0.53#53
 
Non-authoritative answer:
Name:   VM-A2-Label.lnv1.cloudapp.azscss.external
Address: 172.31.12.76
```
 
Trying to resolve VM-B1 (which is from a different VNet) fails as this record does not exist on this zone.

```console
carlos@caalcobi-vm4:~$ nslookup VM-B1
Server:         127.0.0.53
Address:        127.0.0.53#53
 
** server can't find VM-B1: SERVFAIL
```

Using the FQDN for VM-B1 doesn’t help as this record is from a different zone.

```console 
carlos@VM-A1:~$ nslookup VM-B1.e8a6e386-bc7a-43e1-a640-61591b5c76dd.internal.lnv1.azurestack.local
Server:         127.0.0.53
Address:        127.0.0.53#53
 
** server can't find VM-B1.e8a6e386-bc7a-43e1-a640-61591b5c76dd.internal.lnv1.azurestack.local: SERVFAIL
```
 
If you use the FQDN for the DNS label, then it resolves successfully:

``` 
carlos@VM-A1:~$ nslookup VM-B1-Label.lnv1.cloudapp.azscss.external
Server:         127.0.0.53
Address:        127.0.0.53#53
 
Non-authoritative answer:
Name:   VM-B1-Label.lnv1.cloudapp.azscss.external
Address: 172.31.12.57
```
 
From VM-A3 (Windows VM). Notice the difference between authoritative and non-authoritative answers.

Internal records:

```console
C:\Users\carlos>nslookup
Default Server:  UnKnown
Address:  168.63.129.16
 
> VM-A2
Server:  UnKnown
Address:  168.63.129.16
 
Name:    VM-A2.e71e1db5-0a38-460d-8539-705457ª4cf75.internal.lnv1.azurestack.local
Address:  10.0.0.6
```

External records:

```console
> VM-A2-Label.lnv1.cloudapp.azscss.external
Server:  UnKnown
Address:  168.63.129.16
 
Non-authoritative answer:
Name:    VM-A2-Label.lnv1.cloudapp.azscss.external
Address:  172.31.12.76
``` 
 
In short, you can see from the above that:
 
*   Each VNet has its own zone, containing A records for all private IP addresses, consisting of VM name and the DNS suffix of the VNet (which is its GUID).
    *   \<vmname>.\<vnetGUID\>.internal.\<region>.\<stackinternalFQDN>
    *   This is done automatically
*   If you use Public IP addresses, you can also create DNS labels for them. These are resolved like any other external address.
 
 
- iDNS servers are the authoritative servers for their internal DNS zones, and also act as a resolver for public names when tenant VMs attempt to connect to external resources. If there is a query for an external resource, then iDNS servers forward the request to authritative DNS servers to resolve.
 
As you can see from the lab results, you have control over what IP is used. If you use the VM name, you will get the private IP address and if you use the DNS label you get the public IP address.

## Next steps

[Using DNS in Azure Stack](azure-stack-dns.md)
