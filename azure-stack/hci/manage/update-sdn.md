---
title: Update SDN infrastructure for Azure Stack HCI
description: Learn to update SDN infrastructure for Azure Stack HCI.
ms.topic: how-to
author: ManikaDhiman
ms.author: v-mandhiman
ms.reviewer: anpaul
ms.date: 10/22/2021
---

# Update SDN infrastructure for Azure Stack HCI

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022, Windows Server 2019

Software Defined Networking (SDN) infrastructure components include Network Controller and optionally, Software Load Balancers (SLBs), and SDN gateways that run on virtual machines (VMs).

When you update each component, you use any of the standard methods for installing Windows updates, and you also use Windows PowerShell. You can update the SDN infrastructure in any order, but we recommend that you update the Network Controller virtual machines (VMs) first.

Hyper-V hosts can be updated before or after updating the SDN infrastructure.

## Update Network Controller

Complete the following steps for updating the Network Controller:

1. On the first Network Controller VM, install all updates and restart the VM if required by the update. During restart, the Network Controller node goes down and then comes back up again. Upon restarting the VM, it may take a few minutes before it goes back to `Up` status.

1. Before updating the next Network Controller VM, ensure that the status of the node is `Up` by running the following PowerShell `Get-NetworkControllerNode` cmdlet:

    ~~~powershell
    PS C:\> get-networkcontrollernode

    Name            : NCNode1.contoso.com 
    Server          : NCNode1.Contoso.com 
    FaultDomain     : fd:/NCNode1.Contoso.com 
    RestInterface   : Ethernet 
    NodeCertificate : 
    Status          : Down 

    Name            : NCNode2.Contoso.com 
    Server          : NCNode2.contoso.com 
    FaultDomain     : fd:/ NCNode2.Contoso.com 
    RestInterface   : Ethernet 
    NodeCertificate : 
    Status          : Up 

    Name            : NCNode3.Contoso.com 
    Server          : NCNode3.Contoso.com 
    FaultDomain     : fd:/ NCNode3.Contoso.com 
    RestInterface   : Ethernet 
    NodeCertificate : 
    Status          : Up 
    ~~~

1. Complete Steps 1 and 2 for the other Network Controller VMs.

## Update Software Load Balancer

Install updates on each SLB VM one at a time to ensure continuous availability of the load balancer infrastructure.  

## Update SDN gateway

Install updates on each gateway VM one at a time. During the update, the VM may be unavailable or may need to be restarted. In this case, the active connections on that gateway are migrated to a standby gateway VM, if so configured. This will result in some downtime for the tenant connections as they are migrated to the standby gateway.

1. To minimize downtime, install updates on the redundant gateway VM first. If you have not configured any redundant gateway VMs, ignore this step. To find out whether a particular gateway VM is redundant or not, run the following command on a Network Controller VM:

    ~~~powershell
    (Get-NetworkControllerGateway -ConnectionUri <your_REST_URI_for_Network_Controller_deployment> -ResourceId <your_resource_ID_of_gateway>).Properties.State
    ~~~

    The state can be either `Active` or `Redundant`.

1. After a gateway is updated, ensure that the HealthState of the gateway is set to `Healthy` and the State is `Redundant` or `Active` before moving on to the next gateway. If there are no redundant gateways, ensure that the State is `Active` before moving to the next gateway.

    To check the `HealthState` status of a gateway VM, run the following PowerShell command on the Network Controller VM:  

    ~~~powershell
    (Get-NetworkControllerGateway -ConnectionUri <REST uri of the Network Controller deployment> -ResourceId <Resource ID of gateway>).Properties.HealthState
    ~~~

## Next steps

Learn more about SDN infrastructure. See [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md).