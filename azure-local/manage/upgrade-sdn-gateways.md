---
title: Upgrade Gateways in Software Defined Networking (SDN) Managed by On-Premises Tools
description: Learn how to upgrade gateways for SDN managed by on-premises tools.
ms.topic: how-to
ms.author: ronmiab
author: robess
ms.date: 04/08/2026
ms.subservice: hyperconverged
---

# Update SDN gateway

This article describes the procedure for safely updating SDN Gateway VMs with minimal disruption to network connectivity. The update process handles redundant and active gateways differently to ensure continuous service availability.

## SDN gateway update process workflow

The gateway update process follows a three-phase approach:

1. **Phase 1: Identify Gateway Roles**
   - Query Network Controller to retrieve all gateway VMs
   - Categorize gateways by state: **redundant** (standby) vs **active** (hosting connections)
   - Document the original gateway roles before starting updates
1. **Phase 2: Update Redundant Gateways First**
   - Redundant gateways do not host active connections, so they can be updated with minimal impact
   - Each redundant gateway must be removed from Network Controller before updating
   - Removing the gateway from SDN prevents Gateway Manager from interfering with the VM during updates (e.g., triggering unexpected reboots)
   - After Windows updates are installed, the gateway must be re-added to the Network Controller pool
1. **Phase 3: Update Active Gateways**
   - Active gateways host live network connections and virtual gateways
   - Before updating, the active gateway must be rebooted to trigger tunnel failover to redundant gateways
   - After the reboot, the previously active gateway transitions to redundant state
   - Once transitioned to redundant state, the gateway must be removed from Network Controller
   - This removal ensures Gateway Manager does not interfere during the Windows update process
   - After Windows updates are installed, the gateway must be re-added to the pool as a redundant gateway

> [!NOTE]
> The document uses the `SdnDiagnostics` PowerShell module to interact with the Network Controller REST API for adding or removing gateways throughout this procedure.

## Key considerations

- Always remove a gateway from Network Controller before performing Windows updates to prevent SDN Gateway Manager from interfering with the VM (such as triggering reboots at unexpected times).

- Never update or remove an active gateway directly. Always ensure the active gateway transitions to redundant state first before proceeding with the update.

- All steps in this procedure should be executed from a physical host in the cluster that has network access to both the Network Controller REST API and the gateway VMs via WinRM.

## Prerequisites

- **Network Controller update** - Network Controller VMs must have the same Windows update installed and Network Controller application update must be completed
- **Infrastructure health** - SDN infrastructure must be healthy and the existing gateway connections must be operational and healthy
- Access to Network Controller REST API
- Administrative credentials for gateway VMs
- At least one redundant gateway available in the gateway pool
  > [!WARNING]
  > If no redundant gateway is configured, updating active gateways may cause extended traffic disruptions as tunnels may not failover during the update process
- Windows updates (MSU files) staged and ready
- Monitoring tools to verify tunnel connectivity and BGP status *(optional but highly recommended)*
  - These are user-provided tools specific to your environment for validating workload connectivity
- **SdnDiagnostics PowerShell module** - The code snippets in this document use cmdlets from the SdnDiagnostics module

## Install SdnDiagnostics Module

Install the latest version of SdnDiagnostics from PowerShell Gallery:

    # Install SdnDiagnostics module from PowerShell Gallery
    Install-Module -Name SdnDiagnostics -Force -AllowClobber

    # Verify installation
    Get-Module -Name SdnDiagnostics -ListAvailable

    # Import the module
    Import-Module SdnDiagnostics

For more information, visit: <https://github.com/microsoft/SdnDiagnostics>

## Update process

> [!IMPORTANT]
> The code snippets provided in this section are for reference purposes only and must be customized for your environment before execution. Read the comments in each snippet of code carefully as they contain important guidance. Additionally, variables defined in one step may be used in subsequent steps, so all snippets should be executed from the same PowerShell terminal session to preserve variable state.

