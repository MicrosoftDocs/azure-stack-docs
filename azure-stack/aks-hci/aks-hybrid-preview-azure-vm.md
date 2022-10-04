---
title: Quickly get started with using Azure CLI to deploy an AKS hybrid cluster on a Windows Server node in an Azure VM
description: Quickly get started with using Azure CLI to deploy an AKS hybrid cluster on a Windows Server node in an Azure VM
author: sethmanheim
ms.topic: quickstart
ms.date: 07/11/2022
ms.author: sethm 
ms.lastreviewed: 05/02/2022
ms.reviewer: abha

# Intent: As an IT Pro, I want to use Az CLI to test creating AKS hybrid clusters on-premises
# Keyword: AKS setup PowerShell 
---
# Quickstart: Quickly get started with using Azure CLI to deploy an AKS hybrid cluster on a Windows Server node in an Azure VM
In this quickstart, you'll learn use Az CLI to test creating AKS hybrid clusters on-premises using Azure CLI.

# Before you begin
Before you begin, make sure you meet the following requirements -
- Have access to an Azure subscription.
- Make sure you’re an owner on the above subscription. 

## Step 1: Register your Azure subscription for  features and providers
Register the Azure providers and Azure features on your Azure subscription. You can use the Azure shell in Azure portal to complete this operation – 

```cli
az feature register --namespace Microsoft.HybridContainerService
az feature register --namespace Microsoft.ResourceConnector 
az feature register --namespace Microsoft.HybridConnectivity --name hiddenPreviewAccess

az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.KubernetesConfiguration
az provider register --namespace Microsoft.ExtendedLocation
az provider register --namespace Microsoft.ResourceConnector
az provider register --namespace Microsoft.HybridContainerService
az provider register --namespace Microsoft.HybridConnectivity
```

## Step 2: Create an Azure VM and deploy Windows Server on the Azure VM

```PowerShell
# Adjust any parameters you wish to change
$rgName = "aks-hybrid-preview-azurevm"
$location = "eastus" # To check available locations, run Get-AzLocation 
$timeStamp = (Get-Date).ToString("MM-dd-HHmmss")
$deploymentName = ("AksHciDeploy_" + "$timeStamp")
$vmName = "AKSHCIHost004"
$vmSize = "Standard_E16s_v4"
$vmGeneration = "Generation 2" 
$domainName = "akshci.local"
$dataDiskType = "StandardSSD_LRS"
$dataDiskSize = "32"
$enableDHCP = "Enabled" # you have to enable DHCP for this preview
$customRdpPort = "3389" # Between 0 and 65535 #
$autoShutdownStatus = "Enabled" # Or Disabled #
$autoShutdownTime = "00:00"
$autoShutdownTimeZone = "Pacific Standard Time"
$existingWindowsServerLicense = "No"
```
You also need to supply a username and password to login to your Azure VM -

```PowerShell
$adminUsername = <user-name to login to your Azure VM>
$adminPassword = ConvertTo-SecureString '<password to login to your Azure VM>' -AsPlainText -Force
```

### Create the Azure Resource Group
Login to Azure and run the following command.
```Az PowerShell
New-AzresourceGroup -Name $rgName -Location  $location -Verbose
```

### Deploy the ARM Template for the Azure VM
```Az PowerShell
New-AzresourceGroupDeployment -resourceGroupName $rgName -Name $deploymentName `
    -TemplateUri "https://raw.githubusercontent.com/Azure/aks-hci/main/eval/json/akshcihost.json" `
    -virtualMachineName $vmName `
    -virtualMachineSize $vmSize `
    -virtualMachineGeneration $vmGeneration `
    -domainName $domainName `
    -dataDiskType $dataDiskType `
    -dataDiskSize $dataDiskSize `
    -adminUsername $adminUsername `
    -adminPassword $adminPassword `
    -enableDHCP $enableDHCP `
    -customRdpPort $customRdpPort `
    -autoShutdownStatus $autoShutdownStatus `
    -autoShutdownTime $autoShutdownTime `
    -autoShutdownTimeZone $autoShutdownTimeZone `
    -alreadyHaveAWindowsServerLicense $existingWindowsServerLicense `
    -Verbose
```

### Get the connection details of the newly created Azure VM
```
$getIp = Get-AzPublicIpAddress -Name "AKSHCILabPubIp" -resourceGroupName $rgName
$getIp | Select-Object Name,IpAddress,@{label='FQDN';expression={$_.DnsSettings.Fqdn}}
```

### RDP into the Azure VM
RDP into the VM you just deployed in the previous step, then using PowerShell in Admin mode and run the following commands. You can find RDP instructions when you click on the virtual machine resource on the Azure portal.

You passed the username and password to access the Azure VM when you created the VM using the above script. Refer to the script and the `adminUsername` and `adminPassword` values.

