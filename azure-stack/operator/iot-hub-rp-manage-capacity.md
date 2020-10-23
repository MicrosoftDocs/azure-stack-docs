---
title: Manage capacity for IoT Hub on Azure Stack Hub
description: Learn how to manage capacity for the IoT Hub resource provider on Azure Stack Hub.
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 10/30/2020 
---
# Manage capacity for IoT Hub on Azure Stack Hub

[!INCLUDE [preview-banner](../includes/iot-hub-preview.md)]

This article provides the guidance and instructions necessary to perform capacity management of the IoT Hub on Azure Stack Hub resource provider.

## Overview

As an operator, you manage and operate your Azure Stack Hub instance in the same manner as any cloud operator. You make sure software is installed properly, configured correctly and securely, and operated for high availability (HA), coherently and efficiently. In addition, you will need to apply capacity management principles in operating both the Azure Stack Hub instance and the IoT Hub resource provider.

## Azure Stack Hub capacity management

You will need to plan for and calculate the required capacity of your Azure Stack Hub instance. To determine the required capacity for IoT Hub, you'll need to estimate the workload, mainly the number of devices and the message throughput. To assist with planning, we have conducted the following tests on a 4-node environment for reference:

| Scenario | VMs | Vcores | Devices/ hub | [Hub edition](https://azure.microsoft.com/pricing/details/iot-hub) | Hubs | Units/ hub | Total devices | Total hub units | Millions of messages/ day |
|----------|---------------|------------------|-----------------------|-------------------|-|-|-|-|-|
|Minimum (post preview)|3|12|120,000|S2|4|200|480,000|800|4,800|
|Default|5|20|300,000|S2|4|200|1,200,000|800|4,800|
|12 VMs|12|48|500,000|S2|4|200|2,000,000|800|4,800|
|18 VMs|18|72|400,000|S3|4|10|1,600,000|40|12,000|

Refer to [Azure Stack Hub Capacity Planner](azure-stack-capacity-planner.md) for more details.

## IoT Hub service capacity management

Because Azure Stack Hub is deployed in an on-premises data center with limited resources, all services running on Azure Stack Hub share and compete for the same resource pool. Operators need to plan and manage the capacity based on the business needs. The IoT Hub resource provider gives operators the ability to manage the capacity requirements for the service.

IoT Hub has a single VM type. As part of IoT Hub deployment, the system provisions a set of these VMs on Azure Stack Hub. The VMs can support a certain number of devices and message throughput. The default setting should meet most requirements. However, if you need more devices or higher message throughput, you can increase the capacity using the administrator portal, CLI, or PowerShell. 

Operators can access the following capacity management features:

- Monitor current capacity status, specifically, the number of VMs provisioned in an IoT Hub cluster and their resource utilization.
- Increase capacity by adding as many VMs as available resources allow. 

> [!IMPORTANT]
> The ability to decrease capacity is not supported in the IoT Hub preview.

### Increase capacity

To increase the capacity of your IoT Hub cluster:

1. Sign in to the Azure Stack Hub administrator portal, select the **Dashboard** view on the left, then select the **IoT Hub** resource provider.

   [![operator dashboard](media\iot-hub-rp-manage-capacity\dashboard.png)](media\iot-hub-rp-manage-capacity\dashboard.png#lightbox)

2. The IoT Hub overview page provides a summary view, showing current alerts, quotas created on the stamp, and the total number of IoT Hub clusters in your subscription. 

   [![iot hub dashboard - overview](media\iot-hub-rp-manage-capacity\dashboard-rp-iot-hub-overview.png)](media\iot-hub-rp-manage-capacity\dashboard-rp-iot-hub-overview.png#lightbox)

3. Select the **capacity** view on the left. The number of nodes shown is the current number of nodes allocated to IoT Hub. To increase capacity, select the IoT Hub cluster name, change the number of nodes, then select **Update Scale**. 

   > [!IMPORTANT]
   > Only IoT Hub cluster scale-out (smaller-to-larger) is supported for preview. Scale-in (larger-to-smaller) will be supported in the General Availability (GA) version of IoT Hub.

   [![iot hub dashboard - capacity](media\iot-hub-rp-manage-capacity\dashboard-rp-iot-hub-capacity.png)](media\iot-hub-rp-manage-capacity\dashboard-rp-iot-hub-capacity.png#lightbox)

### Monitor alerts and quotas

Operators can also monitor the alerts and quotas:

1. Select **Alerts** to view the alert history.
 
   [![iot hub dashboard - alerts](media\iot-hub-rp-manage-capacity\dashboard-rp-iot-hub-alerts.png)](media\iot-hub-rp-manage-capacity\dashboard-rp-iot-hub-alerts.png#lightbox)  


2.	Select **Quotas** to see the list of quotas in effect.  

   > [!NOTE] 
   > The **Create** feature is disabled for preview, and a single default quota is provided which is unlimited. **Create** will be enabled for GA.  

   [![iot hub dashboard - quotas](media\iot-hub-rp-manage-capacity\dashboard-rp-iot-hub-quotas.png)](media\iot-hub-rp-manage-capacity\dashboard-rp-iot-hub-quotas.png#lightbox)  

## Next steps

For additional IoT Hub management features, see [How to manage IoT Hub on Azure Stack Hub](iot-hub-rp-manage.md).
