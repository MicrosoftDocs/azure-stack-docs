---
title: Quickly get started with using Azure CLI to deploy an AKS hybrid cluster on Windows Server in an Azure VM
description: Quickly get started with using Azure CLI to deploy an AKS hybrid cluster on Windows Server in an Azure VM
author: sethmanheim
ms.topic: quickstart
ms.date: 10/25/2022
ms.author: sethm 
ms.lastreviewed: 10/25/2022
ms.reviewer: abha

# Intent: As an IT Pro, I want to use Az CLI to test creating AKS hybrid clusters on-premises
# Keyword: AKS setup PowerShell 
---

# Quickstart: Using Azure CLI to deploy an AKS hybrid cluster on a Windows Server node in an Azure VM

In this quickstart, you'll learn how to use Azure CLI to test creating AKS hybrid clusters on-premises. You can use this quickstart to run a quick proof of concept on an Azure VM, or if you do not have a Windows Server or Azure Stack HCI cluster.

If you do have a Windows Server or Azure Stack HCI cluster, follow this detailed guide to [get started with deploying AKS hybrid clusters from Azure](aks-hybrid-preview-requirements.md).

## Before you begin

Before you begin, make sure you meet the following requirements:
- Have access to an Azure subscription.
- Make sure you're an owner of the Azure subscription. 

## Step 1: Register your Azure subscription for features and providers

Register the following Azure providers on your Azure subscription. Make sure you login to Azure first. You only need to do this operation once per Azure subscription.

```azurecli
az provider register --namespace Microsoft.Kubernetes --wait 
az provider register --namespace Microsoft.ExtendedLocation --wait
az provider register --namespace Microsoft.ResourceConnector --wait
az provider register --namespace Microsoft.HybridContainerService --wait
az provider register --namespace Microsoft.HybridConnectivity --wait
```

## Step 2: Create an Azure VM and deploy Windows Server on the Azure VM
To keep things simple, we'll show you how to deploy your VM via an Azure Resource Manager template. The **Deploy to Azure** button, when clicked, takes you directly to the Azure portal, and upon sign-in, provides you with a form to complete. If you want to open this in a new tab, hold CTRL when you click the button.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Faks-hci%2Fmain%2Feval%2Fjson%2Fakshcihost.json "Deploy to Azure")

After clicking the **Deploy to Azure** button, enter the details, which should look something similar to those shown below, and click **Review and Create**.

:::image type="content" source="media/aks-hci-evaluation-guide/deploy-custom-template.png" alt-text="Screenshot of custom template deployment in Azure.":::

