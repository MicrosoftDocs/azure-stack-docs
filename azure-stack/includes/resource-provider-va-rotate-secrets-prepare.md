---
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: include
ms.date: 10/10/2020
ms.reviewer: bryanla
ms.lastreviewed: 10/10/2020
---

Create or renew a certificate for securing the resource provider endpoints:

1. Complete the [Generate certificate signing requests for certificate renewal](../operator/azure-stack-get-pki-certs.md#generate-certificate-signing-requests-for-certificate-renewal) steps. Be sure to run the correct `New-AzsHub<resource-provider>CertificateSigningRequest` cmdlet, where `<resource-provider` identifies the name of your value-add resource provider. When finished, you can submit the generated .REQ file to your Certificate Authority (CA) for the new certificate.

2. Once you've received your certificate file from the Certificate Authority, complete the steps in [Prepare certificates for deployment or rotation](../operator/azure-stack-prepare-pki-certs.md).

3. Finally, complete the steps in [Validate Azure Stack Hub PKI certificates](../operator/azure-stack-validate-pki-certs.md)


