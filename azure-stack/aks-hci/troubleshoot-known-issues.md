---
title: Troubleshoot known issues on Azure Kubernetes Service on Azure Stack HCI
description: Learn how to resolve known issues in an Azure Kubernetes Service (AKS) on Azure Stack HCI deployment.
author: EkeleAsonye
ms.topic: how-to
ms.date: 03/05/2021
ms.author: v-susbo
---

# Troubleshoot known issues in Azure Kubernetes Service on Azure Stack HCI

This article includes workaround steps for known issues that occur on AKS on Azure Stack HCI.

For issues not covered by this article, see [troubleshooting Kubernetes clusters](https://kubernetes.io/docs/tasks/debug-application-cluster/troubleshooting/), and this [troubleshooting guide](./troubleshoot.md) for troubleshooting common scenarios on Windows Admin Center (WAC), Windows worker nodes, Linux worker nodes, and Azure Arc Kubernetes.

## Windows Admin Center throws a WinRM error when creating a new Kubernetes workload cluster on an AKS host deployed using PowerShell with static IPs

**Issue description**: When I switched my test environment from DHCP to static IP, I started seeing an error from WAC that the WinRM client cannot process the request. After investigating, I found that this also occurred outside of WAC. WinRM broke when I used static IP addresses, and my servers were not registering an SPN when I moved over to static IP addresses. 

**Resolution**: This issue can be resolved by using `SetSPN` to create the SPN (Service Principal Name). From a command prompt on your WAC gateway, run the following: 

```
Setspn /Q WSMAN/<FQDN on the Azure Stack HCI Server> 
```

Next, if any of the servers in your environment return `No Such SPN Found`, then log in to that server and run:  

```
Setspn /S WSMAN/<server name> <server name> 
Setspn /S WSMAN/<FQDN of server> <server name> 
```

Finally, on your WAC gateway, run the following to ensure that it gets new server information from the domain controller:

```
Klist purge 
```

## Pod stuck in _ContainerCreating_ state at the 70th iteration of an update reliability script

**Issue description**: On the 70th iteration of an update reliability script, a new Kubernetes workload cluster was created with Kubernetes version 1.16.10, and then updated to 1.16.15. After the update, the `csi-msk8scsi-node-9x47m` pod was stuck in the _ContainerCreating_ state, and the `kube-proxy-qqnkr` pod was stuck in the _Terminating_ state. 

AKS on Azure Stack HCI did not reinstall between iterations. Each iteration of the update reliability script only creates a new workload cluster, updates it, and deletes it. 

```output
Error: PS C:\Program Files\AksHci> .\kubectl.exe get nodes --kubeconfig=C:\Users\wolfpack\Documents\kubeconfig-update-cluster70 
NAME              STATUS     ROLES    AGE     VERSION 
moc-lf22jcmu045   Ready      <none>   5h40m   v1.16.15 
moc-lqjzhhsuo42   Ready      <none>   5h38m   v1.16.15 
moc-lwan4ro72he   NotReady   master   5h44m   v1.16.15

PS C:\Program Files\AksHci> .\kubectl.exe get pods -A --kubeconfig=C:\Users\wolfpack\Documents\kubeconfig-update-cluster70

NAMESPACE     NAME                                            READY   STATUS              RESTARTS   AGE 
kube-system   coredns-5644d7b6d9-8bqgg                        1/1     Running             0          5h40m 
kube-system   coredns-5644d7b6d9-8bsvl                        1/1     Running             0          5h38m 
kube-system   csi-msk8scsi-controller-dcf7d9759-qs9vd         5/5     Running             0          5h38m 
kube-system   csi-msk8scsi-node-2zx8b                         3/3     Running             0          5h38m 
kube-system   csi-msk8scsi-node-9x47m                         0/3     ContainerCreating   0          5h44m 
kub-system    csi-msk8scsi-node-z5ff8                         3/3     Running             0          5h40m 
kube-system   etcd-moc-lwan4ro72he                            1/1     Running             0          5h44m 
kube-system   kube-proxy-n5cf4                                1/1     Running             0          5h39m 
kube-system   kube-proxy-qqnkr                                1/1     Terminating         0          5h44m 
kube-system   kube-proxy-wqh4d                                1/1     Running             0          5h40m 
```

In the error output above, the following lines show the errors that occurred:

```
kube-system   csi-msk8scsi-node-9x47m                         0/3     ContainerCreating   0          5h44m
kube-system   kube-proxy-qqnkr                                1/1     Terminating         0          5h44m
```

**Resolution**: Since _kubelet_ ended up in a bad state and can no longer talk to the API server, the only solution is to restart the _kubelet_ service. After restarting, the cluster goes into a _running_ state. This issue is expected to be resolved in Kubernetes version 1.19. 