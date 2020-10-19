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

## Deploy a new Linux VM on Azure Stack Hub [TODO]

Use the [Create a Linux server VM by using the Azure Stack Hub portal](azure-stack-quick-linux-portal.md) quick start, to install a Linux VM on your Azure Stack Hub instance. When the installation is complete, create a user account named **edgeadmin**.

## Install an IoT Hub root certificate authority (CA) on the Edge device 

In this section, you install an IoT Hub root CA in the edge device's trusted store:

1. Obtain a root CA from IoT Hub and store it in .pem format.

2. Copy the IoT Hub hostname and paste it in a new tab in Google Chrome on Windows. Click on a lock icon near address bar, then `Certificates`. Select the top most certificate then select `View Certificate`. Save certificate as a .CRT file in base-64 format, such as `root.crt`.

3. Transfer the certificate on the Edge device.

4. Verify the TLS connection is successfull from the Edge device using the following script:

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

## Generate device Certificates

At this point, everything is ready to install and configure the IoT Edge runtime. First you need to generate the certificates required for the device.

### Setup the certificate generation tool

1. Download the artifacts necessary to generate device certificates using one of the following methods:

   **Use cURL script**

   ```bash
   # navigate to edge device data directory
   cd /home/edgeadmin/edged1
   
   # download script and configs
   curl -Lo certGen.sh https://raw.githubusercontent.com/Azure/iotedge/master/tools/CACertificates/certGen.sh
   curl -Lo openssl_root_ca.cnf https://raw.githubusercontent.com/Azure/iotedge/master/tools/CACertificates/   openssl_root_ca.cnf
   ```

   **Clone the the IoT Edge repository and use tools to generate certificates**
   
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

```bash
./certGen.sh create_root_and_intermediate
```

### Create the IoT Edge device CA certificates

Every IoT Edge device going to production needs a device CA certificate that's referenced from the config.yaml file. The device CA certificate is responsible for creating certificates for modules running on the device. It's also necessary for gateway scenarios, because the device CA certificate is how the IoT Edge device verifies its identity to downstream devices.

```bash
# navigate to home directory
cd /home/edgeadmin/edged1

# generate IoT Edge device CA certificates 
./certGen.sh create_edge_device_certificate edged1cert
```

This command creates several certificate and key files. The following certificate and key pair needs to be copied over to an IoT Edge device and referenced in the config.yaml file:
* `/home/edgeadmin/edged1/certs/iot-edge-device-edged1cert-full-chain.cert.pem`
* `/home/edgeadmin/edged1/private/iot-edge-device-edged1cert.key.pem`

### Append IoT Hub root CA to the device root CA

Run the following script to append the IoT Hub root CA to teh device root CA:

```bash
# navigate to home directory
cd /home/edgeadmin

# append IoT Hub root CA to the device root CA
cat root.crt >> certs/azure-iot-test-only.root.ca.cert.pem
```

## Install IoT Edge and container runtimes

Register Microsoft key and software repository feed
```bash
# Install the repository configuration. 
curl https://packages.microsoft.com/config/ubuntu/16.04/multiarch/prod.list > ./microsoft-prod.list

# Copy the generated list.
sudo cp ./microsoft-prod.list /etc/apt/sources.list.d/

# Install Microsoft GPG public key.
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo cp ./microsoft.gpg /etc/apt/trusted.gpg.d/
```

Install a container runtime
```bash
sudo apt-get update
sudo apt-get install moby-engine moby-cli
```

Install the Azure IoT Edge Security Daemon
```bash
sudo apt-get update
sudo apt-get install iotedge
```

## Configure the security daemon

### Add a new IoT Edge device 

1. Navigate to IoT Hub on Azure Stack Hub
2. Open `IoT Edge` Blade
3. Click `Add an IoT Edge device`
4. Put `Device ID` (e.g. edged1)
5. Click `Save`
6. Wait until `edged1` device is shown in the list

### Obtain a Connection String for Edge device

1. Click on `edged1` device in the list
2. Copy `Primary Connection String`

### Configure Edge device

Open the configuration file on Edge device
```bash
sudo nano /etc/iotedge/config.yaml
```

Put Edge device connection string
```yaml
# Manual provisioning configuration
provisioning:
  source: "manual"
  device_connection_string: "<ADD DEVICE CONNECTION STRING HERE>"
```

Uncomment `certificates` section and provide the file URIs to certificates
```yaml
certificates:
  device_ca_cert: "/home/edgeadmin/edged1/certs/iot-edge-device-edged1cert-full-chain.cert.pem"
  device_ca_pk: "/home/edgeadmin/edged1/private/iot-edge-device-edged1cert.key.pem"
  trusted_ca_certs: "/home/edgeadmin/edged1/certs/azure-iot-test-only.root.ca.cert.pem"
```

To paste clipboard contents into Nano Shift+Right Click or press Shift+Insert.

Save and close the file.

`CTRL + X`, `Y`, `Enter`

After entering the provisioning information in the configuration file, restart the daemon:

```bash
sudo systemctl restart iotedge
```

## Verify successful installation

First check the status of the IoT Edge Daemon:

```bash
systemctl status iotedge
```
Examine daemon logs:

```bash
journalctl -u iotedge --no-pager --no-full
```

Run the troubleshooting tool to check for the most common configuration and networking errors:

```bash
sudo iotedge check
```

Until you deploy your first module to IoT Edge on your device, the `$edgeHub` system module will not be deployed to the device. As a result, the automated check will return an error for the Edge Hub can bind to ports on host connectivity check. This error can be ignored unless it occurs after deploying a module to the device.

Finally, list running modules:

```bash
sudo iotedge list
```

## Next steps

- [Install the Azure IoT Edge runtime on Debian-based Linux systems](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-install-iot-edge-linux)
- [Configure an IoT Edge device to act as a transparent gateway](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-create-transparent-gateway)
- [Create demo certificates to test IoT Edge device features](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-create-test-certificates)