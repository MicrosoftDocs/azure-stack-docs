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

For issues not covered by this article, see [troubleshooting Kubernetes clusters](https://kubernetes.io/docs/tasks/debug-application-cluster/troubleshooting/) and this troubleshooting guide published by Microsoft engineers for troubleshooting common scenarios on Windows Admin Center (WAC), Windows worker nodes, Linux worker nodes, and Azure Arc Kubernetes.

## Windows Admin Center throws a WinRM error when creating a new Kubernetes workload cluster on an AKS host deployed using PowerShell (PS) with static IPs

**Issue description**: When I switched my test environment from DHCP to static IP, I started seeing an error from WAC that the WinRM client cannot process the request. After investigating, I found that this also occurred outside of WAC. WinRM broke when I used static IP addresses, and my servers were not registering an SPN when I moved over to static IP addresses. 

**Resolution**: This issue can be resolved by using `SetSPN` to create the SPN (Service Principal Name). Open a command prompt on your WAC gateway and run: 

```
Setspn /Q WSMAN/<FQDN on the Azure Stack HCI Server> 
```

Next, if any of the servers in your environment return `No Such SPN Found`, then log in to that server and run:  

```
Setspn /S WSMAN/<server name> <server name> 
Setspn /S WSMAN/<FQDN of server> <server name> 
```

Finally, on your WAC gateway, run the following to ensure that it gets new server information from the domain controller.

```
Klist purge 
```

## Csi pod stuck in ContainerCreating state at 70th iteration of update reliability 

