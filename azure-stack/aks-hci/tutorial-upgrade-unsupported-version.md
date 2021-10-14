---
title: Concepts - Upgrade the Azure Kubernetes Services (AKS) on Azure Stack HCI host using PowerShell
description: Learn about using PowerShell to upgrade the Azure Kubernetes Service (AKS) on Azure Stack HCI host.
ms.topic: conceptual
ms.date: 10/13/2021
ms.custom: 
ms.author: rbaziwane
author: baziwane
---

# Upgrading from an unsupported version using PowerShell

When you upgrade from an unsupported version, the main goal of the upgrade process is to ensure your management cluster is upgraded to the latest version without any interruptions. The upgrade process will be performed in a stepped fashion, automatically downloading and installing each interim version you skipped until finally your management cluster is running on the latest version. 

## Before you begin

### Update the PowerShell modules

Make sure you always have the latest PowerShell modules installed on the Azure Stack HCI or Windows Server nodes by executing the following command on all physical Azure Stack HCI nodes. 

```powershell
Update-Module -Name AksHci -Force -AcceptLicense
```

### Check for upgrade prerequisites

Run `Get-AksHciCluster` to check for prerequisites required for upgrade to succeed. The recommendations section in the output will list the actions that you must perform before you kick off upgrading your unsupported cluster. 

```powershell
PS C:\> Get-AksHciCluster | ConvertTo-Json      
```

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
                        "Recommendation":  "Workload Cluster Kubernetes Version v1.18.17 is not in the list of supported Kubernetes versions (v1.19.9 v1.19.11 v1.20.5 v1.20.7 v1.21.1 v1.21.2 v1.19.9 v1.19.11 v1.20.5 v1.20.7 v1.21.1 v1.21.2) for 1.0.4.10928. Please upgrade your target clusters to one of the kubernetes versions supported by 1.0.4.10928 to unblock"
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

In the above example, the workload cluster is still running on unsupported Kubernetes version 1.18.17. Before upgrading the cluster, I need to make sure that the target cluster is first upgraded to a supported version e.g. v1.19.x for the step upgrade to succeed. This is beacuse Kubernetes does not support skipping minor versions during upgrades. All upgrades must be performed sequentially by major version number. For example, upgrades between 1.19.x -> 1.20.x or 1.20.x -> 1.21.x are allowed, however 1.19.x -> 1.21.x is not allowed. The update process has to perform each step upgrade automatically behind the scenes.

### Upgrade workload cluster kubernetes version

See [Update Kubernetes version of your AKS workload clusters](upgrade.md)

### Initiate the cluster update

```powershell
PS C:\> Update-AksHci -Verbose
```

### Verify that management cluster is updated

```powershell
PS C:\> Get-AksHciVersion
```

The output will show the updated version of the AKS on Azure Stack HCI host.

```output
1.0.4.10928
```

## Next steps

- [Update Kubernetes version of your AKS workload clusters](upgrade.md)



<!-- LINKS - external -->


<!-- LINKS - internal -->