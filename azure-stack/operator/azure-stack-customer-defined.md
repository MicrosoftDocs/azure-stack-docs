---
title: Modify specific settings on your Azure Stack Hub switch configuration | Microsoft Docs
description: Learn what you can customize on your Azure Stack Hub switch configuration. After the original equipment manufacturer (OEM) creates the configuration, do not alter it without consent from either the OEM or the Microsoft Azure Stack Hub engineering team.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: Femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 11/11/2019
ms.author: mabrigg
ms.reviewer: wamota
ms.lastreviewed: 11/11/2019
---

#  Modify specific settings on your Azure Stack Hub switch configuration

You can modify a few environmental settings for your Azure Stack Hub switch configuration. You can identify which of the settings you can change in the template created by your original equipment manufacturer (OEM). This article explains each of those customizable settings, and how the changes can affect your Azure Stack Hub. These settings include password update, syslog server, SNMP monitoring, authentication, and the access control list. 

During deployment of the Azure Stack Hub solution, the original equipment manufacturer (OEM) creates and applies the switch configuration for both TORs and BMC. The OEM uses the Azure Stack Hub automation tool to validate that the required configurations are properly set on these devices. The configuration is based the information in your Azure Stack Hub [Deployment Worksheet](azure-stack-deployment-worksheet.md). After the OEM creates the configuration, **do not** alter the configuration without consent from either the OEM or the Microsoft Azure Stack Hub engineering team. A change to the network device configuration can significantly impact the operation or troubleshooting of network issues in your Azure Stack Hub instance.

However, there are some values that can be added, removed, or changed on the configuration of the network switches.

>[!Warning]  
> **Do not** alter the configuration without consent from either the OEM or the Microsoft Azure Stack Hub engineering team. A change to the network device configuration can significantly impact the operation or troubleshooting of network issues in your Azure Stack Hub instance.
>
> For more information about these functions on your network device, how to make these changes, please contact your OEM hardware provider or Microsoft support. Your OEM has the configuration file created by the automation tool based on your Azure Stack Hub deployment worksheet. 

## Password update

The operator may update the password for any user on the network switches at any time. There isn't a requirement to change any information on the Azure Stack Hub system, or to use the steps for [Rotate secrets in Azure Stack Hub](azure-stack-rotate-secrets.md).

## Syslog server

Operators can redirect the switch logs to a syslog server on their datacenter. Use this configuration to ensure that the logs from a particular point in time can be used for troubleshooting. By default, the logs are stored on the switches; their capacity for storing logs is limited. Check the [Access control list updates](#access-control-list-updates) section for an overview of how to configure the permissions for switch management access.

## SNMP monitoring

The operator can configure simple network management protocol (SNMP) v2 or v3 to monitor the network devices and send traps to a network monitoring application on the datacenter. For security reasons, use SNMPv3 since it is more secure than v2. Consult your OEM hardware provider for the MIBs and configuration required. Check the [Access control list updates](#access-control-list-updates) section for an overview of how to configure the permissions for switch management access.

## Authentication

The operator can configure either RADIUS or TACACS to manage authentication on the network devices. Consult your OEM hardware provider for supported methods and configuration required.  Check the [Access control list updates](#access-control-list-updates) section for an overview of how to configure the permissions for Switch Management access.

## Access control list updates

> [!NOTE]
> Starting in 1910, the deployment worksheet will have a new field for **Permitted Networks** which replaces the manual steps required to allow access to network device management interfaces and the hardware lifecycle host (HLH) from a trusted datacenter network range. For more information about this new feature, please check the [Network integration planning for Azure Stack Hub](azure-stack-network.md#permitted-networks).

The operator can change some access control list (ACL)s to allow access to network device management interfaces and the hardware lifecycle host (HLH) from a trusted datacenter network range. With the access control list, The operator can allow their management jumpbox VMs within a specific network range to access the switch management interface, the HLH OS and the HLH BMC.

## Next steps

[Azure Stack Hub datacenter integration - DNS](azure-stack-integrate-dns.md)
