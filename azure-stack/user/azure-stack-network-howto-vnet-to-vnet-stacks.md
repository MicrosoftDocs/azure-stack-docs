---
title: Establish Azure Stack Hub VNET to VNET connection with Fortinet FortiGate NVA 
description: Learn how to establish a VNET to VNET connection in Azure Stack Hub with Fortinet FortiGate NVA
author: sethmanheim

ms.topic: how-to
ms.date: 12/2/2020
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 12/2/2020

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---


# VNet to VNet connectivity between Azure Stack Hub instances with Fortinet FortiGate NVA

In this article, you'll connect a VNET in one Azure Stack Hub to a VNET in another Azure Stack Hub using Fortinet FortiGate NVA, a network virtual appliance.

This article addresses the current Azure Stack Hub limitation, which lets tenants set up only one VPN connection across two environments. Users will learn how to set up a custom gateway on a Linux virtual machine that will allow multiple VPN connections across different Azure Stack Hub. The procedure in this article deploys two VNETs with a FortiGate NVA in each VNET: one deployment per Azure Stack Hub environment. It also details the changes required to set up an IPSec VPN between the two VNETs. The steps in this article should be repeated for each VNET in each Azure Stack Hub. 

## Prerequisites

-  Access to an Azure Stack Hub integrated systems with available capacity to deploy the required compute, network, and resource requirements needed for this solution. 

    > [!NOTE]  
    > These instructions will **not** work with an Azure Stack Development Kit (ASDK) because of the network limitations in the ASDK. For more information, see [ASDK requirements and considerations](../asdk/asdk-deploy-considerations.md).

-  A network virtual appliance (NVA) solution downloaded and published to the Azure Stack Hub Marketplace. An NVA controls the flow of network traffic from a perimeter network to other networks or subnets. This procedure uses the Fortinet FortiGate Next-Generation Firewall Single VM Solution.

