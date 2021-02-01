---
title: Required knowledge for working with Scale Unit nodes in a Ruggedized Cloud Appliance
description: Learn about the required knowledge for working with Scale Unit nodes in a Ruggedized Cloud Appliance
author: PatAltimore

ms.topic: how-to
ms.date: 11/13/2020
ms.author: patricka
ms.reviewer: 
ms.lastreviewed: 

# Intent: 
# Keyword: 

---

# Required knowledge for working with Scale Unit nodes in a Ruggedized Cloud Appliance

To complete FRU procedures, you must be familiar with and able to
access the following concepts, guides, and web sites.

## Privileged Access Workstation and the privileged endpoint

The Privileged Access Workstation (PAW) is a dedicated workstation
protected from the Internet and external threat vectors. It can reside
on the Hardware Lifecycle Host (HLH) or externally on the customer
network with routable access to the Azure Stack Hub Scale Unit nodes.

To access the PAW, you must log in using Remote Desktop. Obtain the
credentials and IP address from the customer.

From this machine, you can also access the privileged endpoint (PEP).
For more information about the Privileged Access Workstation as well
as the PEP, see Privileged Access Workstation and privileged endpoint
access.

## Azure Stack Hub Administrator Portal

Obtain the Administrator Portal credentials and URL from the customer.
For more information see [Use the administrator
portal](../../operator/azure-stack-manage-portals.md)
[in Azure Stack
Hub](../../operator/azure-stack-manage-portals.md).

## Dell EMC PowerEdge R640 Installation and Service Manual

For details on physically replacing the relevant hardware, refer to
the installing and removing PowerEdge R640 system component procedures
in the [Dell EMC PowerEdge R640 Installation and Service
Manual](https://www.dell.com/support/manuals/us/en/04/poweredge-r640/per640_ism_pub/dell-emc-poweredge-r640-overview?guid=guid-f39be9ba-158c-45e3-b8b1-f07bb750d6d4).
Browse to the [Installing and
removing](https://www.dell.com/support/manuals/us/en/04/poweredge-r640/per640_ism_pub/installing-and-removing-system-components?guid=guid-5a5943c4-fe26-4faa-a10c-2afa4c1993ff&lang=en-us)
[system
components](https://www.dell.com/support/manuals/us/en/04/poweredge-r640/per640_ism_pub/installing-and-removing-system-components?guid=guid-5a5943c4-fe26-4faa-a10c-2afa4c1993ff&lang=en-us)
section.

## Microsoft Azure Stack Hub Ruggedized Cloud Appliance Service Manual

The Microsoft Azure Stack Hub Ruggedized Cloud Appliance Service Manual
contains instructions for removing Scale Unit node servers from the
Tracewell Ruggedized Pods.

## Dell EMC PowerEdge iDRAC

You must understand how to navigate and use the Dell EMC PowerEdge
iDRAC web interface. For more information on using the iDRAC, refer to
the [Integrated Dell Remote Access Controller 9 User\'s
Guide](https://www.dell.com/support/manuals/us/en/04/poweredge-r840/idrac9_4.00.00.00_ug_new/overview-of-idrac?guid=guid-a03c2558-4f39-40c8-88b8-38835d0e9003).