---
title: Update Azure Stack HCI, version 23H2 clusters via PowerShell.
description: Learn how to use PowerShell to apply operating system, service, and Solution Extension updates to Azure Stack HCI, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 04/16/2024
---

# Update your Azure Stack HCI, version 23H2 via PowerShell

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]


This article describes how to apply a solution update to your Azure Stack HCI cluster via PowerShell.

The procedure in this article applies to both a single server and multi-server cluster that is running the latest version with the orchestrator (Lifecycle Manager) installed. If your cluster was created via a new deployment of Azure Stack HCI, version 23H2, then the orchestrator was automatically installed as part of the deployment.

[!INCLUDE [WARNING](../../includes/hci-applies-to-23h2-cluster-updates.md)]

For information on how to apply solution updates to clusters created with older versions of Azure Stack HCI that didn't have the orchestrator installed see [Update Azure Stack HCI clusters, version 22H2](../manage/update-cluster.md).

## About solution updates

The Azure Stack HCI solution updates can consist of platform, service, and solution extension updates. For more information on each of these types of updates, see [About updates for Azure Stack HCI, version 23H2](../update/about-updates-23h2.md).

<!--The update example used in this article doesn't include solution extension updates. For more information on solution extension updates, go to [How to install solution extension updates](../index.yml).-->

When you apply a solution update, here are the high-level steps that you take:

1. Make sure that all the prerequisites are completed.
2. Identify the software version running on your cluster.
3. Connect to your Azure Stack HCI cluster via remote PowerShell.
4. Use the [Environment Checker](../manage/use-environment-checker.md?tabs=connectivity) to verify that your cluster is in good health.
5. Discover the updates that are available and filter the ones that you can apply to your cluster.
6. Download the updates, assess the update readiness of your cluster and once ready, install the updates on your cluster. Track the progress of the updates. If needed, you can also monitor the detailed progress.
7. Verify the version of the updates installed.

The time taken to install the updates might vary based on the following factors:

- Content of the update.
- Load on your cluster.
- Number of servers in your cluster.
- Type of the hardware used.
- Solution Builder Extension used.

The approximate time estimates for a typical single server and 4-server cluster are summarized in the following table:

|Cluster/Time           |Time for health check<br>*hh:mm:ss*  |Time to install update<br>*hh:mm:ss*  |
|------------------|-------------------------------------|---------|
|Single server     | 0:01:44	        |1:25:42         |
|4-server cluster    | 0:01:58	        |3:53:09         |

## Prerequisites

Before you begin, make sure that:

- You have access to an Azure Stack HCI, version 23H2 cluster that is running 2310 or higher. The cluster should be registered in Azure.
- You have access to a client that can connect to your Azure Stack HCI cluster. This client should be running PowerShell 5.0 or later.
- You have access to the solution update package over the network. You sideload or copy these updates to the servers of your cluster.

## Connect to your Azure Stack HCI cluster

Follow these steps on your client to connect to one of the servers of your Azure Stack HCI cluster.

1. Run PowerShell as administrator on the client that you're using to connect to your cluster.
2. Open a remote PowerShell session to a server on your Azure Stack HCI cluster. Run the following command and provide the credentials of your server when prompted:

    ```powershell
    $cred = Get-Credential
    Enter-PSSession -ComputerName "<Computer IP>" -Credential $cred 
    ```

    > [!NOTE]
    > You should sign in using your deployment user account credentials: which is the account you created when preparing [Active Directory](../deploy/deployment-prep-active-directory.md) and used during the deployment of the Azure Stack HCI system.

    Here's an example output:

    ```Console
    PS C:\Users\Administrator> $cred = Get-Credential
     
    cmdlet Get-Credential at command pipeline position 1
    Supply values for the following parameters:
    Credential
    PS C:\Users\Administrator> Enter-PSSession -ComputerName "100.100.100.10" -Credential $cred 
    [100.100.100.10]: PS C:\Users\Administrator\Documents>
    ```

## Step 1: Identify the stamp version on your cluster