-  At least two available FortiGate license files to activate the FortiGate NVA. Information on how to get these licenses, see the Fortinet Document Library article [Registering and downloading your license](https://docs.fortinet.com/document/fortigate-public-cloud/6.2.0/azure-administration-guide/19071/registering-and-downloading-your-license).

    This procedure uses the [Single FortiGate-VM deployment](https://docs2.fortinet.com/document/fortigate-public-cloud/6.2.0/azure-administration-guide/632940/single-fortigate-vm-deployment). You can find steps on how to connect the FortiGate NVA to the Azure Stack Hub VNET to in your on-premises network.

    For more information on how to deploy the FortiGate solution in an active-passive (HA) set up, see the Fortinet Document Library article [HA for FortiGate-VM on Azure](https://docs2.fortinet.com/document/fortigate-public-cloud/6.2.0/azure-administration-guide/983245/ha-for-fortigate-vm-on-azure).

## Deployment parameters

The following table summarizes the parameters that are used in these deployments for reference:

### Deployment one: Forti1

| FortiGate Instance Name | Forti1 |
|-----------------------------------|---------------------------|
| BYOL License/Version | 6.0.3 |
| FortiGate administrative username | fortiadmin |
| Resource Group name | forti1-rg1 |
| Virtual network name | forti1vnet1 |
| VNET Address Space | 172.16.0.0/16* |
| Public VNET subnet name | forti1-PublicFacingSubnet |
| Public VNET address prefix | 172.16.0.0/24* |
| Inside VNET subnet name | forti1-InsideSubnet |
| Inside VNET subnet prefix | 172.16.1.0/24* |
| VM Size of FortiGate NVA | Standard F2s_v2 |
| Public IP address name | forti1-publicip1 |
| Public IP address type | Static |

### Deployment two: Forti2

| FortiGate Instance Name | Forti2 |
|-----------------------------------|---------------------------|
| BYOL License/Version | 6.0.3 |
| FortiGate administrative username | fortiadmin |
| Resource Group name | forti2-rg1 |
| Virtual network name | forti2vnet1 |
| VNET Address Space | 172.17.0.0/16* |
| Public VNET subnet name | forti2-PublicFacingSubnet |
| Public VNET address prefix | 172.17.0.0/24* |
| Inside VNET subnet name | Forti2-InsideSubnet |
| Inside VNET subnet prefix | 172.17.1.0/24* |
| VM Size of FortiGate NVA | Standard F2s_v2 |
| Public IP address name | Forti2-publicip1 |
| Public IP address type | Static |

> [!NOTE]
> \* Choose a different set of address spaces and subnet prefixes if the above overlap in any way with the on-premises network environment including the VIP Pool of either Azure Stack Hub. Also ensure that the address ranges do not overlap with one another.**

## Deploy the FortiGate NGFW Marketplace Items

Repeat these steps for both Azure Stack Hub environments. 

1. Open the Azure Stack Hub user portal. Be sure to use credentials that have at least Contributor rights to a subscription.

1. Select **Create a resource** and search for `FortiGate`.

    ![The screenshot shows a single line of results from the search for "fortigate". The name of the found item is "FortiGate NGFW - Single VM Deployment (BYOL)".](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image6.png)

1. Select the **FortiGate NGFW** and select the **Create**.

1. Complete **Basics** using the parameters from the [Deployment parameters](#deployment-parameters) table.

    Your form should contain the following information:

    ![The text boxes (such as Instance Name and BYOL License) of the Basics dialog box have been filled in with values from the Deployment Table.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image7.png)

1. Select **OK**.

1. Provide the virtual network, subnets, and VM size details from the [Deployment parameters](#deployment-parameters).

    If you wish to use different names and ranges, take care not to  use parameters that will conflict with the other VNET and FortiGate resources in the other Azure Stack Hub environment. This is especially true when setting the VNET IP range and subnet ranges within the VNET. Check that they don't overlap with the IP ranges for the other VNET you create.

1. Select **OK**.

1. Configure the public IP that will be used for the FortiGate NVA:

    ![The "Public IP address name" text box of the IP Assignment dialog box shows a value of "forti1-publicip1" (from the Deployment Table).](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image8.png)

1. Select **OK** and then Select **OK**.

1. Select **Create**.

The deployment will take about 10 minutes. You can now repeat the steps to create the other FortiGate NVA and VNET deployment in the other Azure Stack Hub environment.

## Configure routes (UDRs) for each VNET

Perform these steps for both deployments, forti1-rg1 and forti2-rg1.

1. Navigate to the forti1-rg1 Resource Group in the Azure Stack Hub portal.

    ![This is a screenshot of the list of resources in the forti1-rg1 resource group.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image9.png)

2. Select on the 'forti1-forti1-InsideSubnet-routes-xxxx' resource.

3. Select **Routes** under **Settings**.

    ![The screenshot shows the highlighted Routes item of Settings.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image10.png)

4. Delete the **to-Internet** Route.

    ![The screenshot shows the highlighted to-Internet route. There is a delete button.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image11.png)

5. Select **Yes**.

6. Select **Add**.

7. Name the **Route** `to-forti1` or `to-forti2`. Use your IP range if you are using a different IP range.

8. Enter:
    - forti1: `172.17.0.0/16`  
    - forti2: `172.16.0.0/16`  

    Use your IP range if you are using a different IP range.

9. Select **Virtual appliance** for the **Next hop type**.
    - forti1: `172.16.1.4`  
    - forti2: `172.17.0.4`  

    Use your IP range if you are using a different IP range.

    ![The Edit route dialog box for to-forti2 has text boxes with values. "Address prefix" is 172.17.0.0/16, "Next hop type" is "Virtual appliance", and "Next hop address" is 172.16.1.4.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image12.png)

10. Select **Save**.

Repeat the steps for each **InsideSubnet** route for each resource group.

## Activate the FortiGate NVAs and Configure an IPSec VPN connection on each NVA

 You will require a valid license file from Fortinet to activate each FortiGate NVA. The NVAs will **not** function until you have activated each NVA. For more information how to get a license file and steps to activate the NVA, see the Fortinet Document Library article [Registering and downloading your license](https://docs.fortinet.com/document/fortigate-public-cloud/6.2.0/azure-administration-guide/19071/registering-and-downloading-your-license).

Two license files will need to be acquired - one for each NVA.

## Create an IPSec VPN between the two NVAs

Once the NVAs have been activated, follow these steps to create an IPSec VPN between the two NVAs.

Following the below steps for both the forti1 NVA and forti2 NVA:

1. Get the assigned Public IP address by navigating to the fortiX VM Overview page:

    ![The forti1 overview page shows the resource group, status, and so on.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image13.png)

1. Copy the assigned IP address, open a browser, and paste the address into the address bar. Your browser may warn you that the security certificate is not trusted. Continue anyway.

1. Enter the FortiGate administrative user name and password you provided during the deployment.

    ![The screenshot is of the login screen, which has a Login button and text boxes for user name and password.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image14.png)

1. Select **System** > **Firmware**.

1. Select the box showing the latest firmware, for example, `FortiOS v6.2.0 build0866`.

    ![The screenshot for the "FortiOS v6.2.0 build0866" firmware has a link to release notes, and two buttons: "Backup config and upgrade", and "Upgrade".](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image15.png)

1. Select **Backup config and upgrade** and Continue when prompted.

1. The NVA updates its firmware to the latest build and reboots. The process takes about five minutes. Log back into the FortiGate web console.

1. Click **VPN** > **IPSec Wizard**.

1. Enter a name for the VPN, for example, `conn1` in the **VPN Creation Wizard**.

1. Select **This site is behind NAT**.

    ![The screenshot of the VPN Creation Wizard shows it to be on the first step, VPN Setup. The following values are selected: "Site to Site" for Template Type, "FortiGate" for Remote Device Type, and "This site is behind NAT" for NAT Configuration.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image16.png)

1. Select **Next**.

1. Enter the remote IP address of the on-premises VPN device to which you are going to connect.

1. Select **port1** as the **Outgoing Interface**.

1. Select **Pre-shared Key** and enter (and record) a pre-shared key. 

    > [!NOTE]  
    > You will need this key to set up the connection on the on-premises VPN device, that is, they must match *exactly*.

    ![The screenshot of the VPN Creation Wizard shows it to be on the second step, Authentication, and the selected values are highlighted.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image17.png)

1. Select **Next**.

1. Select **port2** for the **Local Interface**.

1. Enter the local subnet range:
    - forti1: 172.16.0.0/16
    - forti2: 172.17.0.0/16

    Use your IP range if you are using a different IP range.

1. Enter the appropriate Remote Subnet(s) that represent the on-premises network, which you will connect to through the on-premises VPN device.
    - forti1: 172.16.0.0/16
    - forti2: 172.17.0.0/16

    Use your IP range if you are using a different IP range.

    ![The screenshot of the VPN Creation Wizard shows it to be on the third step, Policy & Routing, showing the selected and entered values.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image18.png)

1. Select **Create**

1. Select **Network** > **Interfaces**.  

    ![The interface list shows two interfaces: port1, which has been configured, and port2, which hasn't. There are buttons to create, edit, and delete interfaces.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image19.png)

1. Double-click **port2**.

1. Choose **LAN** in the **Role** list and **DHCP** for the Addressing mode.

1. Select **OK**.

Repeat the steps for the other NVA.


## Bring Up All Phase 2 Selectors 

Once the above has been completed for **both** NVAs:

1.  On the forti2 FortiGate web console, select to **Monitor** > **IPsec Monitor**. 

    ![The monitor for VPN connection conn1 is listed. It is shown as being down, as is the corresponding Phase 2 Selector.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image20.png)

2.  Highlight `conn1` and select the **Bring Up** > **All Phase 2 Selectors**.

    ![The monitor and Phase 2 Selector are both shown as up.](./media/azure-stack-network-howto-vnet-to-vnet-stacks/image21.png)


## Test and validate connectivity

You should now be able to route in between each VNET via the FortiGate NVAs. To validate the connection, create an Azure Stack Hub VM in each VNET's InsideSubnet. Creating an Azure Stack Hub VM can be done via the portal, Azure CLI, or PowerShell. When creating the VMs:

-   The Azure Stack Hub VMs are placed on the **InsideSubnet** of each VNET.

-   You do **not** apply any NSGs to the VM upon creation (That is, remove the NSG that gets added by default if creating the VM from the portal.

-   Ensure that the VM firewall rules allow the communication you are going to use to test connectivity. For testing purposes, it is recommended to disable the firewall completely within the OS if at all possible.

## Next steps

[Differences and considerations for Azure Stack Hub networking](azure-stack-network-differences.md)  
[Offer a network solution in Azure Stack Hub with Fortinet FortiGate](../operator/azure-stack-network-solutions-enable.md)  
