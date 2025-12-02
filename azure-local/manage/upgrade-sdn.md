---
title: Upgrade Infrastructure for Software Defined Networking (SDN) Managed by On-Premises Tools
description: Learn how to upgrade infrastructure for SDN managed by on-premises tools.
ms.topic: how-to
ms.author: alkohli
author: alkohli
ms.date: 12/02/2025
---

# Upgrade infrastructure for Software Defined Networking managed by on-premises tools

> Applies to: Azure Local 2311.2 and later; Windows Server 2025, Windows Server 2022

This article provides guidance on safely and securely upgrading infrastructure for Software Defined Networking (SDN) managed by on-premises tools. It also provides troubleshooting guidance to help remediate issues that might occur during the upgrade process.

> [!IMPORTANT]
> Do not use this article for upgrading SDN enabled by Azure Arc on Azure Local. Instead, refer to [About Azure Local upgrades](../upgrade/about-upgrades-23h2.md).

## About upgrading SDN infrastructure

Your SDN deployment consists of several roles and machines, each providing essential services for your environment. To keep your environment secure and up to date, it's required to upgrade the SDN infrastructure, one node at a time.

## Before you begin

- Download the ISO image for performing the in-place upgrade.

    - For Azure Local, see [Download operating system for Azure Local deployment](../deploy/download-23h2-software.md).

    - For Windows Server, see [Install Windows Server from installation media](/windows-server/get-started/install-windows-server).<!--verify the link-->

- Use [Unblock-File](/powershell/module/microsoft.powershell.utility/unblock-file) and copy the ISO to a file system that your Hyper-V hosts can access, or copy it manually to each Hyper-V host as needed.

- Install the `SdnDiagnostics` module on the machine where you'll perform the upgrade tasks:

    ```powershell
    # install or update SdnDiagnostics module
    # once we have installed or updated, we will remove any modules currently
    # from the runspace and import to ensure the latest module is imported
    if ($null -eq (get-module -ListAvailable -Name SdnDiagnostics)) {
    Install-Module -Name SdnDiagnostics
    } else {
    Update-Module -Name SdnDiagnostics
    }
    if (Get-Module -Name SdnDiagnostics){
    Remove-Module -Name SdnDiagnostics
    } else {
    Import-Module -Name SdnDiagnostics
    }
    ```

- After installation, retrieve current SDN fabric environment details and copy the `SdnDiagnostics` module into the environment:

    ```powershell
    $environmentInfo = Get-SdnEnvironmentInfo -NetworkController "<NC_VM>"
    Install-SdnDiagnostics -ComputerName $environmentInfo.FabricNodes
    ```

- Ensure sufficient space before proceeding. The in-place upgrade requires a minimum of 40 GB of available storage. For VMs, you can increase the VM's VHD size using Windows Admin Center. After resizing the VHD, adjust the partition within the VM using the [Resize-Partition](/powershell/module/storage/resize-partition) or [diskpart](/windows-server/administration/windows-commands/diskpart) commands.

## Key considerations

- Upgrade components in the following order:

    - Hyper-V Hosts
    - Network Controller nodes
    - Load Balancer Multiplexer nodes (optional)
    - Gateway nodes (optional)

- Upgrade the Network Controller to the latest version before proceeding. Older versions may contain known issues that can affect stability during the upgrade process.

- Do not upgrade the gateway until the Network Controller completes cleanup and reboots the gateway.

- Workloads that use Load Balancer Multiplexers (Internal Load Balancers, Load Balancers, Public IPs) or Gateways (Layer 3, Generic Routing Encapsulation (GRE), Site-to-Site connections) might experience temporary disruption while services fail over. Schedule the upgrade during a maintenance window and notify users in advance.

## Perform in-place upgrade

Use the steps in this section to perform an in-place upgrade of the existing OS. These steps apply to all SDN nodes.

### Mount the media

#### Mount-DiskImage for Hyper-V hosts

If the ISO file is located on the local file system, you can mount it directly.

1. Locate the ISO file you downloaded earlier.

1. Run the following command to mount the ISO. Make sure to update the drive letter to one that is not already in use.

    ```powershell
    Mount-DiskImage -ImagePath "E:\<PATH_NAME>.ISO"
    ```

#### Add-VMDvdDrive for VMs

For an in-place upgrade on a VM, use Hyper-V to attach the ISO as a DVD drive to the VM directly. This approach reduces overhead required on the file system of the OS.

