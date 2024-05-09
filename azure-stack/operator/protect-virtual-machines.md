---
title: Protect virtual machines in Azure Site Recovery on Azure Stack Hub
description: Learn how to protect virtual machines in Azure Site Recovery on Azure Stack Hub. 
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 04/15/2024
ms.reviewer: rtiberiu
ms.lastreviewed: 04/15/2024

---

# Enable VM protection in Azure Site Recovery

Once the target and the source environments are configured, you can start enabling the protection of VMs (from the source to the target). All configuration is done on the target environment, in the Site Recovery vault itself.

## Prerequisites

You can configure the replication policy for the respective VMs you want to protect in the Site Recovery vault. These VMs are on the source environment, where they configured a specific resource group structure, virtual networks, public IPs, and NSGs.

Site Recovery helps replicate all the VM data itself, but before starting that, make sure that the following prerequisites are met:

- The target network connectivity is configured.
- The target virtual networks are configured - where each of the protected VMs are connected when a failover occurs.
- The target user subscription has enough compute quota allocation for all the VMs you plan to potentially failover.
- These virtual networks can be configured in the same manner as the source networks, or they can have a different design, depending on your disaster recovery plan and goal.
- Ensure that the new public and private IPs work as expected for the specific workloads you are protecting (when failovers occur, the failed-over VMs have IPs from the target environment).
- The desired resource group configuration is created.
- When configuring the replication, you can also create the resource groups, but for a production environment, you should pre-create them according to your naming policy and structure.
- Ensure the right RBAC is assigned and the tagging is in place – all according to your enterprise policy.
- The "cache storage account" is created and available.
- The "cache storage account" is a temporary storage account used in the replication process.

  > [!NOTE]
  > The scope of this storage account is complex and the [Plan capacity for Hyper-V VM disaster recovery](/azure/site-recovery/site-recovery-capacity-planner) article clarifies these concepts. For Azure Site Recovery on Azure Stack Hub, see the Capacity Planning article.

## Enable replication

In the target environment, in the Azure Stack Hub user portal, open the Site Recovery vault and select **Protect workloads**:

:::image type="content" source="media/protect-virtual-machines/protect-workloads.png" alt-text="Screenshot of protect workloads portal screen." lightbox="media/protect-virtual-machines/protect-workloads.png":::

Select the appliance you configured and check that it is healthy:

:::image type="content" source="media/protect-virtual-machines/health-check.png" alt-text="Screenshot of portal health precheck." lightbox="media/protect-virtual-machines/health-check.png":::

The blade then asks you to select the source environment and the source subscription. You should see all the Azure Stack Hub User subscriptions to which the user (or SPN) you configured has access.

Select the subscription that contains the source workloads, and select the VMs for which you plan to enable protection. You can protect up to 10 VMs at a time. PowerShell scripts are available that can enable larger deployments.

:::image type="content" source="media/protect-virtual-machines/enable-replication.png" alt-text="Screenshot of enable replication portal screen." lightbox="media/protect-virtual-machines/enable-replication.png":::

Azure Site Recovery replicates all disks attached to the VM. In this version, all the disks are protected.

:::image type="content" source="media/protect-virtual-machines/replication-settings.png" alt-text="Screenshot of portal replication settings." lightbox="media/protect-virtual-machines/replication-settings.png":::

In the next step, select the target environment configuration. This configuration includes the networks the VMs connect to, and the cache storage account they use. You must use PowerShell to configure the replication policy. Scripts are available that help start the customization process.

:::image type="content" source="media/protect-virtual-machines/target-environment.png" alt-text="Screenshot of target environment settings on portal." lightbox="media/protect-virtual-machines/target-environment.png":::

Review the selected configuration and enable the replication:

:::image type="content" source="media/protect-virtual-machines/review-replication.png" alt-text="Screenshot of final replication review screen." lightbox="media/protect-virtual-machines/review-replication.png":::

## Check replication progress and edit settings

In the Site Recovery vault, in the **Replicated Items** blade, you can see each of the VMs for which you enabled replication:

:::image type="content" source="media/protect-virtual-machines/replicated-items.png" alt-text="Scrrenshot of replicated items on portal." lightbox="media/protect-virtual-machines/replicated-items.png":::

