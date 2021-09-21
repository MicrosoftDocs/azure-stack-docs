---
title: Return an Azure Stack Hub Ruggedized device 
description: Learn how to return an Azure Stack Hub Ruggedized (ASH-R) device 
author: sethmanheim
ms.author: sethm
ms.topic: how-to 
ms.date: 09/21/2021
ms.custom: template-how-to
---


# Return a device

There are several ways that you can return an Azure Stack Hub Ruggedized (ASH-R) device after you reach the end of your subscription. As a user of Azure Stack Hub Ruggedized, you are billed by Microsoft based on how long you have had the device. When the device is returned to Microsoft, billing stops as soon as the appliance is received at the Microsoft warehouse.

## Return options

The following table describes the various options for return:

| Type of Return            | Description                                                                                                                                                                      |
|---------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Standard Return           | Customer chooses to return device with assumption that data on drives will be destroyed and hardware can be refurbished.                                                         |
| Return without Drives     | Customer chooses to keep the data drives and return other hardware. There will be a fee for the drives.                                                                          |
| Data Destruction          | Customer chooses to return the ASH-R but ensure Microsoft destroys data bearing media in compliance with data destruction rules. Note: There will be a fee for data destruction. |
| Secure Device Destruction | Customer chooses to return entire device and have device destroyed securely. Note: There will be a fee for secure device destruction.                                            |

## Return process

Once you have reached the end of a subscription with the device, you must [submit a support ticket](../operator/azure-stack-help-and-support-overview?toc=%2Fazure-stack%2Fruggedized%2Ftoc.json&bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json&view=azs-2102) to initiate the return process. Once the ticket has been received, the following actions occur:

- The Azure Customer Service and Support team provides steps to reset the device prior to return.
- The ASE Customer Operations team coordinates a pickup date for returning the device. The packaging of the device is serviced through our logistics partner. The billing of the device is paused, as of the scheduled date of the pickup.
- After the device has been received by the product operations team and returned to the Microsoft warehouse, the device is appropriately handled based on the customer's choice of return type. This includes re-imaging, diagnostics, refurbishment, and disposition.
- The ASE Customer Operations team provides a final status update to the customer regarding return and sanitization. The operations team provides a "Certificate of Destruction," should that be needed.
- If the returned device inspection is successful, the ASE Customer Operations team applies any remaining charges to the subscription (return without drives fee, data destruction fee, etc.) and then stops the billing for the device, communicating back to the customer the completion of the return. The customer can then delete the resource group associated with the device.

## Next steps

[Learn more about Azure Stack Ruggedized](ruggedized-overview.md).
