---
title: Update Gateways in Software Defined Networking (SDN) Managed by On-Premises Tools
description: Learn how to update gateways for SDN managed by on-premises tools.
ms.topic: how-to
ms.author: ronmiab
author: robess
ms.date: 04/08/2026
ms.subservice: hyperconverged
---

# Update SDN gateways

This article describes how to update SDN gateway virtual machines (VMs) with minimal disruption to network connectivity. The procedure updates redundant and active gateways in a controlled sequence to maintain service availability.

## SDN gateway update process workflow

The SDN gateway update process follows a three-phase approach:

1. **Phase 1: Identify gateway roles**
   - Query the Network Controller to retrieve all gateway VMs.
   - Identify each gateway’s role:
       - Redundant gateways (standby)
       - Active gateways (hosting live connections)
   - Record the original role of each gateway before starting the update process.

1. **Phase 2: Update redundant gateways**
   Redundant gateways don't host active connections and can be updated with minimal impact.
    - Remove each redundant gateway from the Network Controller. Removing the gateway prevents Gateway Manager from interfering with the VM during the update process (for example, triggering unexpected reboots).
    - Install the required Windows updates on the gateway VM.
    - Re‑add the updated gateway to the Network Controller pool.

1. **Phase 3: Update active gateways**
   Active gateways host live network connections and virtual gateways.
   - Reboot the active gateway to trigger tunnel failover to a redundant gateway.
   - After the reboot, verify that the gateway transitions to a redundant state.
   - Remove the gateway from the Network Controller. This removal prevents Gateway Manager from interfering during the Windows update process.
   - Install the required Windows updates.
   - Re‑add the gateway to the Network Controller pool as a redundant gateway.

> [!NOTE]
> This article uses the `SdnDiagnostics` PowerShell module to interact with the Network Controller REST API for adding or removing gateways throughout this procedure.

## Key considerations

## Key considerations

- Always remove a gateway from the Network Controller before applying Windows updates. This prevents SDN Gateway Manager from interfering with the VM (for example, triggering unexpected reboots).

- Never update or remove an active gateway directly. Ensure the active gateway first transitions to a redundant state before proceeding.

- Remove only one gateway at a time from the pool to maintain redundancy.

- Wait for each gateway to fully stabilize and rejoin the pool before moving to the next gateway.

- Document the original roles of all gateways before starting the update process.

- Schedule gateway updates during planned maintenance windows to minimize service impact.

## Prerequisites

- Run all steps in this procedure from a **physical host** in the cluster that has network access to:
    - The Network Controller REST API
    - The gateway VMs via WinRM

- **Network Controller update**
    - All Network Controller VMs must have the same Windows updates installed.
    - The Network Controller application update must be completed before updating gateways.

- **Infrastructure health**
    - The SDN infrastructure must be healthy.
    - Existing gateway connections must be operational and in a healthy state.

- Access to the Network Controller REST API.

- Administrative credentials for the gateway VMs.

- At least one redundant gateway available in the gateway pool.
  > [!WARNING]
  > If no redundant gateway is configured, updating active gateways can cause extended traffic disruptions as tunnels might not failover during the update process.

- Windows update packages (MSU files) downloaded and staged.

- Monitoring tools to verify tunnel connectivity and BGP status *(optional but strongly recommended)*. These tools are user‑provided and specific to your environment, and are used to validate workload connectivity.

- **SdnDiagnostics PowerShell module**
    The code snippets in this article use cmdlets from the `SdnDiagnostics` module. 

### Install SdnDiagnostics module

