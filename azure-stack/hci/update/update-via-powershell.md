---
title: Update Azure Stack HCI clusters via PowerShell (preview)
description: How to apply operating system, service, and Solution Extension updates to Azure Stack HCI using PowerShell (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 03/21/2023
---

# Update your Azure Stack HCI solution via PowerShell (preview)

Applies to: Azure Stack HCI, Supplemental Package

This article describes how to apply a solution update to your Azure Stack HCI cluster via PowerShell.

The procedure in this article applies to both a single node and multi-node cluster that is running software versions with Lifecycle Manager installed. If your cluster was created via a new deployment of Azure Stack HCI, Supplemental Package, then Lifecycle Manager was automatically installed as part of the deployment.

For information on how to apply solution updates to clusters that were created with older versions of Azure Stack HCI that did not have Lifecycle Manager installed, see [Apply updates to an existing cluster](../index.yml).

## About solution updates

The Azure Stack HCI solution updates can consist of platform, service, and solution extension updates. For more information on each of these types of updates, see [What's in an Update](../index.yml).

The update example used in this article does not include solution extension updates. For more information on solution extension updates, go to [How to install solution extension updates](../index.yml).

When you apply a solution update, here are the high-level steps that you’ll take:

1. Make sure that all the prerequisites are completed.
1. Connect to your Azure Stack HCI cluster via remote PowerShell.
1. Discover the updates that are available and filter the ones that you can apply to your cluster.
1. Download the updates, assess the update readiness of your cluster and once ready, install the updates on your cluster. Track the progress of the updates. If needed, you can also monitor the detailed progress.
1. Verify the version of the updates installed.

> [!NOTE]
> The time taken to install the updates may vary based on the content of the update, the load on your cluster, and the number of nodes in your cluster. The approximate time estimate for a typical single node cluster varies from X-Y hrs. and for a two-node cluster varies from Y-Z hrs.

## Prerequisites

Before you begin, make sure that:

- You’ve access to an Azure Stack HCI cluster that is running 2302 or higher. The cluster should be registered in Azure.
- You’ve access to a client that can connect to your Azure Stack HCI cluster. This client should be running PowerShell 5.0 or later.
- You’ve access to the solution update package over the network. You will sideload or copy these updates to the nodes of your cluster.

## Connect to your Azure Stack HCI cluster

Follow these steps on your client to connect to one of the nodes of your Azure Stack HCI cluster.

1. Run PowerShell as administrator on the client that you are using to connect to your cluster.
1. Open a remote PowerShell session to a node on your Azure Stack HCI cluster. Run the following command and provide the credentials of your node when prompted:

    ```powershell
    $cred = Get-Credential
    Enter-PSSession -ComputerName "<Computer IP>" -Credential $cred -Authentication 'CredSSP'
    ```

    Here is an example output:
    
    ```Console
    PS C:\Users\Administrator> $cred = Get-Credential
     
    cmdlet Get-Credential at command pipeline position 1
    Supply values for the following parameters:
    Credential
    PS C:\Users\Administrator> Enter-PSSession -ComputerName "100.100.100.10" -Credential $cred -Authentication 'CredSSP'
    [100.100.100.10]: PS C:\Users\Administrator\Documents>
    ```

## Step 1: Identify the existing version on your cluster

Before you discover the updates, identify the versions that your cluster is currently running. Run the following command and make a note of the operating system version of your cluster:

```powershell
cmd /c ver
```

## Step 2: Discover the updates

You’ll now sideload the updates that you intend to apply to your cluster.

1. Set some parameters. Run the following command:

    ```powershell
    $updates = Get-SolutionUpdate
    ```

1. Get all the available solution updates and filter out the ones that are ready to start preparation and installation. Run the following command:

    ```powershell
    $readyUpdate = $updates | where State -eq "Ready" 
    $readyUpdate | ft DisplayName, Version, State   
    ```

1. Check the component version of the updates that are ready to start preparation and installation. Run the following command:

    ```powershell
    $readyUpdate.ComponentVersions
    ```

    Here is an example output:
    
    ```console
    PS C:\> $updates = Get-SolutionUpdate
    PS C:\> $readyUpdate = $updates | where State -eq "Ready"    
    PS C:\> $readyUpdate | ft DisplayName, Version, State
    
    DisplayName                 Version      State
    -----------                 -------      -----
    Azure Stack HCI 2302 bundle 10.2302.0.15 Ready
    
    PS C:\> $ readyUpdate.ComponentVersions
    
    PackageType Version      LastUpdated
    ----------- -------      -----------
    Services    10.2302.0.15
    Platform    10.2302.0.15
    SBE         4.1.2.3
    ```
    
## Step 3: Download, check readiness, and install updates

You can download the updates, perform a set of checks to verify the update readiness of your cluster, and start installing the updates.

1. You can only download the update without starting the installation or download and install the update. 

    - To download and install the update, run the following command:

        ```powershell
        Get-SolutionUpdate | Start-SolutionUpdate
        ```

    - To only download the updates without starting the installation, use the `-PrepareOnly` flag with `Start-SolutionUpdate`.

1. To track the update progress, monitor the update state. Run the following command:

    ```powershell
    Get-SolutionUpdate
    ```

    When the update starts, the following actions occur:

    - Download of the updates begins. Depending on the size of the download package and the network bandwidth, the download may take several minutes.

        Here is an example output when the updates are being downloaded:

        ```
        [100.100.100.10]: PS C:\ClusterStorage\Infrastructure_1\StagedSolutionAndSbe> Get-SolutionUpdate
        
        
        ResourceId            : redmond/Solution10.2302.1.1
        InstalledDate         :
        Description           :
        
        State                 : Downloading
        KbLink                : https://learn.microsoft.com/en-us/azure-stack/hci/
        MinVersionRequired    :
        MinOemVersionRequired : 1.0.0.0
        PackagePath           : C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\Updates\Packages\Solution10.2302
                                .1.1
        PackageSizeInMb       : 331
        DisplayName           : Azure Stack HCI 2302 bundle
        Version               : 10.2302.1.1
        OemVersion            :
        Publisher             : Microsoft
        ReleaseLink           : https://learn.microsoft.com/en-us/azure-stack/hci/
        AvailabilityType      : Online
        PackageType           : Solution
        Prerequisites         :
        UpdateStateProperties :
        AdditionalProperties  :
        ComponentVersions     : {Microsoft.AzureStack.Services.Update.ResourceProvider.UpdateService.Models.PackageVersionInfo,
                                 Microsoft.AzureStack.Services.Update.ResourceProvider.UpdateService.Models.PackageVersionInfo}
        RebootRequired        : Yes
        HealthState           : Unknown
        HealthCheckResult     :
        HealthCheckDate       : 1/1/0001 12:00:00 AM
        ```

    - Once the package is downloaded, readiness checks are performed to assess the update readiness of your cluster. For more information about the readiness checks, see [Update phases](). During this phase, the **State** of the update shows as `HealthChecking`.

    - When the system is ready, updates are installed. During this phase, the **State** of the updates shows as `Installing` and `UpdateStateProperties` shows the percentage completed.

        **IMPORTANT:**
    
        During the install, the cluster nodes may reboot and you may need to establish the remote PowerShell session again to monitor the updates. If updating a single node, your Azure Stack HCI will experience a downtime.
    
        Here is a sample output while the updates are being installed.

        ```console
        [100.100.100.10]: PS C:\ClusterStorage\Infrastructure_1\StagedSolutionAndSbe> Get-SolutionUpdate
        
        
        ResourceId            : redmond/Solution10.2302.1.1
        InstalledDate         :
        Description           :
        
        State                 : Installing
        KbLink                : https://learn.microsoft.com/en-us/azure-stack/hci/
        MinVersionRequired    :
        MinOemVersionRequired : 1.0.0.0
        PackagePath           : C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\Updates\Packages\Solution10.2302
                                .1.1
        PackageSizeInMb       : 331
        DisplayName           : Azure Stack HCI 2302 bundle
        Version               : 10.2302.1.1
        OemVersion            :
        Publisher             : Microsoft
        ReleaseLink           : https://learn.microsoft.com/en-us/azure-stack/hci/
        AvailabilityType      : Online
        PackageType           : Solution
        Prerequisites         :
        UpdateStateProperties : 89% complete.
        AdditionalProperties  :
        ComponentVersions     : {Microsoft.AzureStack.Services.Update.ResourceProvider.UpdateService.Models.PackageVersionInfo,
                                 Microsoft.AzureStack.Services.Update.ResourceProvider.UpdateService.Models.PackageVersionInfo}
        RebootRequired        : Yes
        HealthState           : Success
        HealthCheckResult     : {Storage Subsystem Summary, Storage Pool Summary, Storage Services Physical Disks Summary,
                                Storage Services Physical Disks Summary...}
        HealthCheckDate       : 2/23/2023 5:48:42 PM
        ```

Once the installation is complete, the **State** changes to `Installed`. For more information on the various states of the updates, see [Asz.Update PowerShell Module.docx](https://microsoft.sharepoint.com/:w:/t/ASZ/EYSSpZVOM-NBm35x867-REwBiOq-9LmW62H_KsL5ENxYcA?e=aHgPLv).

To track a more granular progress of the updates, see [Verify detailed progress](#appendix-verify-detailed-progress).

## Step 4: Verify the installation

After the updates are installed, verify the solution version of the environment as well as the version of the operating system.

1. After the update is in Installed state, check the environment solution version. Run the following command:

    ```powershell
    Get-SolutionUpdateEnvironment | ft State, CurrentVersion
    ```

    Here is a sample output:
    
    ```console
    [100.100.100.10]: PS C:\ClusterStorage\Infrastructure_1\StagedSolutionAndSbe> Get-SolutionUpdateEnvironment | ft State, CurrentVersion
    
    State               CurrentVersion
    -----               --------------
    AppliedSuccessfully 10.2302.1.1
        
    ```

1. Check the operating system version to confirm it matches the recipe you installed. Run the following command:

    ```powershell
    cmd /c ver
    ```

    Here is a sample output:

    ```console
    [100.100.100.10]: PS C:\ClusterStorage\Infrastructure_1\StagedSolutionAndSbe> cmd /c ver
    
    Microsoft Windows [Version 10.0.20349.1547]
    ```

## Appendix: Verify detailed progress

While the update is in the preparation phase (download if necessary, stage the content on the cluster, and run readiness checks), the preparation steps can be viewed as part of the progress.

1. To track the more granular preparation state, run the following command:

    ```powershell
    $updateRun = $readyUpdate | Get-SolutionUpdateRun
    $updateRun.Progress.Steps | ft Name, Status
    ```

    Here is an example output:

    ```console
    PS C:\> $updateRun = $readyUpdate | Get-SolutionUpdateRun
    PS C:\> $updateRun.Progress.Steps | ft Name, Status
    
    Name                                         Status
    ----                                         ------
    Downloading update                           Success
    Verifying additional content is added        Success
    Validating the download and extracting files InProgress
    Checking health.                             NotStarted
    Initiating update installation               NotStarted
    ```

1. When the update has proceeded to the installation phase, the specific installation steps are shown as part of the progress.

    ```powershell
    C:\> $readyUpdate | Get-SolutionUpdate | % State
    ```

    Here is an example output:

    ```console
    PS C:\> $readyUpdate | Get-SolutionUpdate | % State
    Installing
    ```

## Next steps

Learn more about how to [Troubleshoot updates](../index.yml).
