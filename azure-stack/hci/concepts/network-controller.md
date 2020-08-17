---
title: Plan to deploy the Network Controller
description: This topic covers how to plan to deploy the Network Controller via Windows Admin Center on a set of virtual machines (VMs) running the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: conceptual
ms.date: 08/17/2020
---

# Plan to deploy the Network Controller

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

This topic covers how to plan to deploy the Network Controller via Windows Admin Center on a set of virtual machines (VMs) running the Azure Stack HCI operating system. The Network Controller is a highly available and scalable server role that requires a minimum of three VMs to provide high availability on your network.

   >[!NOTE]
   > We recommend deploying the Network Controller on its own dedicated VMs.

## Network Controller requirements for Azure Stack HCI
The following is required to deploy the Network Controller:
- A VHD for the Azure Stack HCI OS to use to create the Network Controller VMs.
- A domain name and credentials to join the Network Controller VMs to a domain.
- A physical network configuration that matches one of the two following topologies.

    Windows Admin Center creates the configuration within the Hyper-V Host. However, the Management Network must be connected to the host physical adapters according to one of the following two options:

    **Option 1**: A single physical switch connects the Management Network to a physical management adapter on the host, as well as a trunk on the physical adapters that the virtual switch uses:

    :::image type="content" source="./media/network-controller/topology-option-1.png" alt-text="Option 1 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-1.png":::

    **Option 2**: If the Management Network is physically separated from the workload networks, then two virtual switches are required:

    :::image type="content" source="./media/network-controller/topology-option-2.png" alt-text="Option 2 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-1.png":::

- Management Network information that the Network Controller uses to communicate with Windows Admin Center and the Hyper-V hosts.
- Either DHCP-based or static network-based addressing for the Network Controller VMs.
- The Representational State Transfer (REST) fully qualified domain name (FQDN) for the Network Controller that the management clients use to communicate with the Network Controller.

   >[!NOTE]
   > Windows Admin Center currently does not support Network Controller authentication, either for communication with REST clients or communication between the Network Controller VMs.

## Configuration requirements
TBD



## Next steps
Now you’re ready to deploy the Network Controller on VMs running the Azure Stack HCI OS.

To learn more, see:
- [Create an Azure Stack HCI cluster](../deploy/create-cluster.md)

## See also
- [Network Controller](/windows-server/networking/sdn/technologies/network-controller/network-controller)
- [Network Controller High Availability](/windows-server/networking/sdn/technologies/network-controller/network-controller-high-availability)