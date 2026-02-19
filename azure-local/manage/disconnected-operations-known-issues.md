---
title: Release Notes for Disconnected Operations for Azure Local
description: Read about the known issues and fixed issues for disconnected operations for Azure Local.
author: ronmiab
ms.topic: concept-article
ms.date: 01/05/2026
ms.author: robess
ms.reviewer: haraldfianbakken
ai-usage: ai-assisted
ms.subservice: hyperconverged
---

# What's new in disconnected operations for Azure Local

::: moniker range=">=azloc-2506"

This article highlights what's new (features and improvements) and critical known issues with workarounds for disconnected operations in Azure Local. These release notes update continuously. We add critical issues and workarounds as they're identified. Review this information before you deploy disconnected operations with Azure Local.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]


## Features and improvements in 2601
 - Added support for the Azure Local 2601 ISO and its associated capabilities.
 - Added Zero Day Update (ZDU) capability for Azure Local.
 - Updated Azure CLI versions and extensions
 - Improved security and bug fixes.

## Features and improvements in 2512
 - Added support for the Azure Local 2512 ISO and its associated capabilities.
 - Added update capability for 2512.
 - Added registration UX to the Azure portal.
 - Improved security and bug fixes.

## Features and improvements in 2511
 - Added support for the Azure Local 2511 ISO and its associated capabilities.
 - Bundled update uploader in OperationsModule.
 - Improved the log collection experience.
 - Added deployment automation capability for operator account during bootstrap.
  - Enabled full end-to-end deployment automation.
 - Fixed empty groups not synchronizing for identity integration.
 - RBAC update and refresh (AKS Arc).
 - Added control plane awareness for Azure Local instance deployments.

## Features and improvements in 2509

 - Added support for the Azure Local 2508 ISO and its associated capabilities.
 - Added support for System Center Operations Manager 2025 and fixed a management pack failure on newer System Center Operations Manager versions; continuing support for System Center Operations Manager 2022.
 - Enabled update scenario. 
 - Improved security.
 - Improved observability.
 - Enabled LDAPS and custom port configuration for LDAP binding.
 - Fixed Portal and UX issues.
 - Improved OperationsModule logging and error messages and added certificate validation and CSR generation.
 - Added external certificate rotation in OperationsModule. For example, `Set-ApplianceExternalEndpointCertificates`.
 - Enabled the use of a FQDN in the SAN of the management certificate.

## Known issues for disconnected operations for Azure Local

### Cloud deployment fails and transitions into a failed state

In Azure Local 2601, a known issue in disconnected operations for Azure Local may cause HIMDS services to stop functioning due to IRVM services taking longer than expected to start. This timing issue can result in the cloud deployment transitioning to a failed state, often accompanied by unclear or non-descriptive error messages.

**Workaround**:

Perform the following steps on all nodes:

