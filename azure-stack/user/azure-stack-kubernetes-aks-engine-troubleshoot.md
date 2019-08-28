---
title: Troubleshoot the AKS Engine on Azure Stack | Microsoft Docs
description: Description
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na (Kubernetes)
ms.devlang: nav
ms.topic: article
ms.date: 08/30/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 08/30/2019

---

# Troubleshoot the AKS Engine on Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You may encounter an issue when deploying or working with the AKS Engine on Azure Stack. This article looks at the steps to troubleshoot your deployment of the AKS Engine, collect information about your AKS Engine, collect Kubernetes logs, review custom script extension error codes, and instructions on opening a GitHub issue for the AKS Engine.

## Troubleshoot AKS engine install

### Try GoFish

If the installation steps in failed, you try to install using the GoFish package manager. [GoFish](https://gofi.sh) describes itself as a cross-platform Homebrew.

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

You can access information from information created by the AKS engine. The AKS Engine reports status, issues, and errors as the application runs.  You can either pipe the output to a text file or copy it directly from the command-line console.

1.  Gather standard output and error from information displayed in the AKS Engine command-line tool.

2. Get logs from a local file. You can set the output directory with the **--output-directory** parameter.

    To set the local path for the logs:

    ```bash  
    aks-engine --output-directory <path to the directory>
    ```

## Collect Kubernetes logs

In addition to the AKS Engine logs, the Kubernetes components generate status, issues, and error messages. You can collect these logs using the` getkuberneteslogs.sh` script.

1. Download the script into your client VM, the machine that has access to your Kubernetes cluster, and likely the same machine you used to deploy your cluster with the AKS engine.

    Run the following commands:

    ```bash
    mkdir -p $HOME/kuberneteslogs
    cd $HOME/kuberneteslogs
    curl -O https://raw.githubusercontent.com/msazurestackworkloads/azurestack-gallery/master/diagnosis/getkuberneteslogs.sh
    chmod 744 getkuberneteslogs.sh

    ```

2.  Look for the information required by the script. The script will use the following parameters:

    | Parameter | Description | Example  |
    | --- | --- | ---  |
    | -h, --help | Print command usage. |
    | -i, --identity-file | Path to the RSA private key file passed to the marketplace item when creating the Kubernetes cluster. Needed to remote in to the Kubernetes nodes. | C:\data\id_rsa.pem (Putty)~/.ssh/id_rsa (SSH)  |
    | -m, --master-host | The public IP or the fully qualified domain name (FQDN) of a Kubernetes master node. The VM name starts with k8s-master-. | IP: 192.168.102.37<br>FQDN: k8s-12345.local.cloudapp.azurestack.external |
    | -u,--user | The user name passed to the marketplace item when creating the Kubernetes cluster. Needed to remote in to the Kubernetes nodes. | azureuser (default value)  |

3.  Run the following commands with your information:

    ```bash
    ./getkuberneteslogs.sh --identity-file "C:\id_rsa.pem" --user azureuser -- master-host 192.168.102.37
    ```

## Review custom script extension error codes

You can consult a list of error codes created by the custom script extension (CSE) in running your cluster. The CSE error can be useful in diagnosing the root cause of the problem. The CSE for the Ubuntu server used in your Kubernetes cluster supports many of the AKS Engine operations. For more information about the CSE exit codes, see [cse_helpers.sh](https://github.com/Azure/aks-engine/blob/master/parts/k8s/cloud-init/artifacts/cse_helpers.sh).

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
