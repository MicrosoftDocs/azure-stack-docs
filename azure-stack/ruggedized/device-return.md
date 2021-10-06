---
title: Return an Azure Stack Hub Ruggedized device 
description: Learn how to return an Azure Stack Hub Ruggedized (ASH-R) device 
author: sethmanheim
ms.author: sethm
ms.topic: how-to 
ms.date: 09/29/2021
ms.custom: template-how-to
---


# Return a device

There are several ways that you can return an Azure Stack Hub Ruggedized (ASH-R) device after you reach the end of your subscription. As a user of Azure Stack Hub Ruggedized, you are billed by Microsoft based on how long you have had the device. When the device is returned to Microsoft, billing stops as soon as the appliance is received at the Microsoft warehouse. All the following return options include an evaluation that is performed after the Microsoft warehouse receives the device, and there will be additional fees for damaged equipment.

## Return options

The following table describes the different options for returning a device:

| Type of return            | Description                                                                                                                                                                      |
|---------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Standard return           | Customer chooses to return device with the assumption that data on drives will be destroyed and hardware can be refurbished.                                                         |
| Return without drives     | Customer chooses to keep the data drives and return other hardware. There will be a fee for the drives.                                                                          |
| Data destruction          | Customer chooses to return the ASH-R, but ensure that Microsoft destroys data-bearing media in compliance with [data destruction rules](/compliance/assurance/assurance-data-bearing-device-destruction). There will be a fee for data destruction. |
| Secure device destruction | Customer chooses to return entire device and have the device destroyed securely. There will be a fee for secure device destruction.                                            |

## Initiate device return

Once the customer has reached the end of a subscription with the device, an owner of the subscription must [submit a support ticket](../operator/azure-stack-help-and-support-overview.md?toc=%2Fazure-stack%2Fruggedized%2Ftoc.json&bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json) to initiate the return process. Once the ticket has been received, the following actions occur:

:::image type="content" source="media/device-return/return-flow.png" alt-text="Device return steps":::

| Step  | Who?                                             | Action                                                                                                                                                                                                                                                                    |
|---------|--------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1       | Customer                                         | Initiates return by opening a support ticket.                                                                                                                                                                                                                             |
| 2       | Azure Customer Service and Support team (CSS)    | CSS provides the steps to reset the device prior to return.                                                                                                                                                                                                               |
| 3       | ASE Customer Operations team (ASE CO)            | ASE CO coordinates a pickup date with the customer for returning their device. The packaging of the device is serviced through our logistics partner (TMC). The billing of the device is paused as of the scheduled date of the pickup.                     |
| 4       | Customer                                         | Customer powers down, removes cables, [packs device](#pack-the-device) to include all components, and prepares for [scheduled pickup](#schedule-a-pickup).                                                                                                                                                         |
| 5       | Product Operations Team                          | After the device has been received by the Product Operations team and returned to the Microsoft warehouse, the device is appropriately handled based on the customer's choice of return type. This process includes re-imaging, diagnostics, refurbishment, and disposition.               |
| 6       | ASE Customer Operations team (ASE CO)            | ASE CO team provides a final status update to the customer regarding return and sanitization. The operations team provides a "Certificate of Destruction," if needed.     |
| 7       | ASE Customer Operations team (ASE CO)            | If the inspection of the returned device is successful, the ASE CO team applies any remaining charges to the subscription (return without drives fee, data destruction fee, etc.) and stops the billing for the device.                             |
| 8       | ASE Customer Operations team (ASE CO)            | ASE CO communicates final completion of the return back to the customer.                                                                                                                                                                                                   |
| 9       | Customer                                         | The customer can delete the resource group associated with the order.                                                                                                                                                                                       |

## Pack the device

Follow these steps to pack the device:

1. Power down the [scale unit nodes](customer-replaceable-unit/power-off-scu.md) and the [Hardware Lifecycle Host](customer-replaceable-unit/power-off-hlh.md).
1. Unplug the power cables and remove all the network cables from the device.
1. Carefully prepare the shipment package as follows:
   1. Use the shipping box you requested from Azure or the original shipping box with its foam packaging.
   1. Place the bottom foam piece in the box.
   1. Lay the device on top of the foam. Ensure that it sits snugly in the foam. Repeat this 3 times for each of the 3 boxes you have.
   1. Place the top foam piece in the package.
   1. Place the power cords in the accessory tray and place the rails on the top foam piece.
   1. Seal the box and affix the shipping label that you received from Azure to the package.

> [!IMPORTANT]
> If proper guidelines to prepare the return shipment are not followed, the device could be damaged and a damaged device fee may apply. See the [FAQ on lost or damaged devices](https://azure.microsoft.com/pricing/details/azure-stack/edge/).

## Schedule a pickup

After coordinating with the ASE CO, schedule a pickup with your regional carrier. If returning the device in the US, your carrier could be UPS or FedEx. To schedule a pickup with UPS:

1. Call the local UPS carrier (country/region-specific toll free number).
1. In your call, quote the reverse shipment tracking number as shown on your printed label.
1. If the tracking number isn't quoted, UPS requires you to pay an extra fee during pickup.

## Delete the resource

After the device is received at the Azure datacenter, the device is inspected for damage or any signs of tampering.

- If the device arrives intact and is in good condition, the billing meter stops for that resource. The ASE Customer Operations team will contact you to confirm that the device was returned. You can then delete the resource associated with the order in the Azure portal.
- If the device arrives significantly damaged, charges may apply. For details, see the [FAQ on lost or damaged devices](https://azure.microsoft.com/pricing/details/azure-stack/edge/).

After you return a device to Microsoft, and the ASE Customer Operations team has called to confirm that the device was returned, you can delete the Azure Resource Manager ID associated with the order in the Azure portal. The operations team does not call until the returned device passes the physical inspection at the Azure datacenter.

If you've activated the device against another subscription or location, Microsoft will move your order to the new subscription or location within one business day. After the order is moved, you can delete the resource.

## Next steps

- [Learn more about Azure Stack Ruggedized](ruggedized-overview.md)
