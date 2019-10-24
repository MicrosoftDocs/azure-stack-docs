---
title: How to extend the data center on Azure Stack | Microsoft Docs
description: Learn how to extend the datacenter on Azure Stack.
services: azure-stack
author: mattbriggs

ms.service: azure-stack
ms.topic: how-to
ms.date: 10/19/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 10/19/2019

# keywords:  X
# Intent: As an Azure Stack Operator, I want < what? > so that < why? >
---

# How to extend the data center on Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

This article provides Azure Stack storage infrastructure information to help you decide how to integrate Azure Stack into your existing networking environment. After providing a general discussion of extending your data center, the article presents two different scenarios. You can connect to a Windows file storage server. You can also connect to a Windows iSCSI server.

## Overview of extending storage to Azure Stack

The diagram depicts a scenario, where a single virtual machine, running a workload, connects to, and utilizes external (to the VM, and the Azure Stack itself) storage, for purposes of data reading/writing etc. For this article, you'll focus on simple retrieval of files, but you can expand this example for more complex scenarios, such as the remote storage of database files.

![Azure Stack extend storage](./media/azure-stack-network-howto-extend-datacenter/image1.png)

In the diagram, you'll see that the VM on the Azure Stack system has been deployed with multiple NICs. From both a redundancy, but also as a storage best practice, it's important to have multiple paths between target and destination. Where things become more complex, are where VMs in Azure Stack have both public and private IPs, just like in Azure. If the external storage needed to reach the VM, it can only do so via the public IP, as the Private IPs are primarily used within the Azure Stack systems, within vNets and the subnets. The external storage would not be able to communicate with the private IP space of the VM, unless it passes through a site-to-site VPN, to connect to the vNet itself. So, for this example, you'll focus on communication via the public IP space. One thing to notice with the public IP space in the graphic, is that there are 2 different public IP pool subnets. By default, Azure Stack requires just one pool for public IP address purposes, but something to consider, for redundant routing, may be to add a second. However it is not possible to select an IP address from a specific pool, so you may end up with VMs with public IPs from the same pool across multiple virtual network cards.

In this example, you can assume that the routing between the border devices and the external storage is taken care of, and traffic can traverse the network appropriately. For this example, it doesn't matter if the backbone is 1 GbE, 10 GbE, 25 GbE or even faster, however this would be important to consider as you plan for your integration, to address the performance needs of any applications accessing this external storage.

## Connect to a Windows Server file server storage

In this scenario, deploy and configure a Windows Server 2019 virtual machine on Azure Stack and prepare it to connect to an external file server, which can also run Windows Server 2019. Where appropriate, set key features such as SMB Multichannel, to optimize performance and connectivity between the VM and external storage.

### Deploy the Windows Server 2019 VM on Azure Stack

1.  From your **Azure Stack administrator portal**, assuming this system has been correctly registered and is connected to the marketplace, select **Marketplace Management,** then, assuming you don't already have a Windows Server 2019 image, select **Add from Azure** and then search for **Windows Server 2019**, adding the **Windows Server 2019 Datacenter** image.

    ![](./media/azure-stack-network-howto-extend-datacenter/image2.png)

    Downloading a Windows Server 2019 image may take some time.

2.  Once you have a Windows Server 2019 image in your Azure Stack environment, sign in to the Azure Stack user portal**.

