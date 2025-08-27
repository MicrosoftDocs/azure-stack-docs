---
title: Update Azure Local, version 23H2 systems via PowerShell
description: Learn how to use PowerShell to apply operating system, service, and Solution Extension updates to Azure Local, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 08/13/2025
---

# Update Azure Local via PowerShell

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to apply a solution update to your Azure Local via PowerShell.

The procedure in this article applies to both single node and multi-node systems that run the latest version of Azure Local with the orchestrator (Lifecycle Manager) installed. If your system was created via a new deployment of Azure Local, then the orchestrator was automatically installed as part of the deployment.

[!INCLUDE [WARNING](../includes/hci-applies-to-23h2-cluster-updates.md)]

## About solution updates

The Azure Local solution updates can consist of platform, service, and solution extension updates. For more information on each of these types of updates, see [About updates for Azure Local](../update/about-updates-23h2.md).

[!INCLUDE [azure-local-banner-new-releases](../includes/azure-local-banner-new-releases.md)]

When you apply a solution update, here are the high-level steps that you take:

1. Make sure that all the prerequisites are completed.
1. Connect to your Azure Local instance via remote PowerShell.
1. Confirm current installed software versions and verify that your cluster is in good health.
1. Discover the updates that are available and filter the ones that you can apply to your system.
1. (Recommended) Predownload the updates and assess the update readiness of your system.
1. Install the updates and track the progress of the updates. Monitor the detailed progress as needed.
1. Verify the version of the updates installed.
1. Install hardware updates.

The time taken to install the updates varies based on the following factors:

- Content of the update.
- Load on your system.
- Number of machines in your system.
- Type of hardware used.
- Solution extension used.

The approximate time estimates for a typical single or multi-node system are summarized in the following table:

|System/Time           |Time for health check<br>*hh:mm*  |Time to install update<br>*hh:mm*  |
|------------------|-------------------------------------|---------|
|Single node     | ~ 03:00        |~ 01:30         |
|4-nodes    | ~ 05:00       |~ 04:00         |

> [!IMPORTANT]
> Use of 3rd party tools to install updates is not supported.

## Prerequisites

Before you begin, make sure that:

- You have access to an Azure Local system that is running 2311 or higher. The system should be registered in Azure.
- You have access to a client that can connect to your Azure Local. <!--This client should be running PowerShell 5.0 or later.-->
- You have access to the solution update over the network. <!--A typical quarterly update downloads around XX GB of files.-->

## Connect to your Azure Local

Follow these steps on your client to connect to one of the machines in your Azure Local.

1. Run PowerShell as administrator on the client that you're using to connect to your system.
2. Open a remote PowerShell session to a machine on your Azure Local. Run the following command and provide the credentials of your machine when prompted:

    ```powershell
    $cred = Get-Credential
    Enter-PSSession -ComputerName "<Computer IP>" -Credential $cred 
    ```

    > [!NOTE]
    > Sign in using your deployment user account credentials. This is the account you created when preparing [Active Directory](../deploy/deployment-prep-active-directory.md) and used to deploy Azure Local.


    <details>
    <summary>Expand this section to see an example output.</summary>


    Here's an example output:

    ```Console
    PS C:\Users\Administrator> $cred = Get-Credential
     
    cmdlet Get-Credential at command pipeline position 1
    Supply values for the following parameters:
    Credential
    PS C:\Users\Administrator> Enter-PSSession -ComputerName "100.100.100.10" -Credential $cred 
    [100.100.100.10]: PS C:\Users\Administrator\Documents>
    ```

    </details>

## Step 1: Confirm software and verify system health

Before you discover the updates, make sure that your system is running Azure Local 2311 or later.  

1. Make sure that you're connected to the machine using the deployment user account. Run the following command:

    ```powershell
    whoami
    ```