Before you discover the updates, make sure that the cluster was deployed using the Azure Stack HCI, version 23H2, software version 2310.  

1. Make sure that you're connected to the cluster server using the deployment user account. Run the following command:

    ```powershell
    whoami
    ```

2. To ensure that the cluster was deployed running Azure Stack HCI, version 23H2, run the following command on one of the servers of your cluster:

    ```powershell
    Get-StampInformation
    ```

    Here's a sample output:

    ```console
    PS C:\Users\lcmuser> Get-StampInformation
    Deployment ID             : b4457f25-6681-4e0e-b197-a7a433d621d6
    OemVersion                : 2.1.0.0
    PackageHash               :
    StampVersion              : 10.2303.0.31
    InitialDeployedVersion    : 10.2303.0.26
    PS C:\Users\lcmuser>
    ```

3. Make a note of the `StampVersion` on your cluster. The stamp version reflects the solution version that your cluster is running.

## Step 2: Optionally validate system health

Before you discover the updates, you can manually validate the system health. This step is optional as the orchestrator always assesses update readiness prior to applying updates.

> [!NOTE]
> Any faults that have a severity of *critical* will block the updates from being applied.

1. Connect to a server on your Azure Stack HCI cluster using the deployment user account.
2. Run the following command to validate system health via the [Environment Checker](../manage/use-environment-checker.md).

    ```powershell
    $result = Test-EnvironmentReadiness
    $result | ft Name,Status,Severity  
    ```

    Here's a sample output:

    ```console
    PS C:\Users\lcmuser> whoami
    rq2205\lcmuser                                                                                               
    PS C:\Users\lcmuser> $result=Test-EnvironmentReadiness                                                         
    VERBOSE: Looking up shared vhd product drive letter.                                                                    
    WARNING: Unable to find volume with label Deployment                                                                    
    VERBOSE: Get-Package returned with Success:True                                                                        
    VERBOSE: Found package Microsoft.AzureStack.Solution.Deploy.EnterpriseCloudEngine.Client.Deployment with version  10.2303.0.31 at                                                                                                         C:\NugetStore\Microsoft.AzureStack.Solution.Deploy.EnterpriseCloudEngine.Client.Deployment.10.2303.0.31\Microsoft.Azure Stack.Solution.Deploy.EnterpriseCloudEngine.Client.Deployment.nuspec.                                                   
    03/29/2023 15:45:58 : Launching StoragePools                                                                            
    03/29/2023 15:45:58 : Launching StoragePhysicalDisks                                                                    
    03/29/2023 15:45:58 : Launching StorageMapping                                                                          
    03/29/2023 15:45:58 : Launching StorageSubSystems                                                                       
    03/29/2023 15:45:58 : Launching TestCauSetup                                                                            
    03/29/2023 15:45:58 : Launching StorageVolumes                                                                          
    03/29/2023 15:45:58 : Launching StorageVirtualDisks                                                                     
    03/29/2023 15:46:05 : Launching OneNodeEnvironment                                                                      
    03/29/2023 15:46:05 : Launching NonMigratableWorkload                                                                   
    03/29/2023 15:46:05 : Launching FaultSummary                                                                            
    03/29/2023 15:46:06 : Launching SBEHealthStatusOnNode                                                                   
    03/29/2023 15:46:06 : Launching StorageJobStatus                                                                        
    03/29/2023 15:46:07 : Launching StorageCsv
    WARNING: There aren't any faults right now.
    03/29/2023 15:46:09 : Launching SBEPrecheckStatus
    WARNING: rq2205-cl: There aren't any faults right now.
    VERBOSE: Looking up shared vhd product drive letter.
    WARNING: Unable to find volume with label Deployment
    VERBOSE: Get-Package returned with Success:True
    VERBOSE: Found package Microsoft.AzureStack.Role.SBE with version 4.0.2303.66 at
    C:\NugetStore\Microsoft.AzureStack.Role.SBE.4.0.2303.66\Microsoft.AzureStack.Role.SBE.nuspec.
    VERBOSE: SolutionExtension module supports Tag 'HealthServiceIntegration'.
    VERBOSE: SolutionExtension module SolutionExtension at
    C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\CloudMedia\SBE\Installed\Content\Configuration\SolutionExtension is valid.
    VERBOSE: Looking up shared vhd product drive letter.
    WARNING: Unable to find volume with label Deployment
    VERBOSE: Get-Package returned with Success:True
    VERBOSE: Found package Microsoft.AzureStack.Role.SBE with version 4.0.2303.66 at
    C:\NugetStore\Microsoft.AzureStack.Role.SBE.4.0.2303.66\Microsoft.AzureStack.Role.SBE.nuspec.
    VERBOSE: SolutionExtension module supports Tag 'HealthServiceIntegration'.
    VERBOSE: SolutionExtension module SolutionExtension at
    C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\CloudMedia\SBE\Installed\Content\Configuration\SolutionExtension is valid.
   PS C:\Users\lcmuser> $result|ft Name,Status,Severity
    
    Name                                    Status  Severity
    ----                                    ------  --------
    Storage Pool Summary                    SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Physical Disks Summary SUCCESS CRITICAL
    Storage Services Summary                SUCCESS CRITICAL
    Storage Services Summary                SUCCESS CRITICAL
    Storage Services Summary                SUCCESS CRITICAL
    Storage Subsystem Summary               SUCCESS CRITICAL
    Test-CauSetup                           SUCCESS INFORMATIONAL
    Test-CauSetup                           SUCCESS INFORMATIONAL
    Test-CauSetup                           SUCCESS INFORMATIONAL
    Test-CauSetup                           SUCCESS INFORMATIONAL
    Test-CauSetup                           SUCCESS CRITICAL
    Test-CauSetup                           SUCCESS INFORMATIONAL
    Test-CauSetup                           SUCCESS INFORMATIONAL
    Test-CauSetup                           SUCCESS INFORMATIONAL
    Test-CauSetup                           FAILURE INFORMATIONAL
    Test-CauSetup                           FAILURE INFORMATIONAL
    Test-CauSetup                           FAILURE INFORMATIONAL
    Storage Volume Summary                  SUCCESS CRITICAL
    Storage Volume Summary                  SUCCESS CRITICAL
    Storage Volume Summary                  SUCCESS CRITICAL
    Storage Volume Summary                  SUCCESS CRITICAL
    Storage Virtual Disk Summary            SUCCESS CRITICAL
    Storage Virtual Disk Summary            SUCCESS CRITICAL
    Storage Virtual Disk Summary            SUCCESS CRITICAL
    Storage Virtual Disk Summary            SUCCESS CRITICAL
    Get-OneNodeRebootRequired               SUCCESS WARNING
    Test-NonMigratableVMs                   SUCCESS WARNING
    Faults                                  SUCCESS INFORMATIONAL
    Test-SBEHealthStatusOnNode              Success Informational
    Test-SBEHealthStatusOnNode              Success Informational
    Storage Job Summary                     SUCCESS CRITICAL
    Storage Cluster Shared Volume Summary   SUCCESS CRITICAL
    Storage Cluster Shared Volume Summary   SUCCESS CRITICAL
    Storage Cluster Shared Volume Summary   SUCCESS CRITICAL
    Test-SBEPrecheckStatus                  Success Informational  
    
    PS C:\Users\lcmuser>
    ```

    > [!NOTE]
    > In this release, the informational failures for `Test-CauSetup` are expected and will not impact the updates.