Install the latest version of `SdnDiagnostics` from the PowerShell Gallery. For more information, see the [SdnDiagnostics wiki page](https://github.com/microsoft/SdnDiagnostics).

```powershell

# Install SdnDiagnostics module from PowerShell Gallery
Install-Module -Name SdnDiagnostics -Force -AllowClobber

# Verify installation
Get-Module -Name SdnDiagnostics -ListAvailable

# Import the module
Import-Module SdnDiagnostics
```

## Update process

> [!IMPORTANT]
> The code examples in this section are for reference only. Customize them for your environment before you run them. Review the comments in each snippet, as they include important guidance. Some variables defined in earlier steps are used later, so run all snippets in the same PowerShell session.

### Phase 1: Identify gateway roles

1.  **Get the list of current gateways**
    - Query the Network Controller to retrieve all gateway VMs.
    - Note down which gateways are **redundant** and which are **active**.
        - Active gateways host active network connections/tunnels.
        - Redundant gateways are standby and don't host active connections.

    ```powershell
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
    ```

### Phase 2: Update redundant gateways

Start with redundant gateways as they do not host active connections, minimizing service disruption.

#### Example walkthrough

The following example illustrates the update process for a redundant gateway (GW01):

| Step | Action | GW01 state | Description |
|--|--|--|--|
| 1 | Backup and remove from Network Controller | **Redundant → (Not in Network Controller)** | Back up the GW01 configuration and remove it from the Network Controller. Removing the gateway triggers a reboot and deletes the GW01 resource from the Network Controller. |
| 2 | Verify removal | **(Not in Network Controller)** | Wait for the reboot to complete and confirm that GW01 no longer appears in the Network Controller. |
| 3 | Install updates | **(Not in Network Controller)** | Install the required Windows updates on GW01. |
| 4 | Re-add to Network Controller | **(Not in Network Controller) → Passive (Unmonitored)** | AAdd GW01 back to the gateway pool. The gateway initially joins in a passive (unmonitored) state. |
| 5 | Verify healthy | **Passive (Unmonitored) → Redundant (Healthy)** | Verify that GW01 transitions to a healthy redundant state. |
| 6 | Next gateway | **Redundant (Healthy)** | Repeat the process for the next redundant gateway. |

#### Detailed steps

Complete the following steps for each redundant gateway.

1. **Remove the gateway from the gateway pool.**

    - Back up the gateway configuration to a JSON file so you can restore it later.
    - Capture the last boot time before removal so you can detect when the reboot completes.
    - Remove the gateway resource from the Network Controller. Removing the gateway triggers a reboot of the gateway VM.

    ```powershell
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
    ```

1. **Verify the gateway is removed.**
    - Wait for the VM to reboot (the boot time should change).
    - Confirm the gateway resource no longer exists in the Network Controller.

    ```powershell
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

    ```

1. **Perform Windows updates.**
    - Install the required Windows updates on the gateway VM using your standard process.
    - Reboot if required by the updates.

1. **Add the gateway back to the gateway pool.**
    - Re-register the gateway with the Network Controller.
    - The gateway typically rejoins the pool in a passive/unmonitored state first.

    ```powershell
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
    ```

1. **Wait for the gateway to return to a healthy redundant state.**
   - Verify the gateway has successfully transitioned to the redundant state.
   - Ensure health checks pass before proceeding.

    ```powershell
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
    ```

1. **Proceed to the next redundant gateway.**
   - Repeat steps 1 through 5 for each remaining redundant gateway.

### Phase 3: Update Active Gateways

After all redundant gateways are updated, proceed with the active gateways. This phase requires careful coordination to ensure tunnel failover occurs correctly and service availability is maintained.

> [!IMPORTANT]
> When an active gateway is rebooted during this process, it transitions to a **redundant** state. As a result, gateway roles can change dynamically during the update.
>
> Always reference the original list of active gateways identified in Phase 1 when selecting the next gateway to update. Don’t rely on the current gateway state, as it might have changed during previous updates. This approach ensures that all gateways that were originally active are updated in a predictable and controlled order.

#### Example walkthrough

The following example illustrates the update process for an active gateway, where **GW01** is initially active and **GW05** is redundant:

| Step | Action | GW01 state | GW05 state | Description |
|----|----|----|----|----|
| 1 | Document tunnels | **Active** | Redundant | Record all virtual gateways and connections hosted on GW01 |
| 2 | Reboot GW01 | **Active → Rebooting** | Redundant → **Active** | Rebooting GW01 triggers tunnel failover; GW05 is promoted to active and takes over all tunnels.  |
| 3 | Verify failover | **Redundant** | **Active** | GW01 comes back online as redundant; all tunnels are now hosted on GW05. |
| 4 | Test connectivity | **Redundant** | **Active** | Verify tunnels are connected on GW05. |
| 5 | Backup and remove GW01 from Network Controller | **Redundant → (Not in Network Controller)** | **Active** | Back up GW01 configuration and remove it from Network Controller. Removal triggers a reboot and deletes the GW01 resource. |
| 6 | Verify removal | **(Not in Network Controller)** | **Active** | Wait for GW01 to reboot and verify it no longer exists in Network Controller. |
| 7 | Install updates | **(Not in Network Controller)** | **Active** |  Install required Windows updates on GW01. |
| 8 | Re-add to Network Controller | **(Not in Network Controller) → Passive (Unmonitored)** | **Active** | Re‑add GW01 to the gateway pool. It initially joins in a passive (unmonitored) state. |
| 9 | Verify healthy | **Passive (Unmonitored) → Redundant (Healthy)** | **Active** | Confirm GW01 transitions to a healthy redundant state. |
| 10 | Next gateway | **Redundant** | Active | Select the next gateway from the original Phase 1 active gateway list and repeat the process. |

#### Detailed steps

Complete the following steps for each active gateway (based on the *original* active gateway list captured in Phase 1).

1.  **Get the list of tunnels hosted on the gateway VM**
    - Document all active network connections and virtual gateways.
    - Note the tunnel states and BGP peer information.

    ```powershell
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
    ```

1.  **Reboot the gateway VM to trigger failover.**
    - This triggers a tunnel failure for all connections on this gateway.
    - Gateway Manager automatically promotes one of the redundant gateways to active.
    - All tunnels from the rebooted gateway move to the newly promoted active gateway.

    ```powershell
    # Reboot the active gateway
    Write-Host "Rebooting Active Gateway $activeGatewayToUpdate - this will trigger tunnel failover!" -ForegroundColor Red
    Restart-Computer -ComputerName $activeGatewayToUpdate -Credential $credential -Force

    Write-Host "Gateway reboot initiated at $(Get-Date)" -ForegroundColor Yellow
    Write-Host "Tunnels will failover to a redundant gateway..."
    ```

1.  **Verify tunnel failover.**
    - Ensure all tunnels are now active and connected on the new gateway.
    - Verify the BGP peering is re-established.
    - Confirm connectivity is restored for all affected connections.
    - Verify that the rebooted gateway transitions to a **Redundant** state.

    ```powershell
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
    ```

1.  **Test connectivity to workload endpoints.**
    - Use your existing monitoring tools to validate traffic flow to critical workload endpoints.
    - Ensure tunnels are operational before proceeding to the next steps.
    - Focus on testing connectivity for the tunnels that were moved from the rebooted gateway to the new active gateway.

1.  **Update the now-redundant gateway.**
    - Follow the redundant gateway update procedure (Phase 2, steps 1-5).
    - Remove the gateway from the pool, install Windows updates, re‑add it to the pool, and verify that it returns to a healthy redundant state.

    > [!NOTE]
    > When using the scripts from Phase 2, ensure that **gatewayToUpdate** is set to this now-redundant gateway (the one that was previously active and has just transitioned to redundant state).

    ```powershell
    Write-Host "`nThe gateway is now Redundant. Follow Phase 2 steps to:" -ForegroundColor Cyan
    Write-Host "  1. Remove gateway from pool (will trigger another reboot)"
    Write-Host "  2. Verify removal"
    Write-Host "  3. Perform Windows updates manually"
    Write-Host "  4. Add gateway back to pool"
    Write-Host "  5. Wait for healthy redundant state"
    Write-Host "`nRefer to Phase 2 code snippets for detailed steps."
    ```

1. **Proceed to the next active gateway.**
    - Repeat steps 1 through 6 for each remaining gateway that was originally identified as active in Phase 1.

## Post-update verification

After all gateways are updated, complete the following validation steps.

1.  **Verify that all gateways are online.**
    - Check that all gateway VMs are registered with the Network Controller.
    - Confirm proper distribution of redundant and active gateways.

    ```powershell
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
    ```

1. **Verify connectivity.**
    - Test all network connections and virtual gateways.
    - Confirm BGP peering is stable across all connections.

    ```powershell
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
    ```

1. **Test connectivity to workload endpoints.**
    - Use your existing monitoring or validation tools to test traffic flow to critical workload endpoints.
    - Confirm that applications are functioning correctly through the gateway connections.