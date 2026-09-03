---
title: How to extend the datacenter on Azure Stack Hub
description: Learn how to extend storage to Azure Stack Hub using Windows Server iSCSI Targets. Follow step-by-step guidance to connect on-premises storage to your workloads.
author: sethmanheim

ms.topic: how-to
ms.date: 07/08/2026
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 12/2/2020
ms.custom: sfi-image-nochange

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---


# Extending storage to Azure Stack Hub

This article provides Azure Stack Hub storage infrastructure information to help you decide how to integrate Azure Stack Hub into your existing networking environment. After providing a general discussion of extending your datacenter, the article presents two different scenarios. You can connect to a Windows file storage server. You can also connect to a Windows iSCSI server.

## Overview of extending storage to Azure Stack Hub

There are scenarios where having your data located in the public cloud isn't enough. Perhaps you have a compute-intensive virtualized database workload that's sensitive to latencies, and the round-trip time to the public cloud could affect performance of the database workload. Perhaps there's data on-premises, held on a file server, NAS, or iSCSI storage array, which needs to be accessed by on-premises workloads, and needs to reside on-premises to meet regulatory or compliance goals. These scenarios show why having data reside on-premises remains important for many organizations.

So, why not just host that data in storage accounts on Azure, or inside virtualized file servers, running on the Azure Stack Hub system? Well, unlike in Azure, Azure Stack Hub storage is finite. The capacity you have available for your usage depends entirely on the per-node capacity you choose to purchase, in addition to the number of nodes you have. And because Azure Stack Hub is a hyper-converged solution, if you wish to grow your storage capacity to meet usage demands, you also need to grow your compute footprint through the addition of nodes. This requirement can be potentially cost prohibitive, especially if the need for extra capacity is for cold, archival storage that could be added for low cost outside of the Azure Stack Hub system.

This requirement brings you to the scenario that you cover in the next section. How can you connect Azure Stack Hub systems, virtualized workloads running on the Azure Stack Hub, simply and efficiently, to storage systems outside of the Azure Stack Hub, accessible via the network?

### Design for extending storage

The following diagram depicts a scenario where a single virtual machine running a workload connects to and utilizes external storage (to the VM, and the Azure Stack Hub itself) for purposes of data reading and writing. For this article, you focus on simple retrieval of files, but you can expand this example for more complex scenarios, such as the remote storage of database files.

:::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/azure-stack-network-howto-extend-datacenter-image1.svg" alt-text="Diagram shows a workload VM,which has two NICs, each with both a public and a private IP address, on the Azure Stack Hub system that accesses external storage.":::

In the diagram, you see that the VM on the Azure Stack Hub system is deployed with multiple NICs. From both a redundancy, but also a storage best practice, it's important to have multiple paths between target and destination. Where things become more complex, are where VMs in Azure Stack Hub have both public and private IPs, just like in Azure. If the external storage needs to reach the VM, it can only do so via the public IP, as the private IPs are primarily used within the Azure Stack Hub systems, within vNets and the subnets. The external storage can't communicate with the private IP space of the VM, unless it passes through a site-to-site VPN, to punch into the vNet itself. So, for this example, focus on communication via the public IP space. One thing to notice with the public IP space in the diagram, is that there are two different public IP pool subnets. By default, Azure Stack Hub requires just one pool for public IP address purposes, but something to consider, for redundant routing, is to add a second. However, at this time, it isn't possible to select an IP address from a specific pool, so you might indeed end up with VMs with public IPs from the same pool across multiple virtual network cards.

For the purposes of this discussion, assume that the routing between the border devices and the external storage is taken care of, and traffic can traverse the network appropriately. For this example, it doesn't matter if the backbone is 1 GbE, 10 GbE, 25 GbE, or even faster. However, this choice would be important to consider as you plan for your integration, to address the performance needs of any applications accessing this external storage.

## Connect to a Windows Server iSCSI Target

In this scenario, you deploy and configure a Windows Server 2019 virtual machine on Azure Stack Hub and prepare it to connect to an external iSCSI Target, which also runs Windows Server 2019. Where appropriate, you enable key features such as MPIO, to optimize performance and connectivity between the VM and external storage.

### Deploy the Windows Server 2019 VM on Azure Stack Hub

1.  From your **Azure Stack Hub administration portal**, assuming you register the system correctly and connect it to the marketplace, select **Marketplace Management**. If you don't already have a Windows Server 2019 image, select **Add from Azure** and then search for Windows Server 2019. Add the Windows Server 2019 Datacenter image.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image2.png" alt-text="Screenshot that shows the Dashboard > Marketplace management - Marketplace items > Add from Azure dialog box with windows server 2019 in the search box and a list of items whose name contains that string.":::

    Downloading a Windows Server 2019 image can take some time.

