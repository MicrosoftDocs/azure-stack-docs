---
title: Use containerd for Windows nodes in Azure Kubernetes Service on Azure Stack HCI
description: Use containerd as the container runtime for Windows Server node pools on Azure Kubernetes Service on Azure Stack HCI.
author: mattbriggs
ms.topic: how-to
ms.date: 03/07/2022
ms.lastreviewed: 03/07/2022
ms.reviewer: crwilhit

# Intent: As a < type of user >, I want < what? > so that < why? >.
# Keyword: containerd Windows AKS HCI

---

# Use containerd for Windows nodes in Azure Kubernetes Service on Azure Stack HCI

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022 Datacenter, Windows Server 2019 Datacenter

Beginning in Kubernetes version v1.22.1, you can use `containerd` as the container runtime for Windows Server node pools. The use of the `containerd` runtime for Windows on AKS on Azure Stack Hub is currently in **preview**. While dockershim remains the default runtime for now, it's deprecated and will be removed in Kubernetes v1.24.

> [!IMPORTANT]  
> The `containerd` runtime for Windows on AKS on Azure Stack Hub is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Prerequisites

Verify you have the following requirements ready:

- You've prepared your machine [for deployment](https://docs.microsoft.com/en-us/azure-stack/aks-hci/prestage-cluster-service-host-create#step-2-prepare-your-machines-for-deployment)
- You have the [AksHci PowerShell module](./kubernetes-walkthrough-powershell.md#install-the-akshci-powershell-module) installed.
- You can run commands in this article from an elevated PowerShell session.

<!-- 4. H2s 
Required. A how-to article explains how to do a task. The bulk of each H2 should be 
a procedure.
-->

## Set the AKS-HCI configuration

Before your deploy your AKS cluster on Azure Stack Hub HCI, set the cluster to be deployed with the `containerd` runtime for Windows nodes. To set the runtime to `containerd`, you'll use the **Set-AksHciConfig** PowerShell cmdlet with the `-ring wincontainerd` and `-catalog aks-hci-stable-catalogs-ext` flags.

1. Run Windows PowerShell as an Administrator.
1. You'll need the following parameters to run the **[Set-AksHciConfig](./reference/ps/set-akshciconfig.md)** cmdlet:
    1. **workingDir**  
        This is a working directory for the module to use for storing small files. for example: c:\ClusterStorage\Volume1\workingDir
    1. **cloudConfigLocation** `this wasn't in your example?`
        The location where the cloud agent will store its configuration. 
    1. **Version**  
        The version of Azure Kubernetes Service on Azure Stack HCI that you want to deploy. 
    1. **vnet**
        The name of the **AksHciNetworkSetting** object created with **New-AksHciNetworkSetting** command.
    1. **imageDir**  
        The path to the directory where Azure Kubernetes Service on Azure Stack HCI will store its VHD images.
1. Run the following cmdlet:
    ```powershell
    Set-AksHciConfig -workingDir $workingDir -Version $version -vnet $vnet -imageDir $imageStore -skipHostLimitChecks -ring wincontainerd -catalog aks-hci-stable-catalogs-ext
    ```

## Deploy an AKS-HCI cluster

Deploy your AKS-HCI cluster.
1. Run Windows PowerShell as an Administrator on any node in your Azure Stack HCI cluster.
1. Run the following cmdlet:
    ```PowerShell
    Install-AksHCI $VerbosePreference = "Continue"
    ```
1. Verify that `containerd` is the container runtime with kubectl. Run the following command from a PowerShell or bash prompt:
    ```PowerShell
    kubectl get nodes -owide
    ```
    Kubectl returns the nodes for your cluster. For example:
    ```output
    PS C:\Users\azureuser> kubectl get nodes -o 
    NAME                                STATUS   ROLES                  AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION    CONTAINER-RUNTIME
    moc-llnr3iekoz5                     Ready    control-plane,master   21m     v1.22.2   192.168.0.5   <none>        CBL-Mariner/Linux                5.10.78.1-2.cm1   containerd://1.4.4
    moc-wh4rlkcxn1n                     Ready    <none>                 4m38s   v1.22.2   192.168.0.6   <none>        Windows Server 2019 Datacenter   10.0.17763.2565   containerd://1.6.0-beta.3-82-ga95a8b8ff+azure
    ```
1. Verify your runtime is `containerd` in the `container-runtime` column.

## Known issues

You may encounter the following issues when using `containerd` on AKS on Azure Stack HCI.

### Issues accessing SMB shares from a pod configured with GMSA
When a Windows pod is configured with GMSA and the runtime is `containerd`, pods sometimes have difficulty accessing SMB shares. If this occurs, you can work around this by opening an administrator terminal on the target node and run the following:

```powershell  
reg add "HKLM\SYSTEM\CurrentControlSet\Services\hns\State" /v EnableCompartmentNamespace /t REG_DWORD /d 1
```

Reboot the node after setting this reg key in order to apply the change.

## Next steps

- [Deploy .NET applications](https://docs.microsoft.com/en-us/azure-stack/aks-hci/deploy-windows-application).
- [Monitor AKS on Azure Stack HCI clusters](https://docs.microsoft.com/en-us/azure-stack/aks-hci/monitor-logging).