3.  Once logged into the Azure Stack user portal, ensure you have a [subscription to an offer](https://docs.microsoft.com/azure-stack/operator/azure-stack-subscribe-plan-provision-vm?view=azs-1908), that lets you to provision IaaS resources (Compute, Storage, and Network).

4.  Once you have a subscription available, back on the **dashboard** in the Azure Stack user portal, select **Create a resource**, select **Compute** and then select the **Windows Server 2019 Datacenter gallery item**.

5.  On the **Basics** blade:

    a.  **Name**: VM001

    b.  **Username**: localadmin

    c.  **Password** and **Confirm password**: \<password of your choice>

    d.  **Subscription**: \<subscription of your choice, with compute/storage/network resources>

    e. **Resource group**: Create new: storagetesting

    f.  Then select **OK**

6.  On the **Choose a size** blade, select a **Standard_F8s_v2**.

7.  On the **Settings** blade, select the **Virtual network** and in the **Create virtual network** blade, adjust the address space to be **10.10.10.0/23** and update the Subnet address range to be **10.10.10.0/24** then select **OK**.

8.  Select the **Public IP address**, and in the **Create public IP address** blade, select the **Static**.

9.  From **Select public inbound ports**, select **RDP (3389)**.

10. Leave the other defaults and select **OK**.
    
    ![](./media/azure-stack-network-howto-extend-datacenter/image3.png)

11. Read the summary, wait for validation, then select **OK** to begin the deployment. The deployment should complete in around 10 minutes.

12. Once the deployment has completed, under **Resource** Select the virtual machine name, **VM001** to go to the *Overview* blade.
    
    ![](./media/azure-stack-network-howto-extend-datacenter/image4.png)

13. Under DNS name, select **Configure** and provide a DNS name label, **vm001** and select **Save**, then select **VM001** in the breadcrumb to return to the *Overview* blade.

14. On the right-hand side of the overview blade, select **storagetesting-vnet/default** under the Virtual network/subnet text.

15. Within the storagetesting-vnet blade, select **Subnets** then **+Subnet**, then in the new Add Subnet blade, enter the following information: 

    a.  **Name**: subnet2

    b.  **Address range (CIDR block)**: 10.10.11.0/24

    c. **Network Security Group**: None

    d.  **Route table**: None

    e. Select **OK**:

16. Once saved, select **VM001** in the breadcrumb to return to the overview blade.

17. Select **Networking**.

18. Select **Attach network interface** and then select **Create network interface**.

19. On the **Create network interface** blade:

    a.  **Name**: vm001nic2

    b.  **Subnet**: Ensure subnet is 10.10.11.0/24

    c. **Network security group**: VM001-nsg

    d.  **Resource group**: storagetesting

20. Once successfully created, select **VM001** in the breadcrumb and select **Stop** to shut down the VM.

21. Once the VM stops (deallocated), select **Networking**, select **Attach network interface** and then select **vm001nic2**, then select **OK**. You will add additional NIC to the VM in a few moments.

22. While on the **Networking** blade, select the **vm001nic2** tab, then select **Network Interface:vm001nic2**.

23. On the vm001nic interface blade, select **IP configurations**, and in the center of the blade, select **ipconfig1**.

24. On the ipconfig1 settings blade, select **Enabled** for Public IP address and select **Configure required settings**, **Create new,** and enter vm001nic2pip for the name, select **Static** and select **OK** then **Save**.

25. Once successfully saved, return to the VM001 overview blade, and select **Start** to start your configured Windows Server 2019 VM.

### Configure the Windows Server 2019 file server storage

For this first example, you're validating a configuration where the Windows Server 2019 file server is a virtual machine running on Hyper-V. This virtual machine will be configured with eight virtual processors, a single VHDX file, and most importantly, two virtual network adapters. In an ideal scenario, these network adapters will have different routable subnets, but in this test, they will have network adapters on the same subnet.

![](./media/azure-stack-network-howto-extend-datacenter/image5.png)

For your file server, it could be Windows Server 2016 or 2019, physical or virtual, running on Hyper-V, VMware, or an alternative platform of your choice. The key focus here, is connectivity into and out of the Azure Stack system, however having multiple paths between the source and destination is preferably, as it provides additional redundancy, and allows the use of more advanced capabilities to drive increased performance, such as SMB Multichannel.

Update your file server with the latest cumulative updates and fixes, rebooting before proceeding with the configuration of file shares.

Once updated and rebooted, you can now configure this server as a file server.

1) On your file server machine, run **ipconfig /all** from **CMD** and make a note of the **DNS Server** your file server is using.