## Step 3: Install AZ CLI on the Azure VM
RDP in the Azure VM and run the following command:
```PowerShell
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
Exit
```

## Step 4: Install Az CLI Extensions on the Azure VM
```cli
$env:PATH += ";C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;"
az extension add -n k8s-extension 
az extension add -n customlocation
az extension add -n arcappliance
az extension add --source "https://hybridaksstorage.z13.web.core.windows.net/HybridAKS/CLI/hybridaks-0.1.4-py3-none-any.whl" --yes
```

## Step 5: Install pre-requisites PowerShell repositories

Open a fresh PowerShell admin window and run the following command:
```PowerShell
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted 
Install-PackageProvider -Name NuGet -Force  
Install-Module -Name PowershellGet -Force 
Exit 
```

Open a fresh PowerShell admin window and run the following command:
```
Install-Module -Name AksHci -Repository PSGallery -AcceptLicense -Force 
Exit 
```

Open a fresh PowerShell admin window and run the following command:
```
Install-Module -Name ArcHci -Repository PSGallery -AcceptLicense -Force 
Exit 
```

Open a fresh PowerShell admin window and run the following command:
```
Initialize-AksHciNode 
Exit 
```

Open a fresh PowerShell admin window and run the following command:
```
New-Item -Path "V:\" -Name "AKS-HCI" -ItemType "directory" -Force 
New-Item -Path "V:\AKS-HCI\" -Name "Images" -ItemType "directory" -Force 
New-Item -Path "V:\AKS-HCI\" -Name "WorkingDir" -ItemType "directory" -Force 
New-Item -Path "V:\AKS-HCI\" -Name "Config" -ItemType "directory" -Force 
Exit 
```

## Step 6: Install AKS on Windows Server management cluster 

Open a fresh PowerShell admin window and run the following command:

```PowerShell
$vnet=New-AksHciNetworkSetting -Name "mgmt-vnet" -vSwitchName "InternalNAT" -gateway "192.168.0.1" -dnsservers "192.168.0.1" -ipaddressprefix "192.168.0.0/16" -k8snodeippoolstart "192.168.0.4" -k8snodeippoolend "192.168.0.10" -vipPoolStart "192.168.0.150" -vipPoolEnd "192.168.0.160"
Set-AksHciConfig -vnet $vnet -imageDir "V:\AKS-HCI\Images" -workingDir "V:\AKS-HCI\WorkingDir" -cloudConfigLocation "V:\AKS-HCI\Config" -Verbose 
```
 
Next, set the Azure subscription and resource group variables and then run `Set-AksHciRegistration`.
```PowerShell
$sub = <Azure subscription>
$rgName = "aksh-hybrid-preview-azurevm"

#Use device authentication to login to Azure. Follow the steps you see on the screen
Set-AksHciRegistration -SubscriptionId $sub -ResourceGroupName $rg -UseDeviceAuthentication
```

Run the following command to install AKS on Windows Server host
```PowerShell
Install-AksHci 
```

## Step 7: Generate pre-requisite YAML files needed to deploy Azure Arc Resource Bridge

```PowerShell
$subscriptionId = <your subscription ID>
$tenantId = <your tenant ID>
```

```PowerShell
$resourceGroup = "aks-hybrid-preview-azurevm"
$location="eastus"
$workingDir = "V:\AKS-HCI\WorkDir"
$arcAppName="arc-resource-bridge"
$configFilePath= $workingDir + "\hci-appliance.yaml"
$arcExtnName = "aks-hybrid-ext"
$customLocationName="azurevm-customlocation"
```

Create the Azure Arc Resourcr Bridge YAML files 
```PowerShell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $arcAppName -workDirectory $workingDir -vnetName "appliance-vnet" -vSwitchName "InternalNAT"-gateway "192.168.0.1" -dnsservers "192.168.0.1" -ipaddressprefix "192.168.0.0/16" -k8snodeippoolstart "192.168.0.11 " -k8snodeippoolend "192.168.0.11" -controlPlaneIP “192.168.0.161”
```

Sample output:
```output
HCI login file successfully generated in 'V:\AKS-HCI\WorkingDir\kvatoken.tok'
Generating ARC HCI configuration files...
Config file successfully generated in 'V:\AKS-HCI\WorkingDir'
```

## Step 8: Deploy Azure Arc Resource Bridge
> Note! Here you will be switching to AZ CLI, please continue to run this from the PS ISE or VS Code inside the Azure VM. 
```cli
az login -t $tenantid --use-device-code
az account set -s $subscriptionid
az arcappliance validate hci --config-file $configFilePath
az arcappliance prepare hci --config-file $configFilePath
az arcappliance deploy hci --config-file $configFilePath --outfile $workingDir\config
az arcappliance create hci --config-file $configFilePath --kubeconfig $workingDir\config
```

