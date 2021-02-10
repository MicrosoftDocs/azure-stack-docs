---
title: Required knowledge for working with the Hardware Lifecycle Host
description: Learn about the required knowledge for working with the Hardware Lifecycle Host
author: PatAltimore

ms.topic: how-to
ms.date: 11/13/2020
ms.author: patricka
ms.reviewer: 
ms.lastreviewed: 

# Intent: 
# Keyword: 

---

# Required knowledge for working with the Hardware Lifecycle Host

To complete FRU procedures, you must be familiar with and able to
access the following concepts and guides.

## Hardware Lifecycle Host

The Hardware Lifecycle Host (HLH) is a physical management server
located at top of the Azure Stack Hub rack. To access the host, you
can connect to it using one of three methods:

* Direct (crash cart)
* iDRAC (service port)
* iDRAC (IP access)

If inside the data center, then you can connect to the HLH directly
using the VGA and USB ports. For example, connecting a crash cart.

If inside the data center, then connect your laptop to the iDRAC 9
service port using a micro USB cable. For more information, see Accessing the iDRAC interface over a direct USB connection.

Work with the customer to connect to the HLH from their management
network and management workstation to the iDRAC IP.

> [!NOTE]
> Only networks that
were previously added to the switch ACLs can connect directly to the
HLH iDRAC.

## Credentials

Work with the customer to obtain the credentials for the following:

* HLH
* administrator
* iDRAC account (optional)

A Windows account with full administrator rights.

If not connecting directly to the server using a crash cart, then you
will need the iDRAC account credentials to gain access to the virtual
KVM.

## Dell EMC PowerEdge R640 Installation and Service Manual

For details on physically replacing the relevant hardware, refer to
the PowerEdge R640 FRU replacement procedures in the
[Dell](https://www.dell.com/support/manuals/us/en/04/poweredge-r640/per640_ism_pub/dell-emc-poweredge-r640-overview?guid=guid-f39be9ba-158c-45e3-b8b1-f07bb750d6d4)
[EMC PowerEdge R640 Installation and Service
Manual](https://www.dell.com/support/manuals/us/en/04/poweredge-r640/per640_ism_pub/dell-emc-poweredge-r640-overview?guid=guid-f39be9ba-158c-45e3-b8b1-f07bb750d6d4).
Browse to the [Installing and removing system
components](https://www.dell.com/support/manuals/us/en/04/poweredge-r640/per640_ism_pub/installing-and-removing-system-components?guid=guid-5a5943c4-fe26-4faa-a10c-2afa4c1993ff&lang=en-us)
section.

## Microsoft Azure Stack Hub Ruggedized Cloud Appliance Service Manual

The Microsoft Azure Stack Hub Ruggedized Cloud Appliance Service Manual
contains instructions for removing the Hardware Lifecycle Host.

## Dell EMC PowerEdge iDRAC

You must understand how to navigate and use the Dell EMC PowerEdge
iDRAC web interface.

