---
title: Validate an Azure Stack HCI cluster
description: This how-to article focuses on why cluster validation is important, and when to run it on an existing Azure Stack HCI cluster. The article includes specific validation scenarios for troubleshooting an updated server cluster.
author: JohnCobb1
ms.author: v-johcob
ms.topic: article
ms.date: 4/13/2020
---

# Validate an Azure Stack HCI cluster
This how-to article focuses on why cluster validation is important, and when to run it on an existing Azure Stack HCI cluster. We recommend performing cluster validation for the following primary scenarios:
- After deploying a server cluster, run the Validate-DCB tool to test networking, and use the Validate feature in Windows Admin Center.
- After updating a server cluster, depending on your scenario, run both validation options to troubleshoot cluster issues.

## What is cluster validation?
Cluster validation is intended to catch hardware or configuration problems before a cluster goes into production. Cluster validation helps to ensure that the Azure Stack HCI solution that you're about to deploy is truly dependable. You can also use cluster validation on configured failover clusters as a diagnostic tool.

You can use Storage Spaces Direct to perform cluster validation prior to creating your server cluster.
To learn more, see [Step 3.2: Validate the cluster](/windows-server/storage/storage-spaces/deploy-storage-spaces-direct#step-32-validate-the-cluster) of the Deploy Storage Spaces Direct topic.

## Specific validation scenarios
This section describes scenarios in which validation is also needed or useful.

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

## Step 1: Validate networking
The Microsoft Validate-DCB tool is designed to validate the Data Center Bridging (DCB) configuration on your Windows nodes. To do this, the tool takes an expected configuration as input, and then unit tests each Windows system. This section covers how to install and run the Validate-DCB tool, review results, and resolve networking errors that the tool identifies.

On the network, remote direct memory access (RDMA) over Converged Ethernet (RoCE) requires DCB technologies to make the network fabric lossless. The configuration requirements are complex and error prone. For these reasons, exact configuration is required across:
- Each Windows node.
- Each network port that RDMA traffic passes through on the fabric.

### Install and run the Validate-DCB tool
To install and run the Validate-DCB tool:

1. <!---Where user goes to get tool. Use Jan's screenshots that require config/mulitple settings--->

### Review results
To review your results from the Validate-DCB tool:

1. <!---Where user goes to get tool. Use Jan's screenshots that require config/mulitple settings--->

### Resolve errors
To learn about resolving errors that the Validate-DCB tool identifies, watch a quick video about how to fix errors.

> [!VIDEO https://www.youtube.com/embed/cC1uACvhPBs]

## Step 2: Validate the cluster
The Create Cluster extension in Windows Admin Center is required for this section.

Use the following steps to validate the servers in an existing cluster in Windows Admin Center.

1. In Windows Admin Center, under **All connections**, select the Windows Server cluster that you want to validate, and then select **Connect**.

    The **Cluster Manager Dashboard** displays overview information about the cluster.

1. On the **Cluster Manager Dashboard**, under **Tools**, select **Servers**.
1. On the **Servers** page, select the **Inventory** tab.
1. On the **Inventory** page, select the servers in the cluster, then expand the **More** submenu and select **Validate cluster (Preview)**.
1. On the **Validate Cluster** pop-up window, select **Yes**.

    :::image type="content" source="../media/validate/validate-cluster.png" alt-text="Validate Cluster pop-up window":::

1. On the **Credential Security Service Provider (CredSSP)** pop-up window, select **Yes**.
1. Provide your credentials to enable **CredSSP** and then select **Continue**.

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

You can also use Windows PowerShell to view your cluster validation report.
1. <!---Detial PS way to do this. See Jason's team notes on this--->

### Disable CredSSP
After your server cluster is successfully validated, you'll need to disable the Credential Security Support Provider (CredSSP) protocol on each server for security purposes. For more information, see [CVE-2018-0886](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-0886).

1. In Windows Admin Center, under **All connections**, select the first server in your cluster, and then select **Connect**.
1. On the **Overview** page, select **Disable CredSSP**, and then on the **Disable CredSSP** pop-up window, select **Yes**.

    The result of Step 2 removes the red **CredSSP ENABLED** banner at the top of the server's **Overview** page, and disables CredSSP on the other servers.

## Next steps
- Windows Server Assessment is a Premier Service available for customers who want Microsoft to review their installations of Windows Server 2019. For more information, contact Microsoft Premier Support. To learn more, see [Getting Started with the Windows Server On-Demand Assessment (Server, Security, Hyper-V, Failover Cluster, IIS)](https://docs.microsoft.com/services-hub/health/getting-started-windows-server).