1. On the Hyper-V host where the VM resides, locate the ISO file that you downloaded earlier.

1. Attach the ISO as a DVD drive:

    ```powershell
    Add-VMDvdDrive -VMName "<VM_NAME>" -Path "<DRIVE>:\<PATH>.ISO"
    ```

### Start the upgrade

1. Check the OS version before the upgrade:

    ```powershell
    # Check the OS version BEFORE OS Upgrade:
    Get-ComputerInfo | Select-Object WindowsProductName, WindowsInstallationType, OSDisplayVersion, WindowsBuildLabEx | Format-Table -AutoSize
    ```

1. Initiate the upgrade. The upgrade process will take a while, and the node may reboot several times. For more information regarding command line options, see [Windows Setup Command-Line Options](/windows-hardware/manufacture/desktop/windows-setup-command-line-options).

    ```powershell
    $DVDDrive = "D:\" # update to the drive path the .ISO was mounted to
    $logDir = "C:\Temp\Upgrade-Logs"

    # Create a folder to store the upgrade logs:
    if(-not(Test-Path -Path $logDir -PathType Container)){
    $null = New-Item -Path $logDir -ItemType Directory
    }

    # /auto upgrade parameter to perform an in-place upgrade.
    # /dynamicupdate enables the download of updates during the upgrade process.
    # added " /quiet" and " /EULA accept" to arguments for the setup.exe command, to suppress the GUI and accept the EULA.

    Start-Process -FilePath "$DVDDrive\setup.exe" -ArgumentList "/auto upgrade /dynamicupdate enable /copylogs $logDir /quiet /eula accept"
    ```

1. Check the OS after the upgrade:

    ```powershell
    # Check the OS version AFTER OS has been upgraded:
    Get-ComputerInfo | Select-Object WindowsProductName, WindowsInstallationType, OSDisplayVersion, WindowsBuildLabEx | Format-Table -AutoSize
    ```

## Upgrade Hyper-V hosts

> [!IMPORTANT]
> If you deployed SDN on Azure Local, upgrade your Hyper-V hosts by following instructions in [About Azure Local upgrades](../upgrade/about-upgrades-23h2.md). Do not use the steps in this article for upgrading Hyper-V hosts.

The upgrade process varies depending on the roles and services in your environment. If you have Storage Spaces Direct, clustering, or similar features, complete the necessary maintenance tasks to take a node offline for the upgrade process.

If virtual machines (VMs) aren't using clustering, evaluate live migrating VMs to another host within the environment depending on capacity.