1. Download and copy the attached [Zip file](https://aka.ms/aldo-fix2/1) to the `C:\AzureLocal` folder.
1. Extract the Zip file to the path: `C:\AzureLocal\HimdsWatchDog`.
1. Run the `Install-HIMDS-Watchdog.ps1` command.
1. Verify if the scheduled task is created by running:
   
   ```powershell
   `Get-ScheduledTask -TaskName HIMDS`.
   ```

1. After the cloud deployment is complete, delete the task on each node by running:
   ```powershell
   Unregister-ScheduledTask -TaskName HIMDSWatchdog
   ```

### Control plane deployment stuck and times out without completing

In rare cases, deployments may time out, and services might not reach 100% convergence, even after 8 hours.

**Mitigation:**

Redeploy the disconnected operations appliance. If the issue persists after 2–3 clean redeployments, collect logs and open a support ticket.

### SSL/TLS error using management endpoint (OperationsModule)

When you use a cmdlet that uses the management endpoint (for example, Get-ApplianceHealthState) you receive an error "threw and exception : The request was aborted: Could not create SSL/TLS secure channel.. Retrying"

**Mitigation:** 

For 2511, do not use `Set-DisconnectedOperationsClientContext`. Instead use `$context = New-DisconnectedOperationsClientContext` and pass the `$context` to the respective cmdlets.

### Arc bootstrap fails on node (Invoke-AzStackHCIArcInitialization) on Original Equipment Manufacturer (OEM) provided images 

If you are running an OEM image, make sure that you are on the correct OS baseline.

Follow these steps:

1. Make sure that you are on a same supported version or an earlier version (for example, 2508 or earlier).
1. Disable zero-day update on each node:
  
   ```powershell
   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\EdgeArcBootstrapSetup" -Name "MicrosoftOSImage" -Value 1
   ```
  
1. Upgrade to the Microsoft provided ISO for your disconnected operations version target. Choose upgrade and keep settings when reimaging the nodes using this approach.
    - Alternatively, run the following command to get the correct update:

      ```powershell
      # Define the solution version and local package path - review the correct versions.
      # Only do this if your OEM image is on a earlier version than the target version.
      
      $TargetSolutionVersion = "12.2511.1002.5"
      $localPlatformVersion = "12.2511.0.3038"
      $DownloadUpdateZipUrl = "https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/WindowsPlatform/$($localPlatformVersion)/Platform.$($localPlatformVersion).zip"
      $LocalPlatformPackagePath = "C:\Platform.$($localPlatformVersion).zip"

      # Download the DownloadUpdateZipUrl to LocalPlatformPackagePath (Alternative do this from browser and copy file over if you cannot run this on your nodes/disconnected scenarios)
      Invoke-WebRequest $DownloadUpdateZipUrl -Outfile $LocalPlatformPackagePath
      
      $updateConfig = @{
        "TargetSolutionVersion" = $TargetSolutionVersion
        "LocalPlatformPackagePath" = $LocalPlatformPackagePath
      }
      
      $configHash = @{
        "UpdateConfiguration" = $updateConfig
      }
      
      # Trigger zero-day update
      $tempConfigPath = "C:\temp.json"
      $configHash | ConvertTo-Json -Depth 3 | Out-File $tempConfigPath -Force
      Start-ArcBootstrap -ConfigFilePath $tempConfigPath
      
      # Continue with Invoke-AzStackHCIArcInitialization.
      ```
      acquire
 1. Review the [version compatibility](disconnected-operations-acquire.md#review-disconnected-operations-for-azure-local-compatible-versions) table.

### Cloud deployment validation fails during the portal experience

Solution Builder extension (SBE) validation fails when trying to reach an *aka.ms* link to download. 

**Workaround**:

1. Run the cloud deployment (portal) flow until the validation fails in the UX.
1. Download a patched version of [ExtractOEMContent.ps1](https://aka.ms/aldo-fix1/1)
1. Download a patched version of [EN-US\ExtractOEMContent.Strings.psd1](https://aka.ms/aldo-fix1/2)
1. Modify the following file using your favorite editor `ExtractOEMContent.ps1`.
1. Replace line 899 in this file with the code snippet:

   ```powershell
   if (-not (Test-SBEXMLSignature -XmlPath $sbeDiscoveryManifestPath)) {
       throw ($localizedStrings.OEMManifestSignature -f $sbeDiscoveryManifestPath)
   }
   $packageHash = (Get-FileHash -Path $zipFile.FullName -Algorithm SHA256).Hash
   $manifestXML = New-Object -TypeName System.Xml.XmlDocument
   $manifestXML.PreserveWhitespace = $false
   $xmlTextReader = New-Object -TypeName System.Xml.XmlTextReader -ArgumentList $sbeDiscoveryManifestPath
   $manifestXML.Load($xmlTextReader)
   $xmlTextReader.Dispose()
   
   # Test that the zip file hash matches the package hash from the manifest
   $applicableUpdate = $manifestXML.SelectSingleNode("//ApplicableUpdate[UpdateInfo/PackageHash='$packageHash']")
   if ([System.String]::IsNullOrEmpty($applicableUpdate)) {
       throw "$($zipFile.FullName) hash of $packageHash does not match value in manifest at $sbeDiscoveryManifestPath"
   }
   $result = [PSCustomObject]@{
       Code = "Latest"
       Message = "Override for ALDO"
       Endpoint = "https://aka.ms/AzureStackSBEUpdate/Dell"
       ApplicableUpdate = $applicableUpdate.OuterXml
   }
   ```
1. Copy the newly modified file to c:\CloudDeployment\Setup\Common\ExtractOEMContent.ps1 on the first machine.
1. Copy the downloaded, unmodified file to c:\CloudDeployment\Setup\Common\En-US\ExtractOEMContent.Strings.psd1 on the first machine.
1. Resume cloud deployment.

### Cloud deployment (validation or deployment) gets stuck

During the validate or cloud deployment flow, the first machine (seed node) restarts, which causes the control plane appliance to restart. Sometimes this process takes longer than expected, causing HIMDS to stop because it can't connect to the HIS endpoint. This issue can cause the deployment flow to stop responding.

**Mitigation**:

1. Check if the HIMDS service is stopped:
  
   ```powershell
   Get-Service HIMDS
   ```

1. If the service is stopped, start it:

   ```powershell
   Start-Service HIMDS
   ```
   
1. Check the logs in the first mode at *C:\CloudDeployment\Logs*.
1. Review the appropriate log file:
   - Validate stage: Check the latest file with a name starting with *EnvironmentValidator*.
   - Deploy stage: Check the latest file with a name starting with *CloudDeployment*.
   - If the status in the file is different from what appears in the portal, follow the next steps to resync the deployment status with the portal.

### Deployment status out of sync from cluster to portal

The portal shows that cloud deployment is in progress even though it's already completed, or the deployment is taking longer than expected. This happens because the cloud deployment status isn't synced with the actual status.

If the portal and log file are out of sync, restart the LCM Controller service to reestablish the connection to relay by running `Restart-Service LCMController`.

**Mitigation on the first machine:**

1. Find the following files:
   - For the **Validate** stage: `c:\ECEStore\efb61d70-47ed-8f44-5d63-bed6adc0fb0f\559dd25c-9d86-dc72-4bea-b9f364d103f8`
   - For the **Deploy** stage: `c:\ECEStore\efb61d70-47ed-8f44-5d63-bed6adc0fb0f\086a22e3-ef1a-7b3a-dc9d-f407953b0f84`
1. Update the attribute **EndTimeUtc** located in the first line of the file to a future time based on the machine's current time. For example, \<Action Type="CloudDeployment" StartTimeUtc="2025-04-09T08:01:51.9513768Z" Status="Success" EndTimeUtc="2025-04-10T23:30:45.9821393Z">.
1. Save the file and close it.
1. LCM sends the notification to HCI RP within 5-10 minutes.
1. To view LCM Controller logs, use the following command:

   ```powershell
   Get-WinEvent -LogName "Microsoft.AzureStack.LCMController.EventSource/Admin" -MaxEvents 100 | Where-Object {$_.Message -like "*from edge common logger*"} | Select-Object TimeCreated, Message
   ```

> [!NOTE]
> This process works if HCI RP hasn't failed the deployment status due to a timeout (approximately 48 hours from the start of cloud deployment).

### Failed to deploy disconnected operations Appliance (Appliance.Operations failure)

Some special characters in the management TLS cert password, external certs password, or observability configuration secrets from the OperationsModule can cause the deployment to fail with an error output: *Appliance.Operations operation [options]* 
 
 **Mitigation**: 
 
 Do not use special characters like single or double quotes in the passwords.

### Resources disappear from portal

When you sign in to the portal with the same user account that worked before, resources are missing and don't appear.

**Mitigation**: Start your browser in incognito mode, or close your browser and clear all cookies. Then go back to your local portal and sign in again. Alternatively, restart IRVM01 on the seed node and wait until the services are back online and healthy.

### Memory consumption when there's less than 128 GB of memory per node

The disconnected operations appliance uses 78 GB of memory. If your node has less than 128 GB of memory, complete these steps after you deploy the appliance but before you deploy Azure Local instances.

**Mitigation**:

1. Shut down the IRVM01VM on the seed node.
1. Change the IRVM01 virtual machine memory setting to 64 GB.
1. Start the IRVM01 appliance.
1. Wait for convergence. Monitor `Get-ApplianceHealthState` until all services converge.
1. Deploy Azure Local instances.

### Deployment failure

In virtual environments, deployments can time out, and services might not reach 100% convergence, even after 8 hours.

**Mitigation:** 

Redeploy the disconnected operations appliance a few times. If you're using a physical environment and the problem continues, collect logs and open a support ticket.

### Azure Local deployment with Azure Keyvault

Role-Based Access Control (RBAC) permissions on a newly created Azure Key Vault can take up to 20 minutes to propagate. If you create the Key Vault in the local portal and quickly try to finish the cloud deployment, you might encounter permission issues when validating the cluster.

**Mitigation**: 

Wait 20 minutes after you create the Azure Key Vault to finish deploying the cluster, or create the Key Vault ahead of time. 

If you create the Key Vault ahead of time, make sure you assign:

- Managed identity for each node
- The Key Vault admin
- The user deploying to the cloud explicit roles on the Key Vault:
 - **Key Vault Secrets Officer** and **Key Vault Data Access Administrator**.

Here's an example script. Modify and use this script to create the Key Vault ahead of time:

```powershell
param($resourceGroupName = "aldo-disconnected", $keyVaultName = "aldo-kv", $subscriptionName = "Starter Subscription")

$location = "autonomous"

Write-Verbose "Sign in interactive with the user who does cloud deployment"
# Sign in to Azure CLI (use the user you run the portal deployment flow with)"
az login 
az account set --subscription $subscriptionName
$accountInfo = (az account show)|convertfrom-json

# Create the Resource Group
$rg = (az group create --name $resourceGroupName --location $location)|Convertfrom-json

# Create a Key Vault
$kv = (az keyvault create --name $keyVaultName --resource-group $resourceGroupName --location $location --enable-rbac-authorization $true)|Convertfrom-json

Write-Verbose "Assigning permissions to $($accountInfo.user.name) on the Key Vault"
# Assign the secrets officer role to the resource group (you can use KV explicit).
az role assignment create --assignee $accountInfo.user.name --role "Key Vault Secrets Officer" --scope $kv.Id
az role assignment create --assignee $accountInfo.user.name --role "Key Vault Data Access Administrator" --scope $kv.Id

$machines = (az connectedmachine list -g $resourceGroupName)|ConvertFrom-Json

# For now, a minimum of 3 machines for Azure Local disconnected operations are supported.
if($machines.Count -lt 3){
    Write-Error "No machines found in the resource group $resourceGroupName. Please check the resource group and try again. Please use the same resource group as where your Azure Local nodes are"
    return 1
}

Write-Verbose "Assigning permissions to MSIs $($machines.count) on the Key Vault"

$apps =(az ad sp list)|ConvertFrom-Json
$managedIds=$machines.displayname | foreach-object {
    $name = $_
    $apps|Where-Object {$_.ServicePrincipalType -eq 'ManagedIdentity' -and $_.displayname -match $name}
}

# Assign role to each of the managed IDs (Arc-VMs) in the RG 
$managedIds|foreach-object {    
    az role assignment create --role "Key Vault Administrator" --assignee $_.Id --scope $kv.id
}

Write-Verbose "Wait 20 min before running cloud deployment from portal"
```

### Azure Local VMs

#### Azure Resource Graph add or edit tags error

After you start, restart, or stop the Azure Local VM, the power action buttons are disabled and the status isn't reflected properly.

**Mitigation**: 

Use Azure Command-Line Interface (CLI) to add or edit tags for the resource.

#### Start, restart, or delete buttons disabled after stopping VM

After you stop an Azure Local VM, the start, restart, and delete buttons in the Azure portal are disabled.

**Mitigation**: 

Refresh your browser and the page.

#### Delete a VM resource

When you delete a VM from the portal, you might see these messages ***Delete associated resource failed*** and ***Failed to delete the associated resource 'name' of type 'Network interface'***.

**Mitigation**: 

After you delete the VM, use CLI to delete the associated network interface. Run this command:

```azurecli
az stack-hci-vm network nic delete
```

### Azure Kubernetes Service (AKS) on Azure Local

#### AKS deployment fails in fully air-gapped scenarios

AKS deployments fails in fully air-gapped scenarios. No mitigation is available for this issue in the current releases.

#### Use an existing public key when creating AKS cluster

In this release, you can only use an existing public key when creating an AKS cluster.

**Mitigation**: 

To create an SSH key, use the following command-line tool and paste the public key in the UI:

```powershell
ssh-keygen -t rsa 
(cat ~\.ssh\id_rsa.pub)|set-clipboard
```

#### Update or scale a node pool from the portal is disabled

Updating or scaling a node pool from the portal is unsupported in this preview release.

**Mitigation**: 

Use CLI to update or scale a node pool.

```azurecli
az aksarc nodepool update
az aksarc nodepool scale
```

#### Kubernetes cluster list empty under Azure Local (Kubernetes clusters)

When you navigate to Azure Local and click **Kubernetes clusters**, you might see an empty list of clusters.

**Mitigation**: 

Navigate to **Kubernetes** > **Azure Arc** in the left menu or use the search bar. Your clusters should appear in the list.

#### Save Kubernetes service notification stuck

After you update to a newer version of Kubernetes, you might see a stuck notification that says, `Save Kubernetes service`.

**Mitigation**: 

Navigate to the **Cluster View** page and refresh it. Check whether the state shows upgrading or completed. If the update completed successfully, you can ignore the notification.

#### Activity log shows authentication issue

Ignore the portal warning in this release.

#### Microsoft Entra authentication with Kubernetes RBAC fails

When attempting to create a Kubernetes cluster with Entra authentication, you encounter an error.

Only local accounts with Kubernetes RBAC are supported in this preview release.

#### Arc extensions

When navigating to extensions on an AKS cluster, the add button is disabled and there aren't any extensions listed.

Arc extensions are unsupported in this preview release.

#### AKS resource shows on portal after deletion

After successfully deleting an AKS cluster from portal, the resource continues to show.

**Mitigation**: 

Use CLI to delete and clean up the cluster. Run this command:

```azurecli
az aksarc delete
```

#### Export Host Guardian Service certificates

This feature is unsupported in this preview release.

#### Restart a node or the control plane VM

After you restart a node or the control plane VM, the system might take up to an hour to become fully ready. If you notice issues with the local portal, missing resources, or failed deployments, check the appliance health using the **OperationsModule** to confirm that all services are fully converged.

### Subscriptions

#### Operator create subscription

After you create a new subscription as an operator, the subscription appears in the list as non-clickable and displays ***no access*** for the owner.

**Mitigation**: 

Refresh your browser window.

#### Operator subscriptions view (timeout)

If you're signed in as an operator, you might see a timeout screen and be unable to view, list, or create subscriptions.

**Cause**: 

This issue happens when a subscription owner is deleted or isn't synced from the source identity system to the local control plane. When you try to view subscriptions, the process fails because the owner's identity isn't available.

**Mitigation**: 

If the portal doesn't work, use Azure CLI or REST API to create and list subscriptions. To assign a different owner, use the REST API and enter the `subscriptionOwnerId` parameter when you create the subscription.

### Azure CLI

#### Manage clouds

When you use the `az cloud` commands, such as `az cloud register`, `az cloud show`, or `az cloud set`, you might encounter issues if you use uppercase letters in the cloud name.

**Mitigation**: 

Only use lowercase letters for cloud names in `az cloud` subcommands, such as `register`, `show`, or `set`.

#### Create subscriptions

Azure CLI doesn't support providing `subscriptionOwnerId` for new subscriptions. This makes the operator the default owner of newly created subscriptions without a way of changing the owner currently.

**Mitigation**: 

Use `az rest` to create subscriptions with a different owner if required to automate directly with different owner

### Azure portal

#### Sign out fails

When you select **Signout**, the request doesn't work.

**Mitigation**: 

Close your browser, then go to the Portal URL.

### Azure Resource Manager

#### Template specs

Template specs are unsupported in the preview release. Deployments that use ARM templates with template specs fail.

### Unsupported scenarios

The following scenarios are unsupported in the preview release.

- Arc-Enabled servers (remote or non Azure Local VMs)
- Arc-Enabled Kubernetes clusters (remote or non AKS clusters)

If you test these scenarios, these systems must trust your custom CA and you need to pass `-custom-ca-cert` when Arc-enabling them.

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506.

::: moniker-end
