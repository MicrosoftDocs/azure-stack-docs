---
title: Concepts - Upgrade the Azure Kubernetes Services (AKS) on Azure Stack HCI host using PowerShell from an unsupported version
description: Learn about using PowerShell to upgrade the Azure Kubernetes Service (AKS) on Azure Stack HCI host (management cluster) from an unsupported version.
ms.topic: conceptual
ms.date: 10/13/2021
ms.custom: 
ms.author: rbaziwane
author: baziwane
---

# Upgrade AKS on Azure Stack HCI from an unsupported version using PowerShell

When you upgrade from an unsupported version of AKS on Azure Stack HCI, the main goal of the upgrade process is to ensure your management cluster (or AKS host) is upgraded to the latest version without any interruption. You perform the upgrade process using a step-by-step method where you automatically download and install each interim version you skipped until your management cluster is finally running the latest version. 

## Before you begin

Before you start the upgrade process, you should ensure you have the latest PowerShell modules installed and also check for upgrade prerequisites.

### Update the PowerShell modules

Make sure you always have the latest PowerShell modules installed on the Azure Stack HCI or Windows Server nodes by executing the following command on all physical Azure Stack HCI nodes. 

```powershell
Update-Module -Name AksHci -Force -AcceptLicense
```

### Check for upgrade prerequisites

Run [Get-AksHciCluster](./reference/ps/get-akshcicluster.md) to check for prerequisites that are required for the upgrade process to succeed. The recommendations section in the output lists the actions that you must perform before you start upgrading your unsupported cluster. 

```powershell
PS C:\> Get-AksHciCluster | ConvertTo-Json      
```

In the example below, the workload cluster is running an unsupported Kubernetes version 1.18.17. Before upgrading the cluster, the workload cluster must first be upgraded to a supported Kubernetes version (such as v1.19.x) for the step upgrade process to succeed. Kubernetes does not support skipping minor versions during upgrades, and therefore, all upgrades must be performed sequentially by major version number. For example, upgrades from 1.19.x to 1.20.x and 1.20.x to 1.21.x are allowed, however, upgrading from 1.19.x to 1.21.x is not allowed. The upgrade process has to automatically perform each step upgrade behind the scenes.

```json
{
    "1.0.4.10928":  {
                        "Comments":  "This is the LATEST Version",
                        "SupportedKubernetesVersions":  [
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.9; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.11; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.5; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.7; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.21.1; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.21.2; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.9; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.11; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.5; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.7; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.21.1; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.21.2; OS=Windows; IsPreview=False}"
                                                        ],
                        "CanUpgradeTo":  false,
                        "Version":  "1.0.4.10928",
                        "Recommendation":  "Workload Cluster Kubernetes Version v1.18.17 is not in the
                         list of supported Kubernetes versions (v1.19.9 v1.19.11 v1.20.5 v1.20.7 v1.21.
                         1 v1.21.2 v1.19.9 v1.19.11 v1.20.5 v1.20.7 v1.21.1 v1.21.2) for 1.0.4.10928. 
                         Please upgrade your target clusters to one of the kubernetes versions 
                         supported by 1.0.4.10928 to unblock"
                    },
    "1.0.3.10901":  {
                        "SupportedKubernetesVersions":  [
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.9; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.11; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.5; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.7; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.21.1; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.21.2; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.9; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.11; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.5; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.7; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.21.1; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.21.2; OS=Windows; IsPreview=False}"
                                                        ],
                        "CanUpgradeTo":  false,
                        "Version":  "1.0.3.10901"
                    },
    "1.0.2.10723":  {
                        "SupportedKubernetesVersions":  [
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.9; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.11; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.5; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.7; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.21.1; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.9; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.11; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.5; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.7; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.21.1; OS=Windows; IsPreview=False}"
                                                        ],
                        "CanUpgradeTo":  false,
                        "Version":  "1.0.2.10723"
                    },
    "1.0.1.10628":  {
                        "Comments":  "This is your CURRENT Version",
                        "SupportedKubernetesVersions":  [
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.18.14; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.18.17; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.7; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.9; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.2; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.5; OS=Linux; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.18.14; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.18.17; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.7; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.19.9; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.2; OS=Windows; IsPreview=False}",
                                                            "@{OrchestratorType=Kubernetes; OrchestratorVersion=v1.20.5; OS=Windows; IsPreview=False}"
                                                        ],
                        "CanUpgradeTo":  false,
                        "Version":  "1.0.1.10628"
                    }
}
```

## Upgrade the management cluster

Follow the steps below to upgrade the management cluster:

1. First, you need to [upgrade the Kubernetes version of the workload cluster](upgrade.md).

2. To initiate the management cluster upgrade, run the following command:

   ```powershell
   PS C:\> Update-AksHci -Verbose
   ```

3. To verify that the management cluster is updated, run the following command:

   ```powershell
   PS C:\> Get-AksHciVersion
   ```

   The output shows the updated version of the management cluster.

   ```output
   1.0.4.10928
   ```

## Next steps

In this article, you learned how to update AKS workload clusters on Azure Stack HCI. Next, you can:
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).

<!-- LINKS - external -->


<!-- LINKS - internal -->