After you put the Hyper-V host in the maintenance mode, follow the steps in [Perform in-place upgrade](#perform-in-place-upgrade). Repeat this process for all Hyper-V hosts within your cluster.

## Upgrade Network Controller VMs (Service Fabric)

Before you upgrade or restart a Network Controller VM, disable it in the Service Fabric cluster.

Follow these steps on a remote computer that has WinRM connectivity to the Network Controller VMs.

1. Retrieve the current state of the Network Controller nodes:

    ```powershell
    Get-SdnServiceFabricNode -NetworkController "<NC_VM>" | FT NodeName, IpAddressOrFQDN, NodeStatus, HealthState, IsStopped -AutoSize
    ```

1. Disable the node from the Service Fabric quorum. This step ensures Service Fabric can migrate primary replicas to other nodes and keep partition databases in sync.

    ```powershell
    Disable-SdnServiceFabricNode -NetworkController "<NC_VM>" -NodeName "<Node_Name>"
    ```

1. After the node is safely disabled, perform the in-place upgrade [Perform in-place upgrade](#perform-in-place-upgrade).

1. After the node has completed the in-place upgrade, re-enable the node. This operation enables the node and waits until Service Fabric returns to a healthy state.

    ```powershell
    Enable-SdnServiceFabricNode -NetworkController "<NC_VM>" -NodeName "<Node_Name>"
    ```

    If the operation times out, wait and manually check the state:

    ```powershell
    Get-SdnServiceFabricNode -NetworkController "<NC_VM>" | FT NodeName, IpAddressOrFQDN, NodeStatus, HealthState, IsStopped -AutoSize

    Confirm-SdnServiceFabricHealthy -NetworkController "<NC_VM>"
    ```
    
      - If the commands return status healthy and node is up, repeat the process for other Network Controller nodes.
        
      - If the issue persists after an hour, see [Troubleshooting](#troubleshooting).

1. Repeat the process for all Network Controller nodes in your deployment.

### Perform Network Controller application update

After upgrading all Network Controller VMs, run the following command on one of the Network Controller VMs directly:

```powershell
Update-NetworkController
```

This command initiates an application upgrade if it was not automatically initiated.

## Upgrade Load Balancer Multiplexer VMs

You can upgrade Load Balancer Multiplexers without any additional requirements. To upgrade, proceed directly with [Perform in-place upgrade](#perform-in-place-upgrade) on each Load Balancer Multiplexer, one at a time.

## Upgrade Gateway VMs

> [!IMPORTANT]
> Ensure that Network Controller and Load Balancer Multiplexer VMs are already upgraded. If the VMs are not upgraded yet, do not proceed with upgrading Gateways.

1. Retrieve the current list of SDN Gateways:

    ```powershell
    $environmentInfo = Get-SdnEnvironmentInfo -NetworkController "<NC_VM>"
    Get-SdnGateway -NcUri $environmentInfo.NcUrl
    ```

1. Identify the Gateway VM to patch first, and remove its resource from the Network Controller using `SdnDiagnostics`:

    > [!IMPORTANT]
    > Gateway VMs should automatically reboot when removed from Network Controller. If the VM doesn't reboot within 10 minutes, investigate the Gateway VM status and ensure it has restarted before proceeding with the in-place upgrade.

    ```powershell

    $cred = Get-Credential
    # Record boot time before removing Gateway from Network Controller
    $bootTimeBefore = Invoke-Command -ComputerName "<GW_VM>" -Credential $cred -ScriptBlock {
    (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
    }
    Write-Host "Gateway boot time before removal: $bootTimeBefore"

    # Remove Gateway resource from Network Controller 
    $resourceRef = "/Gateways/<RESOURCE_ID>"
    $gateway = Get-SdnGateway -NcUri $environmentInfo.NcUrl -ResourceRef $resourceRef

    # create backup of the gateway
    $gateway | ConvertTo-Json -Depth 10 | Out-File -FilePath "$(Get-SdnWorkingDirectory)\$($gateway.resourceId).json"

    # delete the gateway resource
    Set-SdnResource -NcUri $environmentInfo.NcUrl -ResourceRef $gateway.resourceRef -OperationType Delete

    # Wait for Gateway VM to automatically reboot after removal from Network Controller
    Write-Host "Waiting for Gateway VM to reboot after removal from Network Controller..."
    $rebootTimeout = 600  # 10 minutes timeout
    $rebootCheck = 0
    $hasRebooted = $false

    do {
        Start-Sleep -Seconds 30
        $rebootCheck += 30
        try {
            $currentBootTime = Invoke-Command -ComputerName "<GW_VM>" -Credential $cred -ScriptBlock {
            (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
            }
            $hasRebooted = $currentBootTime -gt $bootTimeBefore
            if (!$hasRebooted) { 
            Write-Host "Gateway has not rebooted yet, checking again... (waited $rebootCheck/$rebootTimeout seconds)" 
            }
        }
        catch { 
            Write-Host "Gateway not yet accessible, checking again... (waited $rebootCheck/$rebootTimeout seconds)"
            $hasRebooted = $false 
        }
    } while (!$hasRebooted -and $rebootCheck -lt $rebootTimeout)

    if ($hasRebooted) {
        Write-Host "Gateway VM has rebooted successfully. New boot time: $currentBootTime" -ForegroundColor Green
    } else {
        Write-Error "Gateway VM did not reboot automatically within $rebootTimeout seconds. Manual intervention required."
        throw "Gateway reboot timeout - check Gateway VM status before proceeding with in-place upgrade"
    }
    ```

1. [Perform the in-place upgrade](#perform-in-place-upgrade).

1. Add the Gateway VM resource back to Network Controller:

    ```powershell
    # Add GW resource back to Network Controller 
    # update the filepath to the .json file that was generated in earlier step if variable not available
    $filePath = "$(Get-SdnWorkingDirectory)\$($gateway.resourceId).json"
    $dataObject = Get-Content -Path $filePath | ConvertFrom-Json 

    Set-SdnResource -NcUri $environmentInfo.NcUrl -ResourceRef $dataObject.resourceRef -Object $dataObject -OperationType Add

    # Wait for Gateway to become healthy after re-addition to Network Controller
        $healthTimeout = 300 # 5 minutes
        $healthCheck = 0
        do {
            Start-Sleep -Seconds 30
            $healthCheck += 30
            try {
                $gateway = Get-SdnGateway -NcUri $environmentInfo.NcUrl -ResourceRef $resourceRef
                $healthState = $gateway.properties.healthState
                Write-Host "Gateway health state: $healthState (waited $healthCheck seconds)"
                $isHealthy = $healthState -eq "Healthy"
            }
            catch {
                Write-Host "Error checking gateway health, retrying..."
                $isHealthy = $false
            }
        } while (!$isHealthy -and $healthCheck -lt $healthTimeout)

        if ($isHealthy) {
            Write-Host "Gateway is healthy and ready. Waiting 60 seconds for stabilization before next Gateway..."
            Start-Sleep -Seconds 60
        } else {
            Write-Warning "Gateway did not become healthy within $healthTimeout seconds. Check manually before proceeding."
        }
    ```

1. Repeat these steps for all Gateways.

## Troubleshooting

This section lists common issues that you might encounter during the upgrade process and their recommended remediations.

### Service Fabric node is not healthy

**Issue**

In some cases, the NetAdapter might get renamed during the upgrade. This causes issues as Network Controller node configuration requires the `RestInterface` to match the NetAdapter name on the VM.

**Remediation**

1. Verify that the NetAdapter on the Network Controller VM matches the configuration in NetworkController. For `-NetworkController`, specify a working Network Controller VM. For `-Name`, specify the non-working SDN node.

    ```powershell
    Get-SdnNetworkControllerNode -NetworkController "<WORKING NC_VM>" -Name "<BROKEN NC_VM>"
    ```

1. Note the `RestInterface` value from the output.

1. Connect to Network Controller VM and run `Get-NetAdapter` directly. Ensure the name matches the value returned in step 1.

    - If the adapter name is changed, check if the previous adapter is orphaned or ghosted.
    
        ```powershell
        Get-PnpDevice -class net | ? Status -eq Unknown | Select FriendlyName,InstanceId
        ```

    - If an orphaned adapter exists, remove it.
    
        ```powershell
        pnputil /remove-device "INSTANCE_ID"
        ```    

    - Rename the new adapter back to the original name using [Rename-NetAdapter](/powershell/module/netadapter/rename-netadapter).

### Unable to resolve FQDN of Network Controllers

**Issue**

In some cases, `unattend.xml` is applied for initial VM deployment with SdnExpress. If DNS servers have changed since the initial deployment, incorrect DNS servers can be programmed into the adapters, causing FQDN resolution failures.

**Remediation**

1. Verify that you can resolve the FQDN of other Network Controller nodes. Ensure that the FQDN resolution succeeds because Service Fabric relies on FQDN for communication.

    ```powershell
    Resolve-DnsName -Name "<NC NODE FQDN>" -Type A
    ```

1. If resolution fails, check the current DNS servers configured and confirm they match the configuration on other Network Controller VMs.

    ```powershell
    Get-DnsClientServerAddress
    ```

1. If DNS servers differ, update them using [Set-DnsClientServerAddress](/powershell/module/dnsclient/set-dnsclientserveraddress). If DNS servers are correct but resolution still fails, investigate your DNS infrastructure.

### Resources reporting configurationState failures

**Issue**

During the upgrade process, you might encounter any of the following failures:

- Load Balancer Multiplexer VMs reporting configurationState failure.

- Servers reporting configurationState failure.

- Virtual Networks reporting configurationState failure.

**Remediation**

These errors are typically transient and can be resolved by moving the Service Fabric replicas for the affected service. Perform this operation directly on a Network Controller VM that is enabled within the Service Fabric cluster.

```powershell
Move-SdnServiceFabricReplica -ServiceTypeName VSwitchService
Move-SdnServiceFabricReplica -ServiceTypeName GatewayManager
Move-SdnServiceFabricReplica -ServiceTypeName SlbManagerService
```


### Traffic is unable to traverse the Gateway connection

**Issue**

Due to known issues in certain builds, performing an update or upgrade might result in stale route mappings for specific address prefixes on the Gateway connection.

**Remediation**

If you encounter data-path routing issues and resources don't report failures, we recommend rebooting the Gateway VM that hosts the Virtual Gateway or Network Connection.