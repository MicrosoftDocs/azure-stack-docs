---
title: Connect an IoT Edge device to IoT Hub on Azure Stack Hub
description: Learn how to connect an IoT Edge device to IoT Hub on Azure Stack Hub.
author: BryanLa 
ms.author: bryanla 
ms.service: azure-stack
ms.topic: how-to
ms.date: 10/20/2020 
ms.reviewer: bryanla
ms.lastreviewed: 10/20/2020
---

# Connect an IoT Edge device to IoT Hub on Azure Stack Hub

This article shows you how to connect an IoT Edge device to the IoT Hub service running on Azure Stack Hub.

## Prerequisites

Ensure the IoT Hub service is available in your subscription. If it isn't, work with your administrator to [install the IoT Hub on Azure Stack Hub resource provider](../operator/iot-hub-rp-overview.md). The installation steps also cover the creation of an offer that includes the IoT Hub service. 

Once an offer is available, your administrator can create or update your subscription to include IoT Hub. Alternatively, you can [subscribe to the new offer and create your own subscription](azure-stack-subscribe-services.md).

[TODO - is a Windows client required?]

## Deploy a new Linux VM on Azure Stack Hub [TODO]

Use the [Create a Linux server VM by using the Azure Stack Hub portal](azure-stack-quick-linux-portal.md) quick start, to install a Linux VM on your Azure Stack Hub instance. When the installation is complete, create a user account named **edgeadmin**.

[TODO] - do we need steps for starting the VM? remoting into? etc..

## Install an IoT Hub root certificate authority (CA) on the Edge device 

In this section, you install an IoT Hub root CA in the edge device's trusted store. To complete the following steps, you need to use either the [Microsoft Edge](/microsoft-edge) or Google Chrome browser:

