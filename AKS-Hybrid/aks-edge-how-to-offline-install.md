---
title: AKS Edge Essentials offline installation
description: Learn how to configure your machine for AKS Edge Essentials offline installation.
author: fcabrera
ms.author: fcabrera
ms.topic: how-to
ms.date: 04/24/2023
ms.custom: template-how-to
---

# Prerequisites for AKS Edge Essentials offline installation

AKS Edge Essentials is primarily designed to be installed on an internet-connected machine, since many components are updated regularly. However, with some extra steps, it's possible to deploy AKS Edge Essentials in an offline environment.

The following guide goes over the required configurations needed for an AKS Edge Essentials offline installation:
1. Windows certificates
1. Internet checks
1. Licensing

## Windows certificates

The AKS Edge Essentials setup installs only content that is trusted. It does this by checking Authenticode signatures of the content being downloaded and verifying that all content is trusted before installing it. Also, the _AKSEdge.psm1_ PowerShell module and cmdlets used to deploy the cluster are signed and verified. This keeps your environment safe from attacks where the download location is compromised. 

AKS Edge Essentials setup therefore requires that several standard Microsoft root and intermediate certificates are installed and up-to-date on a user's machine. If the machine has been kept up to date with Windows Update, signing certificates usually are up to date. If the machine is offline, the certificates must be refreshed another way.

One way to check on the installing system is to follow these steps:

1. Open an elevated PowerShell session
1. Check for the **Microsoft Root Certificate Authority 2011** running the following command:
    ```powershell
    Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object {$_.Subject -like "CN=Microsoft Root Certificate Authority 2011*"}
    ```

    If the **Microsoft Root Certificate Authority 2011** is installed on this machine, you should see the following output:

    ```output
    PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\Root

    Thumbprint                                Subject
    ----------                                -------
    8F43288AD272F3103B6FB1428485EA3014C0BCFE  CN=Microsoft Root Certificate Authority 2011, O=Microsoft Corporation, L=R...
    ```

1. Check for the **Microsoft Code Signing PCA 2011** running the following command:
    ```powershell
    Get-ChildItem -Path Cert:\LocalMachine\CA | Where-Object {$_.Subject -like "CN=Microsoft Code Signing PCA 2011*"}
    ```

    If the **Microsoft Code Signing PCA 2011** is installed on this machine, you should see the following output:

    ```output
    PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\CA

    Thumbprint                                Subject
    ----------                                -------
    F252E794FE438E35ACE6E53762C0A234A2C52135  CN=Microsoft Code Signing PCA 2011, O=Microsoft Corporation, L=Redmond, S=...
    ```

  If the **Microsoft Code Signing PCA 2011** intermediate certificate was only in the **Current User** Intermediate Certificate store, then it's available only to the user that is logged in. You might need to install it for other users.

## How to install/refresh certificates when offline

There are two options for installing or updating certificates in an offline environment.

### Option 1 - Install certificates manually or as part of a scripted deployment

If you're scripting the deployment of AKS Edge Essentials in an offline environment to client workstations, you should follow these steps:

1. Open an elevated PowerShell session

1. Download the necessary certificates
    1. [MicrosoftRootCertificateAuthority2011.cer](https://download.microsoft.com/download/2/4/8/248D8A62-FCCD-475C-85E7-6ED59520FC0F/MicrosoftRootCertificateAuthority2011.cer)
    1. [MicCodSigPCA2011.crt](http://www.microsoft.com/pkiops/certs/MicCodSigPCA2011_2011-07-08.crt)

1. Manually run the following commands or add them to your AKS Edge Essentials installation script:

    ```powershell
    certutil.exe -addstore -f "AuthRoot" "[download path]\MicrosoftRootCertificateAuthority2011.cer"

    certutil.exe -addstore -f "CA" "[download path]\MicCodSigPCA2011_2011-07-08.crt"
    ```

1. To check if the certificates were correctly installed, use the PowerShell commands provided in the section [Windows certificates](#windows-certificates) above. 

### Option 2 - Distribute trusted root certificates in an enterprise environment

For enterprises with offline machines that don't have the latest root certificates, an administrator can use the instructions on the [Configure Trusted Roots and Disallowed Certificates](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn265983(v=ws.11)) page to update them.


## Internet checks

During the deployment of AKS Edge Essentials cluster, the PowerShell deployment script checks for internet connectivity. These checks are to make sure that DNS servers work, the cluster is able to connect to the internet and hence Arc connection could be established if the user decided. However, when doing offline installations, these checks aren't required and should be avoided. 

During the creation of the [deployment JSON file](./aks-edge-howto-setup-machine.md), ensure to mark the **InternetDisabled** parameter inside the _Networking_ section as **true**. 

## Licensing

AKS Edge Essentials offline deployments can be licensed for commercial use using **Volume licensing model**.AKS Edge Essentials is licensed and priced as per device, per month model. Each licensed unit is applied to a device in your cluster. For more licensing information, see [AKS Edge Essentials - Licensing](aks-edge-licensing.md).


## Next steps

[AKS Edge Essentials overview](aks-edge-overview.md)
[AKS Edge Essentials setup](aks-edge-howto-setup-machine.md)