3. Review any failures and resolve them before you proceed to the discovery step.

## Step 3: Discover the updates

You can discover updates in one of the following two ways:

- **Discover updates online** - The recommended option when your cluster has good internet connectivity. The solution updates are discovered via the online update catalog.
- **Sideload and discover updates** - An alternative to discovering updates online and should be used for scenarios with unreliable or slow internet connectivity, or when using solution extension updates provided by your hardware vendor. In these instances, you download the solution updates to a central location. You then sideload the updates to an Azure Stack HCI cluster and discover the updates locally.

### Discover solution updates online (recommended)

Discovering solution updates using the online catalog is the *recommended* method. Follow these steps to discover solution updates online:

1. Connect to a server on your Azure Stack HCI cluster using the deployment user account.
2. Verify that the Update service discovers the update package.

    ```powershell
    Get-SolutionUpdate | ft DisplayName, State 
    ```

3. Optionally review the versions of the update package components.

    ```powershell
    $Update = Get-SolutionUpdate | ? version -eq "10.2302.0.31"
    $Update.ComponentVersions
    ```

    Here's an example output:

    ```console
     PS C:\Users\lcmuser> $Update = Get-SolutionUpdate | ? version -eq "10.2302.0.31"
     PS C:\Users\lcmuser> $Update.ComponentVersions
    
    PackageType Version      LastUpdated
    ----------- -------      -----------
    Services    10.2303.0.31
    Platform    10.2303.0.31
    SBE         4.1.2.3
     PS C:\Users\lcmuser>
    ```

