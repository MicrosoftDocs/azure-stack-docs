---
title: Emergency VM access in Azure Stack Hub 
description: Learn how to request help from the operator in scenarios in which a user is locked out from the virtual machine.
author: sethmanheim
ms.topic: article
ms.date: 02/27/2023
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 08/13/2021

---

# Emergency VM access (EVA)

The Emergency VM Access Service (EVA) enables a user to request help from the operator in scenarios in which that user is locked out from the virtual machine, and the redeploy operation does not help to recover access via the network.

> [!NOTE]
> EVA was released with general availability starting with Azure Stack Hub 2301.

This feature must be enabled per subscription, and the operator needs to enable Remote Desktop access in order for the **cloudadmin** user to access the emergency recovery console VMs (ERCS).

The first step for the user is to request VM console access via PowerShell. The request provides consent and allows the operator with additional information to connect to the virtual machine via its console. Console access does not depend on network connectivity and uses a data channel of the hypervisor.

It is important to note that the operator can only authenticate to the operating system running inside the VM if the credentials are known. At that point, the operator can also share screens with the user and resolve the issue together to restore network connectivity.

> [!IMPORTANT]
> For VMs running Windows Server, the EVA feature is limited to computers running with a graphical user interface (GUI). For Windows Server, the core operating system doesn't support on-screen keyboard functionality. Since you cannot send the **Ctrl+Alt+Del** key combination as input, you can't sign in to a core server, even though you can connect to its console. If you need to address an issue with the Windows core OS, please engage Microsoft support to provide console access from an unlocked PEP.

## Operator enables a user subscription for EVA

In this scenario, the operator can decide which subscription should be able to use the emergency VM access feature.

First, run the following PowerShell script. To run this script, you must have Azure Stack Hub PowerShell installed. Follow the guidance on how to install [Azure Stack Hub PowerShell](../operator/azure-stack-powershell-install.md). Replace the variable placeholders with the correct values:

### [AzureRM modules](#tab/azurerm1)

```powershell
# Replace strings with your values before running the script
$FQDN = "External FQDN"
$RegionName = "Azure Stack Region Name"
# The value for "TenantID" should always be the tenant ID of home directory as it's only used for connecting to the admin resource manager endpoint.
$TenantID = "TenantID"
$TenantSubscriptionId = "Tenant Subscription ID"

$tenantSubscriptionSettings = @{
    TenantSubscriptionId = [string]$tenantSubscriptionId
}

# Add environment & authenticate
Add-AzureRmEnvironment -Name AzureStackAdmin -ARMEndpoint https://adminmanagement.$RegionName.$FQDN
Login-AzureRmAccount -Environment AzureStackAdmin -TenantId $TenantID

Invoke-AzureRmResourceAction `
    -ResourceName "$($RegionName)/Microsoft.Compute.EmergencyVMAccess" `
    -ResourceType "Microsoft.Compute.Admin/locations/features" `
    -Action "enableTenantSubscriptionFeature" `
    -Parameters $tenantSubscriptionSettings `
    -ApiVersion "2020-11-01" `
    -ErrorAction Stop `
    -Force
```

### [Az modules](#tab/az1)

```powershell
# Replace strings with your values before running the script
$FQDN = "External FQDN"
$RegionName = "Azure Stack Region Name"
# The value for "TenantID" should always be the tenant ID of home directory as it's only used for connecting to the admin resource manager endpoint.
$TenantID = "TenantID"
$TenantSubscriptionId = "Tenant Subscription ID"

$tenantSubscriptionSettings = @{
    TenantSubscriptionId = [string]$tenantSubscriptionId
}

#Add environment & authenticate
Add-AzEnvironment -Name AzureStackAdmin -ARMEndpoint https://adminmanagement.$RegionName.$FQDN
Login-AzAccount -Environment AzureStackAdmin -TenantId $TenantID

Invoke-AzResourceAction `
    -ResourceName "$($RegionName)/Microsoft.Compute.EmergencyVMAccess" `
    -ResourceType "Microsoft.Compute.Admin/locations/features" `
    -Action "enableTenantSubscriptionFeature" `
    -Parameters $tenantSubscriptionSettings `
    -ApiVersion "2020-11-01" `
    -ErrorAction Stop `
    -Force
```

---

## User to request VM console access

As a user, you provide consent to the operator to create console access for a specific VM.

