---
title: Emergency VM access in Azure Stack Hub 
description: Learn how to request help from the operator in scenarios in which a user is locked out from the virtual machine.
author: sethmanheim
ms.topic: article
ms.date: 02/14/2022
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 08/13/2021

---

# Emergency VM access (EVA) - Public preview

> [!IMPORTANT]
> Emergency VM access for Azure Stack Hub is in public preview and only applies to version 2108.

The Emergency VM Access Service (EVA) enables a user to request help from the operator in scenarios in which that user is locked out from the virtual machine, and the redeploy operation does not help to recover access via the network.

This feature must be enabled per subscription to work, and the operator needs to enable Remote Desktop access in order for the **cloudadmin** user to access the emergency recovery console VMs (ERCS).

The first step for the user is to request VM console access via PowerShell. The request provides consent and allows the operator with additional information to connect to the virtual machine via its console. Console access does not depend on network connectivity and uses a data channel of the hypervisor.

It is important to note that the operator can only authenticate to the operating system running inside the VM if the credentials are known. At that point, the operator can also share screens with the user and resolve the issue together to restore network connectivity.

## Operator enables remote desktop access to ERCS VMs

The first step for the Azure Stack Hub operator is to enable Remote Desktop access to the Emergency Recovery Console VMs (ERCS), which host the privileged endpoints.

Run the following commands in the privileged endpoint (PEP) from the operator workstation that will be used to connect to the ERCS. The command will add the workstation's IP to the network safelist. Follow the guidance on how to [connect to PEP](../operator/azure-stack-privileged-endpoint.md). The operator can be a member of the **cloudadmin** users group, or **cloudadmin** itself:

```powershell
Grant-RdpAccessToErcsVM
```

To disable the remote desktop access to the Emergency Recovery Console VMs (ERCS), run the following command in the privileged endpoint (PEP):

```powershell
Revoke-RdpAccessToErcsVM
```

[!NOTE] Any one of the ERCS VMs will be assigned the tenant user's access request. Consider proactively running the command on each privileged endpoint (PEP).

## Operator enables a user subscription for EVA

In this scenario, the operator can decide which subscription should be able to use the emergency VM access feature.

To run this script, you must have Azure Stack Hub PowerShell installed. Follow the guidance on how to install [Azure Stack Hub PowerShell](../operator/azure-stack-powershell-install.md).

### [AzureRM modules](#tab/azurerm1)

```powershell
$FQDN = Read-Host "Enter External FQDN"
$RegionName = Read-Host "Enter Azure Stack Region Name"
$TenantID = Read-Host "Enter TenantID"
$TenantSubscriptionId  = Read-Host "Enter Tenant Subscription ID"

$tenantSubscriptionSettings = @{
    TenantSubscriptionId = $tenantSubscriptionId
}

#Add environment & authenticate
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
$FQDN = Read-Host "Enter External FQDN"
$RegionName = Read-Host "Enter Azure Stack Region Name"
$TenantID = Read-Host "Enter TenantID"
$TenantSubscriptionId  = Read-Host "Enter Tenant Subscription ID"

$tenantSubscriptionSettings = @{
    TenantSubscriptionId = $tenantSubscriptionId
}

#Add Environment & Authenticate
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

1. As a user, open PowerShell, sign in to your subscription, and run the following script. You must replace the subscription ID, resource group, and VM name in order to construct the **VMResourceID**:

   ### [AzureRM modules](#tab/azurerm1)

   ```powershell
   $SubscriptionID= "your Azure subscription ID" 
   $ResourceGroup = "your resource group name" 
   $VMName = "your VM name" 
   $vmResourceId = "/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroup/providers/Microsoft.Compute/virtualMachines/$VMName" 

   $enableVMAccessResponse = Invoke-AzResourceAction `
       -ResourceId $vmResourceId `
       -Action "enableVmAccess" `
       -ApiVersion "2020-06-01" ` 
       -ErrorAction Stop ` 
       -Force 
   ```

   ### [Az modules](#tab/az1)

   ```powershell
   $SubscriptionID= "your Azure subscription ID" 
   $ResourceGroup = "your resource group name" 
   $VMName = "your VM name" 
   $vmResourceId = "/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroup/providers/Microsoft.Compute/virtualMachines/$VMName" 

   $enableVMAccessResponse = Invoke-AzureRMResourceAction `
       -ResourceId $vmResourceId `
       -Action "enableVmAccess" `
       -ApiVersion "2020-06-01" ` 
       -ErrorAction Stop ` 
       -Force 
   ```

2. The script returns the emergency recovery console name (ERCS), which the tenant provides to the operator, along with the **VMResourceID**.

3. The operator uses the ERCS name, and connects to it using the Remote Desktop Client (RDP); for example, from the operator access workstation (OAW).

   > [!NOTE]
   > The operator authenticates using the **cloudadmin** account.

4. Once connected to the ERCS VM via RDP, launch PowerShell.

5. Import the Emergency VM Access module by running the following command:

   ```powershell
   Import-module Microsoft.AzureStack.Compute.EmergencyVmAccess.PowerShellModule
   ```

6. Connect to the console of the tenant virtual machine using the following command:

   ```powershell
   ConnectTo-TenantVm -ResourceID
   ```

7. The operator now connects to the console screen of the tenant virtual machine to which they need to authenticate using the **cloudadmin** credentials again. The operator does not have any credentials with which to sign in to the guest operating system.

8. The operator can now screen share with the tenant to debug any issues that prevent connecting to the VM via the network.

9. When finished, the operator can run the following command to remove the user consent:

   ```powershell
   Delete-TenantVMSession -ResourceID
   ```

   > [!NOTE]
   > The user consent expires automatically after 8 hours, and will revoke all access by the operator.