> [!NOTE]
> For customers with Software Assurance, Azure Hybrid Benefit for Windows Server allows you to use your on-premises Windows Server licenses and run Windows virtual machines on Azure at a reduced cost. By selecting **Yes** for the "Already have a Windows Server License", you confirm you have an eligible Windows Server license with Software Assurance or Windows Server subscription to apply this Azure Hybrid Benefit and have reviewed the [Azure hybrid benefit compliance](https://go.microsoft.com/fwlink/?LinkId=859786).

The custom template will be validated, and if all of your entries are correct, you can select **Create**. In 30 minutes, your VM will be created.

:::image type="content" source="media/aks-hci-evaluation-guide/deployment-complete.png" alt-text="Screenshot of custom template deployment completed.":::

### Access your Azure VM
With your Azure Virtual Machine (AKSHCIHost001) successfully deployed and configured, you're ready to connect to the VM using Remote Desktop.

If you're not already signed into the [Azure portal](https://portal.azure.com), sign in with the same credentials you previously used. Once signed in, enter "azshci" in the search box on the dashboard, and in the search results select your **AKSHCIHost001** virtual machine.

:::image type="content" source="media/aks-hci-evaluation-guide/azure-vm-search.png" alt-text="Screenshot of virtual machine located in Azure.":::

In the **Overview** blade for your VM, at the top of the blade, select **Connect**, and from the drop-down options select **RDP**. On the newly opened **Connect** blade, ensure that **Public IP** is selected. Also ensure that the RDP port matches what you provided at deployment time. By default, this should be **3389**. Then select **Download RDP File** and choose a suitable folder to store the .rdp file.

:::image type="content" source="media/aks-hci-evaluation-guide/connect-to-vm-properties.png" alt-text="Screenshot of RDP settings for Azure Virtual Machine.":::

Once downloaded, locate the .rdp file on your local machine, and double-click to open it. Click **Connect** and when prompted, enter the credentials you supplied when creating the VM earlier. Accept any certificate prompts, and within a few minutes you should be successfully logged into the Azure VM.

## Step 3: Install Azure CLI on the Azure VM

Once you've logged into the Azure VM, run the following command to install Az CLI.

```PowerShell
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
Exit
```

## Step 4: Install Az CLI extensions on the Azure VM

```azurecli
$env:PATH += ";C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;"
az extension add -n k8s-extension --upgrade
az extension add -n customlocation --upgrade
az extension add -n arcappliance --upgrade --version 0.2.27
az extension add -n hybridaks --upgrade
```

## Step 5: Install pre-requisite PowerShell repositories

Close all open PowerShell windows on your Azure VM and open a fresh new PowerShell admin window and run the following command:

   ```PowerShell
   Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted 
   Install-PackageProvider -Name NuGet -Force  
   Install-Module -Name PowershellGet -Force 
   Exit 
   ```

Open a new PowerShell admin window and run the following command:

   ```PowerShell
   Install-Module -Name AksHci -Repository PSGallery -AcceptLicense -Force 
   Exit 
   ```

Open a new PowerShell admin window and run the following command:

   ```PowerShell
   Install-Module -Name ArcHci -Repository PSGallery -AcceptLicense -Force 
   Exit 
   ```

Open a new PowerShell admin window and run the following command:

   ```PowerShell
   Initialize-AksHciNode 
   Exit 
   ```

Open a new PowerShell admin window and run the following command:

   ```PowerShell
   New-Item -Path "V:\" -Name "AKS-HCI" -ItemType "directory" -Force 
   New-Item -Path "V:\AKS-HCI\" -Name "Images" -ItemType "directory" -Force 
   New-Item -Path "V:\AKS-HCI\" -Name "WorkingDir" -ItemType "directory" -Force 
   New-Item -Path "V:\AKS-HCI\" -Name "Config" -ItemType "directory" -Force 
   Exit 
   ```

## Step 6: Install the AKS on Windows Server management cluster 

Open a new PowerShell admin window and run the following command:

```PowerShell
$vnet=New-AksHciNetworkSetting -Name "mgmt-vnet" -vSwitchName "InternalNAT" -gateway "192.168.0.1" -dnsservers "192.168.0.1" -ipaddressprefix "192.168.0.0/16" -k8snodeippoolstart "192.168.0.4" -k8snodeippoolend "192.168.0.10" -vipPoolStart "192.168.0.150" -vipPoolEnd "192.168.0.160"

Set-AksHciConfig -vnet $vnet -imageDir "V:\AKS-HCI\Images" -workingDir "V:\AKS-HCI\WorkingDir" -cloudConfigLocation "V:\AKS-HCI\Config" -version "1.0.13.10907" -cloudServiceIP "192.168.0.4"  
```

Next, set the Azure subscription and resource group variables and then run `Set-AksHciRegistration`:

```PowerShell
$sub = <Azure subscription>
$rgName = <Azure resource group>

#Use device authentication to login to Azure. Follow the steps you see on the screen
Set-AksHciRegistration -SubscriptionId $sub -ResourceGroupName $rgName -UseDeviceAuthentication
```
   
Run the following command to install AKS on Windows Server host:
```PowerShell
Install-AksHci 
```
   
### Validate AKS on Windows Server version

Make sure your AKS on Windows Server version is the following. 
Expected Output:

```output
1.0.13.10907
```
Do not proceed if you have any errors! If you face an issue installing AKS on Windows Server, review the [troubleshooting section](known-issues.yml). If the troubleshooting section does not help you, file a [GitHub issue](https://github.com/Azure/aks-hci/issues). Attach logs using `Get-AksHciLogs` so that we can help you faster.

## Step 7: Generate pre-requisite YAML files needed to deploy Azure Arc Resource Bridge

```PowerShell
$subscriptionId = <Azure subscription ID>
$resourceGroup = <Azure resource group>
$location=<Azure location. Can be "eastus" or "westeurope">
```

```PowerShell
$workingDir = "V:\AKS-HCI\WorkDir"
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
HCI login file successfully generated in 'V:\AKS-HCI\WorkingDir\kvatoken.tok'
Generating ARC HCI configuration files...
Config file successfully generated in 'V:\AKS-HCI\WorkingDir'
```

## Step 8: Deploy Azure Arc Resource Bridge

Once you've generated the YAML files, run the following command to validate the generated YAML files. Remember to log in to Azure before running these commands.
```azurecli
az account set -s $subscriptionid
az arcappliance validate hci --config-file $configFilePath
```

After you've validated the YAML files, run the following command to download the VHD image for deploying Arc Resource Bridge.

```azurecli
az arcappliance prepare hci --config-file $configFilePath
```
After you've downloaded the VHD image for deploying Arc Resource Bridge, you can now run the following command to deploy Arc Resource Bridge.

```azurecli
az arcappliance deploy hci --config-file $configFilePath --outfile $workingDir\config
```

Once you've deployed Arc Resource Bridge, run the following command to connect it to Azure.
```azurecli
az arcappliance create hci --config-file $configFilePath --kubeconfig $workingDir\config
```

Connecting Arc Resource Bridge to Azure may take up to 10 minutes to finish. To check the status of your deployment, run the following command. The Arc Resource Bridge must be in `Running` state.

```azurecli
az arcappliance show --resource-group $resourceGroup --name $arcAppName --query "status" -o tsv
```
Expected output:
```output
Running
```

## Step 9: Install the AKS hybrid extension on the Arc Resource Bridge

To install the AKS hybrid extension on the Arc Resource Bridge, run the following command:

```azurecli
az k8s-extension create -g $resourceGroup  -c $arcAppName --cluster-type appliances --name $arcExtnName  --extension-type Microsoft.HybridAKSOperator --config Microsoft.CustomLocation.ServiceAccount="default"
```

Once you've created the AKS hybrid extension on top of the Arc Resource Bridge, run the following command to check if the cluster extension provisioning state says **Succeeded**. It might say something else at first, but you can try again after 10 minutes.

```azurecli
az k8s-extension show --resource-group $resourceGroup --cluster-name $arcAppName --cluster-type appliances --name $arcExtnName --query "provisioningState" -o tsv
```
Expected output:
```output
Succeeded
```

## Step 10: Create a Custom Location on top of the Azure Arc Resource Bridge

Run the following commands to create a Custom Location on top of the Arc Resource Bridge. You will choose this Custom Location when creating the AKS hybrid cluster through Az CLI or through the Azure portal.

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
```output
Succeeded
```

## Step 11: Create a local network for AKS hybrid clusters and connect it to Azure

Run the following command to create the local network for AKS hybrid clusters:

```PowerShell
New-KvaVirtualNetwork -name hybridaks-vnet -vSwitchName "InternalNAT" -gateway "192.168.0.1" -dnsservers "192.168.0.1" -ipaddressprefix "192.168.0.0/16" -k8snodeippoolstart "192.168.0.15" -k8snodeippoolend "192.168.0.25" -vipPoolStart "192.168.0.162" -vipPoolEnd "192.168.0.170" -kubeconfig $workingDir\config
```

Once you've created the local network, connect it to Azure by running the following command:

```azurecli
$clid = az customlocation show --name $customLocationName --resource-group $resourceGroup --query "id" -o tsv
az hybridaks vnet create -n "azvnet" -g $resourceGroup --custom-location $clId --moc-vnet-name "hybridaks-vnet"
$vnetId = az hybridaks vnet show -n "azvnet" -g $resourceGroup --query id -o tsv
```

## Step 12: Download the Kubernetes VHD image to your Azure VM

Run the following command to download the Kubernetes VHD image for your AKS hybrid clusters to your Azure VM:

```PowerShell
Add-KvaGalleryImage -kubernetesVersion 1.21.9
```

## Step 13: Create an Azure AD group and add Azure AD members to it
In order to connect to the AKS hybrid cluster from anywhere, you need to create an Azure AD group and add members to it. All the members in the Azure AD group will have cluster administrator access to the AKS hybrid cluster. Make sure to add yourself to the Azure AD group. If you do not add yourself, you will not be able to access the AKS hybrid cluster using `kubectl`.

To learn more about how to create an Azure AD group, visit [how to manage and create Azure AD groups](/azure/active-directory/fundamentals/how-to-manage-groups#create-a-basic-group-and-add-members). You will need the `objectID` of the Azure AD group to create AKS hybrid clusters. You can skip this step if you already have an Azure AD group.

## Step 14: Create an AKS hybrid cluster using Azure CLI

Run the following command to create an AKS hybrid cluster using Azure CLI. 

```azurecli
az hybridaks create --name <Name of your AKS hybrid cluster> --resource-group $resourceGroup --custom-location $clid --vnet-ids $vnetId --kubernetes-version "v1.21.9" --aad-admin-group-object-ids <Azure AD group object ID> --generate-ssh-keys
```

### Add a Linux nodepool to the AKS hybrid cluster

```azurecli
az hybridaks nodepool add -n <nodepool name> --resource-group $resourceGroup --cluster-name <aks hybrid cluster name>
```

## Step 15: Connect to your AKS hybrid cluster using `kubectl` and Azure AD

In order to connect to your AKS hybrid cluster using `kubectl`, run the following command. 
```azurecli
az hybridaks proxy --resource-group $resourceGroup --name <aks-hybrid cluster name> --file .\target-config
```
Let this command run for as long as you want to access your cluster. If this command times out, close the PowerShell window, open a fresh one and run the command again. 

### List the pods of the provisioned cluster using the kubeconfig

In a different command line window, run the following command pointing to the kubeconfig you downloaded in the previous step.
```
kubectl get pods -A --kubeconfig .\target-config
```

Expected Output:
```output
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
