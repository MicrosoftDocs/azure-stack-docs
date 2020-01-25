---
title: Troubleshoot Kubernetes deployment to Azure Stack Hub | Microsoft Docs
description: Learn how to troubleshoot Kubernetes deployment to Azure Stack Hub.
author: mattbriggs

ms.topic: article
ms.author: mabrigg
ms.date: 11/14/2019
ms.reviewer: waltero
ms.lastreviewed: 11/14/2019

---

# Troubleshoot Kubernetes deployment to Azure Stack Hub

> [!Note]  
> Only use the Kubernetes Azure Stack Hub Marketplace item to deploy clusters as a proof-of-concept. For supported Kubernetes clusters on Azure Stack Hub, use [the AKS engine](azure-stack-kubernetes-aks-engine-overview.md).

This article reviews how to troubleshoot your Kubernetes cluster. To begin troubleshooting, review the elements required for the deployment. You might need to collect the deployment logs from Azure Stack Hub or the Linux VMs that host Kubernetes. To retrieve logs from an administrative endpoint, contact your Azure Stack Hub admin.

## Overview of Kubernetes deployment

Before you troubleshoot your cluster, review the Azure Stack Hub Kubernetes cluster deployment process. The deployment uses an Azure Resource Manager solution template to create the VMs and install the AKS-Engine for your cluster.

### Kubernetes deployment workflow

The following diagram shows the general process for deploying the cluster.

![Deploy Kubernetes process](media/azure-stack-solution-template-kubernetes-trouble/002-Kubernetes-Deploy-Flow.png)

### Deployment steps

1. Collect input parameters from the marketplace item.

    Enter the values you need to set up the Kubernetes cluster, including:
    -  **User name**: The user name for the Linux virtual machines (VMs) that are part of the Kubernetes cluster and DVM.
    -  **SSH public key**: The key that's used for the authorization of all Linux machines that were created as part of the Kubernetes cluster and DVM.
    -  **Service principal**: The ID that's used by the Kubernetes Azure cloud provider. The client ID identified as the application ID when you created your service principal. 
    -  **Client secret**: The key you created when you created your service principal.

2. Create the deployment VM and custom script extension.
    -  Create the deployment Linux VM by using the marketplace Linux image **Ubuntu Server 16.04-LTS**.
    -  Download and run the custom  script extension from the marketplace. The script is **Custom Script for Linux 2.0**.
    -  Run the DVM custom script. The script does the following tasks:
        1. Gets the gallery endpoint from the Azure Resource Manager metadata endpoint.
        2. Gets the active directory resource ID from the Azure Resource Manager metadata endpoint.
        3. Loads the API model for the AKS engine.
        4. Deploys the AKS engine to the Kubernetes cluster and saves the Azure Stack Hub cloud profile to `/etc/kubernetes/azurestackcloud.json`.
3. Create the master VMs.

4. Download and run custom script extensions.

5. Run the master script.

    The script does the following tasks:
    - Installs etcd, Docker, and Kubernetes resources such as kubelet. etcd is a distributed key value store that provides a way to store data across a cluster of machines. Docker supports bare-bones operating system-level virtualizations known as containers. Kubelet is the node agent that runs on each Kubernetes node.
    - Sets up the **etcd** service.
    - Sets up the **kubelet** service.
    - Starts kubelet. This task involves the following steps:
        1. Starts the API service.
        2. Starts the controller service.
        3. Starts the scheduler service.
6. Create agent VMs.

7. Download and run the custom script extension.

7. Run the agent script. The agent custom script does the following tasks:
    - Installs **etcd**.
    - Sets up the **kubelet** service.
    - Joins the Kubernetes cluster.

## Steps to troubleshoot Kubernetes

You can collect and review deployment logs on the VMs that support your Kubernetes cluster. Talk to your Azure Stack Hub administrator to verify the version of Azure Stack Hub that you need to use, and to get logs from Azure Stack Hub that are related to your deployment.

