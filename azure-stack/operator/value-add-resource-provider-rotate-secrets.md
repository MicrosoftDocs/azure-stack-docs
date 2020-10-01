---
title: How to rotate secrets for a value-add resource provider
description: Learn how to rotate secrets for a value-add resource provider on Azure Stack Hub. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 10/10/2020
ms.reviewer: bryanla
ms.lastreviewed: 10/10/2020
---

# How to rotate secrets for a value-add resource provider

This article will show you how to rotate the secrets used by a value-add resource provider, for a given product ID.

> [!NOTE]
> Secret rotation for value-add resource providers is currently only supported via PowerShell.  

## Prerequisites

If you haven't already, be sure to review [Azure Stack Hub public key infrastructure (PKI) certificate requirements](azure-stack-pki-certs.md) for important prerequisite information. Particularly the requirements specified in the [Optional PaaS certificates section](azure-stack-pki-certs.md#optional-paas-certificates), for your specific value-add resource provider.

## Acquire and prepare a new certificate

Create or renew a certificate for securing the resource provider endpoints:

1. Complete the [Generate certificate signing requests for certificate renewal](azure-stack-get-pki-certs.md#generate-certificate-signing-requests-for-certificate-renewal) steps. Be sure to run the correct `New-AzsHub<resource-provider>CertificateSigningRequest` cmdlet, where `<resource-provider` identifies the specific value-add resource provider. When finished, you can submit the generated .REQ file to your Certificate Authority (CA).

2. Once you've received your certificate file from the Certificate Authority, complete the steps in [Prepare certificates for deployment or rotation](azure-stack-prepare-pki-certs.md).

3. Finally, complete the steps in [Validate Azure Stack Hub PKI certificates](azure-stack-validate-pki-certs.md)

## Rotate secrets

1. Sign in to the Azure Stack Hub administrator portal.
2. Select **Marketplace Management** on the left.
3. Select **Resource providers**.
4. Select **Event Hubs** from the list of resource providers. You may want to filter the list by entering "Event Hubs" in the search text box provided.

   [![Remove event hubs 1](media/event-hubs-rp-remove/1-uninstall.png)](media/event-hubs-rp-remove/1-uninstall.png#lightbox)

5. Select **Uninstall** from the options provided across the top the page.

   [![Remove event hubs 2](media/event-hubs-rp-remove/2-uninstall.png)](media/event-hubs-rp-remove/2-uninstall.png#lightbox)

6. Enter the name of the resource provider, then select **Uninstall**. This action confirms your desire to uninstall:
   - The Event Hubs resource provider
   - All user-created clusters, namespaces, event hubs, and event data.

   [![Remove event hubs 3](media/event-hubs-rp-remove/3-uninstall.png)](media/event-hubs-rp-remove/3-uninstall.png#lightbox)

   [![Removing event hubs 4](media/event-hubs-rp-remove/4-uninstall.png)](media/event-hubs-rp-remove/4-uninstall.png#lightbox)

   > [!IMPORTANT]
   > You must wait at least 10 minutes after Event Hubs has been removed successfully before installing Event Hubs again. This is due to the fact that cleanup activities might still be running, which may conflict with any new installation.

## Troubleshooting

1.	It takes around 3.5 – 4 hours to complete the secret rotation.
2.	Failure symptoms may include these.
   - Secret rotation completed successfully without any error, but portal fails with 
     - Authentication issues cannot connect to Eventhub RP
     - Cannot create cluster
     - Metrics not showing up
     - Bills not showing up
     - Backups not happening.

In any case open an Service Request.


## Next steps

For details on rotating your Azure Stack Hub infrastructure secrets, visit [Rotate secrets in Azure Stack Hub](azure-stack-rotate-secrets.md).