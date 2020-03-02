---
title: Integrate physical device auditing with your Azure Stack Hub datacenter 
description: Learn how to integrate physical device access auditing with your Azure Stack Hub datacenter.
author: IngridAtMicrosoft
ms.topic: article
ms.date: 06/10/2019
ms.author: inhenkel
ms.reviewer: thoroet
ms.lastreviewed: 06/10/2019

# Intent: As an Azure Stack operator, I want to integrate physical device auditing with my Azure Stack datacenter.
# Keyword: azure stack physical device auditing

---


# Integrate physical device auditing with your Azure Stack Hub datacenter

All physical devices in Azure Stack Hub, like the baseboard management controllers (BMCs) and network switches, emit audit logs. You can integrate the audit logs into your overall auditing solution. Since the devices vary across the different Azure Stack Hub OEM hardware vendors, contact your vendor for the documentation on auditing integration. The sections below provide some general information for physical device auditing in Azure Stack Hub.  

## Physical device access auditing

All physical devices in Azure Stack Hub support the use of TACACS or RADIUS. Support includes access to the baseboard management controller (BMC) and network switches.

Azure Stack Hub solutions don't ship with either RADIUS or TACACS built-in. However, the solutions have been validated to support the use of existing RADIUS or TACACS solutions available in the market.

For RADIUS only, MSCHAPv2 was validated. This represents the most secure implementation using RADIUS. Consult with your OEM hardware vendor to enable TACAS or RADIUS in the devices included with your Azure Stack Hub solution.

## Syslog forwarding for network devices

All physical networking devices in Azure Stack Hub support syslog messages. Azure Stack Hub solutions don't ship with a syslog server. However, the devices have been validated to support sending messages to existing syslog solutions available in the market.

The syslog destination address is an optional parameter collected for deployment, but it can also be added post deployment. Consult with your OEM hardware vendor to configure syslog forwarding on your networking devices.

## Next steps

[Servicing policy](azure-stack-servicing-policy.md)
