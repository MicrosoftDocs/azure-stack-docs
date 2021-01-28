---
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: include
ms.date: 11/20/2020
ms.reviewer: bryanla
ms.lastreviewed: 11/20/2020
---

### Create a device root CA certificate

Create the device root CA certificate and key files required for your device: 

1. Return to the Bash command prompt in your PuTTY session.
2. Navigate to the data directory where you placed the certificate generation scripts in the previous section.
3. Run the following command:

   ```bash
   ./certGen.sh create_root_and_intermediate
   ```

4. The device root CA certificate is stored in the following file: `<DATA-DIR>/certs/azure-iot-test-only.root.ca.cert.pem`.

### Create the IoT Edge device CA certificate

Production IoT Edge devices need a device CA certificate, referenced from the config.yaml file. The device CA certificate is responsible for creating certificates for the modules running on the device. It's also necessary for gateway scenarios, as the device CA certificate is use by the IoT Edge device to verify its identity to downstream devices.

To create the IoT Edge device CA certificate files:

1. Return to the Bash command prompt in your PuTTY session.
2. Run the following script, which creates several device CA certificate and key files: 

   ```bash
   # Navigate to data directory
   cd <DATA-DIR>
   
   # Generate IoT Edge device CA certificate 
   ./certGen.sh create_edge_device_ca_certificate <DEVICE-CA-CERT-NAME>
   ```

3.  The following certificate and key pair files are referenced later in the config.yaml file:

    `<DATA-DIR>/certs/iot-edge-device-ca-<DEVICE-CA-CERT-NAME>-full-chain.cert.pem`  
    `<DATA-DIR>/private/iot-edge-device-ca-<DEVICE-CA-CERT-NAME>.key.pem`