You can now proceed to [Download and install the updates](#step-4-download-check-readiness-and-install-updates).

### Sideload and discover solution updates

If you're using solution extension updates from your hardware, you would need to sideload those updates. Follow these steps to sideload and discover your solution updates.

1. Connect to a server on your Azure Stack HCI cluster using the deployment user account.
2. Go to the network share and acquire the update package that you use. Verify that the update package you sideload contains the following files:
    - *SolutionUpdate.xml*
    - *SolutionUpdate.zip*
    - *AS_Update_10.2303.4.1.zip*

    If a solution builder extension is part of the update package, you should also see the following files:
    - *SBE_Content_4.1.2.3.xml*
    - *SBE_Content_4.1.2.3.zip*
    - *SBE_Discovery_Contoso.xml*

3. Create a folder for discovery by the update service at the following location in the infrastructure volume of your cluster.

    ```powershell
    New-Item C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\sideload -ItemType Directory 
    ```

4. Copy the update package to the folder you created in the previous step.
5. Manually discover the update package using the Update service. Run the following command:

    ```powershell
    Add-SolutionUpdate -SourceFolder C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\sideload
    ```

6. Verify that the Update service discovers the update package and that it's available to start preparation and installation.

    ```powershell
    Get-SolutionUpdate | ft DisplayName, Version, State 
    ```

    Here's an example output:

    ```console
     PS C:\Users\lcmuser> Get-SolutionUpdate | ft DisplayName, Version, State
    
    DisplayName                 Version      State
    -----------                 -------      -----
    2023.03 Feature Update 10.2303.0.31 Ready

     PS C:\Users\lcmuser>
    ```

7. Optionally check the version of the update package components. Run the following command:

    ```powershell
    $Update = Get-SolutionUpdate | ? version -eq "10.2302.0.31"
    $Update.ComponentVersions 
    ```

    Here's an example output:

    ```console
     PS C:\Users\lcmuser> $Update = Get-SolutionUpdate | ? version -eq "10.2302.0.31"
     PS C:\Users\lcmuser> $Update.ComponentVersions
    
    PackageType Version      LastUpdated
    ----------- -------      -----------
    Services    10.2303.0.31
    Platform    10.2303.0.31
    SBE         4.1.2.3
     PS C:\Users\lcmuser>
    ```

## Step 4: Download, check readiness, and install updates

You can download the updates, perform a set of checks to verify your cluster's update readiness, and start installing the updates.

1. You can only download the update without starting the installation or download and install the update.

    - To download and install the update, run the following command:

        ```powershell
        Get-SolutionUpdate | ? version -eq "10.2302.0.31"
        ```

    - To only download the updates without starting the installation, use the `-PrepareOnly` flag with `Start-SolutionUpdate`.

2. To track the update progress, monitor the update state. Run the following command:

    ```powershell
    Get-SolutionUpdate | ft Version,State,UpdateStateProperties,HealthState 
    ```

    When the update starts, the following actions occur:

    - Download of the updates begins. Depending on the size of the download package and the network bandwidth, the download might take several minutes.

        Here's an example output when the updates are being downloaded:

        ```console
          PS C:\Users\lcmuser> Get-SolutionUpdate|ft Version,State,UpdateStateProperties,HealthState

        Version              State UpdateStateProperties HealthState
        -------              ----- --------------------- -----------
        10.2303.4.1 Downloading                        InProgress
        ```

    - Once the package is downloaded, readiness checks are performed to assess the update readiness of your cluster. For more information about the readiness checks, see [Update phases](./update-phases-23h2.md#phase-2-readiness-checks-and-staging). During this phase, the **State** of the update shows as `HealthChecking`.

        ```console
        PS C:\Users\lcmuser> Get-SolutionUpdate|ft Version,State,UpdateStateProperties,HealthState

        Version              State UpdateStateProperties HealthState
        -------              ----- --------------------- -----------
        10.2303.4.1 HealthChecking                        InProgress
        ```

    - When the system is ready, updates are installed. During this phase, the **State** of the updates shows as `Installing` and `UpdateStateProperties` shows the percentage of the installation that was completed.

        > [!IMPORTANT]
        > During the install, the cluster servers may reboot and you may need to establish the remote PowerShell session again to monitor the updates. If updating a single server, your Azure Stack HCI will experience a downtime.

        Here's a sample output while the updates are being installed.

        ```console
        PS C:\Users\lcmuser> Get-SolutionUpdate|ft Version,State,UpdateStateProperties,HealthState

        Version          State UpdateStateProperties HealthState
        -------          ----- --------------------- -----------
        10.2303.4.1 Installing 6% complete.              Success
        
        
        PS C:\Users\lcmuser> Get-SolutionUpdate|ft Version,State,UpdateStateProperties,HealthState
        
        Version          State UpdateStateProperties HealthState
        -------          ----- --------------------- -----------
        10.2303.4.1 Installing 25% complete.             Success

        PS C:\Users\lcmuser> Get-SolutionUpdate|ft Version,State,UpdateStateProperties,HealthState
        
        Version          State UpdateStateProperties HealthState
        -------          ----- --------------------- -----------
        10.2303.4.1 Installing 40% complete.             Success

        PS C:\Users\lcmuser> Get-SolutionUpdate|ft Version,State,UpdateStateProperties,HealthState
        
        Version          State UpdateStateProperties HealthState
        -------          ----- --------------------- -----------
        10.2303.4.1 Installing 89% complete.             Success
        ```

Once the installation is complete, the **State** changes to `Installed`. For more information on the various states of the updates, see [Installation progress and monitoring](./update-phases-23h2.md#phase-3-installation-progress-and-monitoring).

## Step 5: Verify the installation

After the updates are installed, verify the solution version of the environment and the operating system version.

1. After the update is in `Installed` state, check the environment solution version. Run the following command:

    ```powershell
    Get-SolutionUpdateEnvironment | ft State, CurrentVersion
    ```

    Here's a sample output:

    ```console
    PS C:\Users\lcmuser> Get-SolutionUpdateEnvironment | ft State, CurrentVersion
    
    State               CurrentVersion
    -----               --------------
    AppliedSuccessfully 10.2303.0.31
        
    ```

2. Check the operating system version to confirm it matches the recipe you installed. Run the following command:

    ```powershell
    cmd /c ver
    ```

    Here's a sample output:

    ```console
    PS C:\Users\lcmuser> cmd /c ver
    
    Microsoft Windows [Version 10.0.20349.1547]
    PS C:\Users\lcmuser>
    ```

## Troubleshoot updates

To resume a previously failed update run via PowerShell, use the following command:

```powershell
get-solutionupdate | start-solutionupdate
```

To resume a previously failed update due to update health checks in a **Warning** state, use the following command:

```powershell
get-solutionUpdate | start-solutionUpdate -IgnoreWarnings
```

To troubleshoot other update run issues, see [Troubleshoot updates](./update-troubleshooting-23h2.md).

## Next step

Learn more about how to [Update Azure Stack HCI clusters, version 22H2](../manage/update-cluster.md) when the orchestrator isn't installed.
