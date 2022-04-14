---
title: Configure Azure Stack HCI OS - Single-Server 
description: This article describes Azure Stack HCI OS on a Single Server
author: robess
ms.author: robess
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 04/04/2022
---

# **Single-Server Configuration Steps**
> Applies to: Azure Stack HCI, version 21H2

The following sections will provide configuration steps, when installing Azure Stack HCI OS on a physical server/physical hardware or an Azure VM.
## Prerequisites

- Check if Active Directory and DNS are installed and accessible.
- Check if you have access to relevant domain credentials and password for adding a computer to the domain.
- Check if DHCP is installed and accessible (optional, if required).
    - If not DHCP, Static IP address/Default Gateway and DNS IP address/FQDN are known. (***I need clarity on this sentence***)
- [Download](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) Azure Stack HCI software.
- [Manual Deployment](/azure-stack/hci/deploy/operating-system#manual-deployment) Azure Stack HCI OS.
- [Install Windows Admin Center](https://docs.microsoft.com/windows-server/manage/windows-admin-center/deploy/install) (WAC).



## **Single-Server (On Physical Hardware)**

1. Configure 21H2 HCI server with SConfig.
    - If static configuration.
        - Configure IP addresses, default gateway, and DNS for management adapters.
    - **Enable RDP**.
    - Change computer name (if needed).
    - Change time zone (if needed).
    - **Add server to domain** (choose not to reboot).
    - **Add the domain user to local admins group**.
       - Net localgroup administrators **DOMAIN\USER/add**
    - **Install required features using SConfig**
        - exit to **PowerShell**, option 15.
        - *Install-WindowsFeature-NameHyper-V,Failover-Clustering,FS-Data-Deduplication,Bitlocker,Data-Center-Bridging,RSAT-AD-PowerShell,NetworkATC-IncludeAllSubFeature-IncludeManagementTools-Verbose*
    - **Install cumulative updates using SConfig**
        - Select **option 6**
        - Next select **option 1**
        - Then select **option 3**
        - Select **download install all quality or feature updates**.
    - Reboot.
2. Login with the domain user that is local admin.
3. You can rename NICs using the below example commands (**optional**, best practice) - ***I need further clarity on this***
    - *Rename-NetAdapter -Name "Ethernet" -NewName "MGMT-A"*
    - *Rename-NetAdapter -Name "Ethernet 2" -NewName "MGMT-B"*
4. Create and configure a vmSwitch.
    - *New-VMSwitch -name ExternalSwitch -NetAdapterName mgmt-a, mgmt-b -AllowManagementOS $true*.
    - Use Sconfig to configure (**optional**, if using DHCP you may not need to do this).
        - Configure network address, default gateway and DNS for vmSwitch.
5. Configure NetworkATC.
    - *Add-NetIntent -Name Management_Compute -Management -Compute -ComputerName localhost -AdapterName MGMT-A,MGMT-B*.
    - Configure management VLAN (**optional**).
        - *SetNetIntent -Name Management_Compute -ManagementVLAN 10*
    - Use Sconfig to configure (**optional**) - if using DHCP you may not need to do this.
        - *Configure network address, default gateway and DNS for vmSwitch*.
6. Create cluster.
    - *New-Cluster -Name ClusterName -Node NodeName.domain.com -StaticAddress "cluster IPAddress" –NOSTORAGE*.

> [!NOTE]
> If using DHCP, you can skip -StaticAddress "cluster IPAddress".

7. Enable S2D.
    - *Enable-ClusterS2D -verbose*.

8. Add server to Windows Admin Center (WAC) cluster manager and sever manager.

> [!TIP]
> It could take hours for DNS to propagate, adding the server with the IP address might be faster.

9. Register cluster to your subscription (Use WAC or PowerShell).
    - PowerShell
        - Download the module (if needed)
            - *Install-Module -Name Az.StackHCI*.
        - Use the register cmdlet to register with Azure (*-ResourceGroupName is optional*)
            - *Register-AzStackHCI -SubscriptionId "<subscription_ID>" -ComputerName Server1 -ResourceGroupNamecluster1-rg*.
    - WAC
        - [Register WAC with Azure](https://docs.microsoft.com/azure-stack/hci/manage/register-windows-admin-center).
        - [Register Azure Stack HCI with WAC](https://docs.microsoft.com/azure-stack/hci/deploy/register-with-azure#register-a-cluster-using-windows-admin-center).

10. You are now ready to create a volume and workload VM.
    - Create a Volume from PowerShell.
        - *New-Volume -FriendlyName "Volume1" -FileSystem CSVFS_ReFS -StoragePoolFriendlyName S2D -Size 1TB -ProvisioningType Thin14*.
    - Create a VM in WAC on Volume (***Need to clarity the steps here***)