2. To ensure that the system is running Azure Local 2311 or later, run the following command on one of the machines of your system:


    ```powershell
    Get-SolutionUpdateEnvironment
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>


    ```console
    PS C:\Users\lcmuser> Get-SolutionUpdateEnvironment
    ResourceId : redmond 
    SbeFamily : GenA 
    HardwareModel : Contoso680 
    LastChecked : 10/2/2024 12:38:21 PM 
    PackageVersions : {Solution: 10.2408.0.29, Services: 10.2408.0.29, Platform: 1.0.0.0, SBE: 4.1.2409.1} 
    CurrentVersion : 10.2408.0.29 
    CurrentSbeVersion : 4.1.2409.1 
    LastUpdated : 
    State : UpdateAvailable 
    HealthState : Success 
    HealthCheckResult : {Storage Subsystem Summary, Storage Pool Summary, Storage Services Physical Disks Summary, Storage 
    Services Physical Disks Summary...} 
    HealthCheckDate : 10/2/2024 10:46:44 AM 
    AdditionalData : 
    ```

    </details>

1. Note the `CurrentVersion` on your system. The current version reflects the solution version that your system is running.

1. Review the `HealthState` on your system and verify that your system is in good health. If the HealthState is `Failure`, `Error`, or `Warning`, see [Troubleshoot readiness checks](./update-troubleshooting-23h2.md) before you proceed.

## Step 2: Discover the updates

Follow these steps to discover the available updates for your system: 

1. Connect to a machine on your Azure Local using the deployment user account.
1. Review details of updates that are `Ready` to install using `Get-SolutionUpdate`.

    ```powershell
    Get-SolutionUpdate | Where-Object {$_.State -like "Ready*" -or $_.State -like "Additional*"} | FL DisplayName, Description, ResourceId, State, PackageType 
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>


    Here's an example output:

    ```console
    PS C:\Users\lcmuser> Get-SolutionUpdate | Where-Object {$_.State -like "Ready*" -or $_.State -like "Additional*"} | FL DisplayName, Description, ResourceId, State, PackageType

    DisplayName           : 2024.10 Cumulative Update
    ResourceId            : redmond/Solution10.2408.2.7
    Version               : 10.2408.2.7
    State                 : Ready
    PackageType           : Solution
    
    DisplayName           : SBE_Contoso_GenA_4.1.2410.5
    ResourceId            : redmond/SBE4.1.2410.5
    Version               : 4.1.2410.5
    State                 : AdditionalContentRequired
    PackageType           : SBE
    ```

    </details>

    This may list one or more options including entries for both full `Solution` updates (that may also include a Solution Builder Extension) and standalone `SBE` updates.

    If you don't see an expected update listed, remove the filter from the command to see if it's listed in `non-ready` state:
    
    ```powershell
    Get-SolutionUpdate | FL DisplayName, Description, ResourceId, State, PackageType 
    ```

    For more information, see [About Update phases](./update-phases-23h2.md) for details on update states.

1. Select the update you wish to install and note its `ResourceId`. Review the details of the update to confirm you have selected the desired update to install.  

    ```powershell
    $Update = Get-SolutionUpdate –Id <ResourceId>
    $Update
    ```


    <details>
    <summary>Expand this section to see an example output.</summary>


    Here's an example output:

    ```console
    PS C:\Users\lcmuser> $Update = Get-SolutionUpdate –Id redmond/Solution10.2408.2.7
    PS C:\Users\lcmuser> $Update
    ResourceId            : redmond/Solution10.2408.2.7
    InstalledDate         : 
    Description           :
    State                 : Ready
    KbLink                : https://learn.microsoft.com/en-us/azure-stack/hci/
    MinVersionRequired    : 10.2408.0.0
    MinSbeVersionRequired : 2.0.0.0
    PackagePath           : C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\Updates\Packages\Solution10.2408
                            .2.2
    PackageSizeInMb       : 1278
    DisplayName           : 2024.10 Cumulative Update
    Version               : 10.2408.2.7
    SbeVersion            : 4.1.2410.5
    Publisher             : Microsoft
    ReleaseLink           : https://learn.microsoft.com/en-us/azure-stack/hci/
    AvailabilityType      : Online
    PackageType           : Solution
    Prerequisites         : {}
    UpdateStateProperties : The update requires additional content distributed by the OEM.
    AdditionalProperties  : {SBEReleaseLink, SBENotifyMessage, SBEFamily, SBEPublisher...}
    ComponentVersions     : {Services: 10.2408.2.7, Platform: 10.2408.2.7, SBE: 4.1.2410.5}
    RebootRequired        : Unknown
    HealthState           : Unknown
    HealthCheckResult     : 
    HealthCheckDate       : 1/1/0001 12:00:00 AM
    BillOfMaterials       : {PlatformUpdate, ServicesUpdate}
    ```

    </details>

    > [!NOTE]
    > It is normal for `HealthState` to be `Unknown` for an update that has not yet been scheduled or prepared.