1. Obtain a root CA from IoT Hub and store it in PEM format.[TODO - instructions for doing this? is it a .cer file, or .pem file? and where is this used below? OR.. was this step intended to be more of a summary of what's happening in steps 2-4?]

2. Copy the IoT Hub hostname and paste it in a new tab in Microsoft Edge or Google Chrome. Select the lock icon next to the website link in the address bar, then **Certificate**, then the **Certification path** tab. Select the top-most certificate in the path, then select the **View Certificate** button. Select the **Details** tab, then the **Copy to File...** button and export the certificate as a .CRT file in base-64 format, for example, **root.crt**.

3. Transfer the certificate to the Edge device.

4. Verify the TLS connection is successful from the Edge device using the following script:

   ```bash
   # verify connection failed first
   # expected response: Verify return code: 2 (unable to get issuer certificate)
   openssl s_client -connect $IOTHUB_HOSTNAME:443
   
   # verify connection succeeded when root CA provided
   # expected response: Verify return code: 0 (ok)
   openssl s_client -connect $IOTHUB_HOSTNAME:443 -CAfile root.crt
   
   # install root CA in the trusted store on Edge device
   sudo cp root.crt /usr/local/share/ca-certificates/
   sudo update-ca-certificates
   
   # verify connection succeeded even when no root CA provided
   # expected response: Verify return code: 0 (ok)
   openssl s_client -connect $IOTHUB_HOSTNAME:443
   ```

At this point, everything is ready to install and configure the IoT Edge runtime. In the next section  you set up the certificate generation tool, then generate the certificates required for the device. Following that, you install, configure, and test the IoT Edge and container runtimes.

## Generate device certificates

### Set up the certificate generation tool

Download the artifacts necessary to generate device certificates using one of the following methods:

**Use cURL script**
```bash
# navigate to edge device data directory
cd /home/edgeadmin/edged1

# download script and configs
curl -Lo certGen.sh https://raw.githubusercontent.com/Azure/iotedge/master/tools/CACertificates/ertGen.sh
curl -Lo openssl_root_ca.cnf https://raw.githubusercontent.com/Azure/iotedge/master/tools/ACertificates/   openssl_root_ca.cnf
```
**Clone the IoT Edge repository and use tools to generate certificates**

```bash
# navigate to home directory
cd /home/edgeadmin

# clone iotedge repo
git clone https://github.com/Azure/iotedge.git

# navigate to edge device data directory
cd /home/edgeadmin/edged1

# Copy the config and script files from the cloned IoT Edge repo into your working directory.
cp /home/edgeadmin/iotedge/tools/CACertificates/*.cnf .
cp /home/edgeadmin/iotedge/tools/CACertificates/certGen.sh .
```

### Create a root CA certificate

This script creates several certificate and key files, but when articles ask for the root CA certificate, use the following file: `/home/edgeadmin/edged1/certs/azure-iot-test-only.root.ca.cert.pem`
[TODO - need more clarity on "but when articles ask for the root CA certificate". Was this just a note for internal use?]

```bash
./certGen.sh create_root_and_intermediate
```

### Create the IoT Edge device CA certificates

Production IoT Edge devices need a device CA certificate, referenced from the config.yaml file. The device CA certificate is responsible for creating certificates for the modules running on the device. It's also necessary for gateway scenarios, as the device CA certificate is use by the IoT Edge device to verify its identity to downstream devices.

1. Run the following script, which creates several certificate and key files. 

   ```bash
   # navigate to home directory
   cd /home/edgeadmin/edged1
   
   # generate IoT Edge device CA certificates 
   ./certGen.sh create_edge_device_certificate edged1cert
   ```

2.  Copy the following certificate and key pair files to the IoT Edge device. Later they will be referenced in the config.yaml file:

    - `/home/edgeadmin/edged1/certs/iot-edge-device-edged1cert-full-chain.cert.pem`  
    - `/home/edgeadmin/edged1/private/iot-edge-device-edged1cert.key.pem`

### Append IoT Hub root CA to the device root CA

Run the following script to append the IoT Hub root CA to the device root CA:

```bash
# navigate to home directory
cd /home/edgeadmin

# append IoT Hub root CA to the device root CA
cat root.crt >> certs/azure-iot-test-only.root.ca.cert.pem
```

## Install IoT Edge and container runtimes

1. Run the following script to register the Microsoft key and software repository feed:

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

3. Install the Azure IoT Edge Security Daemon:

   ```bash
   sudo apt-get update
   sudo apt-get install iotedge
   ```

## Configure the security daemon

### Add a new IoT Edge device 

1. Navigate to IoT Hub on Azure Stack Hub.
2. Open the **IoT Edge** page.
3. Select **Add an IoT Edge device**.
4. Enter the **Device ID**, for example "edged1".
5. Select **Save**.
6. Wait until your new device is shown in the list.

### Obtain a Connection String for Edge device

1. Select on `edged1` device in the list
2. Copy `Primary Connection String`

### Configure Edge device

1. Open the configuration file on Edge device:

   ```bash
   sudo nano /etc/iotedge/config.yaml
   ```

2. Set the Edge device connection string by updating the \<`ADD DEVICE CONNECTION STRING HERE`\> placeholder:

   ```yaml
   # Manual provisioning configuration
   provisioning:
     source: "manual"
     device_connection_string: "<ADD DEVICE CONNECTION STRING HERE>"
   ```

3. Uncomment the `certificates` section and provide the file URIs to certificates, for example:

   > [!NOTE]
   > To paste clipboard contents into Nano, press and hold the **Shift** key and click the right mouse button. Or, press the **Shift** and **Insert** keys simultaneously.

   ```yaml
   certificates:
     device_ca_cert: "/home/edgeadmin/edged1/certs/iot-edge-device-edged1cert-full-chain.cert.pem"
     device_ca_pk: "/home/edgeadmin/edged1/private/iot-edge-device-edged1cert.key.pem"
     trusted_ca_certs: "/home/edgeadmin/edged1/certs/azure-iot-test-only.root.ca.cert.pem"
   ```

4. Save and close the file using **CTRL** + **X**, then **Y**, then **Enter**.

5. Restart the daemon:
   
   ```bash
   sudo systemctl restart iotedge
   ```

## Verify successful installation

1. Check the status of the IoT Edge Daemon:

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
   > The `$edgeHub` system module won't be deployed to the device until you deploy your first module to    IoT Edge on your device. As a result, the automated check will return an error for the Edge Hub can    bind to ports on host connectivity check. This error can be ignored unless it occurs after deploying a    module to the device. [TODO - need clarity on the 2nd sentence above.]

4. Finally, list the running modules:

   ```bash
   sudo iotedge list
   ```

## Next steps

- [Install the Azure IoT Edge runtime on Debian-based Linux systems](/azure/iot-edge/how-to-install-iot-edge-linux)
- [Configure an IoT Edge device to act as a transparent gateway](/azure/iot-edge/how-to-create-transparent-gateway)
- [Create demo certificates to test IoT Edge device features](/azure/iot-edge/how-to-create-test-certificates)