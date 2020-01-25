---
title: Prepare Azure Stack Hub PKI certificates for deployment or rotation | Microsoft Docs
titleSuffix: Azure Stack Hub
description: Learn how to prepare PKI certificates for Azure Stack Hub integrated systems deployment or for rotating secrets in an existing Azure Stack Hub environment.
author: justinha

ms.topic: article
ms.date: 09/16/2019
ms.author: justinha
ms.reviewer: ppacent
ms.lastreviewed: 09/16/2019
---

# Prepare Azure Stack Hub PKI certificates for deployment or rotation

The certificate files [obtained from your certificate authority (CA) of choice](azure-stack-get-pki-certs.md) must be imported and exported with properties matching Azure Stack Hub's certificate requirements.

## Prepare certificates for deployment

Use the following steps to prepare and validate the Azure Stack Hub PKI certificates that will be used for deploying a new Azure Stack Hub environment or for rotating secrets in an existing Azure Stack Hub environment.

### Import the certificate

1. Copy the original certificate versions [obtained from your CA of choice](azure-stack-get-pki-certs.md) into a directory on the deployment host. 
   > [!WARNING]
   > Don't copy files that have already been imported, exported, or altered in any way from the files provided directly by the CA.

1. Right-click on the certificate and select **Install Certificate** or **Install PFX**, depending on how the certificate was delivered from your CA.

1. In the **Certificate Import Wizard**, select **Local Machine** as the import location. Select **Next**. On the following screen, select next again.

    ![Local machine import location for certificate](./media/prepare-pki-certs/1.png)

1. Choose **Place all certificate in the following store** and then select **Enterprise Trust** as the location. Select **OK** to close the certificate store selection dialog box and then select **Next**.

   ![Configure the certificate store for certificate import](./media/prepare-pki-certs/3.png)

   a. If you're importing a PFX, you'll be presented with an additional dialog. On the **Private key protection** page, enter the password for your certificate files and then enable the **Mark this key as exportable. This allows you to back up or transport your keys at a later time** option. Select **Next**.

   ![Mark key as exportable](./media/prepare-pki-certs/2.png)

1. Select **Finish** to complete the import.

> [!NOTE]
> After you import a certificate for Azure Stack Hub, the private key of the certificate is stored as a PKCS 12 file (PFX) on clustered storage.

### Export the certificate

Open Certificate Manager MMC console and connect to the Local Machine certificate store.

1. Open the Microsoft Management Console. To open the console in Windows 10, right click on the **Start Menu**, select **Run**, then type **mmc** and press enter.

2. Select **File** > **Add/Remove Snap-In**, then select **Certificates** and select **Add**.

    ![Add Certificates Snap-in in Microsoft Management Console](./media/prepare-pki-certs/mmc-2.png)

3. Select **Computer account**, then select **Next**. Select **Local computer** and then **Finish**. Select **OK** to close the Add/Remove Snap-In page.

    ![Select account for Add Certificates Snap-in in Microsoft Management Console](./media/prepare-pki-certs/mmc-3.png)

4. Browse to **Certificates** > **Enterprise Trust** > **Certificate location**. Verify that you see your certificate on the right.

5. From the Certificate Manager Console taskbar, select **Actions** > **All Tasks** > **Export**. Select **Next**.

   > [!NOTE]
   > Depending on how many Azure Stack Hub certificates you have, you may need to complete this process more than once.

6. Select **Yes, Export the Private Key**, and then click **Next**.

7. In the Export File Format section:
    
   - Select **Include all certificates in the certificate if possible**.  
   - Select **Export all Extended Properties**.  
   - Select **Enable certificate privacy**.  
   - Click **Next**.  
    
     ![Certificate export wizard with selected options](./media/prepare-pki-certs/azure-stack-save-cert.png)

8. Select **Password** and provide a password for the certificates. Create a password that meets the following password complexity requirements:

    * A minimum length of eight characters.
    * At least three of the following: uppercase letter, lowercase letter, numbers from 0-9, special characters, alphabetical character that's not uppercase or lowercase.

    Make note of this password. You'll use it as a deployment parameter.

9. Select **Next**.

10. Choose a file name and location for the PFX file to export. Select **Next**.

11. Select **Finish**.

## Next steps

[Validate PKI certificates](azure-stack-validate-pki-certs.md)