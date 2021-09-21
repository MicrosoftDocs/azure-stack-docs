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

The following table describes the different options for returning a device:

| Type of return            | Description                                                                                                                                                                      |
|---------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Standard return           | Customer chooses to return device with the assumption that data on drives will be destroyed and hardware can be refurbished.                                                         |
| Return without drives     | Customer chooses to keep the data drives and return other hardware. There will be a fee for the drives.                                                                          |
| Data destruction          | Customer chooses to return the ASH-R, but ensure that Microsoft destroys data-bearing media in compliance with data destruction rules. There will be a fee for data destruction. |
| Secure device destruction | Customer chooses to return entire device and have the device destroyed securely. There will be a fee for secure device destruction.                                            |

## Return process

Once you have reached the end of a subscription with the device, you must [submit a support ticket](../operator/azure-stack-help-and-support-overview.md?toc=%2Fazure-stack%2Fruggedized%2Ftoc.json&bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json) to initiate the return process. Once the ticket has been received, the following actions occur:

1. The Azure Customer Service and Support team provides steps to reset the device prior to return.
2. The ASE Customer Operations team coordinates a pickup date for returning the device. The packaging of the device is serviced through our logistics partner. The billing of the device is paused, as of the scheduled date of the pickup.
3. After the device has been received by the product operations team and returned to the Microsoft warehouse, the device is appropriately handled based on the customer's choice of return type. This process includes reimaging, diagnostics, refurbishment, and disposition.
4. The ASE Customer Operations team provides a final status update to the customer regarding return and sanitization. The operations team provides a "Certificate of Destruction," if needed.
5. If the returned device inspection is successful, the ASE Customer Operations team applies any remaining charges to the subscription (return without drives fee, data destruction fee, etc.) and then stops the billing for the device, communicating back to the customer the completion of the return. The customer can then delete the resource group associated with the device.

## Next steps

- [Learn more about Azure Stack Ruggedized](ruggedized-overview.md)
