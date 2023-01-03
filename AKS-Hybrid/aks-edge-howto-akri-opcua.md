---
title: Discover Sample OPC UA Servers with Akri
description: This article describes how to deploy an OPC PLC container and use Akri to discover these servers and display anomaly values.
author: yujinkim-msft
ms.author: yujinkim
ms.topic: how-to
ms.date: 01/03/2023
ms.custom: template-how-to
---

# Discover OPC UA Servers with Akri

This article describes how you can deploy sample OPC PLC server containers in Azure and discover them by deploying Akri on your AKS Edge cluster. You'll also deploy a sample anomaly detection app that uses the Akri broker pods to subscribe to the OPC UA variable. This Akri configuration can be used to monitor a barometer, CO detector, and more. However, for this example, the OPC UA variable will represent the PLC values for temperature of a thermostat and any value outside the range of 70-80 degrees is an anomaly.


## Prerequisites

- AKS Edge Essentials cluster up and running.
- Azure subscription and a resource group to deploy OPC PLC servers to.
- Akri only works on Linux: use Linux nodes for this exercise.


If at any point in the demo, you want to dive deeper into OPC UA or clarify a term, you can reference the [online OPC UA specifications](https://reference.opcfoundation.org/v104/).

## (Optional) Creating X.509 v3 Certificates

> [!NOTE]
> If security is not desired, skip to **Creating OPC UA Servers**, as each monitoring broker will use an OPC UA Security Policy of None if it cannot find credentials mounted in its pod.


### Generating certificates

Create three (one for the broker and each server) OPC UA compliant X.509v3 certificates, ensuring that the certificate
contains the [necessary
components](http://opclabs.doc-that.com/files/onlinedocs/QuickOpc/Latest/User%27s%20Guide%20and%20Reference-QuickOPC/Providing%20Client%20Instance%20Certificate.html)
such as an application URI. They should all be signed by a common Certificate Authority (CA). There are many tools for
generating proper certificates for OPC UA, such as the [OPC Foundation's Certificate
Generator](https://github.com/OPCFoundation/Misc-Tools) or openssl (as in this [walk
through](https://github.com/OPCFoundation/Misc-Tools)).


### Creating an opcua-broker-credentials Kubernetes Secret

The OPC UA Client certificate will be passed to the OPC UA Monitoring broker as a Kubernetes Secret mounted as a volume.  

Create a Kubernetes Secret, projecting each certificate/crl/private key with the expected key name (`client_certificate`, `client_key`, `ca_certificate`, and `ca_crl`). Specify the file paths such that they point to the credentials made in the previous section.

```powershell
kubectl create secret generic opcua-broker-credentials `
--from-file=client_certificate=/path/to/AkriBroker/own/certs/AkriBroker\ \[<hash>\].der `
--from-file=client_key=/path/to/AkriBroker/own/private/AkriBroker\ \[<hash>\].pfx `
--from-file=ca_certificate=/path/to/ca/certs/SomeCA\ \[<hash>\].der `
--from-file=ca_crl=/path/to/ca/crl/SomeCA\ \[<hash>\].crl
```

The certificate is mounted to the volume `credentials` at the `mountPath` /etc/opcua-certs/client-pki, as shown in the [OPC UA Configuration Helm template](https://github.com/project-akri/akri/blob/main/deployment/helm/templates/opcua-configuration.yaml). This path is where the brokers expect to find the certificates.

## Creating OPC UA Servers

Now, we must create some OPC UA PLC Servers to discover. Instead of starting from scratch, we deploy OPC PLC server containers. You can read more about the containers and their parameters [here](https://github.com/Azure-Samples/iot-edge-opc-plc). In this demo, we'll use the template provided to deploy OPC PLC server container instances to Azure.

1. Go to Azure IoT Edge OPC PLC sample's [README.md](https://github.com/Azure-Samples/iot-edge-opc-plc) and click **Deploy to Azure**.

2. (Optional) If you're using security, this method can be a little tricky because it requires mounting the folder containing the certificate to the ACI. Follow these [instructions](/azure/container-instances/container-instances-volume-azure-files#create-an-azure-file-share) to create an Azure file share. 

   After creating the Azure file share, add the `plc` folder to the file share in the same structure as described. Then go back to the **Deploy to Azure** page. Click `Edit template`, add the following code inside the "container" section:
   ```
   "volumeMounts": [
                     {
                     "name": "filesharevolume",
                     "mountPath": "/app/pki"
                     }
                  ],
   ```
   Then add the following code inside the "properties" section (same level as "container"):
   ```
   "volumes": [
                  {
                     "name": "filesharevolume",
                     "azureFile": {
                           "shareName": "acishare",
                           "storageAccountName": "<storageAccName>",
                           "storageAccountKey": "<storageAccKey>"
                     }
                  }
                  ]
   ```
   Now the folder `plc` should be mounted to `/app/pki`.

3. Click on **Edit Template** and navigate to `line 172`. Replace the entire line with the following to add the necessary flags for deploying our desired OPC PLC servers:

   If using security:
   ```
   "[concat('./opcplc --pn=50000 --sph --fn=1 --fr=1 --ft=uint --ftl=65 --ftu=85 --ftr=True --aa --sph --ftl=65 --ftu=85 --ftr=True', ' --ph=', variables('aciPlc'), add(copyIndex(), 1), '.', resourceGroup().location, '.azurecontainer.io')]"
   ```
   If not using security:
   ```
   "[concat('./opcplc --pn=50000 --sph --fn=1 --fr=1 --ft=uint --ftl=65 --ftu=85 --ftr=True --aa --sph --ftl=65 --ftu=85 --ftr=True --ut', ' --ph=', variables('aciPlc'), add(copyIndex(), 1), '.', resourceGroup().location, '.azurecontainer.io')]"
   ```

   You can read more about the parameters on the [README.md](https://github.com/Azure-Samples/iot-edge-opc-plc). 

4. Save the template, and fill in the project and instance details. For `Number of Simulations`, put `2` in order to run two OPC PLC servers.

5. Click **Review and Create**, then **Create** to deploy your servers on Azure. 


We've now successfully created two OPC UA PLC servers, each with one fast PLC node, which generates an **unsigned integer** with **lower bound = 65** and **upper bound = 85** at a **rate of 1**. 


## Running Akri

1. Make sure your OPC UA servers are running.

2. Akri depends on `critcl` to track Pod information, and to use it, the Akri Agent must know where the container runtime socket lives. To specify this informatoin, we set a variable `$AKRI_HELM_CRICTL_CONFIGURATION` and add it to each Akri installation.

   If you're using K3s: 
   ```powershell
   $AKRI_HELM_CRICTL_CONFIGURATION="--set kubernetesDistro=k3s"
   ```
   If you're using K8s:
   ```powershell
   $AKRI_HELM_CRICTL_CONFIGURATION="--set kubernetesDistro=k8s"
   ```
3. In order for Akri to discover the servers properly, we need to specify the correct discovery URLs when installing Akri. 
   
   Your discovery URLs will look like `opc.tcp://<FQDN>:50000/` and `opc.tcp://<FQDN>:50001/`. In order to get the FQDNs of your OPC PLC servers, navigate to your deployments in Azure and you'll see the FQDN. Copy and paste your FQDN into your discovery URLs for each server.

   ![Screenshot showing the container instance FQDN in azure portal](media/aks-edge/akri-opcplc-fqdn.png)

4. Now it's time to install Akri using Helm. When installing Akri, we can specify that we want to deploy the OPC UA Discovery Handlers by setting the helm value `opcua.discovery.enabled=true`. 
   
   In this scenario, we'll specify the `Identifier` and `NamespaceIndex` of the NodeID we want the brokers to monitor. In our case that is our temperature variable we made earlier, which has an `Identifier` of `FastUInt1` and `NamespaceIndex`
   of `2`. 
   
   If using security, uncomment `--set opcua.configuration.mountCertificates='true'`.
    
   ```powershell
   helm repo add akri-helm-charts https://project-akri.github.io/akri/
   helm install akri akri-helm-charts/akri `
      $AKRI_HELM_CRICTL_CONFIGURATION `
      --set opcua.discovery.enabled=true `
      --set opcua.configuration.enabled=true `
      --set opcua.configuration.name=akri-opcua-monitoring `
      --set opcua.configuration.brokerPod.image.repository="ghcr.io/project-akri/akri/opcua-monitoring-broker" `
      --set opcua.configuration.brokerPod.image.tag="latest-dev" `
      --set opcua.configuration.brokerProperties.IDENTIFIER='FastUInt1' `
      --set opcua.configuration.brokerProperties.NAMESPACE_INDEX='2' `
      --set opcua.configuration.discoveryDetails.discoveryUrls[0]="opc.tcp://<HOST IP or FQDN>:50000/" `
      --set opcua.configuration.discoveryDetails.discoveryUrls[1]="opc.tcp://<HOST IP or FQDN>:50001/" `
      # --set opcua.configuration.mountCertificates='true'
   ```
       
   >Note: `FastUInt1` is the identifier of the [fast changing node](https://github.com/Azure-Samples/iot-edge-opc-plc#slow-and-fast-changing-nodes) that is provided by the OPC PLC server. 
   
   Learn more about the OPC UA configuration settings [here](https://docs.akri.sh/discovery-handlers/opc-ua).

5. Once Akri is installed, the Akri Agent will discover the two Servers and create an Instance for each Server. Watch two broker pods spin up, one for each Server.

   ```powershell
   kubectl get pods -o wide --watch
   ```

   To inspect more of the elements of Akri:

   * Run `kubectl get crd`, and you should see the CRDs listed.
   * Run `kubectl get akric`, and you should see `akri-opcua-monitoring`. 
   * If the OPC PLC Servers were discovered and pods spun up, the instances can be seen by running `kubectl get akrii` and further inspected by running `kubectl get akrii akri-opcua-monitoring-<ID> -o yaml`

## Deploying an anomaly detection web application as an end consumer of the brokers

A sample anomaly detection web application was created for this end-to-end demo. It has a gRPC stub that calls the brokers' gRPC services, getting the latest temperature value. It then determines whether this value is an outlier to the dataset using the Local Outlier Factor strategy. The dataset is simply a csv with the numbers between 70-80 repeated several times; therefore, any value significantly outside this range will be seen as an outlier. The web application serves as a log, displaying all the temperature values and the address of the OPC UA Server that sent the values. It shows anomaly values in red. The anomalies always have a value of 120 due to how we set up the `DoSimulation` function in the OPC UA Servers. 

1. Deploy the anomaly detection app and watch a pod spin up for the app.  


   ```powershell
   kubectl apply -f https://raw.githubusercontent.com/project-akri/akri/main/deployment/samples/akri-anomaly-detection-app.yaml
   ```

   ```powershell
   kubectl get pods -o wide --watch
   ```

2. Once the pods are running, get your node IP and the service port number of the app.

   ```powershell
   Get-AKSEdgeNodeAddr
   ```
   ```powershell
   kubectl get svc
   ```
3. Navigate to `http://<NODE IP>:<SERVICE PORT NUM>/`. It takes 3 seconds for the site to load, after which, you should see a log of the temperature values, which updates every few seconds. Note how the values are coming from two different DiscoveryURLs, namely the ones for each of the two OPC UA Servers.

![Screenshot showing the anomaly detection app in browser](media/aks-edge/akri-anomaly-detection.png)

## Clean up

1. Delete the anomaly detection application deployment and service.

   ```powershell
    kubectl delete service akri-anomaly-detection-app
    kubectl delete deployment akri-anomaly-detection-app
   ```

2. Delete the OPC UA Monitoring Configuration.

   ```powershell
    kubectl delete akric akri-opcua-monitoring
   ```

3. Bring down the Akri Agent, Controller, and CRDs.

   ```powershell
    helm delete akri
    kubectl delete crd instances.akri.sh
    kubectl delete crd configurations.akri.sh
   ```

4. Delete the OPC UA server deployment by navigating to your container instances and click delete in the Azure portal.



