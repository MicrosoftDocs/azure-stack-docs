---
title: How to deploy Azure Arc Resource Bridge on Windows Server
description: How to deploy Azure Arc Resource Bridge on Windows Server
author: abha
ms.author: abha
ms.topic: how-to
ms.date: 09/29/2022
---



# How to install Arc Resource Bridge on Windows Server through command line

> Applies to: Windows Server 2019 or 2022

Follow these steps to install Arc Resource Bridge on Windows Server through command line. Make sure you have reviewed the [requirements for AKS hybrid cluster provisioning from Azure](aks-hybrid-preview-requirements.md).

### Step 1: Install AKS on Windows Server using PowerShell 

Follow [this quickstart to install](kubernetes-walkthrough-powershell.md) AKS on Windows Server management cluster. Since you will be running preview software beside your AKS on Windows Server setup, we do not recommend running AKS on Windows Server and this private preview in your production environment. We highly recommend installing the AKS management cluster only if using Azure Arc Resource Bridge behind a proxy. 

If you face an issue installing AKS on Windows Server, review the AKS on Windows Server [troubleshooting section](/known-issues). If the troubleshooting section does not help you, please file a [GitHub issue](https://github.com/Azure/aks-hci/issues). Make sure you attach logs (use `Get-AksHciLogs`), so that we can help you faster.

To check if you have successfully installed AKS on Windows Server, run the following command:

```powershell
Get-AksHciVersion
```

Make sure your AKS on Windows Server version is the following version:

Expected Output:

```shell
1.0.12.10727
```

> [!NOTE]
> Do not proceed if you have any errors! If you face an issue installing AKS on Windows Server, review the AKS on Windows Server [troubleshooting section](known-issues.md). If the troubleshooting section does not help you, file a [GitHub issue](https://github.com/Azure/aks-hci/issues). Make sure you attach logs (use `Get-AksHciLogs`), so that we can help you faster.

## Step 2: Generate YAML files required for installing Arc Resource Bridge

Installing Azure Arc Resource Bridge requires you to create a YAML file. Fortunately, we have automated the process of creating this YAML file for you. Before running the PowerShell command that will generate these YAML files, make sure you have the following parameters ready:

| Parameter  |  Parameter details |
| -----------| ------------ |
| $subscriptionID | Your Azure Arc Resource Bridge will be installed on this Azure subscription ID. |
| $resourceGroup | A resource group in the Azure subscription listed above. Make sure your resource group is in the eastus, westeurope, southcentralus or westus3 location. |
| $location | The Azure location where your Azure Arc Resource Bridge will be deployed. Make sure this location is eastus, westeurope, southcentralus or westus3 . It's recommended you use the same location you used while creating the resource group. |
| $resourceName | The name of your Azure Arc Resource Bridge |
| $workDirectory | Path to a shared cluster volume that stores the config files we create for you. We recommend you use the same workDir you used while installing AKS-HCI. Make sure your workDir full path does not contain any spaces. |

#### More parameters if you're using Static IP (recommended)

| Parameter  |  Parameter details |
| -----------| ------------ |
| $vswitchname | The name of your VM switch. |
| $ipaddressprefix | The IP address value of your subnet |
| $gateway | The IP address value of your gateway for the subnet |
| $dnsservers | The IP address value(s) of your DNS servers |
| $vmIP | This IP address will the IP address of the VM that is the underlying compute of Azure Arc Resource Bridge. Make sure that this IP address comes from the subnet in your datacenter. Also make sure that this IP address is available and isnt being used anywhere else.
| $controlPlaneIP | This IP address will be used by the Kubernetes API server of the Azure Arc Resource Bridge. Similar to $vmIP, make sure that this IP address comes from the subnet in your datacenter. Also make sure that this IP address is available and isn't being used anywhere else.

#### More parameters if you're using DHCP

| Parameter  |  Parameter details |
| -----------| ------------ |
| $vswitchname | The name of your VM switch |
| $controlPlaneIP | This IP address will be used by the Kubernetes API server of the Azure Arc Resource Bridge. Make sure that this IP address is excluded from your DHCP scope. Also make sure that this IP address is available and isn't being used anywhere else.

#### More parameters if you have a proxy server in your environment

| Parameter  | Required or Optional? |  Parameter details |
| -----------| ------ | ------------ |
| $proxyServerHTTP | Required | HTTP URL and port information. For example, "http://192.168.0.10:80" |
| $proxyServerHTTPS | Required | HTTPS URL and port information. For example, https://192.168.0.10:443 |
| $proxyServerNoProxy | Required | URLs which can bypass proxy  |
| $certificateFilePath | Optional | Name of the certificate file path for proxy. Example: C:\Users\Palomino\proxycert.crt |
| $proxyServerUsername | Optional | Username for proxy authentication. The username and password will be combined in a URL format similar to the following: http://username:password@proxyserver.contoso.com:3128. Example: Eleanor
| $proxyServerPassword | Optional | Password for proxy authentication. The username and password will be combined in a URL format similar to the following: http://username:password@proxyserver.contoso.com:3128. Example: PleaseUseAStrongerPassword!

#### More parameters if you are using a vlan

| Parameter  |  Parameter details |
| -----------| ------------ |
| $vlanid | VLAN ID |

#### Generate YAML file for static IP based Azure Arc Resource Bridge without VLAN

```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP
```

#### Generate YAML file for static IP based Azure Arc Resource Bridge, VLAN and proxy settings without authentication

```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP -proxyServerHTTP $proxyServerHTTP -proxyServerHTTPS $proxyServerHTTPS -proxyServerNoProxy $proxyServerNoProxy -vlanid $vlanid 
```

#### Generate YAML file for static IP based Azure Arc Resource Bridge, VLAN and proxy settings with certificate based authentication

```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP -proxyServerHTTP $proxyServerHTTP -proxyServerHTTPS $proxyServerHTTPS -proxyServerNoProxy $proxyServerNoProxy -certificateFilePath $certificateFilePath -vlanid $vlanid 
```

#### Generate YAML file for static IP based Azure Arc Resource Bridge, VLAN and proxy settings with username/password based authentication

```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP -proxyServerHTTP $proxyServerHTTP -proxyServerHTTPS $proxyServerHTTPS -proxyServerNoProxy $proxyServerNoProxy -proxyServerUsername $proxyServerUsername -proxyServerPassword $proxyServerPassword -vlanid $vlanid 
```

#### Generate YAML file for static IP based Azure Arc Resource Bridge with VLAN

```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP -vlanID $vlanid
```

#### Generate YAML file for DHCP based Azure Arc Resource Bridge without VLAN

```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -controlPlaneIP $controlPlaneIP
```

#### Generate YAML file for DHCP based Azure Arc Resource Bridge with VLAN

```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -controlPlaneIP $controlPlaneIP -vlanID $vlanid
```

#### Sample output

```shell
HCI login file successfully generated in 'C:\ClusterStorage\Volume01\WorkDir\kvatoken.tok'
Generating ARC HCI configuration files...
Config file successfully generated in 'C:\ClusterStorage\Volume01\WorkDir'
```

## Step 3: Install Azure Arc Resource Bridge

Once you have generated the required YAML files in step 2, you can now proceed with deploying Azure Arc Resource Bridge.

| Parameter  |  Parameter details |
| -----------| ------------ |
| $configfile | The `New-ArcHciAksConfigFiles` command generates a YAML file that will be used to deploy Azure Arc Resource Bridge. You need to pass the full path of this YAML file to validate and prepare for the Azure Arc Resource Bridge deployment. You can find the YAML file in the workDirectory location. |
| $appliancekubeconfig | The location where you want to store Azure Arc Resource Bridge's kubeconfig. I recommend storing it in the WorkDir shared cluster volume location. You will need this kubeconfig file in later steps and to generate logs. |

Example input:

```powershell
$configfile = $workDirectory+"\hci-appliance.yaml"
$appliancekubeconfig = $workDirectory+"\applianceconfig"
```

Run the following commands on any one of the nodes of your Windows Server cluster to validate the YAML file and then download the Azure Arc Resource Bridge VHD:

```azurecli
az arcappliance validate hci --config-file $configfile
az arcappliance prepare hci --config-file $configfile
```

Run the following command on any one of the nodes of your Windows Server cluster to create the on-prem Azure Arc Resource Bridge resource:

```azurecli
az arcappliance deploy hci --config-file $configfile --outfile $appliancekubeconfig
```

Run the following command on any one of the nodes of your Windows Server cluster to connect the on-prem Azure Arc Resource Bridge resource to Azure. Make sure you sign in to Azure before running this command:

```azurecli
az arcappliance create hci --config-file $configfile --kubeconfig $appliancekubeconfig
```

With the `az arcappliance create` command, you're finished deploying the appliance.

Before proceeding to the next step, run the following command to check if the Azure Arc Resource Bridge status says **Running**. It might not say **Running** at first. This operation takes time. Try again after a few minutes:

```azurecli
az arcappliance show --resource-group $resourceGroup --name $resourceName --query "status" -o tsv
```

## Step 4: Installing the AKS hybrid and VM extensions on the Azure Arc Resource Bridge 

To install the AKS hybrid extension, run the following command:

```azurecli
az account set -s <subscription from #1>

az k8s-extension create --resource-group <azure resource group> --cluster-name <arc appliance name> --cluster-type appliances --name <akshci cluster extension name> --extension-type Microsoft.HybridAKSOperator --version 0.0.23 --config Microsoft.CustomLocation.ServiceAccount="default"   
```

|  Parameter  |  Parameter details  |
| ------------|  ----------------- |
| resource-group |  A resource group in the Azure subscription. Make sure you use the same resource group you used when deploying Azure Arc Resource Bridge.  |
| cluster-name  |  The name of your Azure Arc Resource Bridge. |
| name  |  Name of your AKS-HCI cluster extension on top of Azure Arc Resource Bridge  |
| cluster-type  | Must be *appliances*. Do not change this value.  |
| extension-type  |  Must be *Microsoft.HybridAKSOperator*. Do not change this value. |
| version | Must be *0.0.23*. Do not change this value. |
| config  | Must be *config Microsoft.CustomLocation.ServiceAccount="default"*. Do not change this value. |

Once you have created the AKS hybrid extension on top of the Azure Arc Resource Bridge, run the following command to check if the cluster extension provisioning state says **Succeeded**. It might say something else at first. This takes time, so try again after 10 minutes.

```azurecli
az k8s-extension show --resource-group <resource group name> --cluster-name <azure arc resource bridge name> --cluster-type appliances --name <aks hybrid extension name> --query "provisioningState" -o tsv
```

## Step 4: Installing a custom location on top of the VM and AKS hybrid extensions on the Azure Arc Resource Bridge

First, collect the Azure Resource Manager IDs of the Azure Arc Resource Bridge and the AKS hybrid extension in PowerShell variables:

```azurecli
$ArcResourceBridgeId=az arcappliance show --resource-group <resource group name> --name <arc appliance name> --query id -o tsv
$AKSClusterExtensionResourceId=az k8s-extension show --resource-group <resource group name> --cluster-name <arc appliance name> --cluster-type appliances --name <aks hybrid extension name> --query id -o tsv
```
  
You can then create the custom location for your Windows Server cluster that has the AKS hybrid extension installed on it:

```azurecli
az customlocation create --name <customlocation name> --namespace "default" --host-resource-id $ArcResourceBridgeId --cluster-extension-ids $AKSClusterExtensionResourceId, $VMClusterExtensionResourceId --resource-group <resource group name>
```

|  Parameter  |  Parameter details  |
| ------------|  ----------------- |
| resource-group |  A resource group in the Azure subscription listed above. Make sure you use the same resource group you used when deploying Arc Resource Bridge.  |
| namespace  |  Must be *default*. Do not change this value. |
| name  |  Name of your AKS on Windows Server custom location |
| host-resource-id  | ARM ID of the Azure Arc Resource Bridge. You can get the ARM ID using `az arcappliance show --resource-group <resource group name> --name <azure arc resource bridge name> --query id -o tsv`.  |
| cluster-extension-ids   | ARM ID of the AKS extension on top of Resource Bridge. You can get the ARM ID using `az k8s-extension show --resource-group <resource group name> --cluster-name <arc appliance name> --cluster-type appliances --name <AKS/VM extension name> --query id -o tsv`. |

Once you create the custom location on top of the Azure Arc Resource Bridge, run the following command to check if the custom location provisioning state says **Succeeded**. It might say something else at first. This takes time, so try again after 10 minutes.

```azurecli
az customlocation show --name <custom location name> --resource-group <resource group name> --query "provisioningState" -o tsv
```
  
## Next steps

- [Create networks and download VHD images for deploying AKS hybrid clusters from Azure](create-aks-hybrid-preview-networks.md)
