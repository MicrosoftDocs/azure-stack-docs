---
title: Create Kubernetes clusters using Azure CLI (preview)
description: Learn how to create Kubernetes clusters in Azure Stack HCI using Azure CLI.
ms.topic: how-to
author: sethmanheim
ms.date: 11/27/2023
ms.author: sethm 
ms.lastreviewed: 11/27/2023
ms.reviewer: guanghu

---

# Create Kubernetes clusters using Azure CLI (preview)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article describes how to create Kubernetes clusters in Azure Stack HCI using Azure CLI. The workflow is as follows:

1. Create a Kubernetes cluster in Azure Stack HCI 23H2 using Azure CLI. The cluster is Azure Arc-connected by default.
1. While creating the cluster, you provide a Microsoft Entra group that contains the list of Microsoft Entra users with Kubernetes cluster administrator access.
1. Access the cluster using kubectl and your Microsoft Entra ID.
1. Run a sample multi-container application with a web front end and a Redis instance in the cluster.

## Before you begin

- Before you begin, make sure you have the following details from your on-premises infrastructure administrator:
  - **Azure subscription ID** - The Azure subscription ID where Azure Stack HCI is used for deployment and registration.
  - **Custom Location ID** - Azure Resource Manager ID of the custom location. Your infrastructure admin should give you the Resource Manager ID of the custom location. This parameter is required in order to create AKS hybrid clusters. You can also get the Resource Manager ID using `az customlocation show --name "<custom location name>" --resource-group <azure resource group> --query "id" -o tsv`, if the infrastructure admin provides a custom location name and resource group name. These input values are customized during the Azure Stack HCI cluster deployment.
  - **Network ID** - Azure Resource Manager ID of the Azure AKS Arc vnet. Your admin should give you the ID of the AKS Arc vnet. This parameter is required in order to create Kubernetes clusters. You can also get the Azure Resource Manager ID using `az akshybrid vnet show --name "<vnet name>" --resource-group <azure resource group> --query "id" -o tsv` if you know the resource group in which the Azure Arc vnet was created.
- You can run the steps in this article in a local Azure CLI instance. Make sure you have the latest version of [Az CLI](/cli/azure/install-azure-cli) on your local machine. You can also choose to upgrade your Az CLI version using `az upgrade`.
- To connect to the AKS Arc cluster from anywhere, create a Microsoft Entra group and add members to it. All the members in the Microsoft Entra group have cluster administrator access to the AKS hybrid cluster. Make sure to add yourself as a member to the Microsoft Entra group. If you don't add yourself, you cannot access the AKS Arc cluster using kubectl. For more information about creating Microsoft Entra groups and adding users, see [Manage Microsoft Entra groups and group membership](/entra/fundamentals/how-to-manage-groups).
- [Download and install kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) on your local machine. The Kubernetes command-line tool, kubectl, enables you to run commands against Kubernetes clusters. You can use kubectl to deploy applications, inspect and manage cluster resources, and view logs.

## Install the Azure CLI extension

Run the following command to install the necessary Azure CLI extensions:

```azurecli
az extension add -n akshybrid --upgrade
az extension add -n customlocation --upgrade
az extension add -n connectedk8s --upgrade
```

## Create an AKS Arc cluster