1.  After you add a Windows Server 2019 image to your Azure Stack Hub environment, **sign in to the Azure Stack Hub user portal**.

1.  After you sign in to the Azure Stack Hub user portal, ensure you have a [subscription to an offer](../operator/azure-stack-subscribe-plan-provision-vm.md) that allows you to provision IaaS resources (Compute, Storage, and Network).

1.  After you get a subscription, back on the **dashboard** in the Azure Stack Hub user portal, select **Create a resource**, select **Compute**, and then select the Windows Server 2019 Datacenter gallery item.

1.  On the **Basics** blade, enter the following information:

    -  **Name**: VM001

    -  **Username**: localadmin

    -  **Password** and **Confirm password**: \<password of your choice>

    -  **Subscription**: \<subscription of your choice, with compute/storage/network resources>.

    -  **Resource group**: storagetesting (create new)

    -  Select **OK**

1.  On the **Choose a size** blade, select a **Standard_F8s_v2** and select **Select**.

1.  On the **Settings** blade, select the **Virtual network**. In the **Create virtual network** blade, set the address space to **10.10.10.0/23** and update the Subnet address range to **10.10.10.0/24**. Select **OK**.

1.  Select the **Public IP address**. In the **Create public IP address** blade, select the **Static** radio button.

1.  On the **Select public inbound ports** dropdown, select **RDP (3389)**.

1. Leave the other defaults and select **OK**.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image3.png" alt-text="Screenshot that shows the Dashboard > New > Create virtual machine > Summary dialog box that states Validation passed and displays information about VM001.":::

1. Read the summary, wait for validation, and then select **OK** to begin the deployment. The deployment should complete in about 10 minutes.

1. After the deployment completes, under **Resource** select the virtual machine name, **VM001** to open **Overview**.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image4.png" alt-text="Screenshot of the Overview screen shows information about VM001.":::

1. Under DNS name, select **Configure** and provide a DNS name label, **vm001** and select **Save**, then select **VM001**.

1. On the right-hand side of the overview blade, select **storagetesting-vnet/default** under the Virtual network/subnet text.

1. Within the **storagetesting-vnet** blade, select **Subnets** and then **+Subnet**. In the new **Add Subnet** blade, enter the following information, and then select **OK**:

    -  **Name**: subnet2

    -  **Address range (CIDR block)**: 10.10.11.0/24

    -  **Network Security Group**: None

    -  **Route table**: None

1. After saving, select **VM001**.

1. From the left side of the overview, select **Networking**.

1. Select **Attach network interface**, and then select **Create network interface**.

1. On **Create network interface**, enter the following information:

    - **Name**: vm001nic2

    - **Subnet**: Ensure subnet is 10.10.11.0/24

    - **Network security group**: VM001-nsg

    - **Resource group**: storagetesting

1. After you attach the network interface, select **VM001** and select **Stop** to shut down the VM.

1. After the VM is stopped (deallocated), on the left side of the overview, select **Networking**, select **Attach network interface**, and then select **vm001nic2**. Select **OK**. The additional NIC is added to the VM in a few moments.

1. Still on the **Networking** blade, select the **vm001nic2** tab, and then select **Network Interface:vm001nic2**.

1. On the vm001nic interface blade, select **IP configurations**, and in the center of the blade, select **ipconfig1**.

1. On the ipconfig1 settings blade, select **Enabled** for Public IP address and select **Configure required settings**. Select **Create new**, enter vm001nic2pip for the name, select **Static**, and select **OK**. Select **Save**.

1. After you save the settings, return to the VM001 overview, and select **Start** to start your configured Windows Server 2019 VM.

1. After the VM starts, **establish an RDP session** into the VM001.

1. After you connect inside the VM, open **CMD** (as administrator) and enter **hostname** to retrieve the computer name of the OS. **It should match VM001**. Make a note of this name for later.

### Configure second network adapter on Windows Server 2019 VM on Azure Stack Hub

By default, Azure Stack Hub assigns a default gateway to the first (primary) network interface attached to the virtual machine. Azure Stack Hub doesn't assign a default gateway to additional (secondary) network interfaces attached to a virtual machine. Therefore, you can't communicate with resources outside the subnet that a secondary network interface is in, by default. However, secondary network interfaces can communicate with resources outside their subnet, though the steps to enable communication are different for different operating systems.

