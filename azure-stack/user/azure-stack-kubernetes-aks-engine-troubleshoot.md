---
title: Troubleshoot the AKS Engine on Azure Stack | Microsoft Docs
description: This article contains troubleshooting steps for the AKS Engine on Azure Stack. 
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femilav
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na (Kubernetes)
ms.devlang: nav
ms.topic: article
ms.date: 10/28/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 10/28/2019

---

# Troubleshoot the AKS Engine on Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You may encounter an issue when deploying or working with the AKS Engine on Azure Stack. This article looks at the steps to troubleshoot your deployment of the AKS Engine, collect information about your AKS Engine, collect Kubernetes logs, review custom script extension error codes, and instructions on opening a GitHub issue for the AKS Engine.

> [!IMPORTANT]
> The AKS Engine is currently in public preview.
> This preview version is provided without a service level agreement, and it's not recommended for production workloads. Certain features might not be supported or might have constrained capabilities. 
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Troubleshoot the AKS Engine install

### Try GoFish

If your previous installation steps failed, you can install the AKS Engine using the GoFish package manager. [GoFish](https://gofi.sh) describes itself as a cross-platform Homebrew.

#### Install the AKS Engine with GoFish on Linux

Install GoFish from the [Install](https://gofi.sh/#install) page.

1. From a bash prompt, run the following command:

    ```bash
    curl -fsSL https://raw.githubusercontent.com/fishworks/gofish/master/scripts/install.sh | bash
    ```

2.  Run the following command to install the AKS Engine with GoFish:

    ```bash
    Run "gofish install aks-engine"
    ```

#### Install the AKS Engine with GoFish on Windows

Install GoFish from the [Install](https://gofi.sh/#install) page.

1. From an elevated PowerShell prompt, run the following command:

    ```PowerShell
    Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/fishworks/gofish/master/scripts/install.ps1'))
    ```

2.  Run the following command in the same session to install the AKS Engine with GoFish:

    ```PowerShell
    gofish install aks-engine
    ```

### Checklist for common deployment issues

When encountering errors while deploying a Kubernetes cluster using the AKS Engine, you can check:

1.  Are you using the correct Service Principal credentials (SPN)?
2.  Does the SPN have a "Contributors" role to the Azure Stack subscription?
3. Do you have a large enough quota in your Azure Stack plan?
4.  Is the Azure Stack instance having a patch or upgrade being applied?

For more information, see the [Troubleshooting](https://github.com/Azure/aks-engine/blob/master/docs/howto/troubleshooting.md) article in the **Azure/aks-engine** GitHub repo.

## Collect AKS Engine logs

You can access review information created by the AKS engine. The AKS Engine reports status,  and errors as the application runs. You can either pipe the output to a text file or copy it directly from the command-line console. Refer to a list of error codes triggered by the AKS Engine at [Review custom script extension error codes](#review-custom-script-extension-error-codes).

1.  Gather standard output and error from information displayed in the AKS Engine command-line tool.

2. Get logs from a local file. You can set the output directory with the **--output-directory** parameter.

    To set the local path for the logs:

    ```bash  
    aks-engine --output-directory <path to the directory>
    ```

## Collect Kubernetes logs

In addition to the AKS Engine logs, the Kubernetes components generate status  and error messages. You can collect these logs using the Bash script, [getkuberneteslogs.sh](https://github.com/msazurestackworkloads/azurestack-gallery/releases/download/diagnosis-v0.1.0/diagnosis.zip).

This script automates the process of gathering the following logs: 

 - Microsoft Azure Linux Agent (waagent) logs
 - Custom Script Extension logs
 - Running kube-system container metadata
 - Running kube-system container logs
 - Kubelet service status and journal
 - Etcd service status and journal
 - Gallery item's DVM logs
 - kube-system Snapshot

Without this script, you would need to connect to each node in the cluster locate and download the logs manually. In addition, the script can, optionally, upload the collected logs to a storage account that you can use to share the logs with others.

Requirements:

 - A Linux VM, Git Bash or Bash on Windows.
 - [Azure CLI](azure-stack-version-profiles-azurecli2.md) installed in the machine from where the script will be run.
 - Service principal identity signed into an Azure CLI session to Azure Stack. Since the script has the capability of discovering and creating ARM resources to do its work, it requires the Azure CLI and a service principal identity.
 - User account (subscription) where the Kubernetes cluster is already selected in the environment. 
1. Download the latest release of the script tar file into your client VM, a machine that has access to your Kubernetes cluster or the same machine you used to deploy your cluster with the AKS engine.

    Run the following commands:

    ```bash  
    mkdir -p $HOME/kuberneteslogs
    cd $HOME/kuberneteslogs
    wget https://github.com/msazurestackworkloads/azurestack-gallery/releases/download/diagnosis-v0.1.1/diagnosis-v0.1.1.tar.gz
    tar xvf diagnosis-v0.1.1.tar.gz -C ./
    ```

2. Look for the parameters required by the `getkuberneteslogs.sh` script. The script will use the following parameters:

    | Parameter | Description | Required | Example |
    | --- | --- | --- | --- |
    | -h, --help | Print command usage. | no | 
    -u,--user | The administrator username for the cluster VMs | yes | azureuser<br>(default value) |
    | -i, --identity-file | RSA private key tied to the public key used to create the Kubernetes cluster (sometimes named 'id_rsa')  | yes | `./rsa.pem` (Putty)<br>`~/.ssh/id_rsa` (SSH) |
    |   -g, --resource-group    | Kubernetes cluster resource group | yes | k8sresourcegroup |
    |   -n, --user-namespace               | Collect logs from containers in the specified namespaces (kube-system logs are always collected) | no |   monitoring |
    |       --api-model                    | Persists apimodel.json file in an Azure Stack Storage account. Upload apimodel.json file to storage account happens when --upload-logs parameter is also provided. | no | `./apimodel.json` |
    | --all-namespaces               | Collect logs from containers in all namespaces. It overrides --user-namespace | no | |
    | --upload-logs                  | Persists retrieved logs in an Azure Stack storage account. Logs can be found in KubernetesLogs resource group | no | |
    --disable-host-key-checking    | Sets SSH's StrictHostKeyChecking option to "no" while the script executes. Only use in a safe environment. | no | |

3. Run any of the following example commands with your information:

    ```bash
    ./getkuberneteslogs.sh -u azureuser -i private.key.1.pem -g k8s-rg
    ./getkuberneteslogs.sh -u azureuser -i ~/.ssh/id_rsa -g k8s-rg --disable-host-key-checking
    ./getkuberneteslogs.sh -u azureuser -i ~/.ssh/id_rsa -g k8s-rg -n default -n monitoring
    ./getkuberneteslogs.sh -u azureuser -i ~/.ssh/id_rsa -g k8s-rg --upload-logs --api-model clusterDefinition.json
    ./getkuberneteslogs.sh -u azureuser -i ~/.ssh/id_rsa -g k8s-rg --upload-logs
    ```

## Review custom script extension error codes

You can consult a list of error codes created by the custom script extension (CSE) in running your cluster. The CSE error can be useful in diagnosing the root cause of the problem. The CSE for the Ubuntu server used in your Kubernetes cluster supports many of the AKS Engine operations. For more information about the CSE exit codes, see [cse_helpers.sh](https://github.com/Azure/aks-engine/blob/master/parts/k8s/cloud-init/artifacts/cse_helpers.sh).

### Providing Kubernetes logs to a Microsoft support engineer

If after collecting and examining logs you still cannot resolve your issue, you may want to start the process of creating a support ticket and provide the logs that you collected by running `getkuberneteslogs.sh` with the `--upload-logs` parameter set. 

Contact your Azure Stack operator. Your operator uses the information fro your logs to create the support case.

During the process of addressing any support issues, a Microsoft support engineer may request that your Azure Stack operator collect the Azure Stack system logs. You may need to provide your operator with the storage account information where you uploaded the Kubernetes logs by running `getkuberneteslogs.sh`.

Your operator may run the **Get-AzureStackLog** PowerShell cmdlet. This command uses a parameter (`-InputSaSUri`) that specifies the storage account where you stored the Kubernetes logs.

Your operator may combine the logs you produced along with whatever other system logs may be needed by Microsoft support and make them available to the Microsoft.

## Open GitHub issues

If you are unable to resolve your deployment error, you can open a GitHub Issue. 

1. Open a [GitHub Issue](https://github.com/Azure/aks-engine/issues/new) in the AKS Engine repository.
2. Add a title using the following format: C`SE error: exit code <INSERT_YOUR_EXIT_CODE>`.
3. Include the following information in the issue:

    - The cluster configuration file, `apimodel json`, used to deploy the cluster. Remove all secrets and keys before posting it on GitHub.  
     - The output of the following **kubectl** command `get nodes`.  
     - The content of `/var/log/azure/cluster-provision.log` and `/var/log/cloud-init-output.log`

## Next steps

- Read about the [The AKS Engine on Azure Stack](azure-stack-kubernetes-aks-engine-overview.md)
