---
title: Create and access AKS hybrid clusters provisioned from Azure using Az CLI
description: Create and access AKS hybrid clusters provisioned from Azure using Az CLI
author: abha
ms.author: abha
ms.topic: how-to
ms.date: 09/29/2022
---

# How to create AKS hybrid clusters using Az CLI

> Applies to: Windows Server 2019, Windows Server 2022, Azure Stack HCI

In this how-to guide, you'll

- Create an AKS hybrid cluster using Azure CLI. The cluster will be Azure Arc-connected by default
- While creating the cluster, you will provide an Azure AD group that contains the list of Azure AD users with Kubernetes cluster administrator access
- Access the AKS hybrid cluster using `kubectl` and your Azure AD identity
- Run a sample multi-container application with a web front-end and a Redis instance in the AKS hybrid cluster


## Before you begin

- Before you begin, make sure you've got the following details from your on-premises infrastructure administrator:
    - **Azure subscription ID** - The Azure subscription ID where Azure Resource Bridge, AKS hybrid extension and Custom Location has been created.
    - **Custom Location ID** - Azure Resource Manager ID of the custom location. Your infrastructure admin should give you the ARM ID of the custom location. This is a required parameter to create AKS hybrid clusters. You can also get the ARM ID using `az customlocation show --name <custom location name> --resource-group <azure resource group> --query "id" -o tsv` if you know the resource group where the custom location has been created.
    - **AKS hybrid vnet ID** - Azure Resource Manager ID of the Azure hybridaks vnet. Your admin should give you the ID of the Azure vnet. This is a required parameter to create AKS clusters. You can also get the Azure Resource Manager ID using `az hybridaks vnet show --name <vnet name> --resource-group <azure resource group> --query "id" -o tsv` if you know the resource group where the Azure vnet has been created.

- You can run the following steps in a local Azure CLI. Make sure you have the latest version of [Az CLI installed](/cli/azure/install-azure-cli) on your local machine. You can also choose to upgrade your Az CLI version using `az upgrade`.

- In order to connect to the AKS hybrid cluster from anywhere, you need to create an **Azure AD group** and add members to it. All the members in the Azure AD group will have cluster administrator access to the AKS hybrid cluster. **Make sure to add yourself to the Azure AD group.** If you do not add yourself, you will not be able to access the AKS hybrid cluster using `kubectl`. To learn more about creating Azure AD groups and adding users, read [create Azure AD groups using Azure Portal](/azure/active-directory/fundamentals/active-directory-groups-create-azure-portal).

- [Download and install Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) on your local machine. The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters. You can use kubectl to deploy applications, inspect and manage cluster resources, and view logs. 

## Install the Azure hybridAKS extension

Run the following command to install the AKS hybrid extension:

```azurecli
az extension add -n hybridaks
```

## Create an AKS hybrid cluster