### Phase 1: Identify gateway roles

1.  **Get the list of current gateways**
    - Query Network Controller to retrieve all gateway VMs
    - Note down which gateways are **redundant** and which are **active**
    - Active gateways host active network connections/tunnels
    - Redundant gateways are standby and do not host active connections

<!-- -->

    # Set up variables
    $NcUri = "https://nc.contoso.com"  # Replace with your Network Controller URI
    $credential = Get-Credential # Administrative credentials for gateway VMs

    # Get all gateways
    $allGateways = Get-SdnGateway -NcUri $NcUri

    # Categorize gateways by state
    $redundantGateways = $allGateways | Where-Object { $_.properties.state -eq "Redundant" }
    $activeGateways = $allGateways | Where-Object { $_.properties.state -eq "Active" }

    # Display results
    Write-Host "Redundant Gateways:" -ForegroundColor Green
    $redundantGateways | Select-Object resourceId, @{Name="State";Expression={$_.properties.state}}, @{Name="HealthState";Expression={$_.properties.healthState}} | Format-Table

    Write-Host "Active Gateways:" -ForegroundColor Yellow
    $activeGateways | Select-Object resourceId, @{Name="State";Expression={$_.properties.state}}, @{Name="HealthState";Expression={$_.properties.healthState}}, @{Name="VirtualGatewayCount";Expression={$_.properties.virtualGateways.Count}} | Format-Table

### *1.3.2* Phase 2: Update Redundant Gateways

Start with redundant gateways as they do not host active connections, minimizing service disruption.

#### *1.3.2.1* Example Walkthrough

To illustrate the redundant gateway update process, consider this example with GW01 as a redundant gateway:

| Step | Action | GW01 State | Description |
|--|--|--|--|
| 1 | Backup & remove from Network Controller | **Redundant → (Not in Network Controller)** | Backup GW01 config; remove from Network Controller (triggers reboot of GW01); GW01 resource no longer exists in Network Controller |
| 2 | Verify removal | **(Not in Network Controller)** | Wait for reboot; verify GW01 is deleted from Network Controller |
| 3 | Install updates | **(Not in Network Controller)** | Perform Windows updates on GW01 |
| 4 | Re-add to Network Controller | **(Not in Network Controller) → Passive (Unmonitored)** | Add GW01 back to the gateway pool; initially joins in passive state |
| 5 | Verify healthy | **Passive (Unmonitored) → Redundant (Healthy)** | GW01 transitions to healthy redundant state |
| 6 | Next gateway | **Redundant (Healthy)** | Move to the next redundant gateway |

#### *1.3.2.2* Detailed Steps

For **each redundant gateway**:

1.  **Remove the gateway from the gateway pool**

    - Back up the gateway configuration to a JSON file for restoration later
    - Capture the last boot time before removal to detect reboot completion
    - Remove the gateway from Network Controller (triggers Gateway Manager to reboot the VM)

