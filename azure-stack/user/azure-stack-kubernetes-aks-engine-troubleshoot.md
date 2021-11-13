---
title: Troubleshoot the AKS engine on Azure Stack Hub 
description: This article contains troubleshooting steps for the AKS engine on Azure Stack Hub. 
author: mattbriggs

ms.topic: article
ms.date: 11/12/2020
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 10/07/2020

# Intent: As as an Azure STack Hub developer, I want to fix the AKS engine so that can my cluster without incident.
# Keyword: Azure Stack Hub AKS engine error codes

---

# Troubleshoot the AKS engine on Azure Stack Hub

You may find an issue when deploying or working with the AKS engine on Azure Stack Hub. This article looks at the steps to troubleshoot your deployment of the AKS engine. Collect information about your AKS engine, collect Kubernetes logs, and review custom script extension error codes. You can also open a GitHub issue for the AKS engine.

## Troubleshoot the AKS engine install

### Collect Node and Cluster Logs

You can find the instructions on collecting node and cluster logs at [Retrieving Node and Cluster Logs](https://github.com/Azure/aks-engine/blob/master/docs/topics/get-logs.md).

### Prerequisites

This guide assumes you've already downloaded the [Azure CLI](azure-stack-version-profiles-azurecli2.md) and the [AKS engine](azure-stack-kubernetes-aks-engine-overview.md).

This guide also assumes that you've deployed a cluster using the AKS engine. For more information, see [Deploy a Kubernetes cluster with the AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-cluster.md) .

### Retrieving Logs

The `aks-engine get-logs` command can be useful to troubleshoot issues with your cluster. The command produces, collects, and downloads a set of files to your workstation. The files include node configuration, cluster state and configuration, and create log files.

At a high level: the command works by establishing an SSH session into each node, executing a log collection script that collects and zips relevant files, and downloading the zip file to your local computer.

### SSH Authentication

You will need a  valid SSH private key to establish an SSH session to the cluster Linux nodes. Windows credentials are stored in the API model and will be loaded from there. Set `windowsprofile.sshEnabled` to true to enable SSH in your Windows nodes.

### Upload logs to a Storage Account Container

Once the cluster logs were successfully retrieved, AKS Engine can save them on an Azure Storage Account container if optional parameter --storage-container-sas-url is set. AKS Engine expects the container name to be part of the provided [SAS URL](/azure/storage/common/storage-sas-overview). The expected format is `https://{blob-service-uri}/{container-name}?{sas-token}`.

> [NOTE!]  
> Storage accounts on custom clouds using the AD FS identity provider are not yet supported.

### Nodes unable to join the cluster

By default, `aks-engine get-logs` collects logs from nodes that successfully joined the cluster. To collect logs from VMs that were not able to join the cluster, set flag `--vm-names`:

```bash
--vm-name k8s-pool-01,k8s-pool-02
```

## Usage

Assuming that you have a cluster deployed and the API model originally used to deploy that cluster is stored at `_output/<dnsPrefix>/apimodel.json`, then you can collect logs running a command like:

```bash
aks-engine get-logs \
    --location <location> \
    --api-model _output/<dnsPrefix>/apimodel.json \
    --ssh-host <dnsPrefix>.<location>.cloudapp.azure.com \
    --linux-ssh-private-key ~/.ssh/id_rsa \
    --linux-script scripts/collect-logs.sh \
    --windows-script scripts/collect-windows-logs.ps1
```

### Parameters

| **Parameter**                | **Required** | **Description**                                                                                                                                                |
|------------------------------|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| --location                   | Yes          | Azure location of the cluster's resource group.                                                                                                                |
| --api-model                  | Yes          | Path to the generated API model for the cluster.                                                                                                               |
| --ssh-host                   | Yes          | FQDN, or IP address, of an SSH listener that can reach all nodes in the cluster.                                                                               |
| --windows-script             | No           | Custom log collection PowerShell script. Required only when the Windows node distribution is not `aks-windows`. The script should produce file `%TEMP%\\{NodeName}.zip`. |
| --output-directory           | No           | Output directory, derived from `--api-model` if missing.                                                                                                         |
| --control-plane-only         | No           | Only collect logs from control plane nodes.                                                                                                                           |
| --vm-names                   | No           | Only collect logs from the specified VMs (comma-separated names).                                                                                              |
| --upload-sas-url             | No           | Azure Storage Account SAS URL to upload the collected logs.                                                                                                    |
| --storage-container-sas-url  | No           | Storage account SAS URL with corresponding container name. AKS will store the logs in this storage account's container.                                        |

## Review custom script extension error codes

You can consult a list of error codes created by the custom script extension (CSE) in running your cluster. The CSE error can be useful in diagnosing the root cause of the problem. The CSE for the Ubuntu server used in your Kubernetes cluster supports many of the AKS engine operations. For more information about the CSE exit codes, see [`cse_helpers.sh`](https://github.com/Azure/aks-engine/blob/master/pkg/engine/cse.go).

## Providing Kubernetes logs to a Microsoft support engineer

If after collecting and examining logs you still cannot resolve your issue, you may want to start the process of creating a support ticket and provide the logs that you collected by running `getkuberneteslogs.sh` with the `--upload-logs` parameter set.

Contact your Azure Stack Hub operator. Your operator uses the information from your logs to create the support case.

While addressing any support issues, a Microsoft support engineer may request that your Azure Stack Hub operator collect the Azure Stack Hub system logs. You may need to provide your operator with the storage account information where you uploaded the Kubernetes logs by running `getkuberneteslogs.sh`.

Your operator may run the **Get-AzureStackLog** PowerShell cmdlet. This command uses a parameter (`-InputSaSUri`) that specifies the storage account where you stored the Kubernetes logs.

Your operator may combine the logs you produced along with other system logs that may be needed by Microsoft support. The operator may make them available to the Microsoft.

## Open GitHub issues

If you are unable to resolve your deployment error, you can open a GitHub Issue.

1.  Open a [GitHub Issue](https://github.com/Azure/aks-engine/issues/new) in the AKS engine repository.

2.  Add a title using the following format: CSE error: `exit code \<INSERT_YOUR_EXIT_CODE\>`.

3.  Include the following information in the issue:

    -   The cluster configuration file, `apimodel json`, used to deploy the cluster. Remove all secrets and keys before posting it on GitHub.

    -   The output of the following **kubectl** command get nodes.

    -   The content of` /var/log/azure/cluster-provision.log` and `/var/log/cloud-init-output.log`

## Next steps

-   Read about the [AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview).