Use the `az hybridaks create` command to create an AKS hybrid cluster. Make sure you login to Azure before running this command. If you have multiple Azure subscriptions, select the appropriate subscription ID using the [az account set](/cli/azure/account?view=azure-cli-latest#az-account-set) command.

```azurecli
az hybridaks create -n <aks-hybrid cluster name> -g <Azure resource group> --custom-location <ARM ID of the custom location> --vnet-ids <ARM ID of the Azure hybridaks vnet> --aad-admin-group-object-ids <comma seperated list of Azure AD group IDs> --generate-ssh-keys 
```

After a few minutes, the command completes and returns JSON-formatted information about the cluster.

## Connect to the AKS hybrid cluster

Now that you've created the cluster, connect to your AKS hybrid cluster by running the `az hybridaks proxy` command from your local machine. Make sure you login to Azure before running this command. If you have multiple Azure subscriptions, select the appropriate subscription ID using the [az account set](/cli/azure/account?view=azure-cli-latest#az-account-set)] command. 

This command downloads the kubeconfig of your AKS hybrid cluster to your local machine and opens a proxy connection channel to your on-premises AKS hybrid cluster. The channel is open for as long as this command is running. Let this command run for as long as you want to access your cluster. If this command times out, close the CLI window, open a fresh one and run the command again. 

```azurecli
az hybridaks proxy --name <aks-hybrid cluster name> --resource-group <Azure resource group> --file .\aks-hybrid-kube-config
```

Expected output:

```output
Proxy is listening on port 47011
Merged "aks-workload" as current context in .\aks-hybrid-kube-config
Start sending kubectl requests on 'aks-workload' context using kubeconfig at .\aks-hybrid-kube-config
Press Ctrl+C to close proxy.
```

Keep this session running and connect to your AKS hybrid cluster from a different terminal/command prompt. Verify that you can connect to your AKS hybrid cluster by running the `kubectl get` command. This command returns a list of the cluster nodes.

```azurecli
kubectl get nodes -A --kubeconfig .\aks-hybrid-kube-config
```

The following output example shows the node created in the previous steps. Make sure the node status is *Ready*:

```output
NAME              STATUS   ROLES                  AGE     VERSION
moc-l36ivj6mjx0   Ready    control-plane,master   6m25s   v1.21.9
moc-lfdr4ssdabk   Ready    <none>                 4m38s   v1.21.9
```

## Deploy the application

A [Kubernetes manifest file](kubernetes-concepts.md#deployments) defines a cluster's desired state, such as which container images to run.

You will use a manifest to create all objects needed to run the [Azure Vote application](https://github.com/Azure-Samples/azure-voting-app-redis.git). This manifest includes two [Kubernetes deployments](kubernetes-concepts.md#deployments):

* The sample Azure Vote Python applications.
* A Redis instance.

Two [Kubernetes Services](concepts-container-networking.md#kubernetes-services) are also created:

* An internal service for the Redis instance.
* An external service to access the Azure Vote application from the internet.

Create a file named `azure-vote.yaml` and copy in the following manifest.

```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: azure-vote-back
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: azure-vote-back
      template:
        metadata:
          labels:
            app: azure-vote-back
        spec:
          nodeSelector:
            "kubernetes.io/os": linux
          containers:
          - name: azure-vote-back
            image: mcr.microsoft.com/oss/bitnami/redis:6.0.8
            env:
            - name: ALLOW_EMPTY_PASSWORD
              value: "yes"
            resources:
              requests:
                cpu: 100m
                memory: 128Mi
              limits:
                cpu: 250m
                memory: 256Mi
            ports:
            - containerPort: 6379
              name: redis
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: azure-vote-back
    spec:
      ports:
      - port: 6379
      selector:
        app: azure-vote-back
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: azure-vote-front
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: azure-vote-front
      template:
        metadata:
          labels:
            app: azure-vote-front
        spec:
          nodeSelector:
            "kubernetes.io/os": linux
          containers:
          - name: azure-vote-front
            image: mcr.microsoft.com/azuredocs/azure-vote-front:v1
            resources:
              requests:
                cpu: 100m
                memory: 128Mi
              limits:
                cpu: 250m
                memory: 256Mi
            ports:
            - containerPort: 80
            env:
            - name: REDIS
              value: "azure-vote-back"
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: azure-vote-front
    spec:
      type: LoadBalancer
      ports:
      - port: 80
      selector:
        app: azure-vote-front
```

Deploy the application using the [kubectl apply](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply) command and specify the name of your YAML manifest:

```azurecli
kubectl apply -f azure-vote.yaml --kubeconfig .\aks-hybrid-kube-config
```

The following example resembles output showing the successfully created deployments and services:

```output
deployment "azure-vote-back" created
service "azure-vote-back" created
deployment "azure-vote-front" created
service "azure-vote-front" created
```

## Test the application

When the application runs, a Kubernetes service exposes the application front-end to the internet. This process can take a few minutes to complete.

Monitor progress using the `kubectl get service` command with the `--watch` argument.

```azurecli
kubectl get service azure-vote-front --watch --kubeconfig .\aks-hybrid-kube-config
```

The **EXTERNAL-IP** output for the `azure-vote-front` service will initially show as *pending*.

```output
NAME               TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
azure-vote-front   LoadBalancer   10.0.37.27   <pending>     80:30572/TCP   6s
```

Once the **EXTERNAL-IP** address changes from *pending* to an actual public IP address, use `CTRL-C` to stop the `kubectl` watch process. The following example output shows a valid public IP address assigned to the service:

```output
azure-vote-front   LoadBalancer   10.0.37.27   52.179.23.131   80:30572/TCP   2m
```

To see the Azure Vote app in action, open a web browser to the external IP address of your service.

## Delete the AKS hybrid cluster 

Run the `az hybridaks delete` command to clean up the AKS hybrid cluster you created.

```azurecli
az hybridaks delete --resource-group <resource group name> --name <aks hybrid cluster name>
```

## Next steps

- [Troubleshoot and known issues with AKS hybrid cluster provisioning from Azure](troubleshoot-aks-hybrid-preview.md)
