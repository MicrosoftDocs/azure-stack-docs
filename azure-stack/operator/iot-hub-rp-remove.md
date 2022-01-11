---
title: How to remove IoT Hub on Azure Stack Hub
description: Instructions on uninstalling IoT Hub on Azure Stack Hub
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 1/6/2020
---

# How to remove IoT Hub on Azure Stack Hub

This article provides instructions on how to remove IoT Hub resource provider on Azure Stack Hub. This process takes around 37 minutes.

> [!WARNING]
> Once IoT Hub is uninstalled, **_all devices and data will be deleted_**. The operation is **NOT** recoverable.

## Uninstalling IoT Hub

1) Go to **Marketplace management**. IoT Hub will be in the list and marked as installed. Click on **IoT Hub**.

    [![Resource provider list](../operator/media/iot-hub-rp-remove/uninstall1.png)](../operator/media/iot-hub-rp-remove/uninstall1.png#lightbox)

2) Click **Uninstall** under **IoT Hub**, provide the resource provider name **microsoft.iothub**, then click **Uninstall** button under it.

    [![Uninstall IoT Hub and confirm](../operator/media/iot-hub-rp-remove/uninstall2.png)](../operator/media/iot-hub-rp-remove/uninstall2.png#lightbox)

3) Wait for the uninstall to complete. A "Resource Provider installation has been completed successfully" banner will show at the top of the page.

>[!IMPORTANT]
>The dependencies (eg. Event Hub) will **NOT** be uninstalled. Should you want to uninstall/ remove any of the dependencies from marketplace, you will need to do it separately.

## Next steps

For more information on Azure IoT Hub, see the [Azure IoT Hub Documentation](/azure/iot-hub/).