Use the `az akshybrid create` command to create an AKS Arc cluster. Make sure you sign in to Azure before running this command. If you have multiple Azure subscriptions, select the appropriate subscription ID using the [az account set](/cli/azure/account#az-account-set) command.

```azurecli
az akshybrid create -n $aksclustername -g $resource_group --custom-location $customlocationID --vnet-ids $vnetId --aad-admin-group-object-ids $aadgroupID --generate-ssh-keys --load-balancer-count 1
```

After a few minutes, the command completes and returns JSON-formatted information about the cluster.

## Connect to the Kubernetes cluster

Now you can connect to your Kubernetes cluster by running the `az connectedk8s proxy` command from your local machine. Make sure you sign in to Azure before running this command. If you have multiple Azure subscriptions, select the appropriate subscription ID using the [az account set](/cli/azure/account#az-account-set) command.

This command downloads the kubeconfig of your Kubernetes cluster to your local machine and opens a proxy connection channel to your on-premises Kubernetes cluster. The channel is open for as long as the command runs. Let this command run for as long as you want to access your cluster. If it times out, close the CLI window, open a fresh one, then run the command again.

You must have Contributor permissions on the resource group that hosts the Kubernetes cluster in order to run the following command successfully:

```azurecli
az connectedk8s proxy --name $aksclustername --resource-group $resource_group --file .\aks-arc-kube-config
```

Expected output:

```output
Proxy is listening on port 47011
Merged "aks-workload" as current context in .\\aks-arc-kube-config
Start sending kubectl requests on 'aks-workload' context using
kubeconfig at .\\aks-arc-kube-config
Press Ctrl+C to close proxy.
```

Keep this session running and connect to your Kubernetes cluster from a different terminal/command prompt. Verify that you can connect to your Kubernetes cluster by running the kubectl get command. This command returns a list of the cluster nodes:

```azurecli
kubectl get node -A --kubeconfig .\aks-arc-kube-config
```

The following output example shows the node created in the previous steps. Make sure the node status is **Ready**:

```output
NAME             STATUS ROLES                AGE VERSION
moc-l0ttdmaioew  Ready  control-plane,master 34m v1.24.11
moc-ls38tngowsl  Ready  <none>               32m v1.24.11
```

## Deploy the application

A [Kubernetes manifest file](kubernetes-concepts.md#deployments) defines a cluster's desired state, such as which container images to run.

You can use a manifest to create all objects needed to run the [Azure Vote application](https://github.com/Azure-Samples/azure-voting-app-redis). This manifest includes two [Kubernetes deployments](kubernetes-concepts.md#deployments):

- The sample Azure Vote Python applications.
- A Redis instance.

Two [Kubernetes services](concepts-container-networking.md#kubernetes-services) are also created:

- An internal service for the Redis instance.
- An external service to access the Azure Vote application from the internet.

Create a file named **azure-vote.yaml**, and copy in the following manifest:

```yml
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

Deploy the application using the [kubectl apply](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply) command and specify the name of your YAML:

```azurecli
kubectl apply -f azure-vote.yaml --kubeconfig .\\aks-arc-kube-config
```

The following example output shows the successfully created deployments and services:

```output
deployment "azure-vote-back" created
service "azure-vote-back" created
deployment "azure-vote-front" created
service "azure-vote-front" created
```

## Test the application

When the application runs, a Kubernetes service exposes the application frontend to the internet. This process can take a few minutes to complete.

Monitor progress using the kubectl get service command with the `--watch` argument.

```azurecli
kubectl get service azure-vote-front --watch --kubeconfig .\aks-arc-kube-config
```

The EXTERNAL-IP output for the azure-vote-front service initially shows as **pending**.

```output
NAME             TYPE         CLUSTER-IP EXTERNAL-IP PORT(S)      AGE
azure-vote-front LoadBalancer 10.0.37.27 <pending>   80:30572/TCP 6s
```

Once the EXTERNAL-IP address changes from **pending** to an actual public IP address, use CTRL-C to stop the kubectl watch process. The following example output shows a valid public IP address assigned to the service:

```output
azure-vote-front LoadBalancer 10.0.37.27 52.179.23.131 80:30572/TCP 2m
```

To see the Azure Vote app in action, open a web browser to the external IP address of your service.

## Delete the cluster

Run the `az akshybrid delete` command to clean up the cluster you created:

```azurecli
az akshybrid delete --resource-group $aksclustername --name $resource_group
```

## Next steps

- [Troubleshoot and known issues with AKS Arc cluster provisioning from Azure](aks-known-issues.md)
