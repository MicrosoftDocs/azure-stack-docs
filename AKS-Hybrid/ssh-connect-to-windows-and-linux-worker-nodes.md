---
title: 
description: 
ms.date: 01/10/2025
ms.topic: how-to
ms.service: 
author: sethmanheim
ms.author: sethm
manager: 
---

Connect to Windows or Linux worker nodes with SSH

-   Author: Leslie Lin

-   Date: 11/21/2024

-   Document Status: draft

-   TOC: AKS on Azure Local, Version 23H2 &gt;&gt;&gt; How-to &gt;&gt;&gt; Connect to Windows or Linux worker nodes with SSH &lt;below "Configure SSH key for an AKS Arc cluster&gt;

-   Ref.

    -   

    -   [AKS Azure doc](https://learn.microsoft.com/en-us/azure/aks/node-access)AKS 22H2: <https://learn.microsoft.com/en-us/azure/aks/hybrid/ssh-connection>

| Name                  | Review/Approver | LGTM | Date |
|-----------------------|-----------------|------|------|
| **Yi, Raghavendra**   | Reviewer        |      |      |
| **AKS Arc Dev Leads** | Reviewer        |      |      |
| **AKS Arc PM**        | Reviewer        |      |      |
| **Seth**              | Reviewer        |      |      |

Applies to: AKS on Azure Local, version 23H2

During your AKS Arc cluster's lifecycle, you may need to directly access cluster nodes for maintenance, log collection, or troubleshooting operations. For security purposes, you must use a Secure Shell Protocol (SSH) connection to access Windows or Linux worker nodes. You will sign in using the node's IP address.

This article explains how to use SSH to connect to both Windows and Linux nodes.

# Use SSH to connect to Windows and Linux worker nodes

1.  To access the Kubernetes cluster with the given permissions, you need retrieve the certificate-based admin **kubeconfig** using the [az aksarc get-credentials](https://learn.microsoft.com/en-us/cli/azure/aksarc#az-aksarc-get-credentials) command.  Follow [this article](https://learn.microsoft.com/en-us/azure/aks/hybrid/retrieve-admin-kubeconfig) to learn more.

| **Azure CLI**</br>az aksarc get-credentials --resource-group $resource_group_name --name $aks_cluster_name --admin |
|-------------------------|


2.  Run kubectl get to obtain the node's IP address and capture its IP value to sign in to a Windows or Linux worker node using SSH

| **Azure CLI**</br>kubectl --kubeconfig /path/to/aks-cluster-kubeconfig get nodes -o wide |
|-------------------------|


3.  Next, run ssh cloud@&lt;IP Address of the node&gt; to connect to a worker node:

| **Note**</br>You must pass the correct location to your SSH private key. The following example uses the default location of ~/.ssh/id_rsa, but you might need to change this location if you requested a different path. To change the location, follow [these instructions](https://microsoft-my.sharepoint-df.com/:w:/p/leslielin/EfHDyYecQsRHtK9Y9baTmnABTR5rns5U95u7hMsiU7ZmAA?e=7UxOvw) to specify the --ssh-key-value parameter when creating an AKS Arc cluster. |
|-------------------------|


| **Azure CLI**</br>ssh -i $env:USERPROFILE\.ssh\id_rsa [clouduser@&lt;IP Address of the Node&gt;](mailto:clouduser@100.68.153.33) |
|-------------------------|


| Note!</br>If you encounter SSH login issues, verify that your IP address is included in the --ssh-auth-ip list.</br>To check this, run: az aksarc show --name "$aks_cluster_name" --resource-group "$resource_group_name" and look for "authorizedIpRanges" under "clusterVmAccessProfile" |
|-------------------------|


**Next steps**

1.  Use SSH key to [get on-demand logs for troubleshooting](https://learn.microsoft.com/en-us/azure/aks/hybrid/get-on-demand-logs)

2.  Learn how to [configure SSH keys for an AKS Arc cluster](https://microsoft-my.sharepoint-df.com/:w:/p/leslielin/EfHDyYecQsRHtK9Y9baTmnABTR5rns5U95u7hMsiU7ZmAA?e=akmDFg)

<u>Appendix – do not release</u>

<u>Here's the screenshot of the kubeconfig file path</u>

