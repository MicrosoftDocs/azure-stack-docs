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

If you need additional troubleshooting data not covered by this article, [AKS troubleshooting](./troubleshoot.md), or [Windows Admin Center troubleshooting](./troubleshoot-wac.md), see [Troubleshooting Kubernetes clusters](https://kubernetes.io/docs/tasks/debug-application-cluster/troubleshooting/).

## _Install-AksHci_ timed out with an error

After running `Install-AksHci`, the installation stopped and displayed a **waiting for API server** error message:

```output
\kubectl.exe --kubeconfig=C:\AksHci\0.9.7.3\kubeconfig-clustergroup-management get akshciclusters -o json returned a non zero exit code 1 [Unable to connect to the server: dial tcp 192.168.0.150:6443: connectex: A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.]
```

There are multiple reasons why an installation might fail with the **waiting for API server** error. See the following sections for possible causes and solutions for this error.

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

## Next steps
- [Troubleshoot common issues](./troubleshoot.md)
- [Troubleshoot Windows Admin Center](./troubleshoot-windows-admin-center.md)

If you continue to run into problems when you're using Azure Kubernetes Service on Azure Stack HCI, you can file bugs through [GitHub](https://aka.ms/aks-hci-issues).
