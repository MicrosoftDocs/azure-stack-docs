---
title: Replace a hardware component on an Azure Stack scale unit node
titleSuffix: Azure Stack
description: Learn how to replace a hardware component on an Azure Stack integrated system.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 07/18/2019
ms.author: thoroet
ms.lastreviewed: 07/18/2019

---

# Replace a hardware component on an Azure Stack scale unit node

*Applies to: Azure Stack integrated systems*

This article describes the general process to replace hardware components that are non hot-swappable. Actual replacement steps vary based on your original equipment manufacturer (OEM) hardware vendor. See your vendor's field replaceable unit (FRU) documentation for detailed steps that are specific to your Azure Stack integrated system.

> [!CAUTION]  
> Firmware leveling is critical for the success of the operation described in this article. Missing this step can lead to system instability, performance decrease, security threads, or prevent Azure Stack automation from deploying the operating system. Always consult your hardware partner's documentation when replacing hardware to ensure the applied firmware matches the OEM Version displayed in the [Azure Stack administrator portal](azure-stack-updates.md).

| Hardware Partner | Region | URL |
|------------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Cisco | All | [Cisco Integrated System for Microsoft Azure Stack Operations Guide](https://www.cisco.com/c/en/us/td/docs/unified_computing/ucs/azure-stack/b_Azure_Stack_Operations_Guide_4-0/b_Azure_Stack_Operations_Guide_4-0_chapter_00.html#concept_wks_t1q_wbb)<br><br>[Release Notes for Cisco Integrated System for Microsoft Azure Stack](https://www.cisco.com/c/en/us/support/servers-unified-computing/ucs-c-series-rack-mount-ucs-managed-server-software/products-release-notes-list.html) |
| Dell EMC | All | [Cloud for Microsoft Azure Stack 14G (account and sign-in required)](https://support.emc.com/downloads/44615_Cloud-for-Microsoft-Azure-Stack-14G)<br><br>[Cloud for Microsoft Azure Stack 13G (account and sign-in required)](https://support.emc.com/downloads/42238_Cloud-for-Microsoft-Azure-Stack-13G) |
| Fujitsu | JAPAN | [Fujitsu managed service support desk (account and sign-in required)](https://eservice.fujitsu.com/supportdesk-web/) |
|  | EMEA | [Fujitsu support IT products and systems](https://support.ts.fujitsu.com/IndexContact.asp?lng=COM&ln=no&LC=del) |
|  | EU | [Fujitsu MySupport (account and sign-in required)](https://support.ts.fujitsu.com/IndexMySupport.asp) |
| HPE | All | [HPE ProLiant for Microsoft Azure Stack](http://www.hpe.com/info/MASupdates) |
| Lenovo | All | [ThinkAgile SXM Best Recipes](https://datacentersupport.lenovo.com/us/en/solutions/ht505122)
| Wortmann |  | [OEM/firmware package](https://drive.terracloud.de/dl/fiTdTb66mwDAJWgUXUW8KNsd/OEM)<br>[terra Azure Stack documentation (including FRU)](https://drive.terracloud.de/dl/fiWGZwCySZSQyNdykXCFiVCR/TerraAzSDokumentation)

Non hot-swappable components include the following:

- CPU*
- Memory*
- Motherboard/baseboard management controller (BMC)/video card
- Disk controller/host bus adapter (HBA)/backplane
- Network adapter (NIC)
- Operating system disk*
- Data drives (drives that don't support hot swap, for example PCI-e add-in cards)*

*These components may support hot swap, but can vary based on vendor implementation. See your OEM vendor's FRU documentation for detailed steps.

The following flow diagram shows the general FRU process to replace a non hot-swappable hardware component.

![Flow diagram showing component replacement flow](media/azure-stack-replace-component/replacecomponentflow.PNG)

* This action may not be required based on the physical condition of the hardware.

** Whether your OEM hardware vendor performs the component replacement and updates the firmware could vary based on your support contract.

## Review alert information

The Azure Stack health and monitoring system tracks the health of network adapters and data drives controlled by Storage Spaces Direct. It doesn't track other hardware components. For all other hardware components, alerts are raised in the vendor-specific hardware monitoring solution that runs on the hardware lifecycle host.  

## Component replacement process

The following steps provide a high-level overview of the component replacement process. Don't follow these steps without referring to your OEM-provided FRU documentation.

1. Use the Shutdown action to gracefully shut down the scale unit node. This action may not be required based on the physical condition of the hardware.

2. In an unlikely case the shutdown action does fail, use the [Drain](azure-stack-node-actions.md#drain) action to put the scale unit node into maintenance mode. This action may not be required based on the physical condition of the hardware.

   > [!NOTE]  
   > In any case, only one node can be disabled and powered off at the same time without breaking the S2D (Storage Spaces Direct).

3. After the scale unit node is in maintenance mode, use the [Power off](azure-stack-node-actions.md#scale-unit-node-actions) action. This action may not be required based on the physical condition of the hardware.

   > [!NOTE]  
   > In the unlikely case that the power off action doesn't work, use the baseboard management controller (BMC) web interface instead.

4. Replace the damaged hardware component. Whether your OEM hardware vendor performs the component replacement could vary based on your support contract.  
5. Update the firmware. Follow your vendor-specific firmware update process using the hardware lifecycle host to make sure the replaced hardware component has the approved firmware level applied. Whether your OEM hardware vendor performs this step could vary based on your support contract.  
6. Use the [Repair](azure-stack-node-actions.md#scale-unit-node-actions) action to bring the scale unit node back into the scale unit.
7. Use the privileged endpoint to [check the status of virtual disk repair](azure-stack-replace-disk.md#check-the-status-of-virtual-disk-repair-using-the-privileged-endpoint). With new data drives, a full storage repair job can take multiple hours depending on system load and consumed space.
8. After the repair action has finished, validate that all active alerts have been automatically closed.

## Next steps

- For information about replacing a hot-swappable physical disk, see [Replace a disk](azure-stack-replace-disk.md).
- For information about replacing a physical node, see [Replace a scale unit node](azure-stack-replace-node.md).
