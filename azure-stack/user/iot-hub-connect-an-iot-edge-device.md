---
title: Connect an IoT Edge device to IoT Hub on Azure Stack Hub
description: Learn how to connect an IoT Edge device to IoT Hub on Azure Stack Hub.
author: BryanLa 
ms.author: bryanla 
ms.service: azure-stack
ms.topic: how-to
ms.date: 11/20/2020 
ms.reviewer: dmolokanov
ms.lastreviewed: 11/20/2020
---

# Connect an IoT Edge device to IoT Hub on Azure Stack Hub

[!INCLUDE [preview-banner](../includes/iot-hub-preview.md)]

This article shows you how to connect a virtual IoT Edge device to the IoT Hub service running on Azure Stack Hub. You can use the same general process to connect a physical device to your IoT Hub.

## Prerequisites

Complete the following prerequisites before continuing:

- You'll need an account that can access the [Azure Stack Hub user portal](../user/azure-stack-use-portal.md), with at least ["contributor" permissions](../user/azure-stack-manage-permissions.md).

- Work with your administrator to [install the IoT Hub on Azure Stack Hub resource provider](../operator/iot-hub-rp-overview.md). The installation steps also cover the creation of an offer that includes the IoT Hub service. 

- Once an offer is available, your administrator can create or update your Azure Stack Hub subscription to include IoT Hub. Alternatively, you can [subscribe to the new offer and create your own subscription](azure-stack-subscribe-services.md).

- It's helpful to have a basic understanding of Public Key Encryption (PKI). Specifically, how a Certificate Authority (CA) and X509 certificates are used to build a chain of trust, allowing network nodes (such as your IoT Hub service and IoT Edge device) to securely authenticate and communicate with each other. 

## Overview

The general steps you'll complete in the following sections include:

1. Create IoT Hub and Linux VM resources on your Azure Stack Hub instance. The Linux VM serves as a virtual IoT Edge device. 
2. Configure the certificates required for the Edge device.
3. Configure the software and services required for the Edge device.
4. Test the Edge device to make sure it's working properly and communicating with your IoT Hub.

Be sure to update the following script placeholders to match your environment, before running the script in each of the following sections:

| Placeholder | Example | Note |
|-------------|---------|------|
| `<DEVICE-CA-CERT-NAME>` | `edged1cert`| The name you give the IoT Edge device CA certificate. |
| `<IOT-HUB-HOSTNAME>`| `test-hub-1.mgmtiothub.region.mydomain.com`| Your IoT Hub host name. |
| `<IOT-HUB-ROOT-CA>`| `root.cer`| The filename you give to the exported IoT Hub root CA. |
| `<DATA-DIR>`| `/home/edgeadmin/edged1`| The path to the data directory on the Linux VM. |

## Create Azure Stack Hub resources

First you create the necessary Azure Stack Hub resources, including an IoT Hub and a Linux VM. You'll use the [Azure Stack Hub user portal](../user/azure-stack-use-portal.md) to create these resources:

### Create an IoT Hub resource

1. Sign in to the [Azure Stack Hub user portal](../user/azure-stack-use-portal.md) from a computer that has access to your Azure Stack Hub instance.
2. If you haven't created one already, follow the instructions in the [Create an IoT Hub](/azure/iot-hub/iot-hub-create-through-portal#create-an-iot-hub) section of **Create an IoT hub using the Azure portal**, to create an IoT Hub resource. 

   > [!IMPORTANT]
   > Be sure to use the [Azure Stack Hub user portal](../user/azure-stack-use-portal.md) when following the steps in the article, and NOT the Azure portal. Also note that some screenshots and instructions may be slightly different, as not all Azure features are available on Azure Stack Hub. 

### Deploy and configure a Linux VM 

In this section, you deploy a new Linux VM, which will serve as the virtual IoT Edge device:

1. Using the [Create a Linux server VM by using the Azure Stack Hub portal](azure-stack-quick-linux-portal.md) quick start, install a Linux VM on your Azure Stack Hub instance. Be sure to enable port **SSH (22)** on the **Select public inbound ports** property, when you get to the **Settings** page. 

   > [!NOTE]
   > You only need to complete the first 5 sections, up through **Connect to the VM**, as you won't need the NGINX web server. Also, don't complete the **Clean up resources** section, as you'll use the Linux VM for the remainder of this article.

2. After you've created and connected to the VM using PuTTY, create a user account. For the purposes of this article, we'll assume an account named **edgeadmin**. [TODO - remove this and place comment in overview that this article assumes "edgeadmin" user account? or clarify how to establish SSH keys for sign in?]

   ```bash
   # add user account "edgeadmin'
   sudo adduser edgeadmin
   ```

3. Set up the certificate generation tool using one of the following methods. Either will download files from the IoT Edge GitHub repository, required later for generating device certificates:

   **Use cURL script:**
   ```bash
   # navigate to edge device data directory
   cd <DATA-DIR>
   
   # download script and configs
   curl -Lo certGen.sh https://raw.githubusercontent.com/Azure/iotedge/master/tools/CACertificates/certGen.sh
   curl -Lo openssl_root_ca.cnf https://raw.githubusercontent.com/Azure/iotedge/master/tools/CACertificates/openssl_root_ca.cnf
   ```
   **Use Git to clone the repository:**
   
   ```bash
   # navigate to home directory
   cd /home/edgeadmin
   
   # clone iotedge repo
   git clone https://github.com/Azure/iotedge.git
   
   # navigate to edge device data directory
   cd <DATA-DIR>
   
   # Copy the config and script files from the cloned IoT Edge repo into your working directory.
   cp /home/edgeadmin/iotedge/tools/CACertificates/*.cnf .
   cp /home/edgeadmin/iotedge/tools/CACertificates/certGen.sh .
   ```

## Configure certificates for the IoT Edge device

In this section, you'll complete the VM certificate configuration required by the virtual IoT Edge device.

Your IoT Hub service and the IoT Edge device are secured with X509 certificates, which must use the same root CA certificate in their trust chain. Select the appropriate tab below to complete certificate configuration, based on the root CA type being used by your IoT Hub.

# [Public CA](#tab/public-ca)

[!INCLUDE [common-cert-config](../includes/iot-hub-connect-an-iot-edge-device-cert-common.md)]

# [Private CA](#tab/private-ca)

> [!IMPORTANT]
> If you're using a private CA, you must transfer the IoT Hub root CA certificate to the IoT Edge device. Complete these steps ***only*** if you're using your own private CA for certificate generation. If your IoT Hub root CA certificate was issued by a public CA, select the preceding **Public CA** tab. 

#### Export the root CA certificate from your IoT Hub

