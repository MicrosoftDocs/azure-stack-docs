---
title: AKS Edge Essentials Release Notes and Known Issues
description: Release notes and known issues on the latest builds. 
author: yujinkim-msft
ms.author: yujinkim
ms.topic: how-to
ms.date: 12/01/2022
ms.custom: template-resources
---


# Release Notes
Welcome to the Public Preview of AKS Edge Essentials! This release includes the following features and known issues. 

## Features
- K8s distribution 
- K3s distribution
- Run Linux containerized workloads 
- Run Windows containerized workloads 
- Create a single-node Linux (control plane and worker) cluster on a single machine
- Create a dual-node Linux node (control plane and worker) + Windows node (worker) cluster on a single machine 
- Create a cluster with multiple machines
- Remotely deploy your own workloads using Azure Arc GitOps 
- Remotely deploy Azure services using Azure Arc 
- Run on a Windows device with at least 4GB of total RAM | 
- Run on a Windows device with at least 17GB of free disk space after MSI installed 
- Use `calico` or `flannel` network plugins 
- Offline installation  

## Known Issues in this Release
- Private Preview uninstallation: The AksIot event source is not cleaned up upon uninstallation. This will not have an effect on the public preview installation but it is an unwanted remainder that is not removed. To manually clean this, you can run the following in an elevated PS Window: `[System.Diagnostics.EventLog]::DeleteEventSource("AksIot")`
- Public Preview reinstallation: When you uninstall a public preview MSI and reinstall a public preview MSI, please ensure to reboot the system in between. Otherwise event logging will not work.
- Scaling `LinuxAndWindows` nodes as control planes may fail to start the Linux VM on k3s. If this occurs, please use k8s as a workaround for now.
- SSH.exe may hang on the Windows host. If this occurs, please press `Ctrl + C` to break the deployment and rerun the deployment command. 
- When deploying a `LinuxAndWindows` cluster, it may get stuck on testing the connection after Windows VM creation. To avoid this, please validate that the IP addresses are free before deploying the cluster. 
- If your machine goes to sleep while a cluster is running, it may disappear and not return reliably when machine is awake. A cold restart should make the cluster return. If you would like to prevent this issue from occurring, please turn off the power management so that your machine does not go to sleep while your cluster is running.
- `kubectl` commands may fail immediately after a successful new deployment. Please open a new Powershell window (with Adminstrator) to resolve this. 
- `Get-Help New-AksEdgeDeployment -full` has missing module information. For more detailed information on the modules, take a look at the [Powershell reference](/AKS-Hybrid/reference/aks-lite-ps/index.md).
- `Test-AksEdgeNetworkParameters` returns `True` with same config file in a different machine after you have installed it on one machine (they have the same IP addresses). The error may show up too late when a `New-AksEdgeDeployment` is created on the second machine with the same config file on the same network. Please make sure to change the network parameters for the deployments on each machine. 
- k3s on Windows with `calico` as the CNI results in an error. As a workaround, please use `flannel` as the CNI when using k3s on Windows for now. 
- We are still investigating support for IPv6 on AKS Edge Essentials. For now, please limit your usage to IPv4. 
- When the `AksEdgeWindows-V1.exe` fails (i.e. due to lack of memory, etc.), it creates an incomplete VHDX file that causes errors later on. If this occurs, please remove the incomplete `AksEdgeWindows-v1.vhdx` file before proceeding.
