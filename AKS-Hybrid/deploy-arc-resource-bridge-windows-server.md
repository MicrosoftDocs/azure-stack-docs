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

## Step 1: Install August release of AKS host management cluster 
At this point of the preview, it is mandatory to install the AKS host management cluster on your Azure Stack HCI or Windows Server cluster. Follow this documentation to [install AKS host management cluster using PowerShell](kubernetes-walkthrough-powershell.md). We only support running the [August release](https://github.com/Azure/aks-hci/releases/tag/AKS-HCI-2208) of AKS host management cluster.

You can pin your AKS host managemenet cluster to the [August release](https://github.com/Azure/aks-hci/releases/tag/AKS-HCI-2208) by passing the `-version "1.0.13.10907"` parameter to the [`Set-AksHciConfig`](./reference/ps/set-akshciconfig.md) command.

You can verify if the AKS host management cluster has been successfully deployed by running the following command on any one node in your physical cluster:
```PowerShell
Get-AksHciVersion
```

Note that the output should be `1.0.13.10907` for the August release. Expected Output:
```
1.0.13.10907
```

If you face an issue installing AKS on Windows Server or Azure Stack HCI, review the [troubleshooting section](troubleshoot-overview.md). If the troubleshooting section does not help you, file a [GitHub issue](https://github.com/Azure/aks-hci/issues). Make sure you attach logs (use `Get-AksHciLogs`), so that we can help you faster.

## Step 2: Generate YAML files required for installing Arc Resource Bridge

Installing Azure Arc Resource Bridge requires you to generate a YAML file. We have automated the process of creating this YAML file for you. Before running the PowerShell command that will generate these YAML files, make sure you have the following parameters ready:

| Parameter  |  Parameter details |
| -----------| ------------ |
| $subscriptionID | Your Azure Arc Resource Bridge will be installed on this Azure subscription ID. |
| $resourceGroup | A resource group in the Azure subscription listed above. Make sure your resource group is in the eastus, westeurope, southcentralus or westus3 location. |
| $location | The Azure location where your Azure Arc Resource Bridge will be deployed. Make sure this location is eastus, westeurope, southcentralus or westus3. It's recommended you use the same location you used when creating the resource group. |
| $resourceName | The name of your Azure Arc Resource Bridge. |
| $workDirectory | Path to a shared cluster volume that stores the config files we create for you. We recommend you use the same **workDir** you used while installing AKS-HCI. Make sure your **workDir** full path does not contain any spaces. |

#### More parameters if you're using static IP (recommended)

| Parameter  |  Parameter details |
| -----------| ------------ |
| $vswitchname | The name of your VM switch. |
| $ipaddressprefix | The IP address value of your subnet. |
| $gateway | The IP address value of your gateway for the subnet. |
| $dnsservers | The IP address value(s) of your DNS servers. |
| $vmIP | This IP address will be the IP address of the VM that is the underlying compute of Azure Arc Resource Bridge. Make sure that this IP address comes from the subnet in your datacenter. Also make sure that this IP address is available and isn't being used anywhere else.
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
| $proxyServerNoProxy | Required | URLs which can bypass proxy.  |
| $certificateFilePath | Optional | Name of the certificate file path for proxy. Example: C:\Users\Palomino\proxycert.crt |
| $proxyServerUsername | Optional | Username for proxy authentication. The username and password will be combined in a URL format similar to the following: http://username:password@proxyserver.contoso.com:3128. Example: Eleanor
| $proxyServerPassword | Optional | Password for proxy authentication. The username and password will be combined in a URL format similar to the following: http://username:password@proxyserver.contoso.com:3128. Example: PleaseUseAStrongerPassword!

#### More parameters if you are using a vlan

| Parameter  |  Parameter details |
| -----------| ------------ |
| $vlanid | VLAN ID |

#### Generate YAML file for static IP-based Azure Arc Resource Bridge without VLAN

### [Windows Server](#tab/powershell)
```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP
```
### [Azure Stack HCI](#tab/shell)
```powershell
New-ArcHciConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP
```
---

#### Generate YAML file for static IP based Azure Arc Resource Bridge, VLAN, and proxy settings without authentication

### [Windows Server](#tab/powershell)
```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP -proxyServerHTTP $proxyServerHTTP -proxyServerHTTPS $proxyServerHTTPS -proxyServerNoProxy $proxyServerNoProxy -vlanid $vlanid 
```

### [Azure Stack HCI](#tab/shell)
```powershell
New-ArcHciConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP -proxyServerHTTP $proxyServerHTTP -proxyServerHTTPS $proxyServerHTTPS -proxyServerNoProxy $proxyServerNoProxy -vlanid $vlanid 
```
---

#### Generate YAML file for static IP-based Azure Arc Resource Bridge, VLAN, and proxy settings with certificate-based authentication

### [Windows Server](#tab/powershell)
```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP -proxyServerHTTP $proxyServerHTTP -proxyServerHTTPS $proxyServerHTTPS -proxyServerNoProxy $proxyServerNoProxy -certificateFilePath $certificateFilePath -vlanid $vlanid 
```

### [Azure Stack HCI](#tab/shell)
```powershell
New-ArcHciConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP -proxyServerHTTP $proxyServerHTTP -proxyServerHTTPS $proxyServerHTTPS -proxyServerNoProxy $proxyServerNoProxy -certificateFilePath $certificateFilePath -vlanid $vlanid 
```
---

#### Generate YAML file for static IP-based Azure Arc Resource Bridge, VLAN, and proxy settings with username/password-based authentication

### [Windows Server](#tab/powershell)

```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP -proxyServerHTTP $proxyServerHTTP -proxyServerHTTPS $proxyServerHTTPS -proxyServerNoProxy $proxyServerNoProxy -proxyServerUsername $proxyServerUsername -proxyServerPassword $proxyServerPassword -vlanid $vlanid 
```

### [Azure Stack HCI](#tab/shell)

```powershell
New-ArcHciConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP -proxyServerHTTP $proxyServerHTTP -proxyServerHTTPS $proxyServerHTTPS -proxyServerNoProxy $proxyServerNoProxy -proxyServerUsername $proxyServerUsername -proxyServerPassword $proxyServerPassword -vlanid $vlanid 
```
---

#### Generate YAML file for static IP-based Azure Arc Resource Bridge with VLAN

### [Windows Server](#tab/powershell)

```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP -vlanID $vlanid
```

### [Azure Stack HCI](#tab/shell)

```powershell
New-ArcHciConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsservers -controlPlaneIP $controlPlaneIP -k8snodeippoolstart $vmIP -k8snodeippoolend $vmIP -vlanID $vlanid
```
---

#### Generate YAML file for DHCP-based Azure Arc Resource Bridge without VLAN

### [Windows Server](#tab/powershell)

```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -controlPlaneIP $controlPlaneIP
```

### [Azure Stack HCI](#tab/shell)

```powershell
New-ArcHciConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -controlPlaneIP $controlPlaneIP
```
---

#### Generate YAML file for DHCP-based Azure Arc Resource Bridge with VLAN

### [Windows Server](#tab/powershell)

```powershell
New-ArcHciAksConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -controlPlaneIP $controlPlaneIP -vlanID $vlanid
```

### [Azure Stack HCI](#tab/shell)

```powershell
New-ArcHciConfigFiles -subscriptionID $subscriptionID -location $location -resourceGroup $resourceGroup -resourceName $resourceName -workDirectory $workDirectory -vnetName $vswitchname -vswitchName $vswitchName -controlPlaneIP $controlPlaneIP -vlanID $vlanid
```
---

#### Sample output

```output
HCI login file successfully generated in 'C:\ClusterStorage\Volume01\WorkDir\kvatoken.tok'
Generating ARC HCI configuration files...
Config file successfully generated in 'C:\ClusterStorage\Volume01\WorkDir'
```

## Step 3: Install Azure Arc Resource Bridge

Once you have generated the required YAML files in step 2, you can proceed with deploying Azure Arc Resource Bridge. Make sure you sign in to any one of the nodes in your Azure Stack HCI or Windows Server cluster to run the following commands. We do not support using remote desktop.

| Parameter  |  Parameter details |
| -----------| ------------ |
| $configfile | Pass the full path of the YAML file generated in Step 2. The default name of the YAML file is hci-appliance.yaml, and you can find the YAML file in the $workDirectory location. |
| $appliancekubeconfig | The location where you want to store Azure Arc Resource Bridge's kubeconfig. We recommend storing it in the **WorkDir** shared cluster volume location. You will need this kubeconfig file in later steps and to generate logs. |

Example input for $configfile and $appliancekubeconfig:

```powershell
$configfile = $workDirectory+"\hci-appliance.yaml"
$appliancekubeconfig = $workDirectory+"\applianceconfig"
```

Run the following commands on any one of the nodes of your Windows Server or Azure Stack HCI cluster to validate the YAML file and then download the Azure Arc Resource Bridge VHD image. Make sure you sign in to Azure before running these commands:

```azurecli
az arcappliance validate hci --config-file $configfile
az arcappliance prepare hci --config-file $configfile
```

Once you've validated the YAML file and downloaded the Arc Resource Bridge VHD image, run the following command on any one of the nodes of your Windows Server or Azure Stack HCI cluster to deploy the Arc Resource Bridge on your physical cluster:

```azurecli
az arcappliance deploy hci --config-file $configfile --outfile $appliancekubeconfig
```

Run the following command on any one of the nodes of your Windows Server or Azure Stack HCI cluster to connect the deployed Arc Resource Bridge to Azure:

```azurecli
az arcappliance create hci --config-file $configfile --kubeconfig $appliancekubeconfig
```

Before proceeding to the next step, run the following command to check if the Azure Arc Resource Bridge status says **Running**. It might not say **Running** at first. This operation takes time. Try again after a few minutes:

```azurecli
az arcappliance show --resource-group $resourceGroup --name $resourceName --query "status" -o tsv
```

## Step 4: Installing the AKS hybrid extension on the Azure Arc Resource Bridge 

To install the AKS hybrid extension, run the following command:

```azurecli
az account set -s <subscription ID>

az k8s-extension create --resource-group <azure resource group> --cluster-name <arc resource bridge name> --cluster-type appliances --name <aks hybrid cluster extension name> --extension-type Microsoft.HybridAKSOperator --config Microsoft.CustomLocation.ServiceAccount="default"   
```

|  Parameter  |  Parameter details  |
| ------------|  ----------------- |
| resource-group |  A resource group in the Azure subscription. Make sure you use the same resource group you used when deploying Azure Arc Resource Bridge.  |
| cluster-name  |  The name of your Azure Arc Resource Bridge. |
| name  |  Name of your AKS hybrid cluster extension to be created on top of Azure Arc Resource Bridge.  |
| cluster-type  | Must be `appliances`. Do not change this value.  |
| extension-type  |  Must be `Microsoft.HybridAKSOperator`. Do not change this value. |
| config  | Must be `config Microsoft.CustomLocation.ServiceAccount="default"`. Do not change this value. |

Once you have created the AKS hybrid extension on top of the Azure Arc Resource Bridge, run the following command to check if the cluster extension provisioning state says **Succeeded**. It might say something else at first. This takes time, so try again after 10 minutes:

```azurecli
az k8s-extension show --resource-group <resource group name> --cluster-name <azure arc resource bridge name> --cluster-type appliances --name <aks hybrid extension name> --query "provisioningState" -o tsv
```

## Step 5: Create a custom location on top of the Azure Arc Resource Bridge

Run the following commands to create a custom location on top of the Arc Resource Bridge. You will choose this custom location when creating the AKS hybrid cluster through Az CLI or through the Azure portal.

Collect the Azure Resource Manager IDs of the Azure Arc Resource Bridge and the AKS hybrid extension in variables:

```azurecli
$ArcResourceBridgeId=az arcappliance show --resource-group <resource group name> --name <arc resource bridge name> --query id -o tsv
$AKSClusterExtensionResourceId=az k8s-extension show --resource-group <resource group name> --cluster-name <arc resource bridge name> --cluster-type appliances --name <aks hybrid extension name> --query id -o tsv
```
  
You can then create the custom location for your Windows Server or Azure Stack HCI cluster that has the AKS hybrid extension installed on it:

```azurecli
az customlocation create --name <customlocation name> --namespace "default" --host-resource-id $ArcResourceBridgeId --cluster-extension-ids $AKSClusterExtensionResourceId --resource-group <resource group name>
```

|  Parameter  |  Parameter details  |
| ------------|  ----------------- |
| resource-group |  A resource group in the Azure subscription listed above. Make sure you use the same resource group you used when deploying Arc Resource Bridge.  |
| namespace  |  Must be `default`. Do not change this value. |
| name  |  Name of your Windows Server or Azure Stack HCI Custom Location |
| host-resource-id  | Resource Manager ID of the Azure Arc Resource Bridge. |
| cluster-extension-ids   | Resource Manager ID of the AKS hybrid extension on top of Resource Bridge. |

Once you create the custom location on top of the Azure Arc Resource Bridge, run the following command to check if the custom location provisioning state says **Succeeded**. It might say something else at first. This takes time, so try again after 10 minutes:

```azurecli
az customlocation show --name <custom location name> --resource-group <resource group name> --query "provisioningState" -o tsv
```
  
## Next steps

- [Create networks and download VHD images for deploying AKS hybrid clusters from Azure](create-aks-hybrid-preview-networks.md)
