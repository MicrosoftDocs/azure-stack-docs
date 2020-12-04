---
title: Quickstart to set up an Azure Kubernetes Service host on Azure Stack HCI using Windows PowerShell
description: Learn how to set up an Azure Kubernetes Service host on Azure Stack HCI with Windows PowerShell
author: jessicaguan
ms.topic: quickstart
ms.date: 09/23/2020
ms.author: jeguan
---
# Quickstart: Set up an Azure Kubernetes Service host on Azure Stack HCI using PowerShell

> Applies to: Azure Stack HCI, Windows Server 2019 Datacenter

In this quickstart, you'll learn how to set up an Azure Kubernetes Service host using PowerShell. To instead use Windows Admin Center, see [Set up with Windows Admin Center](setup.md).

## Before you begin

Make sure you have one of the following:
 - 2-4 node Azure Stack HCI cluster
 - Windows Server 2019 Datacenter failover cluster
 - Single node Windows Server 2019 Datacenter 
 
Before getting started, make sure you have satisfied all the prerequisites on the [system requirements](.\system-requirements.md) page. 
**We recommend having a 2-4 node Azure Stack HCI cluster.** If you don't have any of the above, follow instructions on the [Azure Stack HCI registration page](https://azure.microsoft.com/products/azure-stack/hci/hci-download/).    


   > [!IMPORTANT]
   > When removing Azure Kubernetes Service on Azure Stack HCI, see [Remove Azure Kubernetes Service on Azure Stack HCI](#remove-azure-kubernetes-service-on-azure-stack-hci) and carefully follow the instructions. 

## Step 1: Download and install the AksHci PowerShell module

Download the `AKS-HCI-Public-Preview-Dec-2020` from the [Azure Kubernetes Service on Azure Stack HCI registration page](https://aka.ms/AKS-HCI-Evaluate). The zip file `AksHci.Powershell.zip` contains the PowerShell module.

If you have previously installed Azure Kubernetes Service on Azure Stack HCI using PowerShell or Windows Admin Center, there are two installation flows for the new PowerShell module:
 - Perform a clean installation of the PowerShell module, so you start with a clean system and your previously deployed workloads are removed. To do this, go to Step 1.1.
 - Upgrade the PowerShell module if you want to keep your system and workloads in place. To do this, go to Step 1.2.

### Step 1.1: Clean install of the AksHci PowerShell module

Run the following command before proceeding.
   ```powershell
   Uninstall-AksHci
   ```

**Close all PowerShell windows.** Delete any existing directories for AksHci, AksHci.UI, MOC and MSK8sDownloadAgent located in the path `%systemdrive%\program files\windowspowershell\modules`. Once this is done, you can extract the contents of the new zip file. Make sure to extract the zip file in the correct location (`%systemdrive%\program files\windowspowershell\modules`). Then, run the following commands.

   ```powershell
   Import-Module AksHci
   ```

Close all PowerShell windows again and reopen an administrative session and proceed to Step 1.3 - Validate upgraded PowerShell module.

### Step 1.2: Upgrade the AksHci PowerShell module

**Close all PowerShell windows.** Delete any existing directories for AksHci, AksHci.UI, MOC and MSK8sDownloadAgent located in the path `%systemdrive%\program files\windowspowershell\modules`. Once these directories are removed, you can extract the contents of the new zip file. Make sure to extract the zip file in the correct location (`%systemdrive%\program files\windowspowershell\modules`). Then, run the following commands.

   ```powershell
   Import-Module AksHci
   ```
  
After running the above commands, close all PowerShell windows and reopen an administrative session to validate PowerShell module upgrade as detailed below and then run the `Update-AksHci` command as instructed later in the document.

## Step 1.3: Validate upgraded PowerShell module

**Close all PowerShell windows** and reopen a new administrative session to check if you have the latest version of the PowerShell module.  

   ```powershell
   Get-Command -Module AksHci
   ```
 
**Output:**
```
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           Initialize-AksHciNode                              0.2.12     AksHci
Function        Get-AksHciCluster                                  0.2.12     AksHci
Function        Get-AksHciConfig                                   0.2.12     AksHci
Function        Get-AksHciCredential                               0.2.12     AksHci
Function        Get-AksHciKubernetesVersion                        0.2.12     AksHci
Function        Get-AksHciLogs                                     0.2.12     AksHci
Function        Get-AksHciUpdates                                  0.2.12     AksHci
Function        Get-AksHciVersion                                  0.2.12     AksHci
Function        Get-AksHciVmSize                                   0.2.12     AksHci
Function        Install-AksHci                                     0.2.12     AksHci
Function        Install-AksHciAdAuth                               0.2.12     AksHci
Function        Install-AksHciArcOnboarding                        0.2.12     AksHci
Function        New-AksHciCluster                                  0.2.12     AksHci
Function        Remove-AksHciCluster                               0.2.12     AksHci
Function        Restart-AksHci                                     0.2.12     AksHci
Function        Set-AksHciClusterNodeCount                         0.2.12     AksHci
Function        Set-AksHciConfig                                   0.2.12     AksHci
Function        Uninstall-AksHci                                   0.2.12     AksHci
Function        Uninstall-AksHciAdAuth                             0.2.12     AksHci
Function        Uninstall-AksHciArcOnboarding                      0.2.12     AksHci
Function        Update-AksHci                                      0.2.12     AksHci
Function        Update-AksHciCluster                               0.2.12     AksHci
```

## Step 2: Prepare your machine(s) for deployment

Run checks on every physical node to see if all the requirements are satisfied to install Azure Kubernetes Service on Azure Stack HCI.

Open PowerShell as an administrator and run the following command.

   ```powershell
   Initialize-AksHciNode
   ```

When the checks are finished, you'll see "Done" displayed in green text.

## Step 3: Configure your deployment

Set the configuration settings for the Azure Kubernetes Service host. **If you're deploying on a 2-4 node Azure Stack HCI cluster or a Windows Server 2019 Datacenter failover cluster, you must specify the `imageDir` and `cloudConfigLocation` parameters.** For a single node Windows Server 2019 Datacenter, all parameters are optional and set to their default values. However, for optimal performance, **we recommend using a 2-4 node Azure Stack HCI cluster deployment.**

Configure your deployment with the following command.

   ```powershell
   Set-AksHciConfig [-imageDir <String>]
                    [-cloudConfigLocation <String>]
                    [-nodeConfigLocation <String>]
                    [-vnetName <String>]
                    [-controlPlaneVmSize <VmSize>]
                    [-loadBalancerVmSize <VmSize>]
                    [-sshPublicKey <String>]
                    [-vipPoolStartIp <String>]
                    [-vipPoolEndIp <String>]
                    [-macPoolStart <String>]
                    [-macPoolEnd <String>]
                    [-vlanID <int>]
                    [-kvaLoadBalancerType {unstacked_haproxy, stacked_kube_vip}]
                    [-kvaControlPlaneEndpoint <String>]
                    [-proxyServerHTTP <String>]
                    [-proxyServerHTTP <String>]
                    [-proxyServerNoProxy <String>]
                    [-proxyServerCredential <PSCredential>]
                    [-cloudServiceCidr <String>]
                    [-workingDir <String>]
                    [-version <String>]
                    [-vnetType <String>]
                    [-nodeAgentPort <int>]
                    [-nodeAgentAuthorizerPort <int>]
                    [-clusterRoleName <String>]
                    [-cloudLocation <String>]
                    [-skipHostLimitChecks]
                    [-insecure]
                    [-skipUpdates]
                    [-forceDnsReplication]

   ```

### Example

To deploy on a 2-4 node cluster with DHCP networking:

   ```powershell
   Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config
   ```

To deploy with a virtual IP pool:

   ```powershell
   Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config -vipPoolStartIp 10.0.0.20 -vipPoolEndIp 10.0.0.80
   ```

To deploy with `stacked_kube_vip` load balancer:

   ```powershell
   Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config -kvaLoadBalancerType stacked_kube_vip -kvaControlPlaneEndpoint 10.0.1.10
   ```

To deploy with a proxy server:

   ```powershell
   Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config -proxyServerHttp "http://proxy.contoso.com:8888" -proxyServerHttps "http://proxy.contoso.com:8888" -proxyServerNoProxy "localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16,10.231.110.0/24,10.68.237.0/24" -proxyServerCredential $credential
   ```  

### Optional parameters

`-imageDir`

The path to the directory where Azure Kubernetes Service on Azure Stack HCI will store its VHD images. Defaults to `%systemdrive%\AksHciImageStore` for single node deployments. *For multi-node deployments, this parameter must be specified*. The path must point to a shared storage path such as `C:\ClusterStorage\Volume2\ImageStore` or an SMB share such as `\\FileShare\ImageStore`.

`-cloudConfigLocation`

The location where the cloud agent will store its configuration. Defaults to `%systemdrive%\wssdcloudagent` for single node deployments. The location can be the same as the path of `-imageDir` above. For *multi-node deployments, this parameter must be specified*. The path must point to a shared storage path such as `C:\ClusterStorage\Volume2\ImageStore` or an SMB share such as `\\FileShare\ImageStore`. The location needs to be on a highly available share so that the storage will always be accessible.

`-nodeConfigLocation`

The location where the node agents will store their configuration. Every node has a node agent, so its configuration is local to it. This location must be a local path. Defaults to `%systemdrive%\programdata\wssdagent` for all deployments.

`-vnetName`

The name of the virtual switch to connect the virtual machines to. If you already have an external switch on the host, you should pass the name of the switch here. The switch will be created if it does not exist. Defaults to “External” name.  

`-controlPlaneVmSize`

The size of the VM to create for the control plane. To get a list of available VM sizes, run `Get-AksHciVmSize`.

`-loadBalancerVmSize`

The size of the VM to create for the Load Balancer VMs. To get a list of available VM sizes, run `Get-AksHciVmSize`.

`-sshPublicKey`

Path to an SSH public key file. Using this public key, you will be able to log in to any of the VMs created by the Azure Kubernetes Service on Azure Stack HCI deployment. If you have your own SSH public key, you will pass its location here. If no key is provided, we will look for one under `%systemdrive%\akshci\.ssh\akshci_rsa.pub`. If the file does not exist, an SSH key pair in the above location will be generated and used.

`-vipPoolStartIp`

When using VIP pools for your deployment, this parameter specifies the network start of the pool. You should use VIP pools for long-lived deployments to guarantee that a pool of IP addresses remain consistent. This is useful when you have workloads that always need to be reachable. Default is none.

`-vipPoolEndIp`

When using VIP pools for your deployment, this parameter specifies the network end of the pool. You should use VIP pools for long-lived deployments to guarantee that a pool of IP addresses remain consistent. This is useful when you have workloads that always need to be reachable. Default is none.

`-macPoolStart` 

This is used to specify the start of the MAC address of the MAC pool that you wish to use for the Azure Kubernetes Service host VM. The syntax for the MAC address requires that the least significant bit of the first byte should always be 0, and the first byte should always be an even number (i.e. 00, 02, 04, 06...). A typical MAC address can look like: 02:1E:2B:78:00:00. You should use MAC pools for long-lived deployments so that MAC addresses assigned are consistent. This is useful if you have a requirement that the VMs have specific MAC addresses. Default is none.

`-macPoolEnd`

This is used to specify the end of the MAC address of the MAC pool that you wish to use for the Azure Kubernetes Service host VM. The syntax for the MAC address requires that the least significant bit of the first byte should always be 0, and the first byte should always be an even number (i.e. 00, 02, 04, 06...). The first byte of the address passed as the `-macPoolEnd` should be the same as the first byte of the address passed as the `-macPoolStart`. You should use MAC pools for long-lived deployments so that MAC addresses assigned are consistent. This is useful if you have a requirement that the VMs have specific MAC addresses. Default is none.

`-vlandID`

This can be used to specify a network VLAN ID. Azure Kubernetes Service host and Kubernetes cluster VM network adapters will be tagged with the provided VLAN ID. This should be used if there is a specific VLAN ID that needs to be tagged to get the right connectivity. Default is none.

`-kvaLoadBalancerType`

This takes in either `unstacked_haproxy` or `stacked_kube_vip`. `unstacked_haproxy` is the default where a separate load balancer VM is deployed with HAProxy as the Azure Kubernetes Service host's API server endpoint. `stacked_kube_vip`is a load balancer solution, [Kubevip](https://kube-vip.io/), for the Azure Kubernetes Service host. It allows you to specify a static IP address in the host as a floating IP across the control plane nodes to keep the API server highly available through the IP. If this option is chosen, you must specify the static IP address in the `kvaControlPlaneEndpoint` parameter, and no separate load balancer VM is deployed.

`stacked_kube_vip` requires an IP address and is more resource friendly by saving memory, CPU, and deployment time. If you do not have an IP address to use as the floating IP, you should use `unstacked_haproxy`. The latter option requires a load balancer VM. 

`-kvaControlPlaneEndpoint`

This specifies the static IP address to use as the Azure Kubernetes Service Host API server address when the `kvaLoadBalancerType` parameter is set to `stacked_kube_vip`. If `stacked_kube_vip` is used, this parameter must be specified.

`-proxyServerHTTP`

This provides a proxy server URI that should be used by all components that need to reach HTTP endpoints. The URI format includes the URI schema, server address, and port (i.e. https://server.com:8888). Default is none.

`-proxyServerHTTPS`

This provides a proxy server URI that should be used by all components that need to reach HTTPS endpoints. The URI format includes the URI schema, server address, and port (i.e. https://server.com:8888). Default is none.

`-proxyServerNoProxy`

This is a comma-delimited string of addresses that will be exempt from the proxy. Default value is `localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16`. This excludes  the localhost traffic (localhost, 127.0.0.1), internal Kubernetes service traffic (.svc), the Kubernetes Service CIDR (10.96.0.0/12), and the Kubernetes POD CIDR (10.244.0.0/16) from the proxy server. You can use this parameter to add more subnet ranges or name exemptions. **The settings for this parameter are very important because, if it's not correctly configured, you may unexpectedly route internal Kubernetes cluster traffic to your proxy. This can cause various failures in network communication.**


`-proxyServerCredential`

This provides the username and password to authenticate to your HTTP/HTTPS proxy servers. You can use `Get-Credential` to generate a PSCredential object to pass to this parameter. Default is none.

`-cloudServiceCidr`

This can be used to provide a static IP/network prefix to be assigned to the MOC CloudAgent service. This value should be provided using the CIDR format. (Example: 192.168.1.2/16). You may want to specify this to ensure that anything important on the network is always accessible because the IP address will not change. Default is none.

`-workingDir`

This is a working directory for the module to use for storing small files. Defaults to `%PROGRAMFILES%\AksHci` and should not be changed for most deployments. We do not recommend changing the default. 

`-version`

The version of Azure Kubernetes Service on Azure Stack HCI that you want to deploy. The default is the latest version. We do not recommend changing the default.

`-vnetType`

The type of virtual switch to connect to or create. This defaults to “External” switch type. We do not recommend changing the default.

`-nodeAgentPort`

The TCP/IP port number that node agents should listen on. Defaults to 45000. We do not recommend changing the default. 

`-nodeAgentAuthorizerPort`

The TCP/IP port number that node agents should use for their authorization port. Defaults to 45001. We do not recommend changing the default.  

`-clusterRoleName`

This specifies the name to use when creating cloud agent as a generic service within the cluster. This defaults to a unique name with a prefix of ca- and a guid suffix (for example: “ca-9e6eb299-bc0b-4f00-9fd7-942843820c26”). We do not recommend changing the default.

`-cloudLocation` 

This parameter provides a custom Microsoft Operated Cloud location name. The default name is "MocLocation". We do not recommend changing the default.

`-skipHostLimitChecks`

Requests the script to skip any checks it does to confirm memory and disk space is available before allowing the deployment to proceed. We do not recommend using this setting.

`-insecure`

Deploys Azure Kubernetes Service on Azure Stack HCI components such as cloud agent and node agent(s) in insecure mode (no TLS secured connections).  We do not recommend using insecure mode in production environments.

`-skipUpdates`

Use this flag if you want to skip any updates available. We do not recommend using this setting.

`-forceDnsReplication`

DNS replication can take up to an hour on some systems. This will cause the deployment to be slow. If you hit this issue, you'll see that the Install-AksHci will be stuck in a loop. To get past this issue, try to use this flag. The `-forceDnsReplication` flag is not a guaranteed fix. If the logic behind the flag fails, the error will be hidden, and the command will carry on as if the flag was not provided. 

### Reset the Azure Kubernetes Service on Azure Stack HCI configuration

To reset the Azure Kubernetes Service on Azure Stack HCI configuration, run the following commands. Running this command on its own will reset the configuration to default values.

```powershell
Set-AksHciConfig
```

## Step 4: Start a new deployment

After you've configured your deployment, you must start deployment. This will install the Azure Kubernetes Service on Azure Stack HCI agents/services and the Azure Kubernetes Service host.

To begin deployment, run the following command.

```powershell
Install-AksHci
```

### Verify your deployed Azure Kubernetes Service host

To ensure that your Azure Kubernetes Service host was deployed, run the following command. You will also be able to get Kubernetes clusters using the same command after deploying them.

```powershell
Get-AksHciCluster
```

**Output:**
```

Name            : clustergroup-management
Version         : v1.18.8
Control Planes  : 1
Linux Workers   : 0
Windows Workers : 0
Phase           : provisioned
Ready           : True
```

## Step 5: Access your clusters using kubectl

To access your Azure Kubernetes Service host or Kubernetes cluster using kubectl, run the following command. This will use the specified cluster's kubeconfig file as the default kubeconfig file for kubectl.

```powershell
Get-AksHciCredential -clusterName <String>
                     [-outputLocation <String>]
```

### Example

```powershell
Get-AksHciCredential -clusterName clustergroup-management
```

### Required Parameters

`clusterName`

The name of the cluster.

### Optional Parameters

`outputLocation`

The location where you want the kubeconfig downloaded. Default is `%USERPROFILE%\.kube`.

## Get logs

To get logs from your all your pods, run the following command. This command will create an output zipped folder called `akshcilogs` in the path `C:\wssd\akshcilogs`.

```powershell
Get-AksHciLogs
```

## Update to the latest version of Azure Kubernetes Service on Azure Stack HCI

To update to the latest version of Azure Kubernetes Service on Azure Stack HCI, run the following command. The update command only works if you have installed the Oct release. It will not work for releases older than the October release. This update command updates the Azure Kubernetes Service host and the on-premise Microsoft operated cloud platform. For this preview release, the Kubernetes version and AKS host OS version still remain the same. This command does not upgrade any existing workload clusters. New workload clusters created after updating the AKS host will differ from existing workload clusters in terms of Windows node OS version and Kubernetes version.

   ```powershell
   Update-AksHci
   ```
   
We recommend updating workload clusters immediately after updating the management cluster to prevent running unsupported Windows Server OS versions in your Kubernetes clusters with Windows nodes. To update your workload cluster, visit [update your workload cluster](create-kubernetes-cluster-powershell.md).

## Restart Azure Kubernetes Service on Azure Stack HCI

Restarting Azure Kubernetes Service on Azure Stack HCI will remove all of your Kubernetes clusters if any, and the Azure Kubernetes Service host. It will also uninstall the Azure Kubernetes Service on Azure Stack HCI agents and services from the nodes. It will then go back through the original install process steps until the host is recreated. The Azure Kubernetes Service on Azure Stack HCI configuration that you configured via `Set-AksHciConfig` and the downloaded VHDX images are preserved.

To restart Azure Kubernetes Service on Azure Stack HCI with the same configuration settings, run the following command.

```powershell
Restart-AksHci
```

## Reset configuration settings and reinstall Azure Kubernetes Service on Azure Stack HCI

To reinstall Azure Kubernetes Service on Azure Stack HCI with different configuration settings, run the following command first.

```powershell
Uninstall-AksHci
```

After running the above command, you can change the configuration settings with the following command. The parameters remain the same as described in Step 3. If you run this command with no specified parameters, the parameters will be reset to their default values.

```powershell
Set-AksHciConfig
```

After changing the configuration to your desired settings, run the following command to reinstall Azure Stack Kubernetes on Azure Stack HCI.

```powershell
Install-AksHci
```

## Remove Azure Kubernetes Service on Azure Stack HCI

To remove Azure Kubernetes Service on Azure Stack HCI, run the following command. **If you are using PowerShell to uninstall a Windows Admin Center deployment, you just run the command with the `-Force` flag.**

```powershell
Uninstall-AksHci
```

After running the above command, you can run the `Install-AksHci` command to install the Azure Kubernetes Service host with the same configuration as before. If you want to change the configuration, run `Set-AksHciConfig` with the changes you want to make before running the install command.

If you don't want to retain the old configuration, run the following command.

```powershell
Uninstall-AksHci -Force
```

If PowerShell commands are run on a cluster where Windows Admin Center was previously used to deploy, the PowerShell module checks the existence of the Windows Admin Center configuration file. Windows Admin Center places the Windows Admin Center configuration file across all nodes. **If you use the uninstall command and go back to Windows Admin Center, run the above uninstall command with the `-Force` flag. If this is not done, PowerShell and Windows Admin Center will be out of sync.**

## Next steps

- [Create a Kubernetes cluster for your applications](create-kubernetes-cluster-powershell.md)
