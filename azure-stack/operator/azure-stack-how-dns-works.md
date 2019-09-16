---
title: How iDNS works | Microsoft Docs
description: A simple lab to demonstrate how iDNS works
services: azure-stack
documentationcenter: ''
author: justinha
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: naS
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/21/2019
ms.author: justinha
ms.reviewer: hectorl
ms.lastreviewed: 08/21/2019

---

# How DNS works in Azure Stack

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