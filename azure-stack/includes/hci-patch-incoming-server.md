---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 05/16/2023
---

```powershell
# Retrieve incoming server's OS build version and installed KBs 

Set-Item WSMan:\LocalHost\Client\TrustedHosts -Value "s-cluster" -Force

$IncomingNodeVersionStr = cmd /c ver 

"$IncomingNodeVersionStr" -match "\d+\.\d+\.\d+\.\d+" | Out-Null 

$IncomingNodeBuildOsVersion = $Matches[0] 

Write-Host "Incoming node's Build Version: $IncomingNodeBuildOsVersion" -ForegroundColor Black -BackgroundColor Yellow 

    

# Retrieve cluster's OS build version and installed KBs 

$ClusterNodeVersionStr = Invoke-Command -Computer s-cluster { cmd /c ver } -Credential $LocalAdmin 

"$ClusterNodeVersionStr" -match "\d+\.\d+\.\d+\.\d+" | Out-Null 

$ClusterNodeBuildOsVersion = $Matches[0] 

Write-Host "Cluster's Build Version: $ClusterNodeBuildOsVersion" -ForegroundColor Black -BackgroundColor Yellow 

    

# Checking KBs on incoming node 

$IncomingNodeKBs = (Get-Hotfix).HotfixID 

$IncomingNodeKBsStr = $IncomingNodeKBs -join "," 

Write-Host "Current KBs installed on incoming node: $IncomingNodeKBsStr" -ForegroundColor Black -BackgroundColor Yellow 

    

# Checking KBs on cluster 

$ClusterNodeKBs = Invoke-Command -Computer s-cluster { (Get-Hotfix).HotfixID } -Credential $LocalAdmin 

$ClusterNodeKBsStr = $ClusterNodeKBs -join "," 

Write-Host "Current KBs installed in cluster: $ClusterNodeKBsStr" -ForegroundColor Black -BackgroundColor Yellow 

    

# Detecting KBs missing from incoming node 

$KbsToInstall = [string[]]((Compare-Object -ReferenceObject $clusterNodeKBs -DifferenceObject $IncomingNodeKBs | Where-Object { $_.SideIndicator -eq '<=' }).InputObject) 

Write-Host "KBs to install: $($KbsToInstall -join ",")" -ForegroundColor Black -BackgroundColor Yellow 

    

# Installing KBs    

Install-Module –Name PSWindowsUpdate -Force -Confirm:$false 

Import-Module PSWindowsUpdate 

Install-WindowsUpdate -KBArticleID $KbsToInstall -AcceptAll –IgnoreReboot -Verbose 

Remove-Module -Name PSWindowsUpdate –Force 

    

# Retrieve incoming server's OS build version and installed KBs after installation 

$IncomingNodeVersionStr = cmd /c ver 

"$IncomingNodeVersionStr" -match "\d+\.\d+\.\d+\.\d+" | Out-Null 

$IncomingNodeBuildOsVersion = $Matches[0] 

Write-Host "Incoming node's build version: $IncomingNodeBuildOsVersion" -ForegroundColor Black -BackgroundColor Green 

    

# Retrieve cluster's OS Build version and installed KBs after installation 

$ClusterNodeVersionStr = Invoke-Command -Computer s-cluster { cmd /c ver } -Credential $LocalAdmin 

"$ClusterNodeVersionStr" -match "\d+\.\d+\.\d+\.\d+" | Out-Null 

$ClusterNodeBuildOsVersion = $Matches[0] 

Write-Host "Cluster's Build Version: $ClusterNodeBuildOsVersion" -ForegroundColor Black -BackgroundColor Green 

    

# Checking KBs on incoming node after installation 

$IncomingNodeKBs = (Get-hotfix).HotfixID 

$IncomingNodeKBsStr = $incomingNodeKBs -join "," 

Write-Host "Current KBs installed on incoming node: $IncomingNodeKBsStr" -ForegroundColor Black -BackgroundColor Green 

    

# Checking KBs on cluster after installation 

$ClusterNodeKBs = Invoke-Command -Computer s-cluster { (Get-Hotfix).HotfixID } -Credential $LocalAdmin 

$ClusterNodeKBsStr = $ClusterNodeKBs -join "," 

Write-Host "Current KBs installed in cluster:    
```