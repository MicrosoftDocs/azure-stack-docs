---
title: Troubleshoot known issues on Azure Kubernetes Service on Azure Stack HCI
description: Learn how to resolve known issues in an Azure Kubernetes Service (AKS) on Azure Stack HCI deployment.
author: EkeleAsonye
ms.topic: how-to
ms.date: 03/05/2021
ms.author: v-susbo
---

# Troubleshoot known issues in Azure Kubernetes Service on Azure Stack HCI

This article includes workaround steps for resolving known issues that occur on AKS on Azure Stack HCI.

For issues not covered by this article, see [troubleshooting Kubernetes clusters](https://kubernetes.io/docs/tasks/debug-application-cluster/troubleshooting/), and this [troubleshooting guide](./troubleshoot.md) for troubleshooting common scenarios on Windows Admin Center (WAC), Windows worker nodes, Linux worker nodes, and Azure Arc Kubernetes.

## Windows Admin Center displays an WinRM error when creating a new workload cluster

**Issue description**: When switching from DHCP to static IP, WAC displayed an error that said the WinRM client cannot process the request. This error also occurred outside of WAC. WinRM broke when static IP addresses were used, and the servers were not registering an Service Principal Name (SPN) when moving to static IP addresses. 

**Resolution**: To resolve this issue, use the **SetSPN** command to create the SPN. From a command prompt on the WAC gateway, run the following command: 

```Bash
Setspn /Q WSMAN/<FQDN on the Azure Stack HCI Server> 
```

Next, if any of the servers in the environment return the message `No Such SPN Found`, then log in to that server and run the following commands:  

```Bash
Setspn /S WSMAN/<server name> <server name> 
Setspn /S WSMAN/<FQDN of server> <server name> 
```

Finally, on the WAC gateway, run the following to ensure that it gets new server information from the domain controller:

```Bash
Klist purge 
```

## Container storage interface pod stuck in a _ContainerCreating_ state

**Issue description**: A new Kubernetes workload cluster was created with Kubernetes version 1.16.10, and then updated to 1.16.15. After the update, the `csi-msk8scsi-node-9x47m` pod was stuck in the _ContainerCreating_ state, and the `kube-proxy-qqnkr` pod was stuck in the _Terminating_ state. 

AKS on Azure Stack HCI did not reinstall between iterations. Each iteration of the update reliability script only creates a new workload cluster, updates it, and deletes it. 

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

**Resolution**: Since _kubelet_ ended up in a bad state and can no longer talk to the API server, the only solution is to restart the _kubelet_ service. After restarting, the cluster goes into a _running_ state.  

## Install-AksHci timed out with an error

**Issue description**: After running `Install-AksHci`, the installation stopped and displayed a **waiting for API server** error message. Then, When `Get-AksHciCluster` was run, the following error was displayed:

```output
\kubectl.exe --kubeconfig=C:\AksHci\0.9.7.3\kubeconfig-clustergroup-management get akshciclusters -o json returned a non zero exit code 1 [Unable to connect to the server: dial tcp 192.168.0.150:6443: connectex: A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.]
```

**Resolution**: There are multiple reasons why an installation might fail when the **waiting for API server** error occurs. One of the causes may occur when using static IP.

If you’re using static IP, confirm that the DNS server is correctly configured. Check the host's DNS server address using the following command:

```powershell
Get-NetIPConfiguration.DNSServer | ?{ $_.AddressFamily -ne 23} ).ServerAddresses
```

Confirm that the DNS server address is the same as the address used when running `New-AksHciNetworkSetting` by running the following command:

```powershell
Get-MocConfig
```

If the DNS server has been incorrectly configured, reinstall AKS on Azure Stack HCI with the correct DNS server. For more information, see [Restart, remove, or reinstall Azure Kubernetes Service on Azure Stack HCI ](./restart-cluster.md).

The issue was resolved after deleting the configuration and restarting the VM with a new configuration.