2)  Open **Server Manager** and select **Manage**, then **Add Roles and Features**.

3)  Select **Next**, select **Role-based or feature-based installation**, and advance through the selections until you reach the **Select server roles** page.

4)  Expand **File and Storage Services**, expand **File & iSCSI Services** and tick the **File Server** box. Once completed, close **Server Manager**.

5)  Reopen **Server Manager** and select **File and Storage Services**.

6)  Select **Shares**.

7)  In the **Shares box**, select **To create a file share, start the New Share Wizard** link.

8)  In the **New Share Wizard** box, select **SMB Share – Quick**, then select **Next**, and advance through the wizard, selecting the **C:\\\\ Volume**.

9)  Give the share a name, **TestStorage** then select **Next**.

10) Back in the **New Share Wizard**, select **Next** and then **Create**, then **Close**.

You have now created your file share on your file server.

### Testing file storage performance and connectivity

To check communication and run some rudimentary tests, log back into the Azure Stack user portal on your **Azure Stack** system and navigate to the **overview** blade for **VM001**.

1)  Select **Connect** to establish an RDP connection into VM001.

2)  In order to communicate via Hostname, you're going to edit the **Hosts** file; however, in a production environment, DNS would be optimally configured such that names would automatically resolve. You could also use IP addresses. For our example, though, you'll edit the **Hosts** file.

3)  Open **Notepad**, making sure you **Run as Administrator**.

4)  Once you have Notepad open, select **File**, **Open** and browse to c:\\Windows\System32\Drivers\etc\, and select **All Files** in the bottom-right corner of the open dialog box. Select the **hosts** file and select **Open**.

5)  Edit your hosts file, by adding an IP address and DNS name for your file server.

    ![](./media/azure-stack-network-howto-extend-datacenter/image6.png)

6)  Save the file, and close Notepad.

7)  Open **CMD** and ping the name of the file server that you entered in the hosts file. This should return the IP address of one of the network adapters on the file server, so manually test the communication to the other adapter, by pinging the IP address.

## Connect to a Windows Server iSCSI Target Server

In this scenario, you will deploy and configure a Windows Server 2019 virtual machine on Azure Stack and prepare it to connect to an external iSCSI Target Server, which will also be running Windows Server 2019.

> [!Note]  
> If you have already completed scenario one, skip ahead to customize your machines.

### Deploy the Windows Server 2019 VM on Azure Stack

If you haven't already deployed the Windows Server 2019 VM on Azure Stack, please follow the steps at [Deploy the Windows Server 2019 VM on Azure Stack](#deploy-the-windows-server-2019-vm-on-azure-stack). Then you can configure the Windows Server 2019 iSCSI target.

### Configure the Windows Server 2019 iSCSI target

For the purpose of this second scenario, validate a configuration where the Windows Server 2019 iSCSI Target is a virtual machine running on Hyper-V. This virtual machine will be configured with eight virtual processors, a single VHDX file, and most importantly, two virtual network adapters. In an ideal scenario, these network adapters will have different routable subnets, but in this test, you'll have network adapters on the same subnet.

![](./media/azure-stack-network-howto-extend-datacenter/image5.png)

For your iSCSI Target, it could be Windows Server 2016 or 2019, physical or virtual, running on Hyper-V, VMware, or an alternative platform of your choice. The key focus here, is connectivity into and out of the Azure Stack system, however having multiple paths between the source and destination is preferably, as it provides additional redundancy and throughput.

Update your file server with the latest cumulative updates and fixes, rebooting before proceeding with the configuration of the iSCSI Target Server.

Once updated and rebooted, you can now configure this server as an iSCSI Target Server.

## Next Steps

[Differences and considerations for Azure Stack networking](azure-stack-network-differences.md)  