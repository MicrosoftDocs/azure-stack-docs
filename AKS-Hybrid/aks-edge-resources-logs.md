---
title: Logs for AKS Edge Essentials
description: Gather and troubleshoot AKS Edge Essentials using logs. 
author: fcabrera
ms.author: fcabrera
ms.topic: resources
ms.date: 02/14/2023
ms.custom: resources
---

# AKS Edge Essentials logs

If you experience issues running AKS Edge Essentials IoT Edge in your environment, use this article as a guide for gathering and using logs. 

## Get logs

Your first step when troubleshooting AKS Edge Essentials should be to use gather logs. The most convenient way is to use the `Get-AksEdgeLogs` command. By default, this command collects different logs around VM management, networking, Kubernetes services and more. It compresses them into a single file for easy sharing.

To get the AKS Edge Essentials logs, use the following steps

1. Open an elevated PowerShell session
1. Run the cmdlet to get the logs
    ```powershell
    Get-AksEdgeLogs
    ```
1. All logs are stored in a .Zip file under the following path `C:\ProgramData\AksEdge\logs\aksedge-logs-ddmmyy-hhmm.zip" 
1. Move to `C:\ProgramData\AksEdge\logs\` folder and unzip the `aksedge-logs-ddmmyy-hhmm.zip` logs file.

## Understanding logs

The logs compressed file consists of different configuration files, deployment & services logs, and information about host OS and deployed cluster. Depending on the cluster state, Kubernetes distribution and host OS, some files may not be available. 

### Generic logs

These logs should be independent of the cluster type and the Kubernetes distribution being used (K3s or K8s)

| File name | Group |  Description |
| --------- | ----- | ------------ | 
| aksedgeconfig.txt | Deployment configurations | Stores deployments configurations being used to create the cluster. Both internal and user-provided configurations are stored in this file. | 
| aksedgeevents.xml | Windows Events | Windows events logged during deployment or VM lifecycle. To manually check these events, use Event Viewer application and check the events under *Applications and Services Logs* -> *AKS Edge Essentials- K3s/K8s*.
| aksedgehost-systeminfo | Information | Windows host OS information including: PowerShell version, Windows OS version, CPU, Memory and Storage. |
| aksedgelogs-summary | Information | Details around which logs were collected and included in the logs compressed file. |
| AksEdgenetworkConfig_LinuxVm | VM Information | Output of networking configurations: IP addresses of network interfaces (`sudo ip a`), routes being used (`sudo route`) and *iptables* firewall rules (`sudo iptables -L`).
| *\<Windows-hostname\>*-ledge_cloudinit & *\<Windows-hostname\>*-ledge_cloudinit-output | VM Information | Output of cloudinit configurations used for the Linux VM creation. For more information, check [cloudinit docs](https://cloudinit.readthedocs.io/en/latest/). | 
| *\<Windows-hostname\>*-ledge_systemd | VM information | Logs of Linux *systemd* (`sudo journalctl`). |
| *\<Windows-hostname\>*-ledge_vmconfig | Deployment configurations | Linux virtual machine configurations - Internal use only. |
| *\<Windows-hostname\>*-ledge-aksedge-agent | VM information | Linux virtual machine deployment logs - Internal use only. |
| *\<Windows-hostname\>*-ledge-aksedge-agent-config | Deployment configurations | Linux virtual machine configurations - Internal use only. |
| *\<Windows-hostname\>*-ledge-aksedge-lifecycle-config | Deployment configurations | Linux virtual machine configurations - Internal use only. |
| *\<Windows-hostname\>*-wedge_cloudbase-init & *\<Windows-hostname\>*-ledge_cloudbase-init-unattend | VM Information | Output of cloudinit configurations used for the Windows VM creation. For more information, check [cloudbase-init docs](https://cloudbase-init.readthedocs.io/en/latest/tutorial.html). | 
| *\<Windows-hostname\>*-wedge_ipconfig | VM information | Output of networking configurations: IP addresses of network interfaces (`ipconfig`). |
| hcsdiag_list | VM Information | Running virtual machines created by [HCS](/virtualization/community/team-blog/2017/20170127-introducing-the-host-compute-service-hcs). Only valid for Windows Client host OS deployments. AKS Edge Essentials nodes should run under the *wssdagent* name. |
| hnsdiag_list_all | VM information | Network information related to the virtual machines. Only valid for Windows Client host OS deployments.
| kubectl_describe | Kubernetes information | 
| kubectl_pods | Cluster information | Output of running `kubectl get pods`. For more information about this command, check [Kubectl Reference Docs - Get](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get). | 

### K3s specific logs

| File name | Group |  Description |
| --------- | ----- | ------------ | 
| *\<Windows-hostname\>*-ledge_k3s | Kubernetes information | Logs of K3S Linux system service (`sudo journalctl -u k3s`). |
| *\<Windows-hostname\>*-wedge_k3s | Kubernetes information | Logs of K3S Windows system service (`C:\tmp\K3s.log`). |
| *\<Windows-hostname\>*-wedge_k3s-config | Kubernetes information | Configuration file used for adding Windows K3s node. |


## Next steps

- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
