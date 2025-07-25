---
title: Move Marketplace item cluster to AKS engine on Azure Stack Hub 
description: Learn how to Move your Marketplace item cluster to the AKS engine on Azure Stack Hub. 
author: sethmanheim

ms.topic: how-to
ms.date: 2/1/2021
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 09/02/2020

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

# Move your Marketplace item cluster to the AKS engine on Azure Stack Hub

The Kubernetes Azure Stack Hub Marketplace item uses an Azure Resource Manager template to deploy a deployment virtual machine (VM) to download and install the AKS engine and generate the input API Model used to describe the cluster, after that AKS engine is run in the VM and the cluster deployed. This article shows you how to access the AKS engine and corresponding files so that you can then use it to perform update and scale operations on your Kubernetes cluster.

## Access AKS engine in the DVM

Once the deployment initiated by the Kubernetes Azure Stack Hub Marketplace item successfully finishes you can find the AKS engine used to deploy the cluster installed in the deployment VM created in the resource group you specified for the cluster, this VM is not part of the Kubernetes cluster, it is created in it own VNet. Here are the steps to find the VM and locate the AKS engine inside it:

1.  Open the Azure Stack Hub user portal, and locate the resource group you specified for the Kubernetes cluster.
2.  In the resource group, find the deployment VM. The name starts with the prefix: **vmd-**.
3.  Select the deployment VM. In Overview,** find the public IP address. Use this address and your console app, such as Putty, to establish an SSH session to the VM.
4.  In your session on the deployment VM, you find the AKS engine at the following path: `./var/lib/waagent/custom-script/download/0/bin/aks-engine`
5.  Locate the `.json` file that describes the clusters used as input into the aks-engine. The file as at `/var/lib/waagent/custom-script/download/0/bin/azurestack.json`. Take note that the file has the service principal credentials used to deploy your cluster. If you decide to preserve the file, take care to transfer the file to a protected store.
6.  Locate the output directory generated by the AKS engine at `/var/lib/waagent/custom-script/download/0/_output/<resource group name>`. In this directory, find the output `apimodel.json` at the path `/var/lib/waagent/custom-script/download/0/bin/apimodel.json`. The directory and `apimodel.json` file contain all of the generated certificates, keys, and credentials you needed to deploy the Kubernetes cluster. Store these resources a secure location.
7.  Locate the Kubernetes configuration file, often referred to as the **kubeconfig** file, at the path `/var/lib/waagent/custom-script/download/0/_output/k8smpi00/kubeconfig/kubeconfig.<location>.json`, where **\<location>**  corresponds to your Azure Stack Hub location identifier. This file is useful if you plan to set up **kubectl** to access your Kubernetes cluster.


## Use the AKS engine with your newly created cluster

Once you have located the aks-engine, input apimodel.json file, output directory, and output apimodel.json file, store them in a secured location, you can use the AKS engine binary and output `apimodel.json` on any Linux VM.

1.  To continue using the AKS engine, to perform operations such as **Upgrade** and **Scale**, copy the **aks-engine** binary file to the target machine. If you are using the same **vmd-** machine to a directory.

2.  Create a directory with the name of the cluster or other mnemotechnic name that refers to the new cluster and save the output apimodel.json file in it. Ensure it is a protected place since this file contains credentials. After that you can run the aks-engine to run operations such as [Scale](azure-stack-kubernetes-aks-engine-scale.md) or [Upgrade](azure-stack-kubernetes-aks-engine-upgrade.md)

## Next steps

- Read about the [The AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)  
- [Troubleshoot the AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-troubleshoot.md)  
