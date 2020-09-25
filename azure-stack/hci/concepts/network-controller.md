---
title: Plan to deploy the Network Controller
description: This topic covers how to plan to deploy the Network Controller via Windows Admin Center on a set of virtual machines (VMs) running the Azure Stack HCI operating system.
author: AnirbanPaul
ms.author: anpaul
ms.topic: conceptual
ms.date: 09/25/2020
---

# Plan to deploy the Network Controller

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019 

Planning to deploy the Network Controller via Windows Admin Center requires a set of virtual machines (VMs) running the Azure Stack HCI operating system. The Network Controller is a highly available and scalable server role that requires a minimum of three VMs to provide high availability on your network.

   >[!NOTE]
   > We recommend deploying the Network Controller on its own dedicated VMs.

## Network Controller requirements
The following is required to deploy the Network Controller:
- A VHD for the Azure Stack HCI operating system to create the Network Controller VMs.
- A domain name and credentials to join the Network Controller VMs to a domain.
- At least one virtual switch that you configure during the cluster creation process in Windows Admin Center.
- A physical network configuration that matches one of the topology options in this section.

    Windows Admin Center creates the configuration within the Hyper-V host. However, the management network must connect to the host physical adapters according to one of the following three options:

    **Option 1**: A single physical switch connects the management network to a physical management adapter on the host, and a trunk on the physical adapters that the virtual switch uses. This option uses a single virtual switch for both compute and storage:

    :::image type="content" source="./media/network-controller/topology-option-1.png" alt-text="Option 1 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-1.png":::

    **Option 2**: The management network is physically separated from the workload networks. This option uses a single virtual switch for compute only:

    :::image type="content" source="./media/network-controller/topology-option-2.png" alt-text="Option 2 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-2.png":::

    **Option 3**: The management network is physically separated from the workload networks. This option uses two virtual switches, one for compute, and one for storage:

    :::image type="content" source="./media/network-controller/topology-option-3.png" alt-text="Option 3 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-3.png":::

- Management network information that the Network Controller uses to communicate with Windows Admin Center and the Hyper-V hosts.
- Either DHCP-based or static network-based addressing for the Network Controller VMs.
- The Representational State Transfer (REST) fully qualified domain name (FQDN) for the Network Controller that the management clients use to communicate with the Network Controller.

   >[!NOTE]
   > Windows Admin Center currently does not support Network Controller authentication, either for communication with REST clients or communication between the Network Controller VMs. You can use Kerberos-based authentication if you use PowerShell to deploy and manage it.

## Configuration requirements
You can deploy the Network Controller cluster nodes on either the same subnet or different subnets. If you plan to deploy the Network Controller cluster nodes on different subnets, you must provide the Network Controller REST DNS name during the deployment process.

To learn more, see [Configure dynamic DNS registration for Network Controller](/windows-server/networking/sdn/plan/installation-and-preparation-requirements-for-deploying-network-controller#step-3-configure-dynamic-dns-registration-for-network-controller).


## Next steps
Now you’re ready to deploy the Network Controller on VMs running the Azure Stack HCI operating system.

To learn more, see:
- [Create an Azure Stack HCI cluster](../deploy/create-cluster.md)

## See also
- [Network Controller](/windows-server/networking/sdn/technologies/network-controller/network-controller)
- [Network Controller High Availability](/windows-server/networking/sdn/technologies/network-controller/network-controller-high-availability)