Export the IoT Hub root CA certificate in PEM format, from a machine that has access to your Azure Stack Hub instance. This example will show how to export the certificate using either a [Microsoft Edge](https://www.microsoft.com/edge) or [Google Chrome](https://www.google.com/chrome/index.html) browser: 

   1. On the **Overview** page of your IoT Hub, use the **Copy** button to the right of the **Hostname** property to copy the IoT Hub hostname to the clipboard:  

      [![iot hub host name](media\iot-hub-connect-an-iot-edge-device\copy-iot-hub-host-name.png)](media\iot-hub-connect-an-iot-edge-device\copy-iot-hub-host-name.png#lightbox)
   1. Open a new tab in a Microsoft Edge or Google Chrome browser, enter `https://`, paste the IoT Hub hostname copied in the previous step, and press **Enter**. 

   1. After the error message is returned, select the lock icon to the left of the address bar, then click **Certificate**.
      [![certificate secure connection](media\iot-hub-connect-an-iot-edge-device\iot-hub-root-ca-connection.png)](media\iot-hub-connect-an-iot-edge-device\iot-hub-root-ca-connection.png#lightbox)

   1. When the SSL/TLS certificate shows, select the **Certification path** tab. Then select the top-most certificate in the path, and select the **View Certificate** button.  
      [![certificate secure connection - SSL cert](media\iot-hub-connect-an-iot-edge-device\iot-hub-root-ca-cert-ssl.png)](media\iot-hub-connect-an-iot-edge-device\iot-hub-root-ca-cert-ssl.png#lightbox) 

   1. When the root CA certificate shows, select the **Details** tab, then the **Copy to File...** button.
      [![certificate secure connection - root CA cert](media\iot-hub-connect-an-iot-edge-device\iot-hub-root-ca-cert-ssl-root-ca.png)](media\iot-hub-connect-an-iot-edge-device\iot-hub-root-ca-cert-ssl-root-ca.png#lightbox) 

   1. When the **Certificate Export Wizard** shows, export the certificate to a **Base-64 encoded X.509 format** file, for example, **root.cer**. You use this file in the next section, so export it to a location that can be accessed from, or copied to, the Linux VM.

   1. After the export finishes successfully, you can close the browser tab.

#### Install the IoT Hub root CA certificate on the Edge device

Now install the IoT Hub root CA certificate you exported in the previous section, into the Edge device's trusted store. 

1. Transfer the IoT Hub root CA file you exported in the previous section, to the Edge device. Since we're using a Linux VM as the Edge device, you'll need to copy it to the Linux VM. Depending on your environment, consider using either PuTTY with the PSCP command, or the WinSCP program to copy the file to the Linux VM.
2. Run the following script from your Linux VM PuTTY session, where you've stored the IoT Hub root CA file. The script will verify that the Edge device TLS connection is successful, and install the root CA in the Edge device's trusted store:

   ```bash
   # verify connection failed first
   # expected response: Verify return code: 2 (unable to get issuer certificate)
   openssl s_client -connect <IOT-HUB-HOSTNAME>:443
   
   # verify connection succeeded when root CA provided
   # expected response: Verify return code: 0 (ok)
   openssl s_client -connect <IOT-HUB-HOSTNAME>:443 -CAfile <IOT-HUB-ROOT-CA>
   
   # install root CA in the trusted store on Edge device
   sudo cp <IOT-HUB-ROOT-CA> /usr/local/share/ca-certificates/
   sudo update-ca-certificates
   
   # verify connection succeeded even when no root CA provided
   # expected response: Verify return code: 0 (ok)
   openssl s_client -connect <IOT-HUB-HOSTNAME>:443
   ```

[!INCLUDE [common-cert-config](../includes/iot-hub-connect-an-iot-edge-device-cert-common.md)]

### Append the IoT Hub root CA to the device root CA (private CA only)

Run the following script to append the IoT Hub root CA to the device root CA:

```bash
# navigate to home directory
cd /home/edgeadmin

# append IoT Hub root CA to the device root CA
cat <IOT-HUB-ROOT-CA> >> certs/azure-iot-test-only.root.ca.cert.pem
```
-----

## Configure software and services for the IoT Edge device

Now complete the IoT Hub and VM configuration required by the virtual IoT Edge device.

### Install IoT Edge and container runtimes on the VM

1. Return to the VM PuTTY session and run the following script to register the Microsoft key and software repository feed:

   ```bash
   # Install the repository configuration. 
   curl https://packages.microsoft.com/config/ubuntu/16.04/multiarch/prod.list > ./microsoft-prod.list
   
   # Copy the generated list.
   sudo cp ./microsoft-prod.list /etc/apt/sources.list.d/
   
   # Install Microsoft GPG public key.
   curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
   sudo cp ./microsoft.gpg /etc/apt/trusted.gpg.d/
   ```

2. Install the container runtime:

   ```bash
   sudo apt-get update
   sudo apt-get install moby-engine moby-cli
   ```

3. Install the Azure IoT Edge security daemon:

   ```bash
   sudo apt-get update
   sudo apt-get install iotedge
   ```

### Create an IoT Edge device in IoT Hub

1. Sign in to the [Azure Stack Hub user portal](../user/azure-stack-use-portal.md), then navigate to the **IoT Hub** service.

2. Select your IoT Hub resource, then select the **IoT Edge** page, then **Add an IoT Edge device**.

   [![iot hub resource](media\iot-hub-connect-an-iot-edge-device\add-an-iot-edge-device.png)](media\iot-hub-connect-an-iot-edge-device\add-an-iot-edge-device.png#lightbox)

3. On the **Create a device** page, enter the **Device ID**, for example "edged1".
4. When finished, select **Save**.

   [![iot edge - create a device](media\iot-hub-connect-an-iot-edge-device\create-iot-edge-device.png)](media\iot-hub-connect-an-iot-edge-device\create-iot-edge-device.png#lightbox)

5. Wait for the portal to return to the **IoT Edge** page, and your new device is added to the devices list.

6. On the **IoT Edge** page, select your device.

   [![iot edge - view devices](media\iot-hub-connect-an-iot-edge-device\view-iot-edge-devices.png)](media\iot-hub-connect-an-iot-edge-device\view-iot-edge-devices.png#lightbox)

7. On the device details page, use the "Copy" button at the right of **Primary Connection String** to copy the string to the clipboard.

   [![iot edge - device details](media\iot-hub-connect-an-iot-edge-device\iot-edge-device-details.png)](media\iot-hub-connect-an-iot-edge-device\iot-edge-device-details.png#lightbox)

### Configure the virtual IoT Edge device on the VM

1. Return to the VM PuTTY session, and open the configuration file on the virtual Edge device:

   ```bash
   sudo nano /etc/iotedge/config.yaml
   ```

2. Set the Edge device connection string. Update the \<`ADD DEVICE CONNECTION STRING HERE`\> placeholder, using the connection string you copied to the clipboard in the previous section:

   > [!NOTE]
   > To paste clipboard contents into Nano, press and hold the **Shift** key and click the right mouse button. Or, press the **Shift** and **Insert** keys simultaneously.

   ```yaml
   # Manual provisioning configuration
   provisioning:
     source: "manual"
     device_connection_string: "<ADD DEVICE CONNECTION STRING HERE>"
   ```

3. Uncomment the `certificates` section and provide the file URIs to certificates, for example:

   ```yaml
   certificates:
     device_ca_cert: "<DATA-DIR>/certs/iot-edge-device-<DEVICE-CA-CERT-NAME>-full-chain.cert.pem"
     device_ca_pk: "<DATA-DIR>/private/iot-edge-device-<DEVICE-CA-CERT-NAME>.key.pem"
     trusted_ca_certs: "<DATA-DIR>/certs/azure-iot-test-only.root.ca.cert.pem"
   ```

4. Save and close the file using **CTRL** + **X**, then **Y**, then **Enter**.

5. Restart the daemon:
   
   ```bash
   sudo systemctl restart iotedge
   ```

## Verify a successful installation

1. Return to the VM PuTTY session, and check the status of the IoT Edge Daemon:

   ```bash
   systemctl status iotedge
   ```

2. Examine the daemon logs:

   ```bash
   journalctl -u iotedge --no-pager --no-full
   ```

3. Run the troubleshooting tool to check for the most common configuration and networking errors:

   ```bash
   sudo iotedge check
   ```

   > [!NOTE]
   > The `$edgeHub` system module is optional, and isn't deployed to the device until you deploy your first IoT Edge module. As such, `iotedge check` will return an error indicating that `$edgeHub` cannot bind to ports during a host connectivity check. This error can be ignored if `$edgeHub` is not required in your deployment.  

4. Finally, list the running modules:

   ```bash
   sudo iotedge list
   ```

## Next steps

- [Install the Azure IoT Edge runtime on Debian-based Linux systems](/azure/iot-edge/how-to-install-iot-edge-linux)
- [Configure an IoT Edge device to act as a transparent gateway](/azure/iot-edge/how-to-create-transparent-gateway)
- [Create demo certificates to test IoT Edge device features](/azure/iot-edge/how-to-create-test-certificates)