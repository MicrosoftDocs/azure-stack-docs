---
title: Quickly get started with using Azure CLI to deploy an AKS hybrid cluster on Windows Server in an Azure VM
description: Quickly get started with using Azure CLI to deploy an AKS hybrid cluster on Windows Server in an Azure VM
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

In this quickstart, you'll learn how to use Azure CLI to test creating AKS hybrid clusters on-premises.

## Before you begin

Before you begin, make sure you meet the following requirements:
- Have access to an Azure subscription.
- Make sure you’re an owner on the Azure subscription. 

## Step 1: Register your Azure subscription for features and providers

Register the following Azure providers on your Azure subscription. Make sure you login to Azure first. You only need to do this operation once per Azure subscription.

```cli
az account set -s <Azure subscription ID>
az feature register --namespace Microsoft.HybridContainerService --name hiddenPreviewAccess
az feature register --namespace Microsoft.ResourceConnector --name appliance-ppauto
az feature register --namespace Microsoft.HybridConnectivity --name hiddenPreviewAccess
```
Check if the above features are in the "Registered" state by running the following commands. Wait till the features in this step have been registered before proceeding with the next step. 

```cli
az account set -s <Azure subscription ID>
az feature show --namespace Microsoft.HybridContainerService --name hiddenPreviewAccess -o table
az feature show --namespace Microsoft.HybridConnectivity --name hiddenPreviewAccess -o table
```
Expected output:

```output
Name                                                  RegistrationState
----------------------------------------------------  -------------------
Microsoft.HybridContainerService/hiddenPreviewAccess  Registered

Name                                                  RegistrationState
------------------------------------------------      -------------------
Microsoft.HybridConnectivity/hiddenPreviewAccess      Registered
```

Once your features have been registered, run the following command to register the Azure providers required for this preview:

```cli
az provider register --namespace Microsoft.Kubernetes --wait 
az provider register --namespace Microsoft.ExtendedLocation --wait
az provider register --namespace Microsoft.ResourceConnector --wait
az provider register --namespace Microsoft.HybridContainerService --wait
az provider register --namespace Microsoft.HybridConnectivity --wait
```

## Step 2: Create an Azure VM and deploy Windows Server on the Azure VM
To keep things, we'll show you how to deploy your VM via an Azure Resource Manager template. The **Deploy to Azure** button, when clicked, takes you directly to the Azure portal, and upon sign-in, provides you with a form to complete. If you want to open this in a new tab, hold CTRL when you click the button.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Faks-hci%2Fmain%2Feval%2Fjson%2Fakshcihost.json "Deploy to Azure")

After clicking the **Deploy to Azure** button, enter the details, which should look something similar to those shown below, and click **Review and Create**.

:::image type="content" source="media/aks-hci-evaluation-guide/deploy-custom-template.png" alt-text="Screenshot of custom template deployment in Azure":::