Selecting these items enables you to view the current state, edit the settings of that protected item, or trigger actions such as a test failover:

:::image type="content" source="media/protect-virtual-machines/protected-item-settings.png" alt-text="Screenshot of protected item settings and properties." lightbox="media/protect-virtual-machines/protected-item-settings.png":::

## Understand the different states for protected VMs

Once a VM is protected and data replicated, there are further tasks you can perform:

- Run a test failover:
  - You can run a test failover to validate your replication and disaster recovery strategy, without any data loss or downtime. A test failover doesn't impact ongoing replication, or your production environment. You can run a test failover on a specific VM, or on a recovery plan containing multiple VMs.
- A test failover simulates the failover of this VM (from the source to the target) by creating the target VM. When doing a test failover, you can select:
  - The recovery point to fail over to:
    - Latest recovery point (lowest RPO): this option first processes all the data that has been sent to the Site Recovery service, to create a recovery point for each VM before failing over to it. This option provides the lowest RPO (Recovery Point Objective), because the VM created after failover will have all the data replicated to Site Recovery when the failover triggers.
    - Latest processed (lowest RTO): fails over all VMs in the plan to the latest recovery point processed by Site Recovery. To see the latest recovery point for a specific VM, check **Latest Recovery Points** in the VM settings. This option provides a low RTO (Recovery Time Objective), because no time is spent processing unprocessed data.
    - Latest app-consistent: fails over all the VMs in the plan to the latest application-consistent recovery point processed by Site Recovery. To see the latest recovery point for a specific VM, check **Latest Recovery Points** in the VM settings.
    - Custom: use this option to fail over a specific VM to a particular recovery point.
  - You cannot select the network at this point. The **test failover network** is configured for each protected VM. If you need to change it, go back to the properties of the protected VM, then select **View or edit**.

    :::image type="content" source="media/protect-virtual-machines/vm-compute-properties.png" alt-text="Screenshot of portal VM properties screen." lightbox="media/protect-virtual-machines/vm-compute-properties.png":::

- The test failover can help check the application behavior when failed over. However, your source VM might still be running. You must consider this behavior when doing a test failover.

  > [!NOTE]
  > Azure Site Recovery replicates the VM completely when doing a test failover. The VM runs on both source and target environments. You must take this into account, as it might affect the behavior of your app.

- When the test failover is complete, you can select **Clean test failover**. This option deletes the test failover VM and all the test resources

  :::image type="content" source="media/protect-virtual-machines/test-clean-up.png" alt-text="Screenshot of failover test cleanup screen." lightbox="media/protect-virtual-machines/test-clean-up.png":::

- Failover:
  - In the event of an issue on the source environment, you can choose to fail the VMs over to the target environment.

    :::image type="content" source="media/protect-virtual-machines/failover-vm.png" alt-text="Screenshot of failover vm screen." lightbox="media/protect-virtual-machines/failover-vm.png":::

  - When starting the failover process, you can **Shut down machine before beginning failover**. Since this option moves the entire VM from the source to the target, the source VM should be shut down before you select this option.

    > [!NOTE]
    > If no test failover was done in the past 180 days, Site Recovery recommends that you perform one before an actual failover. Skipping validation of the replication via test failover can lead to data loss or unpredictable downtime.

  - Once the failover process is complete, you must commit the changes in order to fully complete the failover process. If you don't commit first, then try to re-protect, the re-protect action first triggers a commit, and then continues with the re-protect (therefore it takes longer because both operations are required).

  - After the source environment is healthy again, you can start a "failback" process. This process is performed in two steps:
    - Run re-protect to start replicating the data back to the source.
    - Once data is fully replicated, run the planned failover to move the resource back to the initial environment.

    You can check the following section for a list of considerations needed during each of these phases.

  > [!NOTE]
  > At this time we don't support re-enabling protection (after a failback process). You must disable protection, remove the agent, and then enable protection again for this VM. This process can be automated and we provide scripts to help you get started.

## Uninstall Azure Site Recovery VM extension

