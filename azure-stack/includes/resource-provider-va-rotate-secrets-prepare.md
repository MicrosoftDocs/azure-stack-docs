---
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: include
ms.date: 10/10/2020
ms.reviewer: bryanla
ms.lastreviewed: 10/20/2020
---

Next, create or renew your SSL/TLS certificate for securing the value-add resource provider endpoints:

1. Complete the steps in [Generate certificate signing requests (CSRs) for certificate renewal](../operator/azure-stack-get-pki-certs.md#generate-certificate-signing-requests-for-certificate-renewal) for your certificate. Here you use the Azure Stack Hub Readiness Checker tool to create the CSR. Be sure to run the correct `New-AzsHub<resource-provider>CertificateSigningRequest` cmdlet, where `<resource-provider` identifies the name of your value-add resource provider. When finished, you submit the generated .REQ file to your Certificate Authority (CA) for the new certificate.

2. Once you've received your certificate file from the CA, complete the steps in [Prepare certificates for deployment or rotation](../operator/azure-stack-prepare-pki-certs.md). You use the Readiness Checker tool again, to process the file returned from the CA.

3. Finally, complete the steps in [Validate Azure Stack Hub PKI certificates](../operator/azure-stack-validate-pki-certs.md). You use the Readiness Checker tool once more, to perform validation tests on your new certificate.