The above command may take upto 10mins to finish, so be patient. To check the status of your deployment, run the following command:

``` cli
# check the status == Running 
az arcappliance show --resource-group $resourceGroup --name $arcAppName --query "status" -o tsv
```

## Step 9: Installing AKS hybrid extension on the Arc Resource Bridge

To install the extension, run the following command.
```cli
az k8s-extension create -g $resourceGroup  -c $arcAppName --cluster-type appliances --name $arcExtnName  --extension-type Microsoft.HybridAKSOperator --version 0.0.23 --config Microsoft.CustomLocation.ServiceAccount="default"
```

Once you have created the AKS hybrid extension on top of the Arc Resource Bridge, run the following command to check if the cluster extension provisioning state says `Succeeded`. It might say something else at first. Be patient! This takes time. Try again after 10 minutes.

```cli
az k8s-extension show --resource-group $resourceGroup --cluster-name $arcAppName --cluster-type appliances --name $arcExtnName --query "provisioningState" -o tsv
```

## Step 10: Install a custom location on top of the Azure Arc Resource Bridge

```cli
$ArcApplianceResourceId=az arcappliance show --resource-group $resourceGroup --name $arcAppName --query id -o tsv
$ClusterExtensionResourceId=az k8s-extension show --resource-group $resourceGroup --cluster-name $arcAppName --cluster-type appliances --name $arcExtnName --query id -o tsv
```

To create a custom location, run the following command.
```cli
az customlocation create --name $customLocationName --namespace "default" --host-resource-id $ArcApplianceResourceId --cluster-extension-ids $ClusterExtensionResourceId --resource-group $resourceGroup 
```

Once you create the custom location on top of the Arc Resource Bridge, run the following command to check if the custom location provisioning state says Succeeded. It might say something else at first. Be patient! This takes time. Try again after 10 minutes.

```cli
az customlocation show --name $customLocationName --resource-group $resourceGroup --query "provisioningState" -o tsv
```

## Step 11: Create a local network for AKS hybrid clusters and connect it to Azure

Run the following command to create the local network for AKS hybrid clusters:

```PowerShell
New-KvaVirtualNetwork -name hybridaks-vnet -vSwitchName "InternalNAT" -gateway "192.168.0.1" -dnsservers "192.168.0.1" -ipaddressprefix "192.168.0.0/16" -k8snodeippoolstart "192.168.0.15" -k8snodeippoolend "192.168.0.25" -vipPoolStart "192.168.0.162" -vipPoolEnd "192.168.0.170" -kubeconfig $workingDir\config
```

Once you've created the local network, connect it to Azure by running the following command:

```cli
$clid = az customlocation show --name $customLocationName --resource-group $resourceGroup --query "id" -o tsv
az hybridaks vnet create -n "azvnet" -g $resourceGroup --custom-location $clId --moc-vnet-name "hybridaks-vnet"
$vnetId = az hybridaks vnet show -n "azvnet" -g $resourceGroup --query id -o tsv
```

## Step 12: Download the Kubernetes VHD image to your Azure VM

Run the following command to Download the Kubernetes VHD image to your Azure VM:
```PowerShell
Add-KvaGalleryImage -kubernetesVersion 1.21.9
```

## Step 13: Create an AAD group and add yourself to it

```cli
az ad group create --display-name aad-group --mail-nickname aad-group
$objectId = az ad signed-in-user show --query Id
az ad group member add --group aad-group --member-id $objectId
$aadGroupId =$(az ad group show --display-name aad-group --query Id -o tsv)
```


## Step 14:	Create an AKS hybrid cluster using Az CLI
Note that the below create command can take about 10-15mins to complete.

```cli
az hybridaks create --name "test-cluster" --resource-group $resourceGroup --custom-location $clid --vnet-ids $vnetId --kubernetes-version "v1.21.9" --aad-admin-group-object-ids $aadGroupId --generate-ssh-keys
```

### Add a Linux nodepool to the AKS hybrid cluster
```cli
az hybridaks nodepool add -n "test-nodepool" --resource-group $resourceGroup --cluster-name "test-cluster"
```

## Step 15: Get the AAD based kubeconfig to connect to your AKS hybrid cluster. 
Keep the below command running for as long as you want to remain connected to your AKS hybrid cluster

```cli
az hybridaks proxy --resource-group $resourceGroup --name “test-cluster” --file .\target-config
```

### List the pods of the provisioned cluster using the kubeconfig:
kubectl get pods -A --kubeconfig .\target-config

# Next Steps
Once you've finished quickly trying out this feature in an Azure VM, you can take a look at the following documents related to the preview:

- [Review requirements to get started with AKS hybrid cluster provisioning through Azure in your datacenter](aks-hybrid-preview-requirements.md)
