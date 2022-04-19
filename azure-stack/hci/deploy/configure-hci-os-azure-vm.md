---
title: Configure Azure Stack HCI OS - Azure VM
description: This article describes Azure Stack HCI OS on an Azure VM
author: robess
ms.author: robess
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 04/04/2022
---

# **Azure Stack HCI OS - Single-Server (Azure VM)**
> Applies to: Azure Stack HCI, version 21H2

The following sections will provide configuration steps, when installing Azure Stack HCI OS on an Azure VM.
## Prerequisites

- [Download](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) Azure Stack HCI software.
- [Install Windows Admin Center](https://docs.microsoft.com/windows-server/manage/windows-admin-center/deploy/install) (WAC).

## **Single-Server (on Azure VM)**
> [!TIP]
> You can have one VM as a host and one VM for WAC. If you don't want to use your corporate domains, you may need to configure a VM with Active Directory.

1. 
2. 
3. 
4. 
5. Configure Network ATC.
    - *Add-NetIntent -Name Management_Compute -Management -Compute -ComputerName localhost -AdapterName MGMT-A,MGMT-B*.
    - **Optional**, Configure management VLAN.
        - *SetNetIntent -Name Management_Compute -ManagementVLAN 10*
    - **Optional**, if using DHCP you may not need to do this.
        - *Configure network address, default gateway and DNS for vmSwitch*.
6. Create cluster.
    - *New-Cluster -Name ClusterName -Node NodeName.domain.com -StaticAddress "cluster IPAddress" –NOSTORAGE*.

> [!NOTE]
> If using DHCP, you can skip -StaticAddress "cluster IPAddress".

7. Enable S2D.
    - *Enable-ClusterS2D -verbose*.

8. Add server to Windows Admin Center (WAC) cluster manager and server manager.

> [!TIP]
> It could take hours for DNS to propagate, adding the server with the IP address might be faster.

9. Register cluster to your subscription (Use WAC or PowerShell).
    - PowerShell
        - Download the module (if needed)
            - *Install-Module -Name Az.StackHCI*.
        - Use the register cmdlet to register with Azure (*-ResourceGroupName is optional*)
            - *Register-AzStackHCI -SubscriptionId "<subscription_ID>" -ComputerName Server1 -ResourceGroupNamecluster1-rg*.
    - WAC
        - [Register WAC with Azure](../manage/register-windows-admin-center.md).
        - [Register Azure Stack HCI cluster with WAC](../deploy/register-with-azure.md#register-a-cluster-using-windows-admin-center).

11. - You are now ready to create a volume and workload VM, utilizing PowerShell or WAC.
    - **Create a Volume** from PowerShell.
        - *New-Volume -FriendlyName "Volume1" -FileSystem CSVFS_ReFS -StoragePoolFriendlyName S2D -Size 1TB -ProvisioningType Thin14*.
    - [Create a VM in WAC](../manage/vm.md#create-a-new-vm) on Volume1
