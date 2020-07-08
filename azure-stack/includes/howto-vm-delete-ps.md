---
author: mabrigg
ms.author: mattbriggs
ms.service: azure-stack
ms.topic: include
ms.date: 06/03/2020
ms.reviewer: kivenkat
ms.lastreviewed: 06/03/2020
---

### Delete a VM with dependencies using PowerShell

In the case where you cannot delete the resource group, either the dependencies are not in the same resource group, or there are other resources, follow these steps.

Connect to the your Azure Stack Hub environment, and then update the following variables with your VM name and resource group. For instructions on connecting to your PowerShell session to Azure Stack Hub, see [Connect to Azure Stack Hub with PowerShell as a user](azure-stack-powershell-configure-user.md).

```powershell
$machineName = 'VM_TO_DELETE'
$resGroupName = 'RESOURCE_GROUP'
$machine = Get-AzureRmVM -Name $machineName -ResourceGroupName $resGroupName
```

Retrieve the VM information and name of dependencies. In the same session, run the following cmdlets:

```powershell
 $azResParams = @{
 'ResourceName' = $machineName
 'ResourceType' = 'Microsoft.Compute/virtualMachines'
     'ResourceGroupName' = $resGroupName
 }
 $vmResource = Get-AzureRmResource @azResParams
 $vmId = $vmResource.Properties.VmId
```

Delete the boot diagnostic storage container. In the same session, run the following cmdlets:

```powershell
$container = [regex]::match($machine.DiagnosticsProfile.bootDiagnostics.storageUri, '^http[s]?://(.+?)\.').groups[1].value
$diagContainerName = ('bootdiagnostics-{0}-{1}' -f $machine.Name.ToLower().Substring(0, 9), $vmId)
$containerRg = (Get-AzureRmStorageAccount | where { $_.StorageAccountName -eq $container }).ResourceGroupName
$storeParams = @{
    'ResourceGroupName' = $containerRg
    'Name' = $container }
Get-AzureRmStorageAccount @storeParams | Get-AzureStorageContainer | where { $_.Name-eq $diagContainerName } | Remove-AzureStorageContainer -Force
```

Delete the VM. The cmdlet takes some time to run. In the same session, run the following cmdlets:

```powershell
$machine | Remove-AzureRmVM -Force
```

Remove the the virtual network interface.

```powershell
$machine | Remove-AzureRmNetworkInterface -Force
```

Delete the operating system disk.

```powershell
$osVhdUri = $machine.StorageProfile.OSDisk.Vhd.Uri
$osDiskConName = $osVhdUri.Split('/')[-2]
$osDiskStorageAcct = Get-AzureRmStorageAccount | where { $_.StorageAccountName -eq $osVhdUri.Split('/')[2].Split('.')[0] }
$osDiskStorageAcct | Remove-AzureStorageBlob -Container $osDiskConName -Blob $osVhdUri.Split('/')[-1]
```

Remove data disks attached to your VM.

```powershell
if ($machine.DataDiskNames.Count -gt 0)
 {
    Write-Verbose -Message 'Removing data disks...'
        foreach ($uri in #machine.StorageProfile.DataDisks.Vhd.Uri)
        {
            $dataDiskStorageAcct = Get-AzureRmStorageAccount -Name $uri.Split('/')[2].Split('.')[0]
        
 $dataDiskStorageAcct | Remove-AzureStorageBlob -Container $uri.Split('/')[-2] -Blob $uri.Split('/')[-1] -ea Ignore
     }
 }
```
