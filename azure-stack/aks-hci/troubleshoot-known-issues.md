---
title: Resolve known issues on Azure Kubernetes Service on Azure Stack HCI
description: Learn how to resolve known issues in an Azure Kubernetes Service (AKS) on Azure Stack HCI deployment.
author: EkeleAsonye
ms.topic: how-to
ms.date: 03/05/2021
ms.author: v-susbo
---

# Resolve known issues

This article includes workaround steps for resolving known issues that occur when using Azure Kubernetes Service on Azure Stack HCI.

## _Install-AksHci_ timed out with an error

After running `Install-AksHci`, the installation stopped and displayed a **waiting for API server** error message:

```Output
\kubectl.exe --kubeconfig=C:\AksHci\0.9.7.3\kubeconfig-clustergroup-management get akshciclusters -o json returned a non zero exit code 1 [Unable to connect to the server: dial tcp 192.168.0.150:6443: connectex: A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.]
```

There are multiple reasons why an installation might fail with the **waiting for API server** error. See the following sections for possible causes and solutions for this error.

### Incorrect IP gateway configuration
If you're using static IP and you received the following error message, confirm that the configuration for the IP address and gateway is correct. 
```PowerShell
Install-AksHci 
C:\AksHci\kvactl.exe create –configfile C:\AksHci\yaml\appliance.yaml  --outfile C:\AksHci\kubeconfig-clustergroup-management returned a non zero exit code 1 [ ]
```

To check whether you have the right configuration for your IP address and gateway, run the following: 

```powershell
ipconfig /all
```

In the displayed configuration settings, confirm the configuration. You could also attempt to ping the IP gateway and DNS server. 

If these methods don't work, use [New-AksHciNetworkSetting](./new-akshcinetworksetting.md) to change the configuration.

### Incorrect DNS server
If you’re using static IP, confirm that the DNS server is correctly configured. To check the host's DNS server address, use the following command:

```powershell
Get-NetIPConfiguration.DNSServer | ?{ $_.AddressFamily -ne 23} ).ServerAddresses
```

Confirm that the DNS server address is the same as the address used when running `New-AksHciNetworkSetting` by running the following command:

```powershell
Get-MocConfig
```

If the DNS server has been incorrectly configured, reinstall AKS on Azure Stack HCI with the correct DNS server. For more information, see [Restart, remove, or reinstall Azure Kubernetes Service on Azure Stack HCI ](./restart-cluster.md).

The issue was resolved after deleting the configuration and restarting the VM with a new configuration.