1. As a user, open PowerShell, sign in to your subscription, and [connect to Azure Stack Hub as described here](azure-stack-powershell-configure-user.md).
2. Run the following script. You must replace the subscription ID, resource group, and VM name in order to construct the **VMResourceID**:

   ### [AzureRM modules](#tab/azurerm1)

   ```powershell
   $SubscriptionID = "your Azure subscription ID" 
   $ResourceGroup = "your resource group name" 
   $VMName = "your VM name" 
   $vmResourceId = "/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroup/providers/Microsoft.Compute/virtualMachines/$VMName" 

   $enableVMAccessResponse = Invoke-AzureRMResourceAction `
       -ResourceId $vmResourceId `
       -Action "enableVmAccess" `
       -ApiVersion "2020-06-01" `
       -ErrorAction Stop `
       -Force

   Write-Host "Please provide the following output to operator`n" -ForegroundColor Yellow
   Write-Host "ERCS Name:`t$(($enableVMAccessResponse).ERCSName)" -ForegroundColor Cyan
   Write-Host "ConnectTo-TenantVm -ResourceID $($vmResourceId)" -ForegroundColor Green
   Write-Host "Delete-TenantVMSession -ResourceID $($vmResourceId)" -ForegroundColor Green
   ```

   ### [Az modules](#tab/az1)

   ```powershell
   $SubscriptionID = "your Azure subscription ID" 
   $ResourceGroup = "your resource group name" 
   $VMName = "your VM name" 
   $vmResourceId = "/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroup/providers/Microsoft.Compute/virtualMachines/$VMName" 

   $enableVMAccessResponse = Invoke-AzResourceAction `
       -ResourceId $vmResourceId `
       -Action "enableVmAccess" `
       -ApiVersion "2020-06-01" `
       -ErrorAction Stop `
       -Force

   Write-Host "Please provide the following output to operator`n" -ForegroundColor Yellow
   Write-Host "ERCS Name:`t$(($enableVMAccessResponse).ERCSName)" -ForegroundColor Cyan
   Write-Host "ConnectTo-TenantVm -ResourceID $($vmResourceId)" -ForegroundColor Green
   Write-Host "Delete-TenantVMSession -ResourceID $($vmResourceId)" -ForegroundColor Green
   ```

   ---

3. The script returns the emergency recovery console name (ERCS), which the tenant provides to the operator, along with the **VMResourceID**.

## Operator enables remote desktop access to ERCS VMs

The next step for the Azure Stack Hub operator is to enable Remote Desktop access to the Emergency Recovery Console VMs (ERCS), which host the privileged endpoints.

Run the following commands in the privileged endpoint (PEP) from the operator workstation that will be used to connect to the ERCS. The command will add the workstation's IP to the network safelist. Follow the guidance on how to [connect to PEP](../operator/azure-stack-privileged-endpoint.md). The operator can be a member of the **cloudadmin** users group, or **cloudadmin** itself:

```powershell
Grant-RdpAccessToErcsVM
```

To disable the remote desktop access to the Emergency Recovery Console VMs (ERCS), run the following command in the privileged endpoint (PEP):

```powershell
Revoke-RdpAccessToErcsVM
```

> [!NOTE]
> Any one of the ERCS VMs will be assigned the tenant user's access request. As an operator, you can create a PEP session only to the ERCS VM received from the tenant (the output of `$enableVMAccessResponse`).

1. The operator uses the ERCS name, and connects to it using the Remote Desktop Client (RDP); for example, from the operator access workstation (OAW).

   > [!NOTE]
   > The operator authenticates using the same cloud admin account that executed [**Grant-RdpAccessToErcsVM**](#operator-enables-remote-desktop-access-to-ercs-vms).

2. Once connected to the ERCS VM via RDP, launch PowerShell.

3. Import the Emergency VM Access module by running the following command:

   ```powershell
   Import-module Microsoft.AzureStack.Compute.EmergencyVmAccess.PowerShellModule
   ```

4. Connect to the console of the tenant virtual machine using the following command:

   ```powershell
   ConnectTo-TenantVm -ResourceID
   ```

5. The operator now connects to the console screen of the tenant virtual machine to which they need to authenticate using the **cloudadmin** credentials again. The operator does not have any credentials with which to sign in to the guest operating system.

   > [!NOTE]
   > In the sign-in screen, pressing the Windows + U keys launches the on-screen keyboard, which allows sending CTRL + ALT + Delete. You must be in full screen RDP mode in order to use the Windows + U key combination.

6. The operator can now screen share with the tenant to debug any issues that prevent connecting to the VM via the network.

7. When finished, the operator can run the following command to remove the user consent:

   ```powershell
   Delete-TenantVMSession -ResourceID
   ```

   > [!NOTE]
   > The user consent expires automatically after 8 hours, and will revoke all access by the operator.