1. Review the error code returned by the ARM deployment in your **Deployments** pane in the resource group where you deployed the cluster. The descriptions for the error codes are in the [Troubleshooting](https://github.com/msazurestackworkloads/azurestack-gallery/blob/master/kubernetes/docs/troubleshooting.md) article in AKS Engine GitHub repository. If you can't resolve the issue with the error description, continue with these steps.
2. Review the [deployment status](#review-deployment-status) and retrieve the logs from the master node in your Kubernetes cluster.
3. Check that you're using the latest version of Azure Stack Hub. If you're unsure which version you're using, contact your Azure Stack Hub administrator.
4. Review your VM creation files. You might have had the following issues:  
    - The public key might be invalid. Review the key that you created.  
    - VM creation might have triggered an internal error or triggered a creation error. A number of factors can cause errors, including capacity limitations for your Azure Stack Hub subscription.
    - Make sure that the fully qualified domain name (FQDN) for the VM begins with a duplicate prefix.
5.  If the VM is **OK**, then evaluate the DVM. If the DVM has an error message:
    - The public key might be invalid. Review the key that you created.  
    - Contact your Azure Stack Hub administrator to retrieve the logs for Azure Stack Hub by using the privileged endpoints. For more information, see [Azure Stack Hub diagnostics tools](../operator/azure-stack-configure-on-demand-diagnostic-log-collection.md#use-the-privileged-endpoint-pep-to-collect-diagnostic-logs).
5. If you have a question about your deployment, you can post it or see if someone has already answered the question in the [Azure Stack Hub forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack). 


## Review deployment status

When you deploy your Kubernetes cluster, you can review the deployment status to check for any issues.

1. Open the [Azure Stack Hub portal](https://portal.local.azurestack.external).
2. Select **Resource groups**, and then select the name of the resource group that you used when deploying the Kubernetes cluster.
3. Select **Deployments**, and then select the **Deployment name**.

    ![Troubleshoot Kubernetes: select deployment](media/azure-stack-solution-template-kubernetes-trouble/azure-stack-kub-trouble-report.png)

4.  Consult the troubleshoot window. Each deployed resource provides the following information:
    
    | Property | Description |
    | ----     | ----        |
    | Resource | The name of the resource. |
    | Type | The resource provider and the type of resource. |
    | Status | The status of the item. |
    | TimeStamp | The UTC timestamp of the time. |
    | Operation details | The operation details such as the resource provider that was involved in the operation, the resource endpoint, and the name of the resource. |

    Each item has a status icon of green or red.

## Review deployment logs

If the Azure Stack Hub portal doesn't provide enough information for you to troubleshoot or overcome a deployment failure, the next step is to dig into the cluster logs. To manually retrieve the deployment logs, you typically need to connect to one of the cluster's master VMs. A simpler alternative approach would be to download and run the following [Bash script](https://aka.ms/AzsK8sLogCollectorScript) provided by the Azure Stack Hub team. This script connects to the DVM and cluster's VMs, collects relevant system and cluster logs, and downloads them back to your workstation.

### Prerequisites

You need a Bash prompt on the machine you use to manage Azure Stack Hub. On a Windows machine, you can get a Bash prompt by installing [Git for Windows](https://git-scm.com/downloads). Once installed, look for _Git Bash_ in your start menu.

### Retrieving the logs

Follow these steps to collect and download the cluster logs:

1. Open a Bash prompt. From a Windows machine, open _Git Bash_ or run: `C:\Program Files\Git\git-bash.exe`.

2. Download the log collector script by running the following commands in your Bash prompt:

    ```Bash  
    mkdir -p $HOME/kuberneteslogs
    cd $HOME/kuberneteslogs
    curl -O https://raw.githubusercontent.com/msazurestackworkloads/azurestack-gallery/master/diagnosis/getkuberneteslogs.sh
    chmod 744 getkuberneteslogs.sh
    ```

3. Look for the information required by the script and run it:

    | Parameter           | Description                                                                                                      | Example                                                                       |
    |---------------------|------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------|
    | -d, --vmd-host      | The public IP or the fully qualified domain name (FQDN) of the DVM. The VM name starts with `vmd-`. | IP: 192.168.102.38<br>DNS: vmd-myk8s.local.cloudapp.azurestack.external |
    | -h, --help  | Print command usage. | |
    | -i, --identity-file | Path to the RSA private key file passed to the marketplace item when creating the Kubernetes cluster. Needed to remote in to the Kubernetes nodes. | C:\data\id_rsa.pem (Putty)<br>~/.ssh/id_rsa (SSH)
    | -m, --master-host   | The public IP or the fully qualified domain name (FQDN) of a Kubernetes master node. The VM name starts with `k8s-master-`. | IP: 192.168.102.37<br>FQDN: k8s-12345.local.cloudapp.azurestack.external      |
    | -u, --user          | The user name passed to the marketplace item when creating the Kubernetes cluster. Needed to remote in to the Kubernetes nodes. | azureuser (default value) |


   When you add your parameter values, your command might look something like this example:

    ```Bash  
    ./getkuberneteslogs.sh --identity-file "C:\id_rsa.pem" --user azureuser --vmd-host 192.168.102.37
     ```

4. After a few minutes, the script will output the collected logs to a directory named `KubernetesLogs_{{time-stamp}}`. There you'll find a directory for each VM that belongs to the cluster.

    The log collector script will also look for errors in the log files and include troubleshooting steps if it finds a known issue. Make sure you're running the latest version of the script to increase chances of finding known issues.

> [!Note]  
> Check out this GitHub [repository](https://github.com/msazurestackworkloads/azurestack-gallery/tree/master/diagnosis) to learn more details about the log collector script.

## Next steps

[Deploy Kubernetes to Azure Stack Hub](azure-stack-solution-template-kubernetes-deploy.md)

[Add a Kubernetes cluster to the Marketplace (for the Azure Stack Hub operator)](../operator/azure-stack-solution-template-kubernetes-cluster-add.md)

[Kubernetes on Azure](https://docs.microsoft.com/azure/container-service/kubernetes/container-service-kubernetes-walkthrough)