## When multiple versions of the PowerShell modules are installed, Windows Admin Center does not pick the latest version
If you have multiple versions of the PowerShell modules installed (for example, 0.2.26, 0.2.27, and 0.2.28), Windows Admin Center may not use the latest version (or the one it requires). Make sure you have only one PowerShell module installed. You should uninstall all unused PowerShell versions of the PowerShell modules and leave just one installed. More information on which Windows Admin Center version is compatible with which PowerShell version can be found in the [release notes.](https://github.com/Azure/aks-hci/releases/tag/AKS-HCI-2104).

## After a failed installation, the Install-AksHci PowerShell command cannot be run
If your installation fails using [Install-AksHci](./uninstall-akshci.md), you should run [Uninstall-AksHci](./uninstall-akshci.md) before running `Install-AksHci` again. This issue happens because a failed installation may result in leaked resources that have to be cleaned up before you can install again.

## A timeout error appears when trying to connect an AKS workload cluster to Azure Arc through WAC
Sometimes, due to network issues, Windows Admin Center times out an Arc connection. Use the PowerShell command [Enable-AksHciArcConnection](./enable-akshciarcconnection.md) to connect the AKS workload cluster to Azure Arc while we actively work on improving the user experience.

## An Arc connection on an AKS cluster cannot be enabled after disabling it.
To enable an Arc connection, after disabling it, run the following [Get-AksHciCredential](./get-akshcicredential.md) PowerShell command as an administrator, where `-Name` is the name of your workload cluster.

```powershell
Get-AksHciCredential -Name myworkloadcluster
kubectl --kubeconfig=kubeconfig delete secrets sh.helm.release.v1.azure-arc.v1
```

## Container storage interface pod stuck in a _ContainerCreating_ state
A new Kubernetes workload cluster was created with Kubernetes version 1.16.10, and then updated to 1.16.15. After the update, the `csi-msk8scsi-node-9x47m` pod was stuck in the _ContainerCreating_ state, and the `kube-proxy-qqnkr` pod was stuck in the _Terminating_ state as shown in the output below:

```output
Error: kubectl.exe get nodes  
NAME              STATUS     ROLES    AGE     VERSION 
moc-lf22jcmu045   Ready      <none>   5h40m   v1.16.15 
moc-lqjzhhsuo42   Ready      <none>   5h38m   v1.16.15 
moc-lwan4ro72he   NotReady   master   5h44m   v1.16.15

\kubectl.exe get pods -A 

NAMESPACE     NAME                                            READY   STATUS              RESTARTS   AGE 
    5h38m 
kube-system   csi-msk8scsi-node-9x47m                         0/3     ContainerCreating   0          5h44m 
kube-system   kube-proxy-qqnkr                                1/1     Terminating         0          5h44m  
```

Since _kubelet_ ended up in a bad state and can no longer talk to the API server, the only solution is to restart the _kubelet_ service. After restarting, the cluster goes into a _running_ state.

## Attempt to increase the number of worker nodes fails
When using PowerShell to create a cluster with static IP and then attempt to increase the number of worker nodes in the workload cluster, the installation got stuck at _control plane count at 2, still waiting for desired state: 3_. After a period of time, another error message appears: _Error: timed out waiting for the condition_.

When [Get-AksHciCluster](./get-akshcicluster.md) was run, it showed that the control plane nodes were created and provisioned and were in a _Ready_ state. However, when `kubectl get nodes` was run, it showed that the control plane nodes had been created but not provisioned and were not in a _Ready_ state.

If you get this error, verify that the IP addresses have been assigned to the created nodes using either Hyper-V Manager or PowerShell:

```powershell
(Get-VM |Get-VMNetworkAdapter).IPAddresses |fl
```
  
Then, verify the network settings to ensure there are enough IP addresses left in the pool to create more VMs.   

## When deploying AKS on Azure Stack HCI with a misconfigured network, deployment timed out at various points
When deploying AKS on Azure Stack HCI, the deployment may time out at different points of the process depending on where the misconfiguration occurred. You should review the error message to determine the cause and where it occurred.

For example, in the following error, the point at which the misconfiguration occurred is in `Get-DownloadSdkRelease -Name "mocstack-stable"`: 

```
$vnet = New-AksHciNetworkSettingSet-AksHciConfig -vnet $vnetInstall-AksHciVERBOSE: 
Initializing environmentVERBOSE: [AksHci] Importing ConfigurationVERBOSE: 
[AksHci] Importing Configuration Completedpowershell : 
GetRelease - error returned by API call: 
Post "https://msk8s.api.cdp.microsoft.com/api/v1.1/contents/default/namespaces/default/names/mocstack-stable/versions/0.9.7.0/files?action=generateDownloadInfo&ForegroundPriority=True": 
dial tcp 52.184.220.11:443: connectex: 
A connection attempt failed because the connected party did not properly
respond after a period of time, or established connection failed because
connected host has failed to respond.At line:1 char:1+ powershell -command
{ Get-DownloadSdkRelease -Name "mocstack-stable"}
```

This indicates that the physical Azure Stack HCI node can resolve the name of the download URL, `msk8s.api.cdp.microsoft.com`, but the node can't connect to the target server.

To resolve this issue, you need to determine where the breakdown occurred in the connection flow. Here are some steps to try to resolve the issue from the physical cluster node:

1. Ping the destination DNS name: ping `msk8s.api.cdp.microsoft.com`. 
2. If you get a response back and no time-out, then the basic network path is working. 
3. If the connection times out, then there could be a break in the data path. For more information, see [check proxy settings](./set-proxy-settings.md). Or, there could be a break in the return path, so you should check the firewall rules. 

## Next steps
- [Troubleshoot common issues](./troubleshoot.md)
- [Troubleshoot Windows Admin Center](./troubleshoot-windows-admin-center.md)
- [Troubleshooting Kubernetes clusters](https://kubernetes.io/docs/tasks/debug-application-cluster/troubleshooting/)

If you continue to run into problems when you're using Azure Kubernetes Service on Azure Stack HCI, you can file bugs through [GitHub](https://aka.ms/aks-hci-issues).
