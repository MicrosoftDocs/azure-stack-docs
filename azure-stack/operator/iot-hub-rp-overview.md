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

IoT Hub on Azure Stack Hub allows you to create hybrid IoT solutions. IoT Hub is a managed service, acts as a central message hub for bi-directional communication between your IoT application and the devices it manages. You can use IoT Hub on Azure Stack Hub to build IoT solutions with reliable and secure communications between IoT devices and a on-prem solution backend. 

## Differences between Azure IoT Hub and IoT Hub on Azure Stack Hub

| Feature | Azure IoT Hub | IoT Hub on Azure Stack Hub |
|-|-|-|
| Scale | https://docs.microsoft.com/azure/iot-hub/iot-hub-scaling | Only S2 IoT hubs are supported|
| Service Update | Automatic | Manual |

## IoT Hub throttling

IoT Hub throttles in the following aspects to ensure the performance of the service on Azure Stack Hub.

| IoT Hub on Azure Stack Hub| |
|-|-|
| SKU | S2 only|
| Number of devices | 10,000 |
| Throughput units | 1 - 20 |
| Throughput | Sustained throughput: 120 messages/sec/unit, Maximum: 6 million messages/day/unit |

## Next steps

To prepare for installation of IoT Hub on Azure Stack Hub, review the [Prerequisites](iot-hub-rp-prerequisites.md) document.

To learn more about the difference between a connected and disconnected Azure Stack Hub, review [Azure Stack Connection Model](azure-stack-connection-models.md).
