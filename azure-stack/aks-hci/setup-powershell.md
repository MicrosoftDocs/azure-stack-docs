---
title: Quickstart to set up an Azure Kubernetes Service host on Azure Stack HCI using Windows PowerShell
description: Learn how to set up an Azure Kubernetes Service host on Azure Stack HCI with Windows PowerShell
author: jessicaguan
ms.topic: quickstart
ms.date: 09/23/2020
ms.author: jeguan
---
# Quickstart: Set up an Azure Kubernetes Service host on Azure Stack HCI using PowerShell

> Applies to: Azure Stack HCI

In this quickstart, you'll learn how to set up an Azure Kubernetes Service host on Azure Stack HCI using PowerShell. To instead use Windows Admin Center, see [Set up with Windows Admin Center](setup.md).

## Before you begin

Before you begin, make sure you have a 2-4 node Azure Stack HCI cluster or a single node Azure Stack HCI. **We recommend having a 2-4 node Azure Stack HCI cluster.** If you don't, follow instructions on the [Azure Stack HCI registration page](https://azure.microsoft.com/products/azure-stack/hci/hci-download/).

## Step 1: Download and install the AksHci PowerShell module

Download the `AKS-HCI-Public-Preview-Dec-2020` from the [Azure Kubernetes Service on Azure Stack HCI registration page](https://aka.ms/AKS-HCI-Evaluate). The zip file `AksHci.Powershell.zip` contains the PowerShell module.

If you have previously installed Azure Kubernetes Service on Azure Stack HCI using PowerShell or Windows Admin Center, run the following command before proceeding.

   ```powershell
   Uninstall-AksHci
   ```

**Close all PowerShell windows.** Delete any existing directories for AksHci, AksHci.Day2, and MSK8sDownloadAgent located in the path `%systemdrive%\program files\windowspowershell\modules`. Once this is done, you can extract the contents of the new zip file. Make sure to extract the zip file in the correct location (`%systemdrive%\program files\windowspowershell\modules`).

   ```powershell
   Import-Module AksHci
   ```

After running the above command, close all PowerShell windows and reopen an administrative session to run the commands in the following steps.

## Step 2: Prepare your machine(s) for deployment

Run checks on every physical node to see if all the requirements are satisfied to install Azure Kubernetes Service on Azure Stack HCI.

Open PowerShell as an administrator and run the following command.

   ```powershell
   Initialize-AksHciNode
   ```

When the checks are finished, you'll see "Done" displayed in green text.

## Step 3: Configure your deployment

Set the configuration settings for the Azure Kubernetes Service host. **For a 2-4 node Azure Stack HCI cluster, you must specify `MultiNode` in the `-deploymentType`, the `wssdImageDir` and `cloudConfigLocation` parameters.** For a 1 node Azure Stack HCI cluster, all parameters are optional and set to their default values. However, for optimal performance, **we recommend using a 2-4 node Azure Stack HCI cluster deployment.**

Configure your deployment with the following command.

   ```powershell
   Set-AksHciConfig [-deploymentType {SingleNode, MultiNode}]
                    [-wssdImageDir]
                    [-cloudConfigLocation]
                    [-nodeConfigLocation]
                    [-vnetName]
                    [-controlPlaneVmSize]
                    [-loadBalancerVmSize]
                    [-sshPublicKey]
                    [-vipPoolStartIp]
                    [-vipPoolEndIp]
                    [-macPoolStart]
                    [-macPoolEnd]
                    [-vlanID]
                    [-cloudServiceCidr]
                    [-wssdDir]
                    [-akshciVersion]
                    [-vnetType]
                    [-nodeAgentPort]
                    [-nodeAgentAuthorizerPort]
                    [-clusterRoleName]
                    [-skipHostLimitChecks]
                    [-insecure]
                    [-skipUpdates]
                    [-forceDnsReplication]

   ```

### Optional parameters

`-deploymentType`

The deployment type. Accepted values: SingleNode, MultiNode. Defaults to SingleNode.

`-wssdImageDir`

The path to the directory where Azure Kubernetes Service on Azure Stack HCI will store its VHD images. Defaults to `%systemdrive%\wssdimagestore` for single node deployments. *For multi-node deployments, this parameter must be specified*. The path must point to a shared storage path such as `C:\ClusterStorage\Volume2\ImageStore` or an SMB share such as `\\FileShare\ImageStore`.

`-cloudConfigLocation`

The location where the cloud agent will store its configuration. Defaults to `%systemdrive%\wssdimagestore` for single node deployments. The location can be the same as the path of `-wssdImageDir` above. For *multi-node deployments, this parameter must be specified*.

`-nodeConfigLocation`

The location where the node agents will store their configuration. This must be a local path.

`-vnetName`

The name of the virtual switch to connect the virtual machines to. Defaults to “External” name. The switch will be created if it does not exist.  

`-controlPlaneVmSize`

The size of the VM to create for the control plane. To get a list of available VM sizes, run `Get-AksHciVmSize`.

`-loadBalancerVmSize`

The size of the VM to create for the Load Balancer VMs. To get a list of available VM sizes, run `Get-AksHciVmSize`.

`-sshPublicKey`

Path to an SSH public key file. Using this public key, you will be able to log in to any of the VMs created by the Azure Kubernetes Service on Azure Stack HCI deployment. If no key is provided, we will look for one under `%systemdrive%\Users\<username>\.ssh\id_rsa.pub`. If file does not exist, an SSH key pair in the above location will be generated and used.  

`-vipPoolStartIp`

When using VIP pools for your deployment, this parameter specifies the network start of the pool. Default is none.

`-vipPoolEndIp`

When using VIP pools for your deployment, this parameter specifies the network end of the pool. Default is none.

`-macPoolStart`

This is used to specify the start of the MAC address of the MAC pool that you wish to use for the Azure Kubernetes Service host VM. The syntax for the MAC address requires that the least significant bit of the first byte should always be 0, and the first byte should always be an even number (i.e. 00, 02, 04, 06...). A typical MAC address can look like: 02:1E:2B:78:00:00. Default is none.

`-macPoolEnd`

This is used to specify the end of the MAC address of the MAC pool that you wish to use for the Azure Kubernetes Service host VM. The syntax for the MAC address requires that the least significant bit of the first byte should always be 0, and the first byte should always be an even number (i.e. 00, 02, 04, 06...). The first byte of the address passed as the `-macPoolEnd` should be the same as the first byte of the address passed as the `-macPoolStart`. Default is none.

`-vlandID`

This can be used to specify a network VLAN ID. Azure Kubernetes Service host and Kubernetes cluster VM network adapters will be tagged with the provided VLAN ID. Default is none.

`cloudServiceCidr`

This can be used to provide a static IP/network prefix to be assigned to the MOC CloudAgent service. This value should be provided using the CIDR format. (Example: 192.168.1.2/16). Default is none.

`-wssdDir`

This is a working directory for the module to use for storing small files. Defaults to `%PROGRAMFILES%\AksHci` and should not be changed for most deployments.  

`-akshciVersion`

The version of Azure Kubernetes Service on Azure Stack HCI that you want to deploy. The default is the latest version.

`-vnetType`

The type of virtual switch to connect to or create. This defaults to “External” switch type.

`-nodeAgentPort`

The TCP/IP port number that nodeagents should listen on. Defaults to 45000.  

`-nodeAgentAuthorizerPort`

The TCP/IP port number that nodeagents should use for their authorization port. Defaults to 45001.  

`-clusterRoleName`

This specifies the name to use when creating cloudagent as a generic service within the cluster. This defaults to a unique name with a prefix of ca- and a guid suffix (for example: “ca-9e6eb299-bc0b-4f00-9fd7-942843820c26”)

`-skipHostLimitChecks`

Requests the script to skip any checks it does to confirm memory and disk space is available before allowing the deployment to proceed.

`-insecure`

Deploys Azure Kubernetes Service on Azure Stack HCI components such as cloudagent and nodeagent(s) in insecure mode (no TLS secured connections).  It is not recommended to use insecure mode in production environments.

`-skipUpdates`

Use this flag if you want to skip any updates available.

`-forceDnsReplication`

DNS replication can take up to an hour on some systems. This will cause the deployment to be slow. If you hit this issue, you'll see that the Install-AksHci will be stuck in a loop. To get past this issue, try to use this flag. The `-forceDnsReplication` flag is not a guaranteed fix. If the logic behind the flag fails, the error will be hidden, and the command will carry on as if the flag was not provided.

### Reset the Azure Kubernetes Service on Azure Stack HCI configuration

To reset the Azure Kubernetes Service on Azure Stack HCI configuration, run the following command. Running this command on its own will reset the configuration to default values.

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

## Step 5: Access your clusters using kubectl

To access your Azure Kubernetes Service host or Kubernetes cluster using kubectl, run the following command. This will use the specified cluster's kubeconfig file as the default kubeconfig file for kubectl.

```powershell
Get-AksHciCredential -clusterName
                     [-outputLocation]
```

### Required Parameters

`clusterName`

The name of the cluster.

### Optional Parameters

`outputLocation`

The location were you want the kubeconfig downloaded. Default is `%USERPROFILE%\.kube`.

## Get logs

To get logs from your all your pods, run the following command. This command will create an output zipped folder called `akshcilogs` in the path `C:\wssd\akshcilogs`.

```powershell
Get-AksHciLogs
```

## Reinstall Azure Kubernetes Service on Azure Stack HCI

Reinstalling Azure Kubernetes Service on Azure Stack HCI will remove all of your Kubernetes clusters if any, and the Azure Kubernetes Service host. It will also uninstall the Azure Kubernetes Service on Azure Stack HCI agents and services from the nodes. It will then go back through the original install process steps until the host is recreated. The Azure Kubernetes Service on Azure Stack HCI configuration that you configured via `Set-AksHciConfig` and the downloaded VHDX images are preserved.

To reinstall Azure Kubernetes Service on Azure Stack HCI, run the following command.

```powershell
Restart-AksHci
```

## Remove Azure Kubernetes Service on Azure Stack HCI

To remove Azure Kubernetes Service on Azure Stack HCI, run the following command.

```powershell
Uninstall-AksHci
```

## Next steps

- [Create a Kubernetes cluster for your applications](create-kubernetes-cluster-powershell.md)
