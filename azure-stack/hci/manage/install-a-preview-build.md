---
title: Install an Azure Stack HCI OS preview build
description: How to install feature updates by using Windows Admin Center or Windows PowerShell.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 07/29/2022
---

Applies to: Azure Stack HCI, version 22H2 preview

This article will provide instructions on installing an Azure Stack HCI OS preview build using Windows Admin Center or PowerShell.

## Install a preview build using Windows Admin Center

Once you've joined the preview channel, your cluster will always be offered the latest available preview builds on a continuous basis. You can install a preview build using Windows Admin Center.

# [Windows Admin Center](#tab/windows-admin-center)

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

# [PowerShell](#tab/powershell)

## Install a preview build using PowerShell

To install a preview build using PowerShell, follow these steps.

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

---
