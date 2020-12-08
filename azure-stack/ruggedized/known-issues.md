---
title: Azure Stack Hub known issues for Azure Stack Hub ruggedized 
description: Learn about known issues in Azure Stack Hub Azure Stack Hub ruggedized.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 12/08/2020
ms.author: sethm
ms.reviewer: sranthar
ms.lastreviewed: 12/08/2020
---

# Known issues in Azure Stack Hub ruggedized 

This article lists known issues in Azure Stack Hub ruggedized. The list is updated as new issues are identified.

## Update

For known Azure Stack Hub update issues, see [Troubleshooting Updates in Azure Stack Hub](../operator/azure-stack-troubleshooting.md#troubleshoot-azure-stack-hub-updates).

### Update failed to install package Microsoft.AzureStack.Compute.Installer to CA VM

- Applicable: This issue applies to all supported releases.
- Cause: During update, a process takes a lock on the new content that needs to be copied to CA VM. When the update fails, the lock is released.
- Remediation: Resume the update.
- Occurrence: Rare

## Portal

### Administrative subscriptions

- Applicable: This issue applies to all supported releases.
- Cause: The two administrative subscriptions that were introduced with version 1804 should not be used. The subscription types are **Metering** subscription, and **Consumption** subscription.
- Remediation: If you have resources running on these two subscriptions, recreate them in user subscriptions.
- Occurrence: Common

## Networking

### Network Security Groups

#### DenyAllOutbound rule cannot be created

- Applicable: This issue applies to all supported releases.
- Cause: An explicit **DenyAllOutbound** rule to the internet cannot be created in an NSG during VM creation as this will prevent the communication required for the VM deployment to complete. It will also deny the two essential IPs that are required in order to deploy VMs: DHCP IP:169.254.169.254 and DNS IP: 168.63.129.16.

- Remediation: Allow outbound traffic to the internet during VM creation, and modify the NSG to block the required traffic after VM creation is complete.
- Occurrence: Common

### Virtual Network Gateway

#### Documentation

- Applicable: This issue applies to all supported releases.
- Cause: The documentation links in the overview page of Virtual Network gateway link to Azure-specific documentation instead of Azure Stack Hub. Use the following links for the Azure Stack Hub documentation:

  - [Gateway SKUs](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-skus)
  - [Highly Available Connections](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-availability)
  - [Configure BGP on Azure Stack Hub](../user/azure-stack-vpn-gateway-settings.md#gateway-requirements)
  - [ExpressRoute circuits](azure-stack-connect-expressroute.md)
  - [Specify custom IPsec/IKE policies](../user/azure-stack-vpn-gateway-settings.md#ipsecike-parameters)

### Load Balancer

#### Load Balancer directing traffic to one backend VM in specific scenarios

- Applicable: This issue applies to all supported releases. 
- Cause: When enabling **Session Affinity** on a load balancer, the 2 tuple hash utilizes the PA IP (Physical Address IP) instead of the private IPs assigned to the VMs. In scenarios where traffic directed to the load balancer arrives through a VPN, or if all the client VMs (source IPs) reside on the same node and Session Affinity is enabled, all traffic is directed to one backend VM.
- Occurrence: Common
