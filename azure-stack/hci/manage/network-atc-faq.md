---
title: Network ATC FAQ
description: This page covers some frequently asked questions for Network ATC. 
author: parammahajan
ms.topic: how-to
ms.date: 03/27/2022
ms.author: parammahajan
---

# Network ATC: Frequently Asked Questions 

## What does Network ATC Manage?

### Stretch Clustering
1. **Does Network ATC support stretch clustering?**

Yes it does. From version 22H2, you can add `-Stretch` as a parameter when you adding an intent, and deploy stretch intents with Network ATC. For more information on how to deploy stretch intents, check out this [page](../deploy/create-cluster-powershell.md)

2. **My override is not being applied correctly. How should I fix it?**
 
One common mistake that occurs when deploying a siteOverride for stretch intents is- a mismatch between the siteName used in the cluster fault domain and the siteOverride. Make sure that the name outputted by `Get-ClusterFaultDomain` is the same as the name you are using in your site override, for the `siteoverride.Name` value. 


### Live Migrations 
1. **Does Network ATC manage live migrations?** 

From the version 22H2, Network ATC does indeed manage Live Migrations. Network ATC manages a whole range of properties for Live Migrations, like live migration network selection, number of concurrent VM migrations, SMB bandwidth limit. 

2. **How do I pass an override to customize live migration settings?**

To set and customize cluster and live migration settings, Network ATC uses `GlobalOverrides`. You first create a cluster override object, set its parameters to your desired values and then add it as a global intent. To pass a `GlobalOverrides`, run: 

```powershell
$clusterOverride = New-NetIntentGlobalClusterOverrides
Set-NetIntent -GlobalClusterOverrides $clusterOverride
``` 

## Storage configurations with Network ATC?


1. **Does Network ATC support switchless configurations?**

Yes, absolutely! Network ATC supports both switched and switchless configurations. 

2. **Does Automatic Storage IP Addressing work for switchless storage deployments?**

Currently, Automatic Storage IP Addressing (Auto IP) is only supported for 2-node switchless and all switched configurations.  

3. **The default storage IPs conflict with the IP Addresses in my network. Is there any way I can change or manage the storage IP addresses by myself?**

Yes, you can. If you want to use a customer storage VLAN for your storage intent, use the `-StorageVlans` parameter when adding your intent.
If you want to manage the VLANS as well as the IP addresses, you can submit an override disabling Auto-IP as follows:
```powershell
$storageOverride = new-NetIntentStorageOverrides
$storageOverride.EnableAutomaticIPGeneration = $false
Add-NetIntent -Name Storage_Compute -Storage -Compute -AdapterName 'pNIC01', 'pNIC02' -StorageOverrides $storageoverride
``` 