1.  If you don't already have a connection open, establish an RDP connection into **VM001**.

1.  Open **CMD** as administrator and run **route print** which should return the two interfaces (Hyper-V Network Adapters) inside this VM.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image5.png" alt-text="Screenshot that shows that the route print output is an interface list that includes two Hyper-V network adapters: Interface 6 is Hyper-V network adapter #2, and Interface 7 is adapter #3.":::

1.  Run **ipconfig** to see which IP address is assigned to the secondary network interface. In this example, 10.10.11.4 is assigned to interface 6. No default gateway address is returned for the secondary network interface.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image6.png" alt-text="Screenshot that shows that the partial ipconfig listing shows that Ethernet adapter Ethernet 2 has IPv4 address 10.10.11.4.":::

1.  To route all traffic destined for addresses outside the subnet of the secondary network interface to the gateway for the subnet, run the following command from the **CMD:**.

    ```CMD  
    route add -p 0.0.0.0 MASK 0.0.0.0 <ipaddress> METRIC 5015 IF <interface>
    ```

    The `<ipaddress>` is the .1 address of the current subnet, and `<interface>` is the interface number.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image7.png" alt-text="Screenshot that shows that the route add command is issued with ipaddress value 10.10.11.1, and interface number 6.":::

1.  To confirm the added route is in the route table, enter the **route print** command.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image8.png" alt-text="Screenshot that shows that the added route is shown as a Persistent Route with Gateway Address 10.10.11.1 and Metric 5015.":::

1.  You can also validate outbound communication by running a ping command:  
    `ping 8.8.8.8 -S 10.10.11.4`  
    The `-S` flag allows you to specify a source address, in this case, 10.10.11.4 is the IP address of the NIC that now has a default gateway.

1.  Close **CMD**.

### Configure the Windows Server 2019 iSCSI Target

In this scenario, you validate a configuration where the Windows Server 2019 iSCSI Target is a virtual machine running on Hyper-V, outside of the Azure Stack Hub environment. You configure this virtual machine with eight virtual processors, a single VHDX file, and most importantly, two virtual network adapters. In an ideal scenario, these network adapters have different routable subnets, but in this validation, they have network adapters on the same subnet.

:::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image9.png" alt-text="Screenshot that shows the partial ipconfig command output with two Ethernet adapters on the same subnet.":::

For your iSCSI Target server, you can use Windows Server 2016 or Windows Server 2019, physical or virtual, running on Hyper-V, VMware, or an alternative appliance of your choice, such as a dedicated physical iSCSI SAN. The key focus is connectivity into and out of the Azure Stack Hub system. However, having multiple paths between the source and destination is preferable, as it provides additional redundancy, and it allows the use of more advanced capabilities to drive increased performance, such as MPIO.

Update your Windows Server 2019 iSCSI Target with the latest cumulative updates and fixes, and reboot if necessary, before proceeding with the configuration of file shares.

After updating and rebooting, you can now configure this server as an iSCSI Target.

1.  Open **Server Manager** and select **Manage**, and then select **Add Roles and Features**.

1.  Once opened, select **Next**, select **Role-based or feature-based installation**, and proceed through the selections until you reach the **Select server roles** page.

1.  Expand **File and Storage Services**, expand **File & iSCSI Services**, and select the **iSCSI Target Server** box. Accept any popup prompts to add new features, and then proceed through to completion.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image10.png" alt-text="Screenshot that shows the Confirmation page of the Add Roles and Features Wizard, titled Confirm installation selections.":::

    Once completed, close **Server Manager.**

1.  Open File Explorer, go to C:\\ and **create a new folder** named **iSCSI**.

1.  Reopen **Server Manager** and select **File and Storage Services** from the left-hand menu.

1.  Select **iSCSI** and select the "**To create an iSCSI virtual disk, start the New iSCSI Virtual Disk Wizard**" link on the right pane. A dialog box opens.

1.  On the **Select iSCSI virtual disk location** page, select the radio button for **Type a custom path** and browse to your **C:\\iSCSI** and select **Next**.

1.  Enter **iSCSIdisk1** as the name for the iSCSI virtual disk and optionally, add a description, and then select **Next**.

1.  Set the size of the virtual disk to **10GB**, select **Fixed size**, and select **Next**.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image11.png" alt-text="Screenshot that shows the iSCSI Virtual Disk Size page of the New iSCSI Virtual Disk Wizard, which specifies a fixed size of 10GB, and the Clear the virtual disk on allocation option is checked.":::

