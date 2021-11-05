---
title: Quickstart to set up an Azure Kubernetes Service host and create AKS on Azure Stack HCI clusters using Windows PowerShell and a proxy server
description: Learn how to set up an Azure Kubernetes Service host and create AKS on Azure Stack HCI clusters using Windows PowerShell and a proxy server
author: mkostersitz
ms.topic: quickstart
ms.date: 11/02/2021
ms.author: mikek
---

# Quickstart: Set up an Azure Kubernetes Service host on Azure Stack HCI and deploy a workload cluster using PowerShell and a proxy server

> Applies to: Azure Stack HCI, Windows Server 2019 Datacenter

In this quickstart, you'll learn how to set up an Azure Kubernetes Service host and create AKS on Azure Stack HCI clusters using PowerShell in an environment where a proxy server filters and scans internet bound traffic. To instead use Windows Admin Center, see [Set up with Windows Admin Center](setup.md).

> [!NOTE]
> If you have prestaged cluster service objects and DNS records, see the extra steps in [deploy an AKS host with prestaged cluster service objects and DNS records using PowerShell](prestage-cluster-service-host-create.md).

## Before you begin

- Make sure you have satisfied all the prerequisites on the [system requirements](.\system-requirements.md) page. 
- An Azure account to register your AKS host for billing. For more information, visit [Azure requirements](.\system-requirements.md#azure-requirements).
- **At least one** of the following access levels to your Azure subscription you use for AKS on Azure Stack HCI: 
   - A user account with the built-in **Owner** role. You can check your access level by navigating to your subscription, clicking on "Access control (IAM)" on the left-hand side of the Azure portal and then clicking on "View my access".
   - A service principal with either the built-in **Kubernetes Cluster - Azure Arc Onboarding** role (minimum), the built-in **Contributer** role, or the built-in **Owner** role. 
- An Azure resource group in the East US, Southeast Asia, or West Europe Azure region, available before registration, on the subscription mentioned above.
- **At least one** of the following:
   - 2-4 node Azure Stack HCI cluster
   - Windows Server 2019 Datacenter failover cluster
    
   > [!NOTE]
   > **We recommend having a 2-4 node Azure Stack HCI cluster.** If you don't have any of the above, follow instructions on the [Azure Stack HCI registration page](https://azure.microsoft.com/products/azure-stack/hci/hci-download/).

- **Your proxy server configuration information**
    - HTTP URL and port i.e. http://proxy.corp.contoso.com:8080
    - HTTPS URL and port i.e. https://proxy.corp.contoso.com:8443
    - (Optional) Valid credentials for authentication to the proxy server.
    - (Optional) Valid certificate chain if your proxy server is configured to intercept SSL traffic. This cerificate chain will be imported into all AKS control plane and worker nodes as well as the management cluster to establish a trusted connection to the proxy server.
    - IP Address ranges and domain names to be excluded from being sent to the proxy:
        - Kubernetes Node IP pool
        - Kubernetes Services VIP pool
        - the cluster network IP addresses
        - DNS server IP addresses
        - time service IP addresses
        - local domain name(s)
        - local host name(s)
        - the default proxy exclusion settings:
            - 'localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16'
            - These are comprised of: 
                - 'localhost,127.0.0.1': standard localhost exclusion
                - '.svc': Wildcard exclusion for all Kubernetes Services host names
                - '10.96.0.0/12': Kubernetes services IP address pool
                - '10.244.0.0/16': Kubernetes pod IP address pool

## Install the Azure PowerShell and AksHci PowerShell modules

Configure the System proxy settings on each of the physical nodes in the cluster and ensure that all nodes have access to the URLs and ports outlined in the [System Requirements documentation](system-requirements.md#Network port and URL requirements)

**If you are using remote PowerShell, you must use CredSSP.**

> ![Note]
> If your environment uses a proxy server to access the Internet, it may be necessary to add proxy parameters to the **Install-Module** command before installing
> AKS on Azure Stack HCI. 
> See the [Install-Module Documentation](/powershell/module/powershellget/install-module) for details, and follow the [Azure Stack HCI > documentation](/azure-stack/hci/manage/configure-firewalls#set-up-a-proxy-server) to configure the proxy settings on the physical cluster nodes.


**Close all open PowerShell windows.** If you have removed an older installation from the system delete any existing directories for AksHci, AksHci.Day2, Kva, Moc and MSK8sDownloadAgent located in the path `%systemdrive%\program files\windowspowershell\modules` and then install the following Azure PowerShell modules.

```powershell
Install-Module -Name Az.Accounts -Repository PSGallery -RequiredVersion 2.2.4
Install-Module -Name Az.Resources -Repository PSGallery -RequiredVersion 3.2.0
Install-Module -Name AzureAD -Repository PSGallery -RequiredVersion 2.0.2.128
Install-Module -Name AksHci -Repository PSGallery
```

```powershell
Import-Module Az.Accounts
Import-Module Az.Resources
Import-Module AzureAD
Import-Module AksHci
```

**Close all PowerShell windows** and reopen a new administrative session to check if you have the latest version of the PowerShell module.
  
```powershell
Get-Command -Module AksHci
```
To view the complete list of AksHci PowerShell commands, see [AksHci PowerShell](./reference/ps/index.md).

### Register the resource provider to your subscription

> ![Note]
> **Use the Az PowerShell module behind a proxy**
> If a proxy is necessary for HTTP request, the Azure PowerShell team recommends the following proxy
configuration for different platforms:

> |      **Platform**       |                          **Recommended Proxy Settings**                           |                                               **Comment**                                                |
> | ----------------------- | --------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
> | Windows PowerShell 5.1  | System proxy settings                                                             | Do not suggest setting HTTP_PROXY/HTTPS_PROXY environment variables.                                     |
> | PowerShell 7 on Windows | System proxy settings                                                             | Proxy could be configured by setting both HTTP_PROXY and HTTPS_PROXY environment variables.              |
> | PowerShell 7 on macOS   | System proxy settings                                                             | Proxy could be configured by setting both HTTP_PROXY and HTTPS_PROXY environment variables.              |
> | PowerShell 7 on Linux   | Set both HTTP_PROXY and HTTPS_PROXY environment variables, plus optional NO_PROXY | The environment variables should be set before starting PowerShell, otherwise they may not be respected. |
>
> The environment variables used are:
>
> - HTTP_PROXY: the proxy server used on HTTP requests.
> - HTTPS_PROXY: the proxy server used on HTTPS requests.
> - NO_PROXY: a comma-separated list of hostnames and IP addresses that should be excluded from proxying.
>
> On systems where environment variables are case-sensitive, the variable names may be all lowercase
or all uppercase. The lowercase names are checked first.

Before the registration process, you need to enable the appropriate resource provider in Azure for AKS on Azure Stack HCI registration. To do that, run the following PowerShell commands.

To log in to Azure, run the [Connect-AzAccount](/powershell/module/az.accounts/connect-azaccount) PowerShell command:

```powershell
Connect-AzAccount
```
If you want to switch to a different subscription, run the [Set-AzContext](/powershell/module/az.accounts/set-azcontext?view=azps-5.9.0&preserve-view=true) PowerShell command:

```powershell
Set-AzContext -Subscription "xxxx-xxxx-xxxx-xxxx"
```

Run the following command to register your Azure subscription to Azure Arc enabled Kubernetes resource providers. This registration process can take up to 10 minutes, but it only needs to be performed once on a specific subscription.
   
```PowerShell
Register-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Register-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
```

To validate the registration process, run the following PowerShell command:

```powershell
Get-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Get-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
```

## Step 1: Prepare your machine(s) for deployment

Run checks on every physical node to see if all the requirements are satisfied to install Azure Kubernetes Service on Azure Stack HCI. Open PowerShell as an administrator and run the following [Initialize-AksHciNode](./reference/ps/initialize-akshcinode.md) command.

```powershell
Initialize-AksHciNode
```

## Step 1a: (Optional) Prepare your Active Directory and DNS server for deployment

If you cannot enable Dynamic DNS updates in your DNS environment to allow AKS-HCI to register the cloudagent generic cluster name in Active Directory and the DNS system for discovery you will need to pre-create the respective records in Active Directory and DNS.
To do so create a generic cluster service in Active Directory with the name 'ca-cloudagent' or a name of your choice (do not exceed 32 characters in length) as well an associated DNS record pointing to the FQDN of the generic cluster service with the provided 'cloudservicecidr' address. More details on the steps in this process can be found in the [Azure Stack HCI documentation](/windows-server/failover-clustering/prestage-cluster-adds).

AKS on Azure Stack HCI deployment will try and locate the specified 'clusterRoleName' in Active Directory before proceeding with the deployment.
> [!Note]
> Once AKS on Azure Stack HCI is deployed this information cannot be changed.

Follow Step 3a after Step 2 to specifiy the pre-created object name in 'Set-AksHciConfig'

## Step 2: Create a virtual network

To get the names of your available switches, run the following command. Make sure the `SwitchType` of your VM switch is "External".

```powershell
Get-VMSwitch
```

Sample Output:

```output
Name        SwitchType     NetAdapterInterfaceDescription
----        ----------     ------------------------------
extSwitch   External       Mellanox ConnectX-3 Pro Ethernet Adapter
```

To create a virtual network for the nodes in your deployment to use, create an environment variable with the **New-AksHciNetworkSetting** PowerShell command. This will be used later to configure a deployment that uses static IP. If you want to configure your AKS deployment with DHCP, visit [New-AksHciNetworkSetting](./reference/ps/new-akshcinetworksetting.md) for examples. You can also review some [networking node concepts](./concepts-node-networking.md).

```powershell
#static IP
$vnet = New-AksHciNetworkSetting -name myvnet -vSwitchName "extSwitch" -macPoolName myMacPool -k8sNodeIpPoolStart "172.16.10.1" -k8sNodeIpPoolEnd "172.16.10.255" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" -ipAddressPrefix "172.16.0.0/16" -gateway "172.16.0.1" -dnsServers "172.16.0.1" -vlanId 9
```

> [!NOTE]
> The values given in this example command will need to be customized for your environment.

## Step 3: Configure your deployment

Set the configuration settings for the Azure Kubernetes Service host using the [Set-AksHciConfig](./reference/ps/set-akshciconfig.md) command. You must specify the `imageDir`, `workingDir`, and `cloudConfigLocation` parameters. If you want to reset your configuration details, run the command again with new parameters.

Configure your deployment with the following command.

```powershell
Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -workingDir c:\ClusterStorage\Volume1\ImageStore -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -cloudservicecidr "172.16.10.10/16"
```

> [!NOTE]
> The values given in this example command will need to be customized for your environment.

## Step 3a: Optional if you have prestaged cluster service objects and DNS records

Set the configuration settings for the Azure Kubernetes Service host using the [Set-AksHciConfig](./reference/ps/set-akshciconfig.md) command. You must specify the `imageDir`, `workingDir`, 'clusterrolename', 'cloudservicecidr' and `cloudConfigLocation` parameters. If you want to reset your config details, run the command again with new parameters.

Configure your deployment with the following command.

```powershell
PS C:\> $vnet = New-AksHciNetworkSetting -name newNetwork -vswitchName "DefaultSwitch" -k8snodeippoolstart "172.16.10.0" -k8snodeippoolend "172.16.10.255" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" -ipaddressprefix "172.16.0.0/16" -gateway "172.16.0.1" -dnsservers "172.16.0.1" -vlanID 7

Set-AksHciConfig -workingDir c:\ClusterStorage\Volume1\workingDir -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -cloudservicecidr "172.16.10.10/16" -clusterRoleName "ca-cloudagent"
```
> [!NOTE]
> The values given in this example command will need to be customized for your environment.

## Step 4: Log in to Azure and configure registration settings

Run the following [Set-AksHciRegistration](./reference/ps/set-akshciregistration.md) PowerShell command with your subscription and resource group name to log into Azure. You must have an Azure subscription, and an existing Azure resource group in the East US, Southeast Asia, or West Europe Azure regions to proceed.

```powershell
Set-AksHciRegistration -subscriptionId "<subscriptionId>" -resourceGroupName "<resourceGroupName>"
```

## Step 5: Start a new deployment

After you've configured your deployment, you must start it. This will install the Azure Kubernetes Service on Azure Stack HCI agents/services and the Azure Kubernetes Service host. To begin deployment, run the following command.

```powershell
Install-AksHci
```
> [!WARNING]
> During installation of your Azure Kuberenetes Service host, a *Kubernetes - Azure Arc* resource type is created in the resource group that's set during registration. Do not delete this resource as it represents your Azure Kuberenetes Service host. You can identify the resource by checking its distribution field for a value of `aks_management`. Deleting this resource will result in an out-of-policy deployment.

## Step 6: Create a Kubernetes cluster

After installing your Azure Kubernetes Service host, you are ready to deploy a Kubernetes cluster. Open PowerShell as an administrator and run the following [New-AksHciCluster](./reference/ps/new-akshcicluster.md) command. This example command will create a new Kubernetes cluster with one Linux node pool named *linuxnodepool* with a node count of 1. To read more information about node pools, please visit [Use node pools in AKS on Azure Stack HCI](use-node-pools.md).

```powershell
New-AksHciCluster -name mycluster -nodePoolName linuxnodepool -nodeCount 1 -osType Linux
```

### Check your deployed clusters

To get a list of your deployed Kubernetes clusters, run the following [Get-AksHciCluster](./reference/ps/get-akshcicluster.md) PowerShell command.

```powershell
Get-AksHciCluster
```

**Output**
```
ProvisioningState     : provisioned
KubernetesVersion     : v1.20.7
NodePools             : linuxnodepool
WindowsNodeCount      : 0
LinuxNodeCount        : 0
ControlPlaneNodeCount : 1
Name                  : mycluster
```

To get a list of the node pools in the cluster, run the following [Get-AksHciNodePool](./reference/ps/get-akshcinodepool.md) PowerShell command.

```powershell
Get-AksHciNodePool -clusterName mycluster
```

```output
ClusterName  : mycluster
NodePoolName : linuxnodepool
Version      : v1.20.7
OsType       : Linux
NodeCount    : 1
VmSize       : Standard_K8S3_v1
Phase        : Deployed
```

## Step 7: Connect your cluster to Arc enabled Kubernetes

Connect your cluster to Arc enabled Kubernetes by running the [Enable-AksHciArcConnection](./reference/ps/enable-akshciarcconnection.md) command. The below example connects your AKS on Azure Stack HCI cluster to Arc using the subscription and resource group details you passed in the `Set-AksHciRegistration` command.

```powershell
Connect-AzAccount
Enable-AksHciArcConnection -name mycluster
```

> [!NOTE]
> If you encounter issues or error messages during the installation process, see [installation known issues and errors](known-issues-installation.md) for more information.

## Scale a Kubernetes cluster

If you need to scale your cluster up or down, you can change the number of control plane nodes using the [Set-AksHciCluster](./reference/ps/set-akshcicluster.md) command, and you can change the number of Linux or Windows worker nodes in your node pool using the [Set-AksHciNodePool](./reference/ps/set-akshcinodepool.md) command.

To scale control plane nodes, run the following command.

```powershell
Set-AksHciCluster –name mycluster -controlPlaneNodeCount 3
```

To scale the worker nodes in your node pool, run the following command.

```powershell
Set-AksHciNodePool –clusterName mycluster -name linuxnodepool -count 3
```

> [!NOTE]
> In previous versions of AKS on Azure Stack HCI, the [Set-AksHciCluster](set-akshcicluster.md) command was also used to scale worker nodes. AKS on Azure Stack HCI is introducing node pools in workload clusters now, so this command can only be used to scale worker nodes if your cluster was created with the old parameter set in [New-AksHciCluster](new-akshcicluster.md). To scale worker nodes in a node pool, use the [Set-AksHciNodePool](set-akshcinodepool.md) command.

## Access your clusters using kubectl

To access your Kubernetes clusters using kubectl, run the [Get-AksHciCredential](./reference/ps/get-akshcicredential.md) PowerShell command. This will use the specified cluster's kubeconfig file as the default kubeconfig file for kubectl. You can also use kubectl to [deploy applications using Helm](./helm-deploy.md).

```powershell
Get-AksHciCredential -name mycluster
```

## Delete a Kubernetes cluster

If you need to delete a Kubernetes cluster, run the following command.

```powershell
Remove-AksHciCluster -name mycluster
```

> [!NOTE]
> Make sure that your cluster is deleted by looking at the existing VMs in the Hyper-V Manager. If they are not deleted, then you can manually delete the VMs. Then, run the command `Restart-Service wssdagent`. This should be done on each node in the failover cluster.

## Get logs

To get logs from your all your pods, run the [Get-AksHciLogs](./reference/ps/get-akshcilogs.md) command. This command will create an output zipped folder called `akshcilogs.zip` in your working directory. The full path to the `akshcilogs.zip` folder will be the output after running the command below.

```powershell
Get-AksHciLogs
```

In this quickstart, you learned how to set up an Azure Kubernetes Service host and create AKS on Azure Stack HCI clusters using PowerShell. You also learned how to use PowerShell to scale a Kubernetes cluster and to access clusters with `kubectl`.

## Next steps
- [Prepare an application](./tutorial-kubernetes-prepare-application.md)
- [Deploy a Windows application on your Kubernetes cluster](./deploy-windows-application.md)