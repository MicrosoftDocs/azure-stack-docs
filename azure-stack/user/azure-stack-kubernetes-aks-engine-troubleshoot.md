---
title: Troubleshoot the AKS engine on Azure Stack Hub 
description: This article contains troubleshooting steps for the AKS engine on Azure Stack Hub. 
author: mattbriggs

ms.topic: article
ms.date: 11/18/2020
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 11/18/2020

# Intent: As as an Azure Stack Hub developer, I want to fix the AKS engine so that can my cluster without incident.
# Keyword: Azure Stack Hub AKS engine error codes

---

# Troubleshoot the AKS engine on Azure Stack Hub

You may find an issue when deploying or working with the AKS engine on Azure Stack Hub. This article looks at the steps to troubleshoot your deployment of the AKS engine. Collect information about your AKS engine, collect Kubernetes logs, and review custom script extension error codes. You can also open a GitHub issue for the AKS engine.

## Troubleshoot the AKS engine install

If your previous installation steps failed, you can install the AKS engine using the GoFish package manager. [GoFish](https://gofi.sh) describes itself as a cross-platform Homebrew.

You can find instructions for using GoFish to install the AKS engine at [Install the aks-engine command line tool](https://github.com/Azure/aks-engine/blob/master/docs/tutorials/quickstart.md#install-the-aks-engine-command-line-tool)

## Collect node and cluster logs

You can find the instructions on collecting node and cluster logs at [Retrieving Node and Cluster Logs](https://github.com/Azure/aks-engine/blob/master/docs/topics/get-logs.md).

### Prerequisites

This guide assumes you've already downloaded the [Azure CLI](azure-stack-version-profiles-azurecli2.md) and the [AKS engine](azure-stack-kubernetes-aks-engine-overview.md).

This guide also assumes that you've deployed a cluster using the AKS engine. For more information, see [Deploy a Kubernetes cluster with the AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-cluster.md) .

### Retrieving logs

The `aks-engine get-logs` command can be useful to troubleshoot issues with your cluster. The command produces, collects, and downloads a set of files to your workstation. The files include node configuration, cluster state and configuration, and set up log files. 

At a high level: the command works by establishing an SSH session into each node, executing a log collection script that collects and zips relevant files, and downloading the .ZIP file to your local computer.

### SSH authentication

You will need a  valid SSH private key to establish an SSH session to the cluster Linux nodes. Windows credentials are stored in the API model and will be loaded from there. Set `windowsprofile.sshEnabled` to true to enable SSH in your Windows nodes.

### Upload logs to a storage account container

Once the cluster logs were successfully retrieved, AKS Engine can save them on an Azure Storage Account container if optional parameter `--upload-sas-url` is set. AKS Engine expects the container name to be part of the provided [SAS URL](/azure/storage/common/storage-sas-overview). The expected format is `https://{blob-service-uri}/{container-name}?{sas-token}`.

> [!NOTE]  
> Storage accounts on custom clouds using the AD FS identity provider are not yet supported.

### Nodes unable to join the cluster

By default, `aks-engine get-logs` collects logs from nodes that successfully joined the cluster. To collect logs from VMs that were not able to join the cluster, set flag `--vm-names`:

```bash
--vm-name k8s-pool-01,k8s-pool-02
```

### Usage for aks-engine get-logs

Assuming that you have a cluster deployed and the API model originally used to deploy that cluster is stored at `_output/<dnsPrefix>/apimodel.json`, then you can collect logs running a command like:

```bash
aks-engine get-logs \
    --location <location> \
    --api-model _output/<dnsPrefix>/apimodel.json \
    --ssh-host <dnsPrefix>.<location>.cloudapp.azure.com \
    --linux-ssh-private-key ~/.ssh/id_rsa
```

### Parameters

| **Parameter**                | **Required** | **Description**                                                                                                                                                |
|------------------------------|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| --location                   | Yes          | Azure location of the cluster's resource group.                                                                                                                |
| --api-model                  | Yes          | Path to the generated API model for the cluster.                                                                                                               |
| --ssh-host                   | Yes          | FQDN, or IP address, of an SSH listener that can reach all nodes in the cluster.                                                                               |
| --linux-ssh-private-key | Yes           | Path to a SSH private key that can be use to create a remote session on the cluster Linux nodes. |
| --output-directory           | No           | Output directory, derived from `--api-model` if missing.                                                                                                         |
| --control-plane-only         | No           | Only collect logs from control plane nodes.                                                                                                                           |
| --vm-names                   | No           | Only collect logs from the specified VMs (comma-separated names).                                                                                              |
| --upload-sas-url             | No           | Azure Storage Account SAS URL to upload the collected logs.                                                                                                    |
| --storage-container-sas-url  | No           | Storage account SAS URL with corresponding container name. AKS will store the logs in this storage account's container.                                        |


## Review custom script extension error codes

The AKS engine produces a script for each Ubuntu Server as a resource for the custom script extension (CSE) to perform deployment tasks. If the script throws an error it will log an error in /var/log/azure/cluster-provision.log. The errors are displayed in the portal. The error code may be helpful in figuring out the case of the problem. For more information about the CSE exit codes, see [`cse_helpers.sh`](https://github.com/Azure/aks-engine/blob/master/pkg/engine/cse.go).

## Providing Kubernetes logs to a Microsoft support engineer

If after collecting and examining logs you still cannot resolve your issue, you may want to start the process of creating a support ticket and provide the logs that you collected.

Your operator may combine the logs you produced along with other system logs that may be needed by Microsoft support. The operator may make them available to the Microsoft.

You can provide Kubernetes logs in several ways:
- You can contact your Azure Stack Hub operator. Your operator uses the information from the logs stored in the .ZIP file to create the support case.
- If you have the SAS URL for a storage account where you can upload your Kubernetes logs, you can include the following command and flag with the SAS URL to save the logs to the storage account: 
    ```Bash  
    aks-engine get-logs -upload-sas-url <SAS-URL>
    ```
    For instructions, see [Upload logs to a storage account container](#upload-logs-to-a-storage-account-container).
- If you're a cloud operator, you can:
    - Use the **Help + support** blade in the Azure Stack Hub Administration portal to upload logs. For instructions, see [Send logs now with the administrator portal](/azure-stack/operator/diagnostic-log-collection#send-logs-now-with-the-administrator-portal).
    -  Use the **Get-AzureStackLog** PowerShell cmdlet using the Privileged End Point (PEP) For instruction, see [Send logs now with PowerShell](/azure-stack/operator/diagnostic-log-collection#send-logs-now-with-powershell).
## Open GitHub issues

If you are unable to resolve your deployment error, you can open a GitHub Issue.

1.  Open a [GitHub Issue](https://github.com/Azure/aks-engine/issues/new) in the AKS engine repository.

2.  Add a title using the following format: CSE error: `exit code <INSERT_YOUR_EXIT_CODE>`.

3.  Include the following information in the issue:

    -   The cluster configuration file, `apimodel.json`, used to deploy the cluster. Remove all secrets and keys before posting it on GitHub.

    -   The output of the following **kubectl** command `get nodes`.

    -   The content of `/var/log/azure/cluster-provision.log` from an unhealthy node.

## Next steps

-   Read about the [AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md).
