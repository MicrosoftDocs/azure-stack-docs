---
title: Validate Azure Managed Lustre CSI Driver container image security
description: Learn how to verify the integrity and origin of Azure Lustre CSI Driver container images using Notation CLI and AKS Image Integrity.
ms.topic: how-to
ms.date: 10/16/2026
author: pauljewellmsft
ms.author: akashdubey
ms.reviewer: brianl
ms.custom: sfi-image-nochange

# Intent: As an IT pro, I want to verify the integrity and origin of Azure Lustre CSI Driver container images before deployment.
# Keyword: 

---

# Validate Azure Managed Lustre CSI driver image security

Azure Lustre CSI Driver signs its container images so you can verify the integrity and origin of the images you use. The signing process uses a public/private key pair to prove that Microsoft built a container image by creating a digital signature and adding it to the image. This article provides the steps to verify that an image was signed by Microsoft.

## Understanding image security in Kubernetes system components

You deploy container images used by the Azure Lustre CSI Driver in the `kube-system` namespace, which Kubernetes considers a trusted system namespace. For security and operational reasons, you typically don't enforce image integrity policies on system namespaces because:

- **Bootstrap requirements**: System components like CSI drivers must start before policy enforcement systems (like Gatekeeper and Ratify) are available.
- **Trusted components**: Images in `kube-system` are core Kubernetes infrastructure components managed by trusted providers.
- **Operational stability**: Enforcing policies on policy enforcement components themselves could prevent cluster functionality.

However, you can still verify the integrity of CSI driver images before deployment.

## Pre-deployment image verification

Before you deploy the Azure Lustre CSI Driver, verify the digital signatures and authenticity of the container images by using Microsoft's public signing certificates.

### Verify image signatures with Notation CLI

1. **Download Notation CLI**:

    ```bash
    export NOTATION_VERSION=1.3.2
    curl -LO https://github.com/notaryproject/notation/releases/download/v$NOTATION_VERSION/notation_$NOTATION_VERSION\_linux_amd64.tar.gz
    sudo tar xvzf notation_$NOTATION_VERSION\_linux_amd64.tar.gz -C /usr/bin/ notation
    ```

2. **Download the Microsoft signing public certificate**: 

    ```bash
    curl -sSL "https://www.microsoft.com/pkiops/certs/Microsoft%20Supply%20Chain%20RSA%20Root%20CA%202022.crt" -o msft_signing_cert.crt
    ```

3. **Add the certificate to notation CLI**:

    ```bash
    notation cert add --type ca --store supplychain msft_signing_cert.crt
    ```

4. **Check the certificate in notation**:

    ```bash
    notation cert ls
    ```

    The output of the command looks like the following example:

    ```output
    STORE TYPE  STORE NAME  CERTIFICATE 
    ca          supplychain msft_signing_cert.crt
    ```

5. **Create a trustpolicy file for Azure Lustre CSI Driver images**:

    Create a file called `trustpolicy.json`:

    ```json
    {
        "version": "1.0",
        "trustPolicies": [
            {
                "name": "supplychain",
                "registryScopes": [ "*" ],
                "signatureVerification": {
                    "level" : "strict" 
                },
                "trustStores": [ "ca:supplychain" ],
                "trustedIdentities": [
                    "x509.subject: CN=Microsoft SCD Products RSA Signing,O=Microsoft Corporation,L=Redmond,ST=Washington,C=US"
                ]
            }
        ]
    }
    ```

6. **Use notation to verify Azure Lustre CSI Driver images**:

    ```bash
    notation policy import trustpolicy.json
    export NOTATION_EXPERIMENTAL=1
    
    # Verify the controller image
    notation verify --allow-referrers-api mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.3.0
    ```

    The output of a successful verification looks like the following example:

    ```output
    Successfully verified signature for mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi@sha256:a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456
    ```

## Application workload image integrity

For enhanced security in production environments, consider enabling AKS Image Integrity to automatically validate container image signatures for your application workloads. While policy enforcement typically excludes CSI driver images in the `kube-system` namespace, you can configure image integrity policies for your application namespaces.

To learn more about implementing image integrity policies for your application workloads, see [Image Integrity in Azure Kubernetes Service (AKS)](/azure/aks/image-integrity).

## Related content

- [Azure Lustre CSI driver overview](use-csi-driver-kubernetes.md)
- [Use dynamic provisioning with the Azure Lustre CSI driver](use-container-storage-interface-driver-dynamic-provisioning.md)
- [Use static provisioning with the Azure Lustre CSI driver](use-container-storage-interface-driver-static-provisioning.md)
- [Image Integrity in Azure Kubernetes Service (AKS)](/azure/aks/image-integrity)
