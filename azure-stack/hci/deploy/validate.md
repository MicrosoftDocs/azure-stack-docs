---
title: Validate an Azure Stack HCI cluster
description: This how-to article focuses on why cluster validation is important, and when to run it on an existing Azure Stack HCI cluster. The article includes specific validation scenarios for troubleshooting an updated server cluster.
author: JohnCobb1
ms.author: v-johcob
ms.topic: article
ms.date: 4/24/2020
---

# Validate an Azure Stack HCI cluster

>Applies to: Azure Stack HCI

This how-to article focuses on why cluster validation is important, and when to run it on an existing Azure Stack HCI cluster. We recommend performing cluster validation for the following primary scenarios:
- After deploying a server cluster, run the Validate-DCB tool to test networking, and use the Validate feature in Windows Admin Center.
- After updating a server cluster, depending on your scenario, run both validation options to troubleshoot cluster issues.

To learn about how to create a failover cluster, see [Create a failover cluster](/windows-server/failover-clustering/create-failover-cluster#create-the-failover-cluster).

## What is cluster validation?
Cluster validation is intended to catch hardware or configuration problems before a cluster goes into production. Cluster validation helps to ensure that the Azure Stack HCI solution that you're about to deploy is truly dependable. You can also use cluster validation on configured failover clusters as a diagnostic tool.

You can use Storage Spaces Direct to perform cluster validation prior to creating your server cluster.
To learn more, see [Step 3.2: Validate the cluster](/windows-server/storage/storage-spaces/deploy-storage-spaces-direct#step-32-validate-the-cluster) of the Deploy Storage Spaces Direct topic.

## Specific validation scenarios
This section describes scenarios in which validation is also needed or useful.

- **Validation before the cluster is configured:**
  - **A set of servers ready to become a failover cluster:** This is the most straightforward validation scenario. The hardware components (systems, networks, and storage) are connected, but the systems aren't yet functioning as a cluster. Running tests in this situation has no affect on availability.

  - **Cloned or imaged systems:** If you clone or image systems to different hardware, run the Validate cluster feature as you would with any other new cluster. We recommend to run the Validate cluster feature just after connecting the hardware components and installing the failover cluster feature, before clients start using the cluster.
 
  - **Server VMs:** For virtualized servers in a cluster, run the Validate cluster feature as you would on any other new cluster. The requirement to run the feature is the same whether you have:
    - A "host cluster" where failover occurs between two physical computers.
    - A "guest cluster" where failover occurs between guest operating systems on the same physical computer.
    - Some other configuration that includes one or more virtualized servers.
 
- **Validation after the cluster is configured and in use:**

  - **Before adding a node:** When you add a server to a cluster, we strongly recommend to first connect the server to the cluster networks and storage, and then run the Validate cluster feature. Specify both the existing cluster nodes and the new node when you run the feature.
  
  - **When adding drives:** When you add additional drives to the cluster, which is different from replacing failed drives or creating virtual disks or volumes that rely on the existing drives, run the Validate cluster feature to confirm that the new storage will function correctly. 

  - **When making changes that affect firmware or drivers:** If you upgrade or make changes to the cluster that affect firmware or drivers, you must run the Validate cluster feature to confirm that the new combination of hardware, firmware, drivers, and software supports failover cluster functionality. If the change affects firmware or drivers for storage, we recommend keeping a small LUN available that clustered services and applications do not use. This allows you to run the storage validation tests without taking your services and applications offline.

  - **After restoring a system from backup:** After you restore a system from backup, run the Validate cluster feature to confirm that the system functions correctly as part of a cluster.

## Step 1: Validate networking
The Microsoft Validate-DCB tool is designed to validate the Data Center Bridging (DCB) configuration on the cluster. To do this, the tool takes an expected configuration as input, and then tests each server in the cluster. This section covers how to install and run the Validate-DCB tool, review results, and resolve networking errors that the tool identifies.

On the network, remote direct memory access (RDMA) over Converged Ethernet (RoCE) requires DCB technologies to make the network fabric lossless. The configuration requirements are complex and error prone. For these reasons, exact configuration is required across:
- Each server in the cluster
- Each network port that RDMA traffic passes through on the fabric

### Prerequisites
- Network setup information of the server cluster that you want to validate, including:
    - Host or server cluster name.
    - Virtual switch name.
    - Network adapter names.
    - Priority Flow Control (PFC) and Enhanced Transmission Selection (ETS) settings.
- An internet connection to download the tool module in Windows PowerShell from Microsoft.

<!---Should we add Jan's disclaimer in a note? Or maybe include the video link after each procedure that shows the disclaimer?--->

### Install and run the Validate-DCB tool
To install and run the Validate-DCB tool:
1. On your management PC, open a Windows PowerShell session as an Administrator, type `Install-module validate-DCB`, and then press **Enter**.

    :::image type="content" source="../media/validate/powershell-install-for-tool.png" alt-text="The PowerShell command to install the validate-DCB tool module":::

1. Accept the requests to use the NuGet provider and access the repository to install the tool.
1. After PowerShell connects to the Microsoft network to download the tool, type `Validate-DCB` and press **Enter** to start the tool wizard.

    > [!NOTE]
    > If you cannot run the Validate-DCB tool script, you might need to adjust your PowerShell execution policies. Use the Get-ExecutionPolicy cmdlet to view your current script execution policy settings. For information on setting execution policies in PowerShell, see [About Execution Policies](https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7).

1. On the Welcome to the Validate-DCB configuration wizard page, select **Next**.
1. On the Clusters and Nodes page, type the name of the server cluster that you want to validate, select **Resolve** to list it on the page, and then select **Next**.

    :::image type="content" source="../media/validate/clusters-and-nodes.png" alt-text="The Clusters and Nodes page of the Validate-DCB configuration wizard":::

1. On the Adapters page:
   1. Select the **vSwitch attached** checkbox and type the name of the vSwitch.
   1. Under **Adapter Name**, type the name of each physical NIC, under **Host vNIC Name**, the name of each virtual NIC (vNIC), and under **VLAN**, the name of each network.
   1. Expand the **RDMA Type** drop-down list box and select **RoCE**, leave **Jumbo Frames** set to **9014**, and then select **Next**.

    :::image type="content" source="../media/validate/adapters.png" alt-text="The Adapters page of the Validate-DCB configuration wizard":::

    > [!IMPORTANT]
    > - To learn more about how SR-IOV improves network performance, see [Overview of Single Root I/O Virtualization (SR-IOV)](https://docs.microsoft.com/windows-hardware/drivers/network/overview-of-single-root-i-o-virtualization--sr-iov-). 
    > - To learn more about how jumbo frames increase Ethernet and network processing efficiency, see the [Jumbo frame](https://en.wikipedia.org/wiki/Jumbo_frame) wiki.

1. On the Data Center Bridging page, under **Policy Name**, change **SMBDirect** to **SMB**, leave the other settings values as is, and select **Next**.

    :::image type="content" source="../media/validate/data-center-bridging.png" alt-text="The Data Center Bridging page of the Validate-DCB configuration wizard":::

    > [!NOTE]
    > Selecting RDMA over RoCE on the previous wizard page requires DCB for network reliability on all NICs and switchports.

1. On the Save and Deploy page, in the **Configuration File Path** box, save the configuration file using a .ps1 extension to a location where you can use it again later if needed, and then select **Export** to start running the Validate-DCB tool.

   - You can optionally deploy your configuration file by completing the **Deploy Configuration to Nodes** section of the page.

    :::image type="content" source="../media/validate/save-and-deploy.png" alt-text="The Save and Deploy page of the Validate-DCB configuration wizard":::

### Review results and fix errors
The Validate-DCB tool produces results in two units:
1. [Global Unit] results list prerequisites and requirements to run the modal tests.
1. [Modal Unit] results provide feedback on each cluster host configuration and best practices.

This example shows successful scan results of a single server for all prerequisites and modal unit tests by indicating a Failed Count of 0.

:::image type="content" source="../media/validate/global-unit-and-modal-unit-results.png" alt-text="Validate-DCB Global unit and Modal unit test results":::

The following steps show how to identify a Jumbo Packet error from vNIC SMB02 and fix it:
1. The results of the Validate-DCB tool scans show a Failed Count error of 1.

    :::image type="content" source="../media/validate/failed-count-error-1.png" alt-text="Validate-DCB tool scan results showing a a Failed Count error of 1":::

1. Scrolling back through the results shows an error in red indicating that the Jumbo Packet for vNIC SMB02 on Host S046036 is set at the default size of 1514, but should be set to 9014.

    :::image type="content" source="../media/validate/jumbo-packet-setting-error.png" alt-text="Validate-DCB tool scan result showing a jumbo packet size setting error":::

1. Reviewing the **Advanced** properties of vNIC SMB02 on Host S046036 shows that the Jumbo Packet is set to the default of **Disabled**.

    :::image type="content" source="../media/validate/hyper-v-advanced-properties-jumbo-packet-setting.png" alt-text="The Server host's Hyper-V Advanced properties Jumbo Packet setting":::

1. Fixing the error requires enabling the Jumbo Packet feature and changing its size to 9014 bytes. Running the scan again on host S046036 confirms this change by returning a Failed Count of 0.

    :::image type="content" source="../media/validate/jumbo-packet-error-fix-confirmation.png" alt-text="Validate-DCB scan results confirming that the Server host's Jumbo Packet setting is fixed":::

<!---Need screenshot from Jan for final step without numbers--->

To learn more about resolving errors that the Validate-DCB tool identifies, see the following video.

> [!VIDEO https://www.youtube.com/embed/cC1uACvhPBs]

## Step 2: Validate the cluster
The Create Cluster extension in Windows Admin Center is required for this section.

Use the following steps to validate the servers in an existing cluster in Windows Admin Center.

1. In Windows Admin Center, under **All connections**, select the Azure Stack HCI cluster that you want to validate, and then select **Connect**.

    The **Cluster Manager Dashboard** displays overview information about the cluster.

1. On the **Cluster Manager Dashboard**, under **Tools**, select **Servers**.
1. On the **Servers** page, select the **Inventory** tab.
1. On the **Inventory** page, select the servers in the cluster, then expand the **More** submenu and select **Validate cluster**.
1. On the **Validate Cluster** pop-up window, select **Yes**.

    :::image type="content" source="../media/validate/validate-cluster.png" alt-text="Validate Cluster pop-up window":::

1. On the **Credential Security Service Provider (CredSSP)** pop-up window, select **Yes**.
1. Provide your credentials to enable **CredSSP** and then select **Continue**.<br> Cluster validation runs in the background and gives you a notification when it's complete, at which point you can view the validation report, as described in the next section.

    :::image type="content" source="../media/validate/validated-cluster-notice.png" alt-text="Validated cluster notice":::

> [!NOTE]
> After your cluster servers have been validated, you will need to disable CredSSP for security reasons.

### View validation reports
Now you're ready to view your cluster validation report.

There are a couple ways to access validation reports:
- On the **Inventory** page, expand the **More** submenu, and then select **View validation reports**.

    Or

- At the top right of **Windows Admin Center**, select the **Notifications** bell icon to display the **Notifications** pane.
Select the **Successfully validated cluster** notice, and then select **Go to Failover Cluster validation report**.

> [!NOTE]
> The server cluster validation process may take some time to complete. Don't switch to another tool in Windows Admin Center while the process is running. In the **Notifications** pane, a status bar below your **Validate cluster** notice indicates when the process is done.

You can also use Windows PowerShell to run validation tests on your server cluster and view the results. You can run tests both before and after a cluster is set up.

To run a validation test on a server cluster, issue the **Get-Cluster** and **Test-Cluster** <server clustername> PowerShell cmdlets from your management PC, or run only the **Test-Cluster** cmdlet directly on the cluster:

```PowerShell
$Cluster = Get-Cluster -Name 'server-cluster1'
Test-Cluster -InputObject $Cluster -Verbose
```

### Disable CredSSP
After your server cluster is successfully validated, you'll need to disable the Credential Security Support Provider (CredSSP) protocol on each server for security purposes. For more information, see [CVE-2018-0886](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-0886).

1. In Windows Admin Center, under **All connections**, select the first server in your cluster, and then select **Connect**.
1. On the **Overview** page, select **Disable CredSSP**, and then on the **Disable CredSSP** pop-up window, select **Yes**.

    The result of Step 2 removes the red **CredSSP ENABLED** banner at the top of the server's **Overview** page, and disables CredSSP on the other servers.

## Next steps
- Windows Server Assessment is a Premier Service available for customers who want Microsoft to review their installations of Windows Server 2019. For more information, contact Microsoft Premier Support. To learn more, see [Getting Started with the Windows Server On-Demand Assessment (Server, Security, Hyper-V, Failover Cluster, IIS)](https://docs.microsoft.com/services-hub/health/getting-started-windows-server).