By design, when you uninstall the the Azure Site Recovery extension, it doesn't remove the mobility service that runs within that VM. This blocks any future protection and requires manual steps to enable protection again for that VM.

After you remove the Azure Site Recovery VM extension, you must uninstall the mobility service that runs within that VM. To do so, see these steps to [Uninstall Mobility service](/azure/site-recovery/vmware-physical-manage-mobility-service#uninstall-mobility-service).
 
> [!NOTE]
> If you plan to re-enable protection for that VM, after following the previous steps, make sure to restart the VM before trying to add protection using Azure Site Recovery.

## Considerations

The following information is not necessary for normal operations. However, these notes can help give you a better understanding of the processes that take place behind the scenes.

For each of the states, there are several considerations:

- Re-protect:
  - Ensure that the initial source subscription, the initial resource group, and the virtual network/subnet of the initial primary NIC still exist on the primary stamp. You can retrieve this information from the protected item using PowerShell:

    ```powershell
    Get-AzResource -ResourceID "/subscriptions/<subID>/resourceGroups/<RGname>/providers/Microsoft.DataReplication/replicationVaults/<vaultName>/protectedItems/<vmName>"
    ```

    The following image shows example output from this command:

    :::image type="content" source="media/protect-virtual-machines/resource-output.png" alt-text="Screenshot of PowerShell command output." lightbox="media/protect-virtual-machines/resource-output.png":::

  - Before running re-protect for Linux VMs, ensure that the certificate of the Site Recovery service is trusted on the Linux VMs that you want to re-protect. This trust unblocks the VM registration with the Site Recovery service, which re-protection requires.

    For Ubuntu/Debian VMs:

    ```shell
    sudo cp /var/lib/waagent/Certificates.pem /usr/local/share/ca-certificates/Certificates.crt

    sudo update-ca-certificates
    ```

    For Red Hat VMs:

    ```shell
    sudo update-ca-trust force-enable

    sudo cp /var/lib/waagent/Certificates.pem /etc/pki/ca-trust/source/anchors/

    sudo update-ca-trust extract
    ```

  - Ensure that the Site Recovery appliance VM has enough data disk slots available. The replica disks for re-protection are attached to the appliance (check the Capacity Planning for more information).
  - During the re-protection process, the source VM (which would have the **sourceAzStackVirtualMachineId** on the source stamp) is shut down once the re-protect is triggered, and the OS disk and data disks attached to it are detached and attached to the appliance as replica disks if they are the old ones. The OS disk is replaced with a temporary OS disk of size 1GB.
  - Even if a disk can be re-used as replica in re-protect, but it is in a different subscription from the appliance VM, a new disk is created from it in the same subscription and resource group as the appliance, so that the new disk can be attached to the appliance.
  - The attached data disks of the appliance should not be modified/attached/detached/changed manually, as a re-protect manual resync is not supported in public preview (see the known issues article). The re-protection cannot be recovered if the replica disks are removed.

- Failback (planned failover): fail back a re-protected item from the target stamp to the source stamp:
  - Ensure that the initial source subscription, the initial resource group, and the virtual network/subnet of the initial primary NIC still exist on the source stamp. You can retrieve this information from the protected item using PowerShell.
  - The VM with the **sourceAzStackVirtualMachineId** on the source stamp is created with the replica disks and newly created NICs if it does not exist; or it is replaced with a replica OS disk and data disks if it exists.
  - If the VM with the **sourceAzStackVirtualMachineId** on the primary stamp exists, all the disks attached to it are detached but not deleted, and the NICs remain the same.
  - If the VM with the **sourceAzStackVirtualMachineId** on the primary stamp exists, and if it is in a different subscription from the appliance VM, new disks are created in the same subscription and resource group as the failback VM from the replica ones detached from the appliance, so that the new disks can be attached to the failback VM.

- Commit that the failover/failback is done. The failed-over VM on the recovery stamp is deleted after failback is committed.
- When you uninstall the Azure Site Recovery Resource Provider, all the vaults created in those target Azure Stack Hub stamps are also removed. This is an Azure Stack Hub operator action, with no warnings or alerts for users when it happens.

## Next steps

[Azure Site Recovery overview](azure-site-recovery-overview.md)