1.  Since this is a new target, select **New iSCSI target** and select **Next**.

1.  On the **Specify target name** page, enter **TARGET1** and select **Next**.

1.  On the **Specify access servers** page, select **Add**. This step opens a dialog to enter specific **initiators** that are authorized to connect to the iSCSI Target.

1.  In the **Add initiator ID window**, select **Enter a value for the selected type** and under **Type** ensure IQN is selected in the drop-down menu. Enter **iqn.1991-05.com.microsoft:\<computername>** where \<computername> is the **computer name** of **VM001** and then select **Next**.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image12.png" alt-text="Screenshot that shows the Add initiator ID window with the values to specify the initiator ID.":::

1.  On the **Enable Authentication** page, leave the boxes blank, and then select **Next**.

1.  Confirm your selections and select **Create**, and then close. You should see your iSCSI virtual disk created in Server Manager.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image13.png" alt-text="Screenshot that shows that the Results page of the New iSCSI Virtual Disk Wizard shows that creation of the ISCSI virtual disk succeeded.":::

### Configure the Windows Server 2019 iSCSI Initiator and MPIO

To set up the iSCSI Initiator, first, sign in to the **Azure Stack Hub user portal** on your **Azure Stack Hub system** and go to the **overview** page for **VM001**.

1.  Establish an RDP connection to VM001. Once connected, open **Server Manager**.

1.  Select **Add roles and features**, and accept the defaults until you reach the **Features** page.

1.  On the **Features** page, add **Multipath I/O** and select **Next**.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image14.png" alt-text="Screenshot that shows the Features page of the Add Roles and Features Wizard with one feature, Multipath I/O, selected.":::

1.  Select the **Restart the destination server automatically if required** box and select **Install**, and then select **Close**. A reboot is most likely required, so once completed, reconnect to VM001.

1.  Back in **Server Manager**, wait for the **MPIO install to complete**, select **close**, and then select **Tools** and select **MPIO**.

1.  Select the **Discover Multi-Paths** tab, and select the box to **Add support for iSCSI devices** and select **Add**, and then select **Yes** to **reboot** VM001. If you don't receive a window, select **OK**, and then reboot manually.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image15.png" alt-text="Screenshot that shows the Discover Multi-Paths page of the MPIO dialog box with the Add Support for iSCSI devices option checked.":::

1.  Once rebooted, establish a **new RDP connection to VM001**.

1.  Once connected, open **Server Manager**, select **Tools** and select **iSCSI Initiator**.

1.  When a Microsoft iSCSI window pops up, select **Yes** to allow the iSCSI service to run by default.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image16.png" alt-text="Screenshot that shows that the Microsoft iSCSI dialog box reports that the iSCSI service is not running.":::

1. In the iSCSI Initiator properties window, select the **Discovery** tab.

1.  You add two targets, so first select the **Discover Portal** button.

1.  Enter the first IP address of your iSCSI Target server, and select **Advanced**.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image17.png" alt-text="Screenshot that shows the Discover Target Portal window with 10.33.131.15 in the IP address or DNS name: text box, and 3260 (the default) in the Port text box.":::

1.  In the **Advanced Settings** window, select the following, and then select **OK**.

    -  **Local adapter**: Microsoft iSCSI Initiator.

    -  **Initiator IP**: 10.10.10.4.

1.  Back in the **Discover Target Portal** window, select **OK**.

1.  Repeat the process with the following values:

    -  **IP address**: Your second iSCSI Target IP address.

    -  **Local adapter**: Microsoft iSCSI Initiator.

    -  **Initiator IP**: 10.10.11.4.

1.  Your target portals should look like this, with your own iSCSI Target IPs under the **Address** column.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image18.png" alt-text="Screenshot that shows the Target portals dialog box with the two portals that have just been created.":::

1.  Back on the **Targets** tab, select your iSCSI Target from the middle of the window, and select **Connect**.

1.  In the **Connect to target** window, select the **Enable multi-path** box, and select **Advanced**.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image19.png" alt-text="Screenshot that shows the Connect to target dialog box with the specified values.":::

1.  Enter the following information and select **OK**. In the **Connect to Target** window, select **OK**.

    - **Local adapter**: Microsoft iSCSI Initiator.
    - **Initiator IP**: 10.10.10.4.
    - **Target portal IP**: \<your first iSCSI Target IP / 3260>.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image20.png" alt-text="Screenshot that shows the Connect using dialog box with the specified information for target portal 10.33.131.15/3260.":::

