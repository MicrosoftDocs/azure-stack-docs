---
title: Join the Azure Stack HCI preview channel
description: How to join the Azure Stack HCI preview channel and install feature updates by using Windows PowerShell or Windows Admin Center.
author: jasongerend
ms.author: jgerend
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 06/17/2022
---

# Join the Azure Stack HCI preview channel

> Applies to: Azure Stack HCI, version 22H2 Preview

The Azure Stack HCI release preview channel is an opt-in program that lets customers install the next version of the operating system before it's officially released. It's intended for customers who want to evaluate new features, system architects who want to build a solution before conducting a broader deployment, or anyone who wants to see what's next for Azure Stack HCI. There are no program requirements or commitments. Preview builds are available via Windows Update using Windows Admin Center or PowerShell.

   > [!IMPORTANT]
   > Now that Azure Stack HCI, version 21H2 has reached general availability (GA), we strongly encourage all participants to update their preview channel clusters to build 22471 (future version) to avoid being billed. If you don't install build 22471, stay on version 21H2 and continue applying quality updates, your cluster will become billable. If you stay on version 21H2 and don't apply further quality updates past September 2021, you won't be billed.

   > [!WARNING]
   > Azure Stack HCI clusters that are managed by Microsoft System Center should not join the preview channel yet. System Center 2022 (including Virtual Machine Manager, Operations Manager, and other components) supports Azure Stack HCI, version 21H2 which is the current in-market (GA) version. System Center does not yet support further preview versions. See the [System Center blog](https://techcommunity.microsoft.com/t5/system-center-blog/bg-p/SystemCenterBlog) for the latest updates.

   > [!WARNING]
   > Don't use preview builds in production. Preview builds contain experimental pre-release software made available for evaluating and testing only. You might experience crashes, security vulnerabilities, or data loss. Be sure to back up any important virtual machines (VMs) before upgrading your cluster. Once you install a build from the preview channel, the only way to go back is a clean install.

## How to join the preview channel

Before joining the preview channel, make sure that all servers in the cluster are online, and that the cluster is [registered with Azure](../deploy/register-with-azure.md). 

   > [!IMPORTANT]
   > If your cluster is still running Azure Stack HCI, version 20H2, be sure to apply the latest Feature updates before joining the preview channel. See [Update Azure Stack HCI clusters](update-cluster.md).


1. Make sure you have the latest version of Windows Admin Center installed on a management PC or server.

2. Connect to the Azure Stack HCI cluster on which you want to install feature updates, and select **Settings** from the bottom-left corner of the screen. Select **Join the preview channel**, then **Get started**.

   :::image type="content" source="media/preview-channel/join-preview-channel.png" alt-text="Select join the preview channel, then Get started" lightbox="media/preview-channel/join-preview-channel.png":::

3. You'll be reminded that preview builds are provided as-is, and are not eligible for production-level support. Select the **I understand** checkbox, then click **Join the preview channel**.

4. You should see a confirmation that you've successfully joined the preview channel and that the cluster is now ready to flight preview builds.

   :::image type="content" source="media/preview-channel/joined-preview-channel.png" alt-text="Your cluster is now ready to flight preview builds" lightbox="media/preview-channel/joined-preview-channel.png":::

   > [!NOTE]
   > If any of the servers in the cluster say **Not configured** for preview builds, try repeating the process.

Now you're ready to install a preview build using either Windows Admin Center or PowerShell.

## Install a preview build using Windows Admin Center

Once you've joined the preview channel, your cluster will always be offered the latest available preview builds on a continuous basis. You can install a preview build using Windows Admin Center.

1. In Windows Admin Center, select **Updates** from the **Tools** pane at the left. If you've successfully joined the preview channel, feature updates will be displayed.

   :::image type="content" source="media/preview-channel/feature-updates.png" alt-text="Feature updates will be displayed" lightbox="media/preview-channel/feature-updates.png":::
<!--- This image is currently shared with the Updates page. --->
   > [!NOTE]
   > If you're installing build 22471, Windows Admin Center displays the correct update title, but incorrectly shows a banner advertising "version 21H2." This is a known issue.

2. Select **Install**. A readiness check will be displayed. If any of the condition checks fail, resolve them before proceeding.

   :::image type="content" source="media/preview-channel/readiness-check.png" alt-text="A readiness check will be displayed" lightbox="media/preview-channel/readiness-check.png":::

3. When the readiness check is complete, you're ready to install the updates. Unless you want the ability to roll back the updates, check the optional **Update the cluster functional level to enable new features** checkbox; otherwise, you can update the cluster functional level post-installation using PowerShell. Review the updates listed, and select **Install** to start the update.

   :::image type="content" source="media/preview-channel/install-updates.png" alt-text="Review the updates and install them" lightbox="media/preview-channel/install-updates.png":::

4. You'll be able to see the installation progress as in the screenshot below. Because you're updating the operating system with new features, the updates may take a while to complete. You can continue to use Windows Admin Center for other operations during the update process.

   :::image type="content" source="media/preview-channel/updates-in-progress.png" alt-text="You'll be able to see the installation progress as updates are installed" lightbox="media/preview-channel/updates-in-progress.png":::

   > [!NOTE]
   > If the updates appear to fail with a **Couldn't install updates** or **Couldn't check for updates** warning, or if one or more servers indicates **couldn't get status** during the updating run, try waiting a few minutes and refreshing your browser. You can also use `Get-CauRun` to [check the status of the updating run with PowerShell](update-cluster.md#check-on-the-status-of-an-updating-run).

5. When the feature updates are complete, check if any further updates are available and install them.

You're now ready to perform [post installation steps](#post-installation-steps).

## Install a preview build using PowerShell

To install a preview build using PowerShell, follow these steps. If your cluster is running Azure Stack HCI, version 20H2, be sure to apply the [May 20, 2021 preview update (KB5003237)](https://support.microsoft.com/en-us/topic/may-20-2021-preview-update-kb5003237-0c870dc9-a599-4a69-b0d2-2e635c6c219c) via Windows Update, or the `Set-PreviewChannel` cmdlet won't work.

1. Run the following cmdlets on every server in the cluster:

   ```PowerShell
   Set-WSManQuickConfig
   Enable-PSRemoting
   Set-NetFirewallRule -Group "@firewallapi.dll,-36751" -Profile Domain -Enabled true
   ```

2. To test whether the cluster is properly set up to apply software updates using Cluster-Aware Updating (CAU), run the `Test-CauSetup` cmdlet, which will notify you of any warnings or errors:

   ```PowerShell
   Test-CauSetup -ClusterName Cluster1
   ```

3. Validate the cluster's hardware and settings by running the `Test-Cluster` cmdlet on one of the servers in the cluster. If any of the condition checks fail, resolve them before proceeding to step 4.

   ```PowerShell
   Test-Cluster
   ```

4. Run the following cmdlet with no parameters on every server in the cluster:

   ```PowerShell
   Set-PreviewChannel
   ```

   This will configure your server to receive builds sent to the **ReleasePreview-External** audience. If your server was not already configured for flight signing, you'll need to restart after opting in. The module's output will tell you if you need to restart.

5. Check for the feature update:

   ```PowerShell
   Invoke-CauScan -ClusterName <ClusterName> -CauPluginName "Microsoft.RollingUpgradePlugin" -CauPluginArguments @{'WuConnected'='true';} -Verbose | fl *
   ```

   Inspect the output of the above cmdlet and verify that each server is offered the same Feature Update, which should be the case.

6. You'll need a separate server or VM outside the cluster to run the `Invoke-CauRun` cmdlet from. 

   > [!IMPORTANT]
   > The system on which you run `Invoke-CauRun` must be running either Windows Server 2022, Azure Stack HCI, version 21H2, or Azure Stack HCI, version 20H2 with the [May 20, 2021 preview update (KB5003237)](https://support.microsoft.com/en-us/topic/may-20-2021-preview-update-kb5003237-0c870dc9-a599-4a69-b0d2-2e635c6c219c) installed.

   ```PowerShell
   Invoke-CauRun -ClusterName <ClusterName> -CauPluginName "Microsoft.RollingUpgradePlugin" -CauPluginArguments @{'WuConnected'='true';} -Verbose -EnableFirewallRules -Force
   ```

7. Check for any further updates and install them. See [Install operating system updates using PowerShell](update-cluster.md#install-operating-system-updates-using-powershell).

You're now ready to perform [post installation steps](#post-installation-steps).

## Post installation steps

Once the feature updates are installed, you'll need to update the cluster functional level and update the storage pool version using PowerShell in order to enable new features.

1. **Update the cluster functional level.**

   We recommend updating the cluster functional level as soon as possible. If you installed the feature updates with Windows Admin Center and checked the optional **Update the cluster functional level to enable new features** checkbox, you can skip this step.
   
   Run the following cmdlet on any server in the cluster:
   
   ```PowerShell
   Update-ClusterFunctionalLevel
   ```
   
   You'll see a warning that you cannot undo this operation. Confirm **Y** that you want to continue.
   
   > [!WARNING]
   > After you update the cluster functional level, you can't roll back to the previous operating system version.

2. **Update the storage pool.**
   
   After the cluster functional level has been updated, use the following cmdlet to update the storage pool. Run `Get-StoragePool` to find the FriendlyName for the storage pool representing your cluster. In this example, the FriendlyName is **S2D on hci-cluster1**:
   
   ```PowerShell
   Update-StoragePool -FriendlyName "S2D on hci-cluster1"
   ```
   
   You'll be asked to confirm the action. At this point, new cmdlets will be fully operational on any server in the cluster.

3. **Upgrade VM configuration levels (optional).**
   
   You can optionally upgrade VM configuration levels by stopping each VM using the `Update-VMVersion` cmdlet, and then starting the VMs again.

4. **Verify that the upgraded cluster functions as expected.**
   
   Roles should fail-over correctly and if VM live migration is used on the cluster, VMs should successfully live migrate.

5. **Validate the cluster.**
   
   Run the `Test-Cluster` cmdlet on one of the servers in the cluster and examine the cluster validation report.

## Next steps

For more information, see also:

- [Update Azure Stack HCI clusters](update-cluster.md)