> [!NOTE]
> For customers with Software Assurance, Azure Hybrid Benefit for Windows Server allows you to use your on-premises Windows Server licenses and run Windows virtual machines on Azure at a reduced cost. By selecting **Yes** for the "Already have a Windows Server License", you confirm you have an eligible Windows Server license with Software Assurance or Windows Server subscription to apply this Azure Hybrid Benefit and have reviewed the [Azure hybrid benefit compliance](https://go.microsoft.com/fwlink/?LinkId=859786).

The custom template will be validated, and if all of your entries are correct, you can select **Create**. In 30 minutes, your VM will be created.

:::image type="content" source="media/aks-hci-evaluation-guide/deployment-complete.png" alt-text="Screenshot of custom template deployment completed":::

### Access your Azure VM
With your Azure Virtual Machine (AKSHCIHost001) successfully deployed and configured, you're ready to connect to the VM, using Remote Desktop.

If you're not already signed into the [Azure portal](https://portal.azure.com), sign in with the same credentials you previously used. Once signed in, enter "azshci" in the search box on the dashboard, and in the search results select your **AKSHCIHost001** virtual machine.

:::image type="content" source="media/aks-hci-evaluation-guide/azure-vm-search.png" alt-text="Screenshot of virtual machine located in Azure":::

In the **Overview** blade for your VM, at the top of the blade, select **Connect**, and from the drop-down options select **RDP**. On the newly opened **Connect** blade, ensure that **Public IP** is selected. Also ensure that the RDP port matches what you provided at deployment time. By default, this should be **3389**. Then select **Download RDP File** and choose a suitable folder to store the .rdp file.

:::image type="content" source="media/aks-hci-evaluation-guide/connect-to-vm-properties.png" alt-text="Screenshot of RDP settings for Azure Virtual Machine":::

Once downloaded, locate the .rdp file on your local machine, and double-click to open it. Click **Connect** and when prompted, enter the credentials you supplied when creating the VM earlier. Accept any certificate prompts, and within a few minutes you should be successfully logged into the Windows Server VM.

## Step 3: Install Azure CLI on the Azure VM

Once you've logged into the Azure VM, run the following command to install Az CLI.

```PowerShell
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
Exit
```

## Step 4: Install Az CLI extensions on the Azure VM

```cli
$env:PATH += ";C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;"
az extension add -n k8s-extension 
az extension add -n customlocation
az extension add -n arcappliance
az extension add --source "https://hybridaksstorage.z13.web.core.windows.net/HybridAKS/CLI/hybridaks-0.1.4-py3-none-any.whl" --yes
```

## Step 5: Install pre-requisite PowerShell repositories

1. Open a new PowerShell admin window and run the following command:

   ```PowerShell
   Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted 
   Install-PackageProvider -Name NuGet -Force  
   Install-Module -Name PowershellGet -Force 
   Exit 
   ```

2. Open a new PowerShell admin window and run the following command:

   ```PowerShell
   Install-Module -Name AksHci -Repository PSGallery -AcceptLicense -Force 
   Exit 
   ```

3. Open a new PowerShell admin window and run the following command:

   ```PowerShell
   Install-Module -Name ArcHci -Repository PSGallery -AcceptLicense -Force 
   Exit 
   ```

4. Open a new PowerShell admin window and run the following command:

   ```PowerShell
   Initialize-AksHciNode 
   Exit 
   ```

5. Open a new PowerShell admin window and run the following command:

   ```PowerShell
   New-Item -Path "V:\" -Name "AKS-HCI" -ItemType "directory" -Force 
   New-Item -Path "V:\AKS-HCI\" -Name "Images" -ItemType "directory" -Force 
   New-Item -Path "V:\AKS-HCI\" -Name "WorkingDir" -ItemType "directory" -Force 
   New-Item -Path "V:\AKS-HCI\" -Name "Config" -ItemType "directory" -Force 
   Exit 
   ```

## Step 6: Install AKS on Windows Server management cluster 

1. Open a new PowerShell admin window and run the following command:

   ```PowerShell
   $vnet=New-AksHciNetworkSetting -Name "mgmt-vnet" -vSwitchName "InternalNAT" -gateway "192.168.0.1" -dnsservers "192.168.0.1" -ipaddressprefix "192.168.0.0/16" -   k8snodeippoolstart "192.168.0.4" -k8snodeippoolend "192.168.0.10" -vipPoolStart "192.168.0.150" -vipPoolEnd "192.168.0.160"
   Set-AksHciConfig -vnet $vnet -imageDir "V:\AKS-HCI\Images" -workingDir "V:\AKS-HCI\WorkingDir" -cloudConfigLocation "V:\AKS-HCI\Config" -Verbose 
   ```
 
2. Next, set the Azure subscription and resource group variables and then run `Set-AksHciRegistration`:

   ```PowerShell
   $sub = <Azure subscription>
   $rgName = "aksh-hybrid-preview-azurevm"

   #Use device authentication to login to Azure. Follow the steps you see on the screen
   Set-AksHciRegistration -SubscriptionId $sub -ResourceGroupName $rg -UseDeviceAuthentication
   ```

3. Run the following command to install AKS on Windows Server host:

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

Create the Azure Arc Resource Bridge YAML files:

```PowerShell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $arcAppName -workDirectory $workingDir -vnetName "appliance-vnet" -vSwitchName "InternalNAT"-gateway "192.168.0.1" -dnsservers "192.168.0.1" -ipaddressprefix "192.168.0.0/16" -k8snodeippoolstart "192.168.0.11 " -k8snodeippoolend "192.168.0.11" -controlPlaneIP “192.168.0.161”
```

Sample output:

```shell
HCI login file successfully generated in 'V:\AKS-HCI\WorkingDir\kvatoken.tok'
Generating ARC HCI configuration files...
Config file successfully generated in 'V:\AKS-HCI\WorkingDir'
```

## Step 8: Deploy Azure Arc Resource Bridge

> [!NOTE]
> Here you will be switching to AZ CLI, please continue to run this from the PS ISE or VS Code inside the Azure VM. 

```cli
az login -t $tenantid --use-device-code
az account set -s $subscriptionid
az arcappliance validate hci --config-file $configFilePath
az arcappliance prepare hci --config-file $configFilePath
az arcappliance deploy hci --config-file $configFilePath --outfile $workingDir\config
az arcappliance create hci --config-file $configFilePath --kubeconfig $workingDir\config
```

This command may take up to 10 minutess to finish. To check the status of your deployment, run the following command:

``` cli
# check the status == Running 
az arcappliance show --resource-group $resourceGroup --name $arcAppName --query "status" -o tsv
```

## Step 9: Install the AKS hybrid extension on the Arc Resource Bridge

To install the extension, run the following command:

```cli
az k8s-extension create -g $resourceGroup  -c $arcAppName --cluster-type appliances --name $arcExtnName  --extension-type Microsoft.HybridAKSOperator --version 0.0.23 --config Microsoft.CustomLocation.ServiceAccount="default"
```

Once you have created the AKS hybrid extension on top of the Arc Resource Bridge, run the following command to check if the cluster extension provisioning state says **Succeeded**. It might say something else at first, but you can try again after 10 minutes.

```cli
az k8s-extension show --resource-group $resourceGroup --cluster-name $arcAppName --cluster-type appliances --name $arcExtnName --query "provisioningState" -o tsv
```

## Step 10: Install a custom location on top of the Azure Arc Resource Bridge

```cli
$ArcApplianceResourceId=az arcappliance show --resource-group $resourceGroup --name $arcAppName --query id -o tsv
$ClusterExtensionResourceId=az k8s-extension show --resource-group $resourceGroup --cluster-name $arcAppName --cluster-type appliances --name $arcExtnName --query id -o tsv
```

To create a custom location, run the following command:

```cli
az customlocation create --name $customLocationName --namespace "default" --host-resource-id $ArcApplianceResourceId --cluster-extension-ids $ClusterExtensionResourceId --resource-group $resourceGroup 
```

Once you create the custom location on top of the Arc Resource Bridge, run the following command to check if the custom location provisioning state says **Succeeded**. It might say something else at first, but you can try again after 10 minutes.

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

Run the following command to download the Kubernetes VHD image to your Azure VM:

```PowerShell
Add-KvaGalleryImage -kubernetesVersion 1.21.9
```

## Step 13: Create an Azure AD group and add yourself to it

```cli
az ad group create --display-name aad-group --mail-nickname aad-group
$objectId = az ad signed-in-user show --query Id
az ad group member add --group aad-group --member-id $objectId
$aadGroupId =$(az ad group show --display-name aad-group --query Id -o tsv)
```

## Step 14:	Create an AKS hybrid cluster using Az CLI

Note that the following create command can take about 10-15mins to complete:

```cli
az hybridaks create --name "test-cluster" --resource-group $resourceGroup --custom-location $clid --vnet-ids $vnetId --kubernetes-version "v1.21.9" --aad-admin-group-object-ids $aadGroupId --generate-ssh-keys
```

### Add a Linux nodepool to the AKS hybrid cluster

```cli
az hybridaks nodepool add -n "test-nodepool" --resource-group $resourceGroup --cluster-name "test-cluster"
```

## Step 15: Get the AAD based kubeconfig to connect to your AKS hybrid cluster

Keep the following command running for as long as you want to remain connected to your AKS hybrid cluster:

```cli
az hybridaks proxy --resource-group $resourceGroup --name “test-cluster” --file .\target-config
```

### List the pods of the provisioned cluster using the kubeconfig

```shell
kubectl get pods -A --kubeconfig .\target-config
```

## Next steps

Once you've finished quickly trying out this feature in an Azure VM, you can take a look at the following documents related to the preview:

- [Review requirements to get started with AKS hybrid cluster provisioning through Azure in your datacenter](aks-hybrid-preview-requirements.md)