1. Optionally review the versions of the update package components.


    ```powershell
    $Update = Get-SolutionUpdate -Id <ResourceID>
    $Update.ComponentVersions
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>


    Here's an example output:

    ```console
    PS C:\Users\lcmuser> $Update = Get-SolutionUpdate -Id redmond/Solution10.2408.2.7
    
    PS C:\Users\lcmuser> $Update.ComponentVersions
    
    PackageType Version      LastUpdated
    ----------- -------      -----------
    Services    10.2408.2.7
    Platform    10.2408.2.7
    SBE         4.1.2410.5
    
    PS C:\Users\lcmuser>

    ```

    </details>


## Step 3: Import and rediscover updates

This is an *optional* step. Importing updates could be required in one of the following scenarios:

- The update you wish to install reports an `AdditionalContentRequired`state. Some extra content may be required before you can schedule the update in the `AdditionalContentRequired`state. For details on this state and on solution extension updates, see [Solution Builder Extension updates on Azure Local](./solution-builder-extension.md).

- The update you wish to install isn't listed because Support is providing you with a private release to address an issue you're experiencing.

- The update is listed as `Ready`, but as your system has limited network connectivity, you want to avoid the online download phase of the solution extension update.

Follow these steps to import and discover your solution updates.

1. Connect to a machine on your Azure Local using the deployment user account.
1. Go to the network share and acquire the update package that you use. Verify that the update package you import contains the following files:
    - *SolutionUpdate.xml*
    - *SolutionUpdate.zip*
    - *AS_Update_10.2408.2.7.zip*

    If a solution builder extension is part of the update package, you should also see the following files:
    - *SBE_Contoso_GenA_4.1.2410.5.xml*
    - *SBE_Contoso_GenA_4.1.2410.5.zip*
    - *SBE_Discovery_Contoso.xml*

1. Download the files you intend to import to a location that your Azure Local instance can access. If you're importing a solution extension, you always download three files that matching the following naming pattern:

    | Filename pattern                          | Example                         | Description                                         |
    |-------------------------------------------|---------------------------------|-----------------------------------------------------|
    | SBE_Discovery_\<Manufacturer>\.xml          | SBE_Discovery_Contoso.xml       | A solution extension discovery manifest that enables update discovery.   |
    | SBE_\<Manufacturer>\_\<Family>\_\<Version>\.xml | SBE_Contoso_GenA_4.1.2410.5.xml | A file with solution extension inventory and signed software Bill of Materials |
    | SBE_\<Manufacturer>\_\<Family>\_\<Version>\.zip | SBE_Contoso_GenA_4.1.2410.5.zip | A file with solution extension payload                                         |

1. Create a folder for discovery by the update service at the following location in the infrastructure volume of your system.

    ```powershell
    New-Item C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import -ItemType Directory 
    ```

1. Copy the update files to the folder you created in the previous step.

1. Manually discover the update package using the Update service. Run the following command:

    ```powershell
    Add-SolutionUpdate -SourceFolder C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import
    ```

1. Verify that the Update service discovers the update package and that it's available to start preparation and installation. Repeat the `Get-SolutionUpdate` command to rediscover the updates.

## Step 4: (Recommended) Predownload and check update readiness

You can download the update and perform a set of checks to verify your cluster’s update readiness without starting the installation.

1. To download the updates without starting the installation, run the following command:

    ```powershell
    Get-SolutionUpdate -Id <ResourceId> | Start-SolutionUpdate –PrepareOnly
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>


    Here’s an example output:
    
    ```console
    PS C:\Users\lcmuser> Get-SolutionUpdate -Id redmond/Solution10.2408.2.7 | Start-SolutionUpdate –PrepareOnly
    redmond/SBE4.1.2410.9/<GUID>
    ```


    </details>

