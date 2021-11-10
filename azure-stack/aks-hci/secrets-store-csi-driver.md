---
title: Kubernetes Secrets Store CSI Driver integration with AKS on Azure Stack HCI
description: Learn how to use the Azure Key Vault Provider for Secrets Store CSI Driver to integrate secrets stores with Azure Kubernetes Service (AKS) on Azure Stack HCI.
ms.topic: how-to
ms.date: 11/10/2021
ms.author: jeguan
author: jessicaguan
---

# Use the Azure Key Vault Provider for Kubernetes Secrets Store CSI Driver with AKS on Azure Stack HCI

> [!NOTE]
> AKS on Azure Stack HCI preview features are available on a self-service, opt-in basis. Previews are provided "as is" and "as available," and it's recommended that you do not use these features in production scenarios. AKS on Azure Stack HCI preview features are partially covered by customer support on a best-effort basis.

The Kubernetes Secrets Store CSI driver integrates secrets stores with Kubernetes through a [Container Storage Interface (CSI) volume](https://kubernetes-csi.github.io/docs/). Integrating the Secrets Store CSI driver with AKS on Azure Stack HCI allows you to mount secrets, keys, and certificates as a volume, and the data is mounted into the container's file system. 

With the Secrets Store CSI driver, you can also integrate a key vault with one of the supported providers, such as [Azure Key Vault](/azure/key-vault/general/overview).

## Before you begin

- You need to have an existing deployment of AKS on Azure Stack HCI with an existing workload cluster. If you do not, follow this [Quickstart](./kubernetes-walkthrough-powershell.md) to deploy it.
- If you are running Linux clusters, they need to be on version 1.16.0 or later.
- If you are running Windows clusters, they need to be on version 1.18.0 or later.
- You need have [Helm](https://helm.sh/) installed. 
- You need `kubectl` installed.
- You need to have the latest version of the [Azure CLI installed](/cli/azure/install-azure-cli).
- You need to have an Azure account and subscription.

## Access your clusters using kubectl
Run the following command to access your cluster through `kubectl`. Replace the value of `-name` in the command with your existing cluster name, which will use the specified cluster's `kubeconfig` file as the default `kubeconfig` file for `kubectl`.

```powershell
Get-AksHciCredential -name mycluster
```

## Install the Secrets Store CSI Driver

To install the Secrets Store CSI Driver, run the following Helm commands:

```powershell
helm repo add csi-secrets-store-provider-azure https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/chartsy
```

The following command installs both the Secrets Store CSI Driver and the Azure Key Vault provider:

```powershell
helm install csi csi-secrets-store-provider-azure/csi-secrets-store-provider-azure --namespace kube-system
```

> [!NOTE]
> It's recommended to install the Secrets Store CSI driver and Azure Key Vault provider in the `kube-system` namespace. In this tutorial, the `kube-system` namespace is used for all instances.

## Verify the Secrets Store CSI driver and Azure Key Vault provider are successfully installed

Check your running pods to make sure that the Secrets Store CSI driver and the Azure Key Vault provider are installed by running the following command:

```powershell
kubectl get pods -l app=secrets-store-csi-driver -n kube-system
```

**Example Output**

```
NAME                             READY   STATUS    RESTARTS   AGE
secrets-store-csi-driver-spbfq   3/3     Running   0          3h52m
```

```powershell
kubectl get pods -l app=csi-secrets-store-provider-azure -n kube-system
```

**Example Output**
```
NAME                                         READY   STATUS    RESTARTS   AGE
csi-csi-secrets-store-provider-azure-tpb4j   1/1     Running   0          3h52m
```

## Create or use an existing Azure Key Vault and set up the secrets

You need an Azure Key Vault resource that contains your secret data. You can use an existing Azure Key Vault resource or create a new one. If you need to create an Azure Key Vault resource, run the following command. Make sure you are logged in by running `az login` and logging in with your Azure credentials and to change the following values to your environment.

```powershell
az keyvault create -n <keyvault-name> -g <resourcegroup-name> -l eastus
```

Azure Key Vault can store keys, secrets, and certificates. In this example, a plain text secret called `ExampleSecret` is configured.

```powershell
az keyvault secret set --vault-name <keyvault-name> -n ExampleSecret --value MyAKSHCIExampleSecret
```

## Create an identity on Azure

Use a Service Principal to access the Azure Key Vault instance that was created in the previous step. You should take note of the outputs of the following commands as the Client Secret and Client ID will be used in the next steps.

The following command provides the Client Secret:

```powershell
az ad sp create-for-rbac --skip-assignment --name http://secrets-store-test --query 'password' -otsv
```

The follow command provides the Client ID:

```powershell
az ad sp show --id http://secrets-store-test --query 'appId' -otsv
```

## Provide the identity to access Azure Key Vault

Use the values from the previous step to set permissions.

```powershell
az keyvault set-policy -n <keyvault-name> --secret-permissions get --spn <client-id>
```

## Create the Kubernetes Secret with credentials

To create the Kubernetes secret with the Service Principal credentials, run the following command. Replace the following values with the Client ID and Client Secret from the previous step.

```powershell
kubectl create secret generic secrets-store-creds --from-literal clientid=<client-id> --from-literal clientsecret=<client-secret>

kubectl label secret secrets-store-creds secrets-store.csi.k8s.io/used=true
```

## Create and apply your own SecretProviderClass object

To use and configure the Secrets Store CSI driver for your AKS cluster, create a `SecretProviderClass` custom resource. Ensure the `objects` array matches the objects you've store in the Azure Key Vault instance:

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1alpha1
kind: SecretProviderClass
metadata:
  name: <keyvault-name>                  # The name of the Azure Key Vault
  namespace: kube-system
spec:
  provider: azure
  parameters:
    keyvaultName: "<keyvault-name>"       # The name of the Azure Key Vault
    useVMManagedIdentity: "false"         
    userAssignedIdentityID: "false" 
    cloudName: ""                         # [OPTIONAL for Azure] if not provided, Azure environment will default to AzurePublicCloud 
    objects:  |
      array:
        - |
          objectName: <secret-name>       # In this example, 'ExampleSecret'   
          objectType: secret              # Object types: secret, key or cert
          objectVersion: ""               # [OPTIONAL] object versions, default to latest if empty
    tenantId: "<tenant-id>"               # the tenant ID containing the Azure Key Vault instance
```

## Apply the SecretProviderClass to your cluster

Deploy the `SecretProviderClass` you created by running the following command:

```powershell
kubectl apply -f ./new-secretproviderclass.yaml --namespace 
```

## Update and apply your cluster's deployment YAML file

To ensure your cluster is using the new custom resource, update the deployment YAML file. For example:

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: busybox-secrets-store-inline
spec:
  containers:
  - name: busybox
    image: k8s.gcr.io/e2e-test-images/busybox:1.29
    command:
      - "/bin/sleep"
      - "10000"
    volumeMounts:
    - name: secrets-store-inline
      mountPath: "/mnt/secrets-store"
      readOnly: true
  volumes:
    - name: secrets-store-inline
      csi:
        driver: secrets-store.csi.k8s.io
        readOnly: true
        volumeAttributes:
          secretProviderClass: "<keyvault-name>"
        nodePublishSecretRef:                       # Only required when using service principal mode
          name: secrets-store-creds                 # Only required when using service principal mode
```

Then, apply the updated deployment to the cluster:

```powershell
kubectl apply -f ./my-deployment.yaml 
```

## Validate deployment

To show the secrets held in `secrets-store`, run the following command:

```powershell
kubectl exec busybox-secrets-store-inline -- ls /mnt/secrets-store/ --namespace kube-system
```

If successful, the output should show the name of the secret. In this example, it should display the output below:

```Output
ExampleSecret
```

To show the test secret held in `secrets-store`, run the following command:

```powershell
kubectl exec busybox-secrets-store-inline -- cat /mnt/secrets-store/ExampleSecret --namespace kube-system
```

If successful, the output should show the value of the secret. In this example, it should show the output below.

```Output
MyAKSHCIExampleSecret
```

## Next steps 

- [Deploy Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).