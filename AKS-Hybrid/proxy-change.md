---
title: Update noProxy settings, certificates in Azure Kubernetes Service on AKS hybrid
description: Learn how to update proxy settings and certificates in Azure Kubernetes Service (AKS) on Azure Stack HCI or AKS on Windows Server.
ms.topic: how-to
ms.date: 01/05/2023
ms.author: sethm
ms.lastreviewed: 05/31/2022
ms.reviewer: abha
author: sethmanheim

# Intent: As an IT Pro, I want to learn how to update the proxy settings.
# Keyword: noproxy proxy settings certificate updates

---

# Update proxy settings in AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

In this article, learn how to update the proxy settings of your AKS hybrid deployment. Each AKS deployment has a single global proxy configuration. You can add exclusions using the `noProxy` parameter and update proxy certificates for the deployment, but you can't change HTTP or HTTPS settings.

## Current limitations

Before you begin, review current limitations to proxy setting updates in AKS hybrid:

- AKS hybrid supports one global proxy configuration per AKS hybrid deployment. When you update the proxy settings, they're updated for the entire AKS hybrid deployment.

- You can only update `noProxy` settings and proxy certificates. HTTP and HTTPs proxy settings can't be updated.

- You can't configure different proxy settings for a specific node pool or workload cluster.

- You can't update proxy settings for a specific node pool or workload cluster.

- **Updates to proxy settings are only applied after you update your entire AKS deployment.** You must update the AKS host management cluster and all AKS hybrid workload clusters. To check whether an update is available, use the AKS PowerShell module cmdlet [Get-AksHciClusterUpdates](reference/ps/get-akshciclusterupdates.md).

## Prerequisites

To update proxy settings for an AKS deployment, you must meet the following prerequisites:

* Your AKS deployment must be running the [October build](https://github.com/Azure/aks-hybrid/releases/tag/AKS-hybrid-2210) or later.

* The latest version of the AksHci PowerShell module must be installed. For more information, see [Install the AksHci PowerShell module](kubernetes-walkthrough-powershell.md#install-the-akshci-powershell-module).

* At least one update must be available for your AKS deployment. To check whether an update is available, use the [`Get-AksHciClusterUpdates`](/azure-stack/aks-hci/reference/ps/get-akshciclusterupdates) command in the AksHci PowerShell module.

## Update proxy settings (noproxy, proxy certificates) for AKS deployment

<!--Their first step is to make a list of URLs to ecxclude from the proxy server? What URLs might the list include? An example list might be helfpul.-->

Before you update your `noProxy` settings, review the [proxy exclusion table](https://learn.microsoft.com/en-us/azure/aks/hybrid/set-proxy-settings#exclusion-list-for-excluding-private-subnets-from-being-sent-to-the-proxy) to make sure you exclude the right URLs for your AKS hybrid deployment to function. Not excluding these URLs may cause failures in your AKS hybrid deployment.

Once you review the proxy exclusion table, store the updated noProxy URL list in a PowerShell variable:

```powershell  
$noProxy = "localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.contoso.com"
```

You can also update your proxy certificate bundle. To learn more about how to update certificates, read [update certificate bundle for your AKS hyrbid deployment](https://learn.microsoft.com/en-us/azure/aks/hybrid/update-certificate-bundle#certificate-format).

- Specify the certificates in a single .crt file in PEM format. This format is applicable for updating certificates on Linux container hosts.<!--Link to PEM format info.-->

- It's important to add the certificates to a single .crt file in this order: leaf certificate > intermediate certificate > root certificate. For example, `<.leaf.crt>`, `<intermediate.crt>`, `<root.crt>`.

- The contents of the certificate file aren't validated. Check carefully to make sure the file contains the right certificates and is in the correct format.

Create a single certificate bundle for Linux hosts, and store your changes in a PowerShell variable.

```bash
cat [leaf].crt  [intermediate].crt [Root].crt >  [your single cert file].crt
```

```powershell
$certFile ="/../[bundle].crt" # path to the bundled .crt file
```

### Update proxy settings

Before you update the proxy changes, confirm that your PowerShell variables have the right changes.

```PowerShell
echo $noProxy
echo $certFile
```

To update both the certificates and your proxy settings, run the following command:

```PowerShell
Set-AksHciProxySetting -noProxy $noProxy -certFile $certFile
```

### Apply updated global proxy settings to your AKS hybrid deployment

Check whether an update is available for your AKS host management cluster by running the following command:

```powershell  
Get-AksHciUpdates
```

If an update is available, run the following command to update your AKS host management cluster. When you run this command, the proxy changes are applied on your AKS host management cluster.

```powershell  
Update-AksHci
```

Next, update all the workload clusters in your AKS hybrid deployment. Proxy changes won't be applied unless you update your workload clusters. 

To check whether workload cluster updates are available, run the following command on each of your AKS workload clusters:

```powershell  
Get-AksHciClusterUpdates -name mycluster
```

If an update is available (either a Kubernetes version or an operating system (OS) image), update your workload clusters one by one by running `Update-AksHciCluster`. Be aware that the following command also updates the Kubernetes version of your AKS workload cluster.

To update the Kubernetes version and OS version on a workload cluster, run the following command:

```powershell  
Update-AksHciCluster -name mycluster
```

If you don't want to update the Kubeneretes version, run the update command with the `-operatingSystem` parameter. If an OS image-only update isn't available for your workload cluster, you won't be able to apply the proxy changes unless you update the Kubernetes version.

To update OS version only on a workload cluster, run the following command:
    
```powershell  
Update-AksHciCluster -name mycluster -operatingSystem
```

## Next steps

- To learn more about networking in AKS hybrid, see [Kubernetes networking concepts](/azure-stack/aks-hci/concepts-node-networking).