1. To track the update progress, monitor the update state. Run the following command:


    ```powershell
    Get-SolutionUpdate -Id <ResourceId> | ft Version,State,UpdateStateProperties,HealthState
    ```

    When the update starts, the following actions occur:

    - Download of the updates begins. Depending on the size of the download package and the network bandwidth, the download might take several minutes.


    <details>
    <summary>Expand this section to see an example output.</summary>

    
    Here's an example output when the updates are being downloaded:

    ```console
    PS C:\Users\lcmuser> Get-SolutionUpdate -Id redmond/Solution10.2408.2.7 | ft Version,State,HealthState

    Version              State          HealthState
    -------              -----          ---------------------
    10.2408.2.7          Downloading    InProgress
    ```

    </details>

1. Once the package is downloaded, readiness checks are performed to assess the update readiness of your system. For more information about the readiness checks, see [Update phases](./update-phases-23h2.md#phase-2-readiness-checks-and-staging). During this phase, the **State** of the update shows as `HealthChecking`.

    <details>
    <summary>Expand this section to see an example output.</summary>


    ```console
    PS C:\Users\lcmuser> Get-SolutionUpdate|ft Version,State,UpdateStateProperties,HealthState

    Version         State             HealthState
    -------         -----             --------------------- 
    10.2408.2.7     HealthChecking    InProgress
    ```

    </details>

1. When the readiness checks are done, the system is ready to install updates. The `State` of the update shows as `ReadyToInstall`. If the `State` of the update shows as `HealthCheckFailed`, see [Troubleshoot readiness checks](update-troubleshooting-23h2.md) before you proceed.


## Step 5: Start the update

During the install, the system machines may reboot and you may need to establish the remote PowerShell session again to monitor the updates. If updating a single machine, your Azure Local experiences a downtime.

Start an update by selecting a single update and passing it to `Start-SolutionUpdate`.

```powershell
$InstanceId = Get-SolutionUpdate -Id <ResourceId>  | Start-SolutionUpdate
```

> [!NOTE]
> If step 4 was skipped (and you did not make a similar call to `Start-SolutionUpdate -PrepareOnly`) calling `Start-SolutionUpdate` first downloads the updates and performs a set of checks to verify your cluster's update readiness prior to starting the update install.


<details>
<summary>Expand this section to see an example output.</summary>

```console
PS C:\Users\lcmuser> $InstanceId = Get-SolutionUpdate -Id redmond/Solution10.2408.2.7 | Start-SolutionUpdate
```

</details>

This starts the process to install the update.

> [!TIP]
> Save the `$InstanceId` as you could use it later to [Troubleshoot solution updates for Azure Local](./update-troubleshooting-23h2.md).


## Step 6: Track update progress

Microsoft recommends tracking cluster update progress in the Azure portal after the update has started. The portal is a great option for tracking update progress even when the update is started via PowerShell as it isn't subject to the disruptions in status reporting.

> [!TIP]
> - If monitoring via PowerShell, we recommend that you connect your PowerShell session to the last server in your cluster to avoid the session from disconnecting early. The sessions disconnect as the systems reboot so switching to monitor from an already updated server can minimize the frequency of disconnects. 
> - We recommend that you track cluster update progress in the Azure portal to avoid having to reconnect to PowerShell sessions following a machine reboot.

Follow these steps to track update progress using PowerShell.

1. To track the update progress, monitor the update state. Run the following command:

    ```powershell
    Get-SolutionUpdate -Id <ResourceId> | ft Version,State,UpdateStateProperties,HealthState
    ```

    The update progresses through several states as described in [Review update phases](./update-phases-23h2.md#review-update-phases-of-azure-local).

    Using the above command the following examples show how to monitor the update as it progresses through those phases using the `State` and `UpdateStateProperties` properties.

    - **Downloading state**
    
        Shortly after `Start-SolutionUpdate` is called, the download of the updates begins. Depending on the size of the download package and the network bandwidth, the download might take several minutes.
    
        <details>
        <summary>Expand this section to see an example output.</summary>
    
    
        Here's an example output when the updates are being downloaded:
    
        ```console
        PS C:\Users\lcmuser> Get-SolutionUpdate -Id redmond/Solution10.2408.2.7 |ft Version,State,UpdateStateProperties,HealthState
    
        Version              State         HealthState
        -------              -----         ------------
        10.2408.2.7          Downloading   Unknown
        ```

        </details>

    - **Preparing state**
    
        Once the updates are downloaded, the updates need be prepared. In the preparation state, the update files hashes are confirmed and files are extracted to prepare and stage update files.

        <details>
        <summary>Expand this section to see an example output.</summary>
    
    
        Here's an example output when the updates are being downloaded:
    
        ```console
        PS C:\Users\lcmuser> Get-SolutionUpdate -Id redmond/Solution10.2408.2.7 |ft Version,State,HealthState
    
        Version              State       HealthState
        -------              -----       -----------
        10.2408.2.7          Preparing   Unknown
        ```

        </details>

    - **HealthChecking state**
    
        Once the updates are prepared, readiness checks are performed to assess the update readiness of your cluster. For more information about the readiness checks, see [Update phases](./update-phases-23h2.md#phase-2-readiness-checks-and-staging).

        During this phase, the `State` of the update shows as `HealthChecking`. If the `State` of the update shows as `HealthCheckFailed`, see [Troubleshoot readiness checks](./update-troubleshooting-23h2.md) before you proceed.
        
        <details>
        <summary>Expand this section to see an example output.</summary>
    
    
        Here's an example output when the updates are undergoing `HealthChecking`:
    
        ```console
        PS C:\Users\lcmuser> Get-SolutionUpdate -Id redmond/Solution10.2408.2.7 |ft Version,State,HealthState
    
        Version              State           HealthState
        -------              -----           -----------
        10.2408.2.7          HealthChecking  Unknown
        ```

        </details>

    - **Installing state**
        When the system is ready, the update transitions to `Installing`. During this phase, the `State` of the updates shows as `Installing` and `UpdateStateProperties` shows the percentage of the installation that was completed.

        <details>
        <summary>Expand this section to see an example output.</summary>
    
    
        Here's an example output when the updates are undergoing `Installing`:
    
        ```console
        PS C:\Users\lcmuser> Get-SolutionUpdate -Id redmond/Solution10.2408.2.7 |ft Version,State,HealthState
    
        Version              State       HealthState
        -------              -----       -----------
        10.2408.2.7          Installing   Unknown
        ```

        </details>

 
Once the installation is complete, the **State** changes to `Installed`. For more information on the various states of the updates, see [Installation progress and monitoring](./update-phases-23h2.md#phase-3-installation-progress-and-monitoring).

## Step 7: Resume the update (if needed)

To resume a previously failed update run via PowerShell, use the following command:

```powershell
Get-SolutionUpdate -Id <ResourceId>  | Start-SolutionUpdate
```

To resume a previously failed update due to update readiness checks in a `Warning` state, use the following command:

```powershell
Get-SolutionUpdate -Id <ResourceId>  | Start-SolutionUpdate -IgnoreWarnings    
```

To troubleshoot other update run issues, see [Troubleshoot updates](./update-troubleshooting-23h2.md).

## Step 8: Verify the installation

After the updates are installed, verify the solution version of the environment and the operating system version.

1. After the update is in `Installed` state, check the environment solution version. Run the following command:

    ```powershell
    Get-SolutionUpdateEnvironment | ft State, CurrentVersion
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>


    ```console
    PS C:\Users\lcmuser> Get-SolutionUpdateEnvironment | ft State, CurrentVersion
    
    State               CurrentVersion
    -----               --------------
    AppliedSuccessfully 10.2408.2.7
        
    ```

    </details>

2. Check the operating system version to confirm it matches the recipe you installed. Run the following command:

    ```powershell
    cmd /c ver
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>

    Here's a sample output:

    ```console
    PS C:\Users\lcmuser> cmd /c ver
    
    Microsoft Windows [Version 10.0.25398.1189]
    PS C:\Users\lcmuser>
    ```

    </details>

## Step 9: Install hardware updates

[!INCLUDE [azure-local-install-harware-updates](../includes/azure-local-install-harware-updates.md)]

## Next step

- If you run into issues during the update process, see [Troubleshoot updates](./update-troubleshooting-23h2.md).

- Learn more about how to [Update version 22H2](../manage/update-cluster.md) when the orchestrator isn't installed.