<!-- -->

    # Select a redundant gateway to update from the list captured in Phase 1
    # Replace with actual gateway name, 
    # or Use $redundantGateways[$i].resourceId where $i is the index of the gateway to update
    # IMPORTANT: If executing this step as part of Phase 3 (active gateway update), do NOT use $redundantGateways[$i].resourceId. Instead, set $gatewayToUpdate to the active gateway that has just transitioned to redundant state.
    $gatewayToUpdate = "GW1.contoso.com" 
    # Note: In SDNExpress deployments, the gateway resource ID in NetworkController matches the VM FQDN.
    # For custom deployments, adjust $resourceRef to use the correct resource ID.
    $resourceRef = "/Gateways/$gatewayToUpdate"

    # Get the gateway object
    $gateway = Get-SdnGateway -NcUri $NcUri -ResourceRef $resourceRef

    # Backup the gateway configuration
    $backupPath = "C:\GatewayBackups"
    if (-not (Test-Path $backupPath)) {
        New-Item -Path $backupPath -ItemType Directory -Force
    }
    $gateway | ConvertTo-Json -Depth 10 | Out-File -FilePath "$backupPath\$($gateway.resourceId).json" -Force
    Write-Host "Gateway configuration backed up to: $backupPath\$($gateway.resourceId).json"

    # Get last boot time before removal
    $lastBootTime = Invoke-Command -ComputerName $gatewayToUpdate -Credential $credential -ScriptBlock {
        (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
    }
    Write-Host "Last boot time: $lastBootTime"

    # Remove the gateway from the pool
    Set-SdnResource -NcUri $NcUri -ResourceRef $gateway.resourceRef -OperationType Delete -Confirm:$false
    Write-Host "Gateway removed from Network Controller pool at $(Get-Date)"

2.  **Verify gateway removal**
    - Wait for the VM to reboot.
    - After the VM reboots, perform a GET operation to ensure the gateway is deleted from NetworkController

<!-- -->

    # Wait for reboot (boot time should change)
    # Note: $lastBootTime was captured in the previous step when removing the gateway
    $maxWaitTime = 600  # 10 minutes
    $checkInterval = 15
    $elapsedTime = 0
    $rebooted = $false

    Write-Host "Waiting for gateway to reboot..."
    while ($elapsedTime -lt $maxWaitTime) {
        Start-Sleep -Seconds $checkInterval
        $elapsedTime += $checkInterval
        
        try {
            $currentBootTime = Invoke-Command -ComputerName $gatewayToUpdate -Credential $credential -ErrorAction Stop -ScriptBlock {
                (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
            }
            
            if ($currentBootTime -gt $lastBootTime) {
                Write-Host "Gateway rebooted successfully at $currentBootTime" -ForegroundColor Green
                $rebooted = $true
                break
            }
        }
        catch {
            # VM may be unreachable during reboot
        }
        
        Write-Host "Waiting... (elapsed: $elapsedTime seconds)"
    }

    # Verify gateway is removed from Network Controller
    try {
        $removedGateway = Get-SdnGateway -NcUri $NcUri -ResourceRef $resourceRef -ErrorAction SilentlyContinue
        if ($null -eq $removedGateway) {
            Write-Host "Verified: Gateway is removed from Network Controller" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "WARNING: Failed to verify gateway removaL. Error: $_" -ForegroundColor Yellow
    }

3.  **Perform Windows updates**
    - Install required updates (KBs) on the gateway VM
    - Reboot if necessary
    - *Customer performs this step manually*
4.  **Add the gateway back to the gateway pool**
    - Re-register the gateway with Network Controller
    - Gateway will rejoin the pool in a passive/unmonitored state

<!-- -->

    # Read the backup configuration
    $backupFile = "$backupPath\$gatewayToUpdate.json"
    $gatewayConfig = Get-Content -Path $backupFile | ConvertFrom-Json

    # Re-add the gateway to the pool
    Set-SdnResource -NcUri $NcUri -ResourceRef $gatewayConfig.resourceRef -Object $gatewayConfig -OperationType Add -Confirm:$false
    Write-Host "Gateway re-added to Network Controller pool at $(Get-Date)" -ForegroundColor Green

    # Verify gateway is back in the pool
    $verifyGateway = Get-SdnGateway -NcUri $NcUri -ResourceRef $resourceRef
    Write-Host "Gateway State: $($verifyGateway.properties.state)"
    Write-Host "Gateway Health State: $($verifyGateway.properties.healthState)"

5.  **Wait for gateway to become redundant**
    - Verify the gateway has successfully transitioned to redundant state
    - Ensure health checks pass before proceeding

<!-- -->

    # Wait for gateway to become healthy
    $maxWaitTime = 600  # 5 minutes
    $checkInterval = 10
    $elapsedTime = 0
    $isHealthy = $false

    Write-Host "Waiting for gateway to become Healthy..."
    while ($elapsedTime -lt $maxWaitTime) {
        $gateway = Get-SdnGateway -NcUri $NcUri -ResourceRef $resourceRef
        $healthState = $gateway.properties.healthState
        $state = $gateway.properties.state
        
        Write-Host "Current State: $state, Health State: $healthState (elapsed: $elapsedTime seconds)"
        
        if ($healthState -eq "Healthy" -and $state -eq "Redundant") {
            Write-Host "Gateway is now Healthy and Redundant!" -ForegroundColor Green
            $isHealthy = $true
            break
        }
        
        Start-Sleep -Seconds $checkInterval
        $elapsedTime += $checkInterval
    }

    if (-not $isHealthy) {
        Write-Host "WARNING: Gateway did not become Healthy within timeout" -ForegroundColor Yellow
    }

6.  **Move to the next redundant gateway**
    - Repeat steps 1-5 for each remaining redundant gateway

### *1.3.3* Phase 3: Update Active Gateways

After all redundant gateways are updated, proceed with active gateways. This phase requires careful handling to ensure tunnel failover works correctly.

**Important Note:** When an active gateway is rebooted and updated, it will transition to a redundant state. This means subsequent active gateways may change roles during the update process. **Always refer to the original list of active gateways from Phase 1** when selecting the next gateway to update, rather than re-querying the current state. This ensures you update all originally active gateways in a predictable order.

#### *1.3.3.1* Example Walkthrough

To illustrate the active gateway update process, consider this example with GW01 as an active gateway, and GW05 as the redundant gateway:

| Step | Action | GW01 State | GW05 State | Description |
|----|----|----|----|----|
| 1 | Document tunnels | **Active** | Redundant | Record all virtual gateways and connections hosted on GW01 |
| 2 | Reboot GW01 | **Active → Rebooting** | Redundant → **Active** | Triggers tunnel failover; GW05 is promoted to active and takes over tunnels |
| 3 | Verify failover | **Redundant** | **Active** | GW01 comes back online as redundant; tunnels now hosted on GW05 |
| 4 | Test connectivity | **Redundant** | **Active** | Verify tunnels are connected on GW05 |
| 5 | Backup & remove GW01 from Network Controller | **Redundant → (Not in Network Controller)** | **Active** | Backup GW01 config; remove from Network Controller (triggers reboot of GW01); GW01 resource no longer exists in Network Controller |
| 6 | Verify removal | **(Not in Network Controller)** | **Active** | Wait for reboot of GW01; verify GW01 is deleted from Network Controller |
| 7 | Install updates | **(Not in Network Controller)** | **Active** | Perform Windows updates on GW01 |
| 8 | Re-add to Network Controller | **(Not in Network Controller) → Passive (Unmonitored)** | **Active** | Add GW01 back to the gateway pool; initially joins in passive state |
| 9 | Verify healthy | **Passive (Unmonitored) → Redundant (Healthy)** | **Active** | GW01 transitions to healthy redundant state |
| 10 | Next gateway | **Redundant** | Active | Move to the next active gateway from the Phase 1 list |

#### *1.3.3.2* Detailed Steps

For **each active gateway**:

1.  **Get the list of tunnels hosted on the gateway VM**
    - Document all active network connections and virtual gateways
    - Note the tunnel states and BGP peer information

<!-- -->

    # Select a active gateway to update from the list captured in Phase 1
    # Replace with actual gateway name, 
    # or Use $activeGateways[$i].resourceId where $i is the index of the gateway to update
    $activeGatewayToUpdate = "GW2.contoso.com"
    # Note: In SDNExpress deployments, the gateway resource ID in NetworkController matches the VM FQDN.
    # For custom deployments, adjust $resourceRef to use the correct resource ID.
    $resourceRef = "/Gateways/$activeGatewayToUpdate"

    # Get the gateway object
    $activeGateway = Get-SdnGateway -NcUri $NcUri -ResourceRef $resourceRef

    # Display virtual gateways hosted on this gateway with connection and BGP status
    Write-Host "Virtual Gateways hosted on $activeGatewayToUpdate :" -ForegroundColor Yellow
    $virtualGateways = @()
    foreach ($vgwRef in $activeGateway.properties.virtualGateways) {
        $vgwResourceId = $vgwRef.virtualGateway.resourceRef.Split("/") | Select-Object -Last 1
        $virtualGateways += $vgwResourceId
        
        # Get full virtual gateway details
        $vgw = Get-SdnResource -NcUri $NcUri -ResourceRef "/VirtualGateways/$vgwResourceId"
        
        Write-Host "  VGW: $vgwResourceId" -ForegroundColor Cyan
        
        # Display network connection status
        foreach ($nc in $vgw.properties.networkConnections) {
            $connState = $nc.properties.connectionState
            Write-Host "    Network Connection: $($nc.resourceId)"
            Write-Host "      Connection State: $connState"
        }
        
        # Display BGP router and peer status
        foreach ($bgpRouter in $vgw.properties.bgpRouters) {
            Write-Host "    BGP Router: $($bgpRouter.resourceId)"
            foreach ($bgpPeer in $bgpRouter.properties.bgpPeers) {
                $bgpConnState = $bgpPeer.properties.connectionState
                Write-Host "      BGP Peer: $($bgpPeer.resourceId)"
                Write-Host "        Connection State: $bgpConnState"
            }
        }
    }

    Write-Host "`nTotal Virtual Gateways: $($virtualGateways.Count)" -ForegroundColor Yellow

2.  **Reboot the gateway VM**
    - This triggers a tunnel failure for all connections on this gateway
    - Gateway Manager will automatically promote one of the redundant gateways to active
    - All tunnels from the rebooted gateway will be moved to the newly promoted active gateway

<!-- -->

    # Reboot the active gateway
    Write-Host "Rebooting Active Gateway $activeGatewayToUpdate - this will trigger tunnel failover!" -ForegroundColor Red
    Restart-Computer -ComputerName $activeGatewayToUpdate -Credential $credential -Force

    Write-Host "Gateway reboot initiated at $(Get-Date)" -ForegroundColor Yellow
    Write-Host "Tunnels will failover to a redundant gateway..."

3.  **Verify tunnel failover**
    - Ensure all tunnels are now active and connected on the new gateway
    - Verify BGP peering is re-established
    - Confirm connectivity is restored for all affected connections
    - The rebooted gateway VM will transition to redundant state

<!-- -->

    # Wait for the gateway to come back online and check its state
    $maxWaitTime = 600  # 10 minutes
    $checkInterval = 15
    $elapsedTime = 0
    $transitionedToRedundant = $false

    Write-Host "`nWaiting for gateway to transition to Redundant state..."
    while ($elapsedTime -lt $maxWaitTime) {
        Start-Sleep -Seconds $checkInterval
        $elapsedTime += $checkInterval
        
        try {
            # Check if VM is back online
            $null = Test-NetConnection -ComputerName $activeGatewayToUpdate -CommonTCPPort WINRM -InformationLevel Quiet -ErrorAction Stop
            
            # Check gateway state in Network Controller
            $currentGateway = Get-SdnGateway -NcUri $NcUri -ResourceRef $resourceRef -ErrorAction Stop
            $currentState = $currentGateway.properties.state
            
            Write-Host "Gateway State: $currentState (elapsed: $elapsedTime seconds)"
            
            if ($currentState -eq "Redundant") {
                Write-Host "Gateway successfully transitioned to Redundant state!" -ForegroundColor Green
                $transitionedToRedundant = $true
                break
            }
        }
        catch {
            Write-Host "Gateway not yet ready... (elapsed: $elapsedTime seconds)"
        }
    }

    # Verify virtual gateways have moved to other active gateways
    Write-Host "`nVerifying virtual gateway placement and BGP status..."
    foreach ($vgwId in $virtualGateways) {
        try {
            $vgw = Get-SdnResource -NcUri $NcUri -ResourceRef "/VirtualGateways/$vgwId"
            
            Write-Host "  VGW: $vgwId" -ForegroundColor Cyan
            
            # Check network connections
            foreach ($nc in $vgw.properties.networkConnections) {
                $connState = $nc.properties.connectionState
                $gatewayRef = $nc.properties.gateway.resourceRef
                $gatewayName = $gatewayRef.Split("/") | Select-Object -Last 1
                
                Write-Host "    Network Connection: $($nc.resourceId)"
                Write-Host "      Connection State: $connState"
                Write-Host "      Now on Gateway: $gatewayName"
                
                if ($connState -eq "Connected") {
                    Write-Host "      Status: OK" -ForegroundColor Green
                } else {
                    Write-Host "      Status: WARNING - Not connected" -ForegroundColor Yellow
                }
            }
            
            # Check BGP router and peer status
            foreach ($bgpRouter in $vgw.properties.bgpRouters) {
                Write-Host "    BGP Router: $($bgpRouter.resourceId)"
                foreach ($bgpPeer in $bgpRouter.properties.bgpPeers) {
                    $bgpConnState = $bgpPeer.properties.connectionState
                    Write-Host "      BGP Peer: $($bgpPeer.resourceId)"
                    Write-Host "        Connection State: $bgpConnState"
                    
                    if ($bgpConnState -eq "Connected") {
                        Write-Host "        Status: OK" -ForegroundColor Green
                    } else {
                        Write-Host "        Status: WARNING - BGP not connected" -ForegroundColor Yellow
                    }
                }
            }
        }
        catch {
            Write-Host "  Failed to get info for VGW $vgwId : $_" -ForegroundColor Red
        }
    }

4.  **Test connectivity to workload endpoints**
    - Use your existing monitoring tools to validate traffic flow to critical workload endpoints
    - Ensure tunnels are operational before proceeding to the next steps
    - Focus on testing connectivity for the tunnels that were moved from the rebooted gateway to the new active gateway
5.  **Update the now-redundant gateway**
    - Follow the redundant gateway update procedure (Phase 2, steps 1-5)
    - Remove from pool, update Windows, add back to pool, verify redundant state

> **Note:** When using the scripts from Phase 2 procedure, ensure that **gatewayToUpdate** is set to this now-redundant gateway (the one that was previously active and has just transitioned to redundant state).

    Write-Host "`nThe gateway is now Redundant. Follow Phase 2 steps to:" -ForegroundColor Cyan
    Write-Host "  1. Remove gateway from pool (will trigger another reboot)"
    Write-Host "  2. Verify removal"
    Write-Host "  3. Perform Windows updates manually"
    Write-Host "  4. Add gateway back to pool"
    Write-Host "  5. Wait for healthy redundant state"
    Write-Host "`nRefer to Phase 2 code snippets for detailed steps."

6.  **Proceed to the next active gateway**
    - Repeat steps 1-5 for each remaining active gateway

## *1.4* Post-Update Verification

After all gateways are updated:

1.  **Verify all gateways are online**
    - Check that all gateway VMs are registered with Network Controller
    - Confirm proper distribution of redundant and active gateways

<!-- -->

    # Get all gateways and display their status
    $allGateways = Get-SdnGateway -NcUri $NcUri

    Write-Host "`n========== Gateway Status Summary ==========" -ForegroundColor Cyan
    Write-Host "Total Gateways: $($allGateways.Count)" -ForegroundColor Cyan

    $redundantCount = ($allGateways | Where-Object { $_.properties.state -eq "Redundant" }).Count
    $activeCount = ($allGateways | Where-Object { $_.properties.state -eq "Active" }).Count

    Write-Host "Redundant Gateways: $redundantCount" -ForegroundColor Green
    Write-Host "Active Gateways: $activeCount" -ForegroundColor Yellow

    Write-Host "`nDetailed Gateway Status:" -ForegroundColor Cyan
    $allGateways | Select-Object resourceId, @{Name="State";Expression={$_.properties.state}}, @{Name="HealthState";Expression={$_.properties.healthState}}, @{Name="VirtualGateways";Expression={$_.properties.virtualGateways.Count}} | Format-Table -AutoSize

2.  **Verify connectivity**
    - Test all network connections and virtual gateways
    - Confirm BGP peering is stable across all connections

<!-- -->

    # Get all virtual gateways and check connection states
    $allVirtualGateways = Get-SdnResource -NcUri $NcUri -ResourceRef "/VirtualGateways"

    Write-Host "`n========== Virtual Gateway Connection Status ==========" -ForegroundColor Cyan
    $connectionIssues = 0
    $bgpIssues = 0

    foreach ($vgw in $allVirtualGateways) {
        Write-Host "VGW: $($vgw.resourceId)" -ForegroundColor Cyan
        
        # Check network connections
        foreach ($nc in $vgw.properties.networkConnections) {
            $connState = $nc.properties.connectionState
            $connStatus = $nc.properties.configurationState.status
            $gatewayRef = $nc.properties.gateway.resourceRef
            $gatewayName = $gatewayRef.Split("/") | Select-Object -Last 1
            
            $status = "OK"
            $color = "Green"
            
            if ($connState -ne "Connected" -or $connStatus -ne "Success") {
                $status = "ISSUE"
                $color = "Red"
                $connectionIssues++
            }
            
            Write-Host "  Network Connection: $($nc.resourceId)" -ForegroundColor $color
            Write-Host "    Gateway: $gatewayName" -ForegroundColor $color
            Write-Host "    Connection State: $connState" -ForegroundColor $color
            Write-Host "    Config Status: $connStatus" -ForegroundColor $color
            Write-Host "    Status: $status" -ForegroundColor $color
        }
        
        # Check BGP router and peer status
        foreach ($bgpRouter in $vgw.properties.bgpRouters) {
            Write-Host "  BGP Router: $($bgpRouter.resourceId)"
            foreach ($bgpPeer in $bgpRouter.properties.bgpPeers) {
                $bgpConnState = $bgpPeer.properties.connectionState
                
                $bgpStatus = "OK"
                $bgpColor = "Green"
                
                if ($bgpConnState -ne "Connected") {
                    $bgpStatus = "ISSUE"
                    $bgpColor = "Red"
                    $bgpIssues++
                }
                
                Write-Host "    BGP Peer: $($bgpPeer.resourceId)" -ForegroundColor $bgpColor
                Write-Host "      Connection State: $bgpConnState" -ForegroundColor $bgpColor
                Write-Host "      Status: $bgpStatus" -ForegroundColor $bgpColor
            }
        }
        Write-Host ""
    }

    if ($connectionIssues -eq 0 -and $bgpIssues -eq 0) {
        Write-Host "All virtual gateway connections and BGP peers are healthy!" -ForegroundColor Green
    } else {
        if ($connectionIssues -gt 0) {
            Write-Host "WARNING: Found $connectionIssues network connection issue(s)" -ForegroundColor Red
        }
        if ($bgpIssues -gt 0) {
            Write-Host "WARNING: Found $bgpIssues BGP peer issue(s)" -ForegroundColor Red
        }
    }

3.  **Test connectivity to workload endpoints**
    - Use your existing monitoring tools to validate traffic flow to critical workload endpoints
    - Verify that applications are functioning correctly through the gateway connections

## *1.5* Important Notes

- **Always update redundant gateways first** before touching active gateways
- **Only remove one gateway from the pool at a time** to maintain redundancy
- **Wait for each gateway to fully stabilize** before moving to the next
- **Document the original gateway roles** before starting the update process
- **Schedule updates during maintenance windows** to minimize impact
