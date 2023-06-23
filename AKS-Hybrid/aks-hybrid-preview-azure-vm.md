---
title: Quickly get started with using Azure CLI to deploy an AKS hybrid cluster on Windows Server in an Azure VM
description: Quickly get started with using Azure CLI to deploy an AKS hybrid cluster on Windows Server in an Azure VM
author: sethmanheim
ms.topic: quickstart
ms.custom:
  - devx-track-azurecli
ms.date: 02/21/2023
ms.author: sethm 
ms.lastreviewed: 02/13/2023
ms.reviewer: abha

# Intent: As an IT Pro, I want to use Az CLI to test creating AKS hybrid clusters on-premises
# Keyword: AKS setup PowerShell 
---

# Quickstart: Using Azure CLI to deploy an AKS hybrid cluster on a Windows Server node in an Azure VM

In this quickstart, you learn how to use Azure CLI to test creating AKS hybrid clusters on-premises. You can use this quickstart to run a quick proof-of-concept on an Azure VM, or if you do not have a Windows Server or Azure Stack HCI cluster.

If you do have a Windows Server or Azure Stack HCI cluster, follow this detailed guide to [get started with deploying AKS hybrid clusters from Azure](aks-hybrid-preview-requirements.md).

## Before you begin

Before you begin, make sure you meet the following requirements:

- Have access to an Azure subscription.
- You're an owner of the Azure subscription.

## Step 1: Create an Azure VM and deploy Windows Server on the Azure VM

To keep things simple, we show you how to deploy your VM via an Azure Resource Manager template. The **Deploy to Azure** button, when clicked, takes you directly to the Azure portal, and upon sign-in, provides you with a form to complete. If you want to open this form in a new tab, hold CTRL when you click the button.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Faks-hci%2Fmain%2Feval%2Fjson%2Fakshcihost.json "Deploy to Azure")

After clicking the **Deploy to Azure** button, enter the details, which should look something similar to the following image, and then click **Review and Create**.

:::image type="content" source="media/aks-hci-evaluation-guide/deploy-custom-template.png" alt-text="Screenshot of custom template deployment in Azure.":::

