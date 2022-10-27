---
title: Set up Trust in Azure Kubernetes Service on AKS hybrid
description: Learn how to add a certificate chain of trust (root, intermediate and lead certificates) with public key.
author: sethmanheim
ms.topic: how-to
ms.date: 10/26/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: sulahiri

---

# Update certificate bundle on container hosts

An AKS cluster needs to trust other on-premises resources such as the container registry. This article describes how to add a certificate chain of trust (root, intermediate and lead certificates) with a public key, for the endpoints the cluster is expected to trust and allow communication. The certificates are added on the Linux hosts.

This scenario uses a modified version of the [noProxy settings](proxy-change.md) command.

## Prerequisites and details

- An AKS deployment running the September 2022 build.
- The certificates are not immediately available upon running the command; they are deployed on the next update.
- You can check if there is an update available using the AKS PowerShell module cmdlet [Get-AksHciClusterUpdates](reference/ps/get-akshciclusterupdates.md).
- Currently there is no command to view, change, or delete scheduled update. Once the update is applied, it is possible to SSH into the container host and see the certs installed, then delete them.

## Certificate format

- The certificates should be specified in a single .crt file in PEM format. This format is applicable for updating certificates on Linux container hosts
- It's important to make sure the certificates are added in the right order in single .crt file. For example `<.leaf.crt>`, `<intermediate.crt>`,`<root.crt>`.
- The contents of the certificate file are not validated. Please ensure that the file contains the right certificates and is in the correct format.

## Example: create a single certificate bundle

For Linux hosts:

```bash
cat [leaf].crt  [intermediate].crt [Root].crt >  [your single cert file].crt
```

PowerShell:

```powershell
$noProxy = "" # keep this as an empty string
$certFile ="/../[bundle].crt" # path to the bundled .crt file
Set-AksHciProxySetting -noProxy $noProxy -certFile $certFile
```

## Next steps

[AKS hybrid deployment options](aks-hybrid-options-overview.md)
