---
title: IoT Hub on Azure Stack Hub overview
description: Learn about the IoT Hub resource provider on Azure Stack Hub and differences from the Azure hosted version of IoT Hub.
author: yiyiguo 
ms.author: yiygu 
ms.service: azure-stack
ms.topic: how-to
ms.date: 1/6/2020 
---

# IoT Hub on Azure Stack Hub overview

[!INCLUDE [preview-banner](../includes/iot-hub-preview.md)]

IoT Hub on Azure Stack Hub allows you to create hybrid IoT solutions. IoT Hub is a managed service, acts as a central message hub for bi-directional communication between your IoT application and the devices it manages. You can use IoT Hub on Azure Stack Hub to build IoT solutions with reliable and secure communications between IoT devices and a on-prem solution backend. 

## Differences between Azure IoT Hub and IoT Hub on Azure Stack Hub

| Feature | Azure IoT Hub | IoT Hub on Azure Stack Hub |
|-|-|-|
| Scale | https://docs.microsoft.com/azure/iot-hub/iot-hub-scaling | S2 and S3 IoT Hubs are supported|
| Service Update | Automatic | Manual |

## IoT Hub throttling

The throttling and quotas for IoT Hub on Azure Stack Hub S2 and S3 SKUs, is same as IoT Hub on Azure. Please refer to [Azure IoT Hub quotas and throttling](/azure/iot-hub/iot-hub-devguide-quotas-throttling#quotas-and-throttling) for more details.

## Next steps

To prepare for installation of IoT Hub on Azure Stack Hub, review the [Prerequisites](iot-hub-rp-prerequisites.md) document.

To learn more about the difference between a connected and disconnected Azure Stack Hub, review [Azure Stack Connection Model](azure-stack-connection-models.md).
