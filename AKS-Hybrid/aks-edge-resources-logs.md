---
title: Logs for AKS Edge Essentials
description: Gather and troubleshoot AKS Edge Essentials using logs. 
author: fcabrera
ms.author: fcabrera
ms.topic: end-user-help
ms.date: 02/14/2023
ms.custom: end-user-help
---

# AKS Edge Essentials logs

If you experience issues running AKS Edge Essentials IoT Edge in your environment, use this article as a guide for gathering and using logs. 

## Get logs

Your first step when troubleshooting AKS Edge Essentials should be to gather logs. The most convenient way is to use the `Get-AksEdgeLogs` command. By default, this cmdlet collects different logs around VM management, networking, Kubernetes services, and more. It compresses them into a single file for easy sharing.

To get the AKS Edge Essentials logs, use the following steps

1. Open an elevated PowerShell session.
1. Run the cmdlet to get the logs:

    ```powershell
    Get-AksEdgeLogs
    ```
1. All logs are stored in a .zip file under the following path: **C:\ProgramData\AksEdge\logs\aksedge-logs-ddmmyy-hhmm.zip**. 
1. Go to the **C:\ProgramData\AksEdge\logs** folder and unzip the **aksedge-logs-ddmmyy-hhmm.zip** logs file.

## Understanding logs

The compressed log file consists of different configuration files, deployment and services logs, and information about host OS and deployed cluster. Depending on the cluster state, Kubernetes distribution and host OS, some files may not be available. 

### Windows host OS logs

| File name | Group |  Description |
| --------- | ----- | ------------ | 
| **aksedgeevents.xml** | Windows Events | Windows events logged during deployment or VM lifecycle. To manually check these events, use Event Viewer application and check the events under *Applications and Services Logs* -> *AKS Edge Essentials- K3s/K8s*.
| **aksedgehost-systeminfo** | Information | Windows host OS information including: PowerShell version, Windows OS version, CPU, Memory and Storage. |
| **Microsoft-Windows-Host-Network-Service-Admin.xml** | Event logs | HNS service event logs - Internal use only. | 
| **Microsoft-Windows-Host-Network-Service-Operational.xml** | Event logs | HNS operational service event logs - Internal use only. | 
| **Microsoft-Windows-Hyper-V-Compute-Admin.xml**| Event logs | Events from the Host Compute Service [HCS](/virtualization/community/team-blog/2017/20170127-introducing-the-host-compute-service-hcs) are collected here - Internal use only. | 
| **Microsoft-Windows-Hyper-V-Compute-Operational.xml** | Event logs | Events from the Host Compute Service [HCS](/virtualization/community/team-blog/2017/20170127-introducing-the-host-compute-service-hcs) are collected here - Internal use only. | 
| **Microsoft-Windows-Hyper-V-VMMS-Admin.xml** | Event logs | Events from the virtual machine management service (VMMS) can be found here - Internal use only. | 
| **Microsoft-Windows-Hyper-V-VMMS-Networking.xml** | Event logs | Events from the virtual machine management service (VMMS) networking stack can be found here - Internal use only. | 
| **Microsoft-Windows-Hyper-V-VMMS-Operational.xml** | Event logs | Events from the virtual machine management service (VMMS) operation can be found here - Internal use only. | 

### Wssdagent logs

The WSSDAgent is the AKS Edge Essentials service used for virtual machines creation and lifecycle management. This service runs on the Windows host OS and uses Hyper-V API implementations (HCS or VMMS) to manage the VMs. 

| File name | Group |  Description |
| --------- | ----- | ------------ | 
| **agent-log-0** | VM Information | Virtual machines lifecycle logs - Internal use only.| 
| **wssdagent** | VM Information | Virtual machines lifecycle logs - Internal use only. |
| **Other files** | Deployment configurations | Internal use only. | 

### Linux-containers logs

Linux containers running inside the Linux nodes use `/var/log/continers/<container-name>.log` files to store container logs. All these `.log` files are copied and compressed under the *linux-containers* folder. 

### AKS Edge nodes logs

These logs should be independent of the cluster type and the Kubernetes distribution being used (K3s or K8s).

