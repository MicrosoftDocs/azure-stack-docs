---
title:  Azure Local security book network security
description: Network security for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/30/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Network security

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

## Software defined networking (SDN) and micro-segmentation

With Azure Local, you can take steps towards ensuring that your applications and workloads are protected from external as well as internal attacks. Through micro-segmentation, you can create granular network policies between applications and services. This essentially reduces the security perimeter to a fence around each application or VM. This fence permits only necessary communication between application tiers or other logical boundaries, thus making it exceedingly difficult for cyberthreats to spread laterally from one system to another. Micro-segmentation securely isolates networks from each other and reduces the total attack surface of a network security incident.

Micro-segmentation in Azure Local is implemented through Network Security Groups (NSGs), like Azure. With NSGs, you can create allow or deny firewall rules where your rule source and destination are network prefixes. We also support tag-based segmentation, where you can assign any custom tags to classify your VMs, and then apply NSGs based on the tags to restrict communication to/from external as well as internal sources. So, to prevent your SQL VMs from communicating with your web server VMs, simply tag corresponding VMs with "SQL" and "Web" tags and create a NSG to prevent "Web" tag from communicating with "SQL" tag. These policies are available for VMs on traditional VLAN networks and on SDN overlay networks.

Management of NSGs is supported through Windows Admin Center, PowerShell, and REST APIs. To learn more about NSGs, see [Configure network security groups with tags in Windows Admin Center](../manage/configure-network-security-groups-with-tags.md).

Finally, we also support default network access policies. Default network access policies help ensure that all virtual machines (VMs) in your Azure Local instance are secure by default from external threats. If you choose to enable default policies for a virtual machine (VM), we will block inbound access to the VM by default, while giving the option to enable specific selective inbound management ports and thus securing the VM from external attacks. To learn more about default network access policies, see [Manage default network access policies on your Azure Local](../manage/manage-default-network-access-policies-virtual-machines.md).


## Related content

- [Trustworthy addition overview](trustworthy-addition-overview.md)
