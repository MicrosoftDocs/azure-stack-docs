---
title: Customize on your Azure Stack switch configuration | Microsoft Docs
description: Learn what you can customize on your Azure Stack switch configuration.
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
ms.date: 08/09/2019
ms.author: mabrigg
ms.reviewer: wamota
ms.lastreviewed: 08/09/2019
---

#  Customize on your Azure Stack switch configuration

You can customize your Azure Stack switch configuration. You can check the templates created by the automation tool used to configure your switches to identify the specific values that you can change. This article explains each of those customizations, and how the changes can affect your Azure Stack.

During deployment of the Azure Stack solution, the original equipment manufacturer (OEM) creates and applies the switch configuration for both TORs and BMC. The OEM uses the Azure Stack automation tool to validate that the required configurations are properly set on these devices. The configuration is based the information in your Azure Stack [Deployment Worksheet](azure-stack-deployment-worksheet.md). After the OEM configuration is created, shouldn't be altered without consent from either the OEM or the Microsoft Azure Stack engineering team. A change to the network device configuration can significantly impact the operation or troubleshooting of network issues in the solution.

However, there are some values that can be added, removed, or changed on the configuration of the network switches.

>[!NOTE]  
>For more information about these functions on your network device or how to make these changes, please contact your OEM hardware provider.

## Password update

The operator may change the passwords for any user on the network switches at any time. There isn't a requirement to change any information on the Azure Stack system, or use the steps for [Update Secrets](azure-stack-rotate-secrets.md).

## Syslog server

Operators can redirect the switch logs to a syslog server on their datacenter. Use this configuration to ensure that the logs from a particular point in time can be used for troubleshooting. By default, the logs are stored on the switches; their capacity for storing logs is limited. Check the [Access control list updates](#access-control-list-updates) section for an overview of how to configure the permissions for switch management access.

## Snmp monitoring

The operator can configure SNMP v2 or v3 to monitor the network devices and send traps to a network monitoring application on the datacenter. For security reasons, we strongly recommend the use of SNMPv3 as it is far more secure than v2.  Consult your OEM hardware provider for the MIBs and configuration required. Check the [Access control list updates](#access-control-list-updates) section for an overview of how to configure the permissions for Switch Management access.

## Authentication

The operator can configure either RADIUS or TACACS to manage authentication on the network devices. Consult your OEM hardware provider for supported methods and configuration required.  Check the [Access control list updates](#access-control-list-updates) section for an overview of how to configure the permissions for Switch Management access.

## Access control list updates

The operator can change some Access control list (ACL)s to allow access to network device management interfaces and the hardware lifecycle host (HLH) from a trusted datacenter network range. The operator can pick which component will be reachable and from where. The operator can allow their management jumpbox VMs within a specific network range to access the switch management interface, and the HLH OS, and the HLH BMC.

## Next steps

[DNS integration](azure-stack-integrate-dns.md)