> [!NOTE]
> For customers with Software Assurance, Azure Hybrid Benefit for Windows Server allows you to use your on-premises Windows Server licenses and run Windows virtual machines on Azure at a reduced cost. By selecting **Yes** for the "Already have a Windows Server License", you confirm you have an eligible Windows Server license with Software Assurance or Windows Server subscription to apply this Azure Hybrid Benefit and have reviewed the [Azure hybrid benefit compliance](https://go.microsoft.com/fwlink/?LinkId=859786).

The custom template is validated, and if all of your entries are correct, you can select **Create**. In 30 minutes, your VM is created.

:::image type="content" source="media/aks-hci-evaluation-guide/deployment-complete.png" alt-text="Screenshot of custom template deployment completed.":::

### Access your Azure VM

With your Azure Virtual Machine (AKSHCIHost001) successfully deployed and configured, you're ready to connect to the VM using Remote Desktop.

If you're not already signed into the [Azure portal](https://portal.azure.com), sign in with the same credentials you previously used. Once signed in, enter "azshci" in the search box on the dashboard, and in the search results select your **AKSHCIHost001** virtual machine.

:::image type="content" source="media/aks-hci-evaluation-guide/azure-vm-search.png" alt-text="Screenshot of virtual machine located in Azure.":::

In the **Overview** blade for your VM, at the top of the blade, select **Connect**, and from the drop-down options select **RDP**. On the newly opened **Connect** blade, ensure that **Public IP** is selected. Also ensure that the RDP port matches what you provided at deployment time. By default, this port should be **3389**. Then select **Download RDP File** and choose a suitable folder to store the .rdp file.

:::image type="content" source="media/aks-hci-evaluation-guide/connect-to-vm-properties.png" alt-text="Screenshot of RDP settings for Azure Virtual Machine.":::

Once downloaded, locate the .rdp file on your local machine, and double-click to open it. Click **Connect** and when prompted, enter the credentials you supplied when creating the VM earlier. Accept any certificate prompts, and within a few minutes you should be successfully logged into the Azure VM.

## Step 2: Register your Azure subscription for features and providers

You can use the Azure portal shell to run the following commands.

Register the following Azure feature on your Azure subscription. Make sure you sign in to Azure first, then select the correct Azure subscription using `az account set`. You only need to do this operation once per Azure subscription:  

```azurecli
az feature register --namespace Microsoft.HybridConnectivity --name hiddenPreviewAccess
```

Wait until the feature registration is complete before moving to the next step. You can check if it's registered using the following command:

```azurecli
az feature show --namespace Microsoft.HybridConnectivity --name hiddenPreviewAccess --query "properties" -o tsv
```

Expected output:

`Registered`

Register the following Azure providers on your Azure subscription. Make sure you sign in to Azure first, then select the correct Azure subscription using `az account set`. You only need to do this operation once per Azure subscription:

```azurecli
az provider register --namespace Microsoft.Kubernetes --wait 
az provider register --namespace Microsoft.KubernetesConfiguration --wait 
az provider register --namespace Microsoft.ExtendedLocation --wait
az provider register --namespace Microsoft.ResourceConnector --wait
az provider register --namespace Microsoft.HybridContainerService --wait
az provider register --namespace Microsoft.HybridConnectivity --wait
```

## Step 3: Install Azure CLI on the Azure VM

You must run the commands in this step in an administrative PowerShell window inside the Azure VM.

Follow step 1 to sign in to the Azure VM. Once you've signed in to the Azure VM, run the following command on the Azure VM to install Azure CLI:

```PowerShell
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
Exit
```

## Step 4: Install Az CLI extensions on the Azure VM

Run the following commands in a PowerShell admin window inside the Azure VM:

```PowerShell
$env:PATH += ";C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;"
az extension add -n k8s-extension --upgrade
az extension add -n customlocation --upgrade
az extension add -n arcappliance --upgrade
az extension add -n hybridaks --upgrade
```

## Step 5: Install prerequisite PowerShell repositories

Run the following commands in a PowerShell admin window inside the Azure VM.

Close all open PowerShell windows on your Azure VM, open a new PowerShell admin window, and run the following commands:

```PowerShell
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted 
Install-PackageProvider -Name NuGet -Force  
Install-Module -Name PowershellGet -Force 
Exit 
```

Open a new PowerShell admin window and run the following command:

```PowerShell
Install-Module -Name ArcHci -Repository PSGallery -AcceptLicense -Force -RequiredVersion 0.2.23
Exit 
```

Open a new PowerShell admin window and run the following command:

```PowerShell
New-Item -Path "V:\" -Name "Arc-HCI" -ItemType "directory" -Force  
New-Item -Path "V:\Arc-HCI\" -Name "WorkingDir" -ItemType "directory" -Force 
Exit 
```

## Step 6: Install Moc on the Azure VM & download Kubernetes VHD image

Open a new PowerShell admin window and run the following command:
```PowerShell
Set-MocConfig -workingDir "V:\Arc-HCI\WorkingDir" 
Install-Moc
curl.exe -LO "https://dl.k8s.io/release/v1.25.0/bin/windows/amd64/kubectl.exe"
$config = Get-MocConfig
cp .\kubectl.exe $config.installationPackageDir
```

Download the Linux VHD image by running the following command:
```PowerShell
Import-Module 'C:\Program Files\WindowsPowerShell\Modules\ArcHci\0.2.23\ArcHci.psm1' -Force
$mocConfig = Get-MocConfig
$k8sVersion = "1.22.11"
$mocVersion = "1.0.16.10113"
$imageType = "Linux"
$imageName = Get-LegacyKubernetesGalleryImageName -imagetype $imageType -k8sVersion $k8sVersion
$galleryImage = $null

# Check if requested k8s gallery image is already present
try {
    $galleryImage = Get-MocGalleryImage -name $imageName -location $mocConfig.cloudLocation
} catch {}

if ($null -ine $galleryImage) {
    Write-Output "$imageType $k8sVersion k8s gallery image already present in MOC"
} else {
    $imageRelease = Get-ImageReleaseManifest -imageVersion $mocVersion -operatingSystem $imageType -k8sVersion $k8sVersion -moduleName "Moc"

    Write-Output "Downloading $imageType $k8sVersion k8s gallery image"
    $result = Get-ImageRelease -imageRelease $imageRelease -imageDir $mocConfig.imageDir -moduleName "Moc" -releaseVersion $mocVersion

    Write-Output "Adding $imageType $k8sVersion k8s gallery image to MOC"
    New-MocGalleryImage -name $imageName -location $mocConfig.cloudLocation -imagePath $result -container "MocStorageContainer"
}
```


## Step 7: Generate prerequisite YAML files needed to deploy Azure Arc Resource Bridge

Run the following commands in a PowerShell admin window inside the Azure VM:

```PowerShell
$subscriptionId = <Azure subscription ID>
$resourceGroup = <Azure resource group>
$location=<Azure location. Can be "eastus", "westeurope", "westus3", or "southcentralus">
```

```PowerShell
$workingDir = "V:\Arc-HCI\WorkingDir"
$arcAppName="arc-resource-bridge"
$configFilePath= $workingDir + "\hci-appliance.yaml"
$arcExtnName = "aks-hybrid-ext"
$customLocationName="azurevm-customlocation"
```

Generate the Azure Arc Resource Bridge YAML files:

```PowerShell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionId -location $location -resourceGroup $resourceGroup -resourceName $arcAppName -workDirectory $workingDir -vnetName "appliance-vnet" -vSwitchName "InternalNAT" -gateway "192.168.0.1" -dnsservers "192.168.0.1" -ipaddressprefix "192.168.0.0/16" -k8snodeippoolstart "192.168.0.11" -k8snodeippoolend "192.168.0.11" -controlPlaneIP "192.168.0.161"
```

Sample output:

```output
HCI login file successfully generated in 'V:\Arc-HCI\WorkingDir\kvatoken.tok'
Generating ARC HCI configuration files...
Config file successfully generated in 'V:\Arc-HCI\WorkingDir'
```

## Step 8: Deploy Azure Arc Resource Bridge

You must run the commands in this step in a PowerShell admin window inside the Azure VM.

Once you've generated the YAML files, run the following command to validate the generated YAML files. Remember to log in to Azure before running these commands.

```PowerShell
az account set -s $subscriptionid
az arcappliance validate hci --config-file $configFilePath
```

After you've validated the YAML files, run the following command to download the VHD image for deploying Arc Resource Bridge.

```PowerShell
az arcappliance prepare hci --config-file $configFilePath
```

After you've downloaded the VHD image for deploying Arc Resource Bridge, you can now run the following command to deploy Arc Resource Bridge.

```PowerShell
az arcappliance deploy hci --config-file $configFilePath --outfile $workingDir\config
```

Once you've deployed Arc Resource Bridge, run the following command to connect it to Azure.

```PowerShell
az arcappliance create hci --config-file $configFilePath --kubeconfig $workingDir\config
```

Connecting Arc Resource Bridge to Azure can take up to 10 minutes to finish. To check the status of your deployment, run the following command. The Arc Resource Bridge must be in the `Running` state:

```PowerShell
az arcappliance show --resource-group $resourceGroup --name $arcAppName --query "status" -o tsv
```

Expected output:

`Running`

## Step 9: Install the AKS hybrid extension on the Arc Resource Bridge

You can run the commands in this step from an Azure portal shell.

To install the AKS hybrid extension on the Arc Resource Bridge, run the following command:

```azurecli
az k8s-extension create -g $resourceGroup  -c $arcAppName --cluster-type appliances --name $arcExtnName  --extension-type Microsoft.HybridAKSOperator --config Microsoft.CustomLocation.ServiceAccount="default"
```

Once you've created the AKS hybrid extension on top of the Arc Resource Bridge, run the following command to check if the cluster extension provisioning state says **Succeeded**. It might say something else at first, but you can try again after 10 minutes.

```azurecli
az k8s-extension show --resource-group $resourceGroup --cluster-name $arcAppName --cluster-type appliances --name $arcExtnName --query "provisioningState" -o tsv
```

Expected output:

`Succeeded`

## Step 10: Create a custom location on top of the Azure Arc Resource Bridge

You can run the commands in this step from an Azure portal shell.

Run the following commands to create a custom Location on top of the Arc Resource Bridge. You choose this custom location when creating the AKS hybrid cluster through Azure CLI or through the Azure portal.

```azurecli
$ArcApplianceResourceId=az arcappliance show --resource-group $resourceGroup --name $arcAppName --query id -o tsv
$ClusterExtensionResourceId=az k8s-extension show --resource-group $resourceGroup --cluster-name $arcAppName --cluster-type appliances --name $arcExtnName --query id -o tsv
```

To create a Custom Location, run the following command:

```azurecli
az customlocation create --name $customLocationName --namespace "default" --host-resource-id $ArcApplianceResourceId --cluster-extension-ids $ClusterExtensionResourceId --resource-group $resourceGroup 
```

Once you create the Custom Location on top of the Arc Resource Bridge, run the following command to check if the Custom Location provisioning state says **Succeeded**. It might say something else at first, but you can try again after 10 minutes.

```azurecli
az customlocation show --name $customLocationName --resource-group $resourceGroup --query "provisioningState" -o tsv
```

Expected output:

`Succeeded`

## Step 11: Create a local network for AKS hybrid clusters and connect it to Azure

You must run the commands in this step in a PowerShell admin window inside the Azure VM.

Run the following command to create the local network for AKS hybrid clusters:

```PowerShell
New-ArcHciVirtualNetwork -name hybridaks-vnet -vSwitchName "InternalNAT" -gateway "192.168.0.1" -dnsservers "192.168.0.1" -ipaddressprefix "192.168.0.0/16" -k8snodeippoolstart "192.168.0.15" -k8snodeippoolend "192.168.0.25" -vipPoolStart "192.168.0.162" -vipPoolEnd "192.168.0.170" 
```

Once you've created the local network, connect it to Azure by running the following command:

```azurecli
$clid = az customlocation show --name $customLocationName --resource-group $resourceGroup --query "id" -o tsv
az hybridaks vnet create -n "azvnet" -g $resourceGroup --custom-location $clId --moc-vnet-name "hybridaks-vnet"
$vnetId = az hybridaks vnet show -n "azvnet" -g $resourceGroup --query id -o tsv
```

## Step 12: Create an Azure AD group and add Azure AD members to it

You can perform the operations in this step from the Azure portal or from Azure CLI.

In order to connect to the AKS hybrid cluster from anywhere, you need to create an Azure AD group and add members to it. All the members of the Azure AD group have cluster administrator access to the AKS hybrid cluster. Make sure to add yourself to the Azure AD group. If you do not add yourself, you cannot access the AKS hybrid cluster using `kubectl`.

To learn more about how to create an Azure AD group, visit [how to manage and create Azure AD groups](/azure/active-directory/fundamentals/how-to-manage-groups#create-a-basic-group-and-add-members). You need the `objectID` of the Azure AD group to create AKS hybrid clusters. You can skip this step if you already have an Azure AD group.

## Step 13: Create an AKS hybrid cluster using Azure CLI

Run the following command to create an AKS hybrid cluster using Azure CLI:

```azurecli
az hybridaks create --name <Name of your AKS hybrid cluster> --resource-group $resourceGroup --custom-location $clid --vnet-ids $vnetId --kubernetes-version "v1.22.11" --aad-admin-group-object-ids <Azure AD group object ID> --generate-ssh-keys
```

### Add a Linux nodepool to the AKS hybrid cluster

```azurecli
az hybridaks nodepool add -n <nodepool name> --resource-group $resourceGroup --cluster-name <aks hybrid cluster name>
```

## Step 15: Connect to your AKS hybrid cluster using `kubectl` and Azure AD

In order to connect to your AKS hybrid cluster using `kubectl`, run the following command:

```azurecli
az hybridaks proxy --resource-group $resourceGroup --name <aks-hybrid cluster name> --file .\target-config
```

To access your cluster, let this command run for as long as you want. If this command times out, close the PowerShell window, open a new one, and run the command again.

### List the pods of the provisioned cluster using the kubeconfig

In a different command line window, run the following command pointing to the kubeconfig you downloaded in the previous step.

```powershell
kubectl get pods -A --kubeconfig .\target-config
```

Expected output:

```shell
NAME                                              READY   STATUS      RESTARTS   AGE
akshci-telemetry-initial-h6xr9                    0/1     Completed   0          48s
calico-kube-controllers-5477b8df74-8sxbq          1/1     Running     0          9h
calico-node-6hhwb                                 1/1     Running     0          8h
calico-node-tmqmh                                 1/1     Running     0          9h
calico-patch-99pc8                                1/1     Running     0          9h
calico-patch-z4pn2                                1/1     Running     0          8h
calicoctl                                         1/1     Running     0          9h
certificate-controller-manager-7c7cb9746c-ppdt7   1/1     Running     0          9h
coredns-7489c675f5-84xcz                          1/1     Running     0          9h
coredns-7489c675f5-qbfjn                          1/1     Running     0          9h
csi-akshcicsi-controller-5f6bff6dc8-j4dzx         5/5     Running     0          9h
csi-akshcicsi-node-jjzxg                          3/3     Running     0          8h
csi-akshcicsi-node-pj2sp                          3/3     Running     0          9h
etcd-moc-l1hj0nllpvs                              1/1     Running     0          9h
kube-apiserver-moc-l1hj0nllpvs                    1/1     Running     0          9h
kube-controller-manager-moc-l1hj0nllpvs           1/1     Running     0          9h
kube-proxy-8jhdl                                  1/1     Running     0          9h
kube-proxy-lsk6f                                  1/1     Running     0          8h
kube-scheduler-moc-l1hj0nllpvs                    1/1     Running     0          9h
moc-cloud-controller-manager-5fbb78df68-6d7b5     1/1     Running     0          9h
```

## Next steps

Once you've finished quickly trying out this preview in an Azure VM, you can take a look at the following documents related to the preview:

- [Review requirements to get started with AKS hybrid cluster provisioning through Azure in your datacenter](aks-hybrid-preview-requirements.md)
