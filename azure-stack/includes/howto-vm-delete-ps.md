---
author: mabrigg
ms.author: mattbriggs
ms.service: azure-stack
ms.topic: include
ms.date: 06/03/2020
ms.reviewer: kivenkat
ms.lastreviewed: 06/03/2020
---

## Delete a VM with dependencies using PowerShell

In the case where we cannot delete the resource group (either the dependencies are not in the same resource group, or there are other resources ), follow the steps below:

Connect to the your Azure Stack Hub environment.

```powershell
$vmName = 'MYVM'
 $rgName = 'MyResourceGroup'
 $vm = Get-AzureRmVM -Name $vmName -ResourceGroupName $rgName
 Next, we need to get the VM ID. This is required to find the associated boot diagnostics container.

```

Retrieve the VM information and name of dependencies.

```powershell
 $azResourceParams = @{
 'ResourceName' = $vmName
 'ResourceType' = 'Microsoft.Compute/virtualMachines'
     'ResourceGroupName' = $rgName
 }
 $vmResource = Get-AzureRmResource @azResourceParams
 $vmId = $vmResource.Properties.VmId
```

Delete the boot diagnostic storage container.

```powershell
$diagSa = [regex]::match($vm.DiagnosticsProfile.bootDiagnostics.storageUri, '^http[s]?://(.+?)\.').groups[1].value
 $diagContainerName = ('bootdiagnostics-{0}-{1}' -f $vm.Name.ToLower().Substring(0, 9), $vmId)
 $diagSaRg = (Get-AzureRmStorageAccount | where { $_.StorageAccountName -eq $diagSa }).ResourceGroupName
 $saParams = @{
 'ResourceGroupName' = $diagSaRg
-'Name' = $diagSa
 }
 Get-AzureRmStorageAccount @saParams | Get-AzureStorageContainer | where { $_.Name-eq $diagContainerName } | Remove-AzureStorageContainer -Force
```

Delete the VM.

```powershell
$vm | Remove-AzureRmVM _Force
```

Remove the vNic.

```powershell
$vm | Remove-AzureRmNetworkInterface –Force
```

Remove the OS disc.

```powershell
$osDiskUri = $vm.StorageProfile.OSDisk.Vhd.Uri
$osDiskContainerName = $osDiskUri.Split('/')[-2]
$osDiskStorageAcct = Get-AzureRmStorageAccount | where { $_.StorageAccountName -eq $osDiskUri.Split('/')[2].Split('.')[0] }
$osDiskStorageAcct | Remove-AzureStorageBlob -Container $osDiskContainerName -Blob $osDiskUri.Split('/')[-1]
```

Remove any attached data disks.

```powershell
if ($vm.DataDiskNames.Count -gt 0)
 {
    Write-Verbose -Message 'Removing data disks...'
        foreach ($uri in $vm.StorageProfile.DataDisks.Vhd.Uri)
        {
            $dataDiskStorageAcct = Get-AzureRmStorageAccount -Name $uri.Split('/')[2].Split('.')[0]
        
 $dataDiskStorageAcct | Remove-AzureStorageBlob -Container $uri.Split('/')[-2] -Blob $uri.Split('/')[-1] -ea Ignore
     }
 }
```
