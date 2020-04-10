---
title: Validate an Azure Stack HCI cluster
description: This how-to article focuses on why cluster validation is important, and when to run it on an existing Azure Stack HCI cluster. The article includes  validation scenarios for troubleshooting an updated server cluster.
author: JohnCobb1
ms.author: v-johcob
ms.topic: article
ms.date: 4/10/2020
---

> Applies to Windows Server 2019

# Validate an Azure Stack HCI cluster
This how-to article focuses on why cluster validation is important and when to run it:
- After deploying a server cluster, run the Validate-DCB tool to test networking, and the Validate feature in Windows Admin Center.
- After updating a server cluster, depending on your scenario, run both validation options to troubleshoot cluster issues.
<!---Redo intro and list based on Jason's feedback in article, then match in metadata.--->

## What is cluster validation?
Cluster validation is intended to catch hardware or configuration problems before a cluster goes into production. Cluster validation helps to ensure that the Azure Stack HCI solution that you're about to deploy is truly dependable. You can also use cluster validation on configured failover clusters as a diagnostic tool. You can use Storage Spaces Direct to perform cluster validation prior to creating your server cluster.
To learn more, see [Step 3.2: Validate the cluster](windows-server/storage/storage-spaces/deploy-storage-spaces-direct#step-32-validate-the-cluster) of the Deploy Storage Spaces Direct topic.

## Cluster validation considerations for an existing cluster
When you do cluster validation on an existing cluster, you might not always run all tests. If you include storage tests, there are different considerations to keep in mind. This section outlines the main considerations:

- **Considerations when including storage tests:** When you run cluster validation on an existing cluster, the default tests include storage tests that only test disk resources in an *Offline* state or disk resources unassigned to a clustered service or application. The cluster validation feature warns you if you've selected storage tests to run on storage in an *Online* state that either clustered services or applications are using. This safety warning is by design to avoid disruption to highly available services or applications that depend on disk resources being online.

  However, you might run validation tests on production clusters when a cluster storage failure occurs because of an underlying storage configuration change or failure. By default, the cluster validation feature won't run storage tests on online storage that clustered services or applications are using. In this situation, you can run the validation with storage tests by creating or choosing a new logical unit number (LUN) from the same shared storage device and presenting it to all nodes. By testing this LUN, you avoid disruption to online clustered services and applications in the cluster but still test the underlying storage subsystem.

  A failover cluster that passes the full set of validation tests and requires no future hardware or software changes is a supported configuration. However, routine updates to software components, such as drivers and firmware, might require you to rerun the cluster validation feature. Rerunning the tests ensures that the failover cluster's current configuration is supported. The following guidelines can help this process:

  - All storage components should be identical across all nodes in the cluster. Multipath I/O (MPIO) software and Device Specific Module (DSM) software components must be identical.
    
  - All mass-storage device controllers: the host bus adapter (HBA), HBA drivers, and HBA firmware attached to cluster storage should be identical. If you use dissimilar HBAs, verify with the storage vendor that you're following their supported or recommended configurations.

  - To minimize impact on highly available applications and services, a best practice is to keep a small LUN available. The LUN allows the cluster validation feature to run tests on available storage without negatively affecting clustered services and applications. If you need to run a full set of cluster validation tests, the cluster validation feature by default runs the tests on either the available storage or the new LUN only.

- **Considerations when not including storage tests:** System configuration tests, inventory tests, and network tests have low overhead. For this reason, you can run these tests without significant effect on the servers in a cluster.

  You might need to run the cluster validation feature on a production cluster during troubleshooting that isn't focused on storage. In this scenario, use the cluster validation feature to inventory hardware and software, test the network, and validate system configuration.
    
  Certain scenarios might require you to only run a subset of the full tests. For example, if you're troubleshooting a networking problem on a production cluster, you might only need to run the tests for hardware and software inventory, and the network.

## Step 1: Validate networking
The Microsoft Validate-DCB tool is designed to validate the Data Center Bridging (DCB) configuration on your Windows nodes. To do this, the tool takes an expected configuration as input, and then unit tests each Windows system.

On the network, remote direct memory access (RDMA) over Converged Ethernet (RoCE) requires DCB technologies to make the network fabric lossless. The configuration requirements are complex and error prone. For these reasons, exact configuration is required across:
- Each Windows node.
- Each network port that RDMA traffic passes through on the fabric.

Watch a quick video about how to install and run the tool.

> [!VIDEO https://www.youtube.com/embed/NXK_amScDDE]

To learn about the networking scenarios that the tool covers, testing, and interpreting test results, see [Validate-DCB](https://github.com/microsoft/Validate-DCB).

## Step 2: Validate the cluster
The Create Cluster extension in Windows Admin Center is required for this section.

Use the following steps to validate the servers in an existing cluster in Windows Admin Center.

1. In Windows Admin Center, under **All connections**, select the Windows Server cluster that you want to validate, and then select **Connect**.

    The **Cluster Manager Dashboard** displays overview information about the cluster.

1. On the **Cluster Manager Dashboard**, under **Tools**, select **Servers**.
1. On the **Servers** page, select the **Inventory** tab.
1. On the **Inventory** page, select the servers in the cluster, then expand the **More** submenu and select **Validate cluster (Preview)**.
1. On the **Validate Cluster** pop-up window, select **Yes**.

    :::image type="content" source="./media/validate/validate-cluster.png" alt-text="Validate Cluster pop-up window":::

1. On the **Credential Security Service Provider (CredSSP)** pop-up window, select **Yes**.
1. Provide your credentials to enable **CredSSP** and then select **Continue**.

    :::image type="content" source="./media/validate/validated-cluster-notice.png" alt-text="Validated cluster notice":::

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

### Disable CredSSP
After your server cluster is successfully validated, you'll need to disable the Credential Security Support Provider (CredSSP) protocol on each server for security purposes. For more information, see [CVE-2018-0886](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-0886).

1. In Windows Admin Center, under **All connections**, select the first server in your cluster, and then select **Connect**.
1. On the **Overview** page, select **Disable CredSSP**, and then on the **Disable CredSSP** pop-up window, select **Yes**.

    The result of Step 2 removes the red **CredSSP ENABLED** banner at the top of the server's **Overview** page, and disables CredSSP on the other servers.

## Specific validation scenarios
The guidance in this article requires at least one cluster previously created in Windows Admin Center. This section describes scenarios in which validation is also needed or useful.

- **Validation before the cluster is configured:**
  - **A set of servers ready to become a failover cluster:** This is the most straightforward validation scenario. The hardware components (systems, networks, and storage) are connected, but the systems aren't functioning as a cluster. Running tests in this situation has no affect on availability.

  - **Cloned or imaged systems:** If you clone or image systems to different hardware, run the Validate cluster feature as you would with any other new cluster. We recommend to run the Validate cluster feature just after connecting the hardware components and installing the failover cluster feature, before clients start using the cluster.
 
  - **Server VMs:** For virtualized servers in a cluster, run the Validate cluster feature as you would on any other new cluster. The requirement to run the feature is the same whether you have:
    - A "host cluster" where failover occurs between two physical computers.
    - A "guest cluster" where failover occurs between guest operating systems on the same physical computer.
    - Some other configuration that includes one or more virtualized servers.
 
- **Validation after the cluster is configured and in use:**

  - **Before adding a node:** When you add a server to a cluster, we strongly recommend first connecting the server to the cluster networks and storage, and then run the Validate cluster feature. Specifying both the existing cluster nodes and the new node when you run the feature.
  
  - **When attaching new storage:** When you attach new storage to the cluster, which is different from exposing a new LUN in existing storage, run the Validate cluster feature to confirm that the new storage will function correctly. To minimize the affect on availability, we recommend running the Validate cluster feature after attaching the storage. Run the feature before using any new LUNs in clustered services or applications.

  - **When making changes that affect firmware or drivers:** If you upgrade or make changes to the cluster that affect firmware or drivers, you must run the Validate cluster feature to confirm that the new combination of hardware, firmware, drivers, and software supports failover cluster functionality. If the change affects firmware or drivers for storage, we recommend keeping a small LUN available that clustered services and applications do not use. This allows you to run the storage validation tests without taking your services and applications offline.

  - **After restoring a system from backup:** After you restore a system from backup, run the Validate cluster feature to confirm that the system functions correctly as part of a cluster.

## Next steps
- Windows Server Assessment is a Premier Service available for customers who want Microsoft to review their installations of Windows Server 2019. For more information, contact Microsoft Premier Support. To learn more, see [Getting Started with the Windows Server On-Demand Assessment (Server, Security, Hyper-V, Failover Cluster, IIS)](https://docs.microsoft.com/services-hub/health/getting-started-windows-server).