| File name | Group |  Description |
| --------- | ----- | ------------ | 
| **aksedgeconfig.txt** | Deployment configurations | Stores deployments configurations being used to create the cluster. Both internal and user-provided configurations are stored in this file. | 
| **aksedgelogs-summary** | Information | Details around which logs were collected and included in the logs compressed file. |
| **AksEdgenetworkConfig_LinuxVm** | VM Information | Output of networking configurations: IP addresses of network interfaces (`sudo ip a`), routes being used (`sudo route`) and *iptables* firewall rules (`sudo iptables -L`).
| ***\<Windows-hostname\>*-ledge_cloudinit** & ***\<Windows-hostname\>*-ledge_cloudinit-output** | VM Information | Output of cloudinit configurations used for the Linux VM creation. For more information, check [cloudinit docs](https://cloudinit.readthedocs.io/en/latest/). | 
| ***\<Windows-hostname\>*-ledge_systemd** | VM information | Logs of Linux *systemd* (`sudo journalctl`). |
| ***\<Windows-hostname\>*-ledge_vmconfig** | Deployment configurations | Linux virtual machine configurations - Internal use only. |
| ***\<Windows-hostname\>*-ledge-aksedge-agent** | VM information | Linux virtual machine deployment logs - Internal use only. |
| ***\<Windows-hostname\>*-ledge-aksedge-agent-config** | Deployment configurations | Linux virtual machine configurations - Internal use only. |
| ***\<Windows-hostname\>*-ledge-aksedge-lifecycle-config** | Deployment configurations | Linux virtual machine configurations - Internal use only. |
| ***\<Windows-hostname\>*-wedge_cloudbase-init** & ***\<Windows-hostname\>*-ledge_cloudbase-init-unattend** | VM Information | Output of cloudinit configurations used for the Windows VM creation. For more information, check [cloudbase-init docs](https://cloudbase-init.readthedocs.io/en/latest/tutorial.html). | 
| ***\<Windows-hostname\>*-wedge_ipconfig** | VM information | Output of networking configurations: IP addresses of network interfaces (`ipconfig /all`). |
| ***\<Windows-hostname\>*-wedge_vmconfig** | Deployment configurations | Windows virtual machine configurations - Internal use only. |
| ***\<Windows-hostname\>*-wedge-aksedge-agent** | VM information | Windows virtual machine deployment logs - Internal use only. |
| ***\<Windows-hostname\>*-wedge-aksedge-agent-config** | Deployment configurations | Windows virtual machine configurations - Internal use only. |
| ***\<Windows-hostname\>*-ledge-aksedge-lifecycle-mgmt** | VM information | Windows virtual machine lifecycle management logs - Internal use only. |
| **config** | Deployment configurations | Copy of JSON configuration used for deployment. Sensitive information isn't included. |
| **hcsdiag_list** | VM Information | Running virtual machines created by [HCS](/virtualization/community/team-blog/2017/20170127-introducing-the-host-compute-service-hcs). Only valid for Windows Client host OS deployments. AKS Edge Essentials nodes should run under the *wssdagent* name. |
| **hnsdiag_list_all** | VM information | Network information related to the virtual machines. Only valid for Windows Client host OS deployments.
| **kubectl_describe** | Kubernetes information | Output of running `kubectl describe nodes`. For more information about this command, check [Kubectl Reference Docs - Describe](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe). | 
| **kubectl_pods** | Cluster information | Output of running `kubectl describe pods`. For more information about this command, check [Kubectl Reference Docs - Describe](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#describe). | 

### K3s specific logs

These logs will be available only if AKS EE K3s version was installed, and *Linux* and/or *Windows* nodes were deployed. 

| File name | Group |  Description |
| --------- | ----- | ------------ | 
| ***\<Windows-hostname\>*-ledge_k3s** | Kubernetes information | Logs of K3S Linux system service (`sudo journalctl -u k3s` or `sudo journalctl -u k3s-agent`). |
| ***\<Windows-hostname\>*-wedge_k3s** | Kubernetes information | Logs of K3S Windows system service (`C:\tmp\K3s.log`). |
| ***\<Windows-hostname\>*-wedge_k3s-config** | Kubernetes information | Configuration file used for adding Windows K3s node. |

### K8s specific logs

These logs will be available only if AKS EE K8s version was installed, and *Linux* and/or *Windows* nodes were deployed. 

| File name | Group |  Description |
| --------- | ----- | ------------ | 
| ***\<Windows-hostname\>*-ledge_k8s** | Kubernetes information | Logs of K8s Linux system service (`sudo journalctl -u kubelet`). |
| ***\<Windows-hostname\>*-wedge_k8s** | Kubernetes information | Logs of K8s Windows system service (`C:\tmp\kubelet.log`). |
| ***\<Windows-hostname\>*-wedge_k8s-config** | Kubernetes information | Configuration file used for adding Windows K8s node. |

## Next steps

- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