1.  Repeat the process for the second initiator and target combination.

    - **Local adapter**: Microsoft iSCSI Initiator.
    - **Initiator IP**: 10.10.11.4.
    - **Target portal IP**: \<your second iSCSI Target IP / 3260>.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image21.png" alt-text="The Connect using dialog box shows the specified information for target portal 10.33.131.16/3260.":::

1.  Select the **Volumes and Devices** tab, and then select **Auto Configure**. You see an MPIO volume presented:

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image22.png" alt-text="Screenshot that shows the Volume List window with volume name, mount point, and device for a single volume.":::

1.  Back on the **Targets** tab, select **Devices** and you see two connections to the single iSCSI VHD you created earlier.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image23.png" alt-text="Screenshot that shows that the Devices dialog box shows Disk 2 listed on two lines with the target is 0 on the first line, 1 on the second.":::

1.  Select the **MPIO** button to see more information about the load-balancing policy and paths.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image24.png" alt-text="Screenshot that shows that the MPIO page of the Devices Details dialog box shows Round Robin for the Load balance policy, and lists two devices.":::

1.  Select **OK** three times to exit the windows and the iSCSI Initiator.

1.  Open Disk Management (diskmgmt.msc) and you're prompted with an **Initialize Disk** window.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image25.png" alt-text="Screenshot that shows the Initialize Disk dialog box with Disk 2 checked, and MBR (Master Boot Record) selected as the partition style. There is an OK button.":::

1.  Select **OK** to accept the defaults. Then scroll down to the new disk, right-click, and select **New Simple Volume**.

1.  Walk through the wizard, accepting the defaults. Change the Volume label to **iSCSIdisk1** and then select **Finish**.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image26.png" alt-text="Screenshot that shows that the New Simple Volume Wizard dialog box shows that the volume is to be NTFS with a default allocation unit size and a volume label of 'iSCSIdisk1'.":::

1.  The drive is then formatted and presented with a drive letter.

1. Open File Explorer and select **This PC** to see your new drive attached to VM001.

### Testing external storage connectivity

To validate communication and run a rudimentary file copy test, first, sign in to the **Azure Stack Hub user portal** on your **Azure Stack Hub system** and go to the **overview** page for **VM001**.

1.  Select **Connect** to establish an RDP connection to **VM001**.

1.  Open **Task Manager**, select the **Performance** tab, and then snap the window to the right-hand side of the RDP session.

1.  Open **Windows PowerShell ISE** as administrator and snap it to the left-hand side of the RDP session. On the right-hand side of the ISE, close the **Commands** pane, and select the **Script** button, to expand the white script pane at the top of the ISE window.

1.  In this VM, there are no native PowerShell modules to create a VHD, which you use as a large file to test the file transfer to the iSCSI Target. In this case, run DiskPart to create a VHD file. In the ISE, run the following steps:

    1. `Start-Process Diskpart`

    1. A new CMD window opens. Enter the following command:  

       `Create vdisk file="c:\\test.vhd" type=fixed maximum=5120`
    
       :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image27.png" alt-text="Screenshot of the CMD window shows that the specified command was issued to DiskPart which completed it successfully, creating the virtual disk file.":::
    
    1. This process takes a few moments. When it's done, open **File Explorer** and go to C:\ - you see the new test.vhd file, and a size of 5 GB.

       :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image28.png" alt-text="Screenshot that shows that the file test.vhd appears within C:\, as expected, and is the specified size.":::

    1. Close the CMD window, and return to the ISE. Enter the following command in the script window. Replace F:\\ with the iSCSI Target drive letter that you applied earlier.

       `Copy-Item "C:\\test.vhd" -Destination "F:\\"`

    1. Select the line in the script window, and press F8 to run.

    1. While the command is running, watch the two network adapters and see the transfer of data taking place across both network adapters in VM001. You should also notice that each network adapter shares the load evenly.

    :::image type="content" source="./media/azure-stack-network-howto-extend-datacenter/image29.png" alt-text="Screenshot that shows that both adapters show a load of 2.6 Mbps.":::

This scenario highlights the connectivity between a workload running on Azure Stack Hub, and an external storage array, in this case, a Windows Server-based iSCSI Target. This scenario isn't designed to be a performance test, nor be reflective of the steps you'd need to perform if you were using an alternative iSCSI-based appliance. However, it does highlight some of the core considerations you'd make when deploying workloads on Azure Stack Hub, and connecting them to storage systems outside of the Azure Stack Hub environment.

## Next steps

[Differences and considerations for Azure Stack Hub networking](azure-stack-network-differences.md)
