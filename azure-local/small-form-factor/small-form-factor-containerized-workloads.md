---
title: Run Containerized Workloads on a Provisioned Machine for Small Form Factor Deployments of Azure Local (preview)
description: Learn how to run containerized workloads on a provisioned machine (preview).
author: sipastak
ms.topic: how-to
ms.date: 05/04/2026    
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Run containerized workloads on a provisioned machine (preview)

This article describes how to run containerized workloads on a provisioned machine for small form factor deployments of Azure Local.

Docker is included in the image by default. If you want a lightweight Kubernetes environment, you can also install the open-source K3s distribution.

To compare these options before you choose one, see [Container orchestrators](small-form-factor-container-orchestrators.md).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure that you have:

- A provisioned machine that you can reach over SSH
- Completed [Connect a provisioned machine from the Azure portal](small-form-factor-connect-portal.md)
- A Windows PC on the same local network as the provisioned machine
- Azure CLI installed and signed in

## Choose your approach

- Use Docker if you want the fastest way to run a container on a single device.
- Use K3s if you want Kubernetes APIs, `kubectl` workflows, or a lightweight orchestration layer.
- Use AKS if you want an end-to-end Microsoft stack with a Microsoft managed Kubernetes solution.

## [Docker](#tab/docker)

### Use Docker on the provisioned device

Docker is already installed on the provisioned device image, so you can start immediately.

Docker is a good fit when you want:

- A simple runtime on a single device
- A fast way to validate a containerized application
- A lightweight workflow for troubleshooting or early testing

#### Verify that Docker is installed

Run the following command:

```bash
docker --version
```

#### Pull and run a container from Azure Container Registry

If you don't already have an Azure Container Registry, complete step 1. Otherwise, skip to step 2.

1. Create an Azure Container Registry by following [Quickstart: Create a container registry in the portal](/azure/container-registry/container-registry-get-started-portal).

   > [!NOTE]
   > Use the same **Location** and **Resource Group** as your provisioned machine.

1. Sign in to your registry from the terminal:

   ```bash
   docker login <YOUR_REGISTRY_NAME>.azurecr.io
   ```

   Replace `YOUR_REGISTRY_NAME` with your registry name. You can find the authentication server name on the **Overview** page of the registry in the Azure portal.

1. When prompted for credentials, open the Azure portal and select **Access keys** under **Settings** for your container registry.

1. Enable **Admin user** if it isn't already enabled.

1. Copy the **Username** value and paste it into the terminal.

1. Select **Show**, copy the password, and paste it into the terminal.

1. After sign-in succeeds, Docker displays `Login Succeeded`.

   > [!NOTE]
   > Docker stores credentials in `~/.docker/config.json`. For production workloads, consider using an Azure Container Registry credential helper instead.

1. Pull, tag, and push the public `hello-world` test image. Replace `YOUR_REGISTRY_NAME` with your registry name.

   ```bash
   docker pull hello-world
   docker tag hello-world <YOUR_REGISTRY_NAME>.azurecr.io/hello-world:latest
   docker push <YOUR_REGISTRY_NAME>.azurecr.io/hello-world:latest
   ```

   > [!NOTE]
   > To confirm the push succeeded, open the registry in the Azure portal, select **Services** > **Repositories**, and verify that `hello-world` appears.

1. On your provisioned machine, pull and run the image from Container Registry.

   ```bash
   docker pull <YOUR_REGISTRY_NAME>.azurecr.io/hello-world:latest
   docker run <YOUR_REGISTRY_NAME>.azurecr.io/hello-world:latest
   ```

1. If the container runs successfully, you see the standard `Hello from Docker!` output.

      :::image type="content" source="media/small-form-factor-docker-output.png" alt-text="Screenshot showing the Hello from Docker output." border="true" lightbox="media/small-form-factor-docker-output.png":::

1. To list all containers, run:

   ```bash
   docker ps -a
   ```

#### Review the Docker deployment

Confirm that:

- Docker is installed on the provisioned device.
- Docker sign-in to Container Registry succeeds.
- The `hello-world` image is pushed to your registry.
- The provisioned machine pulls the image from Container Registry successfully.
- The container runs and displays `Hello from Docker!`.

## [K3s](#tab/k3s)

### Install and use open source K3s

If you want a lightweight Kubernetes environment on the device, install K3s.

#### Connect to the machine over SSH

Follow the SSH steps in [Connect a provisioned machine from the Azure portal](small-form-factor-connect-portal.md#connect-to-the-machine-over-ssh).

#### Install K3s

To remotely install open source K3s, connect the cluster to Azure Arc, and configure Azure RBAC, use [setup-k3s-arc.sh](https://github.com/Azure-Samples/AzureLocal/blob/main/small-form-factor/setup-k3s-arc.sh). Otherwise, follow the steps in this section.

1. Install K3s and disable Traefik:

   ```cmd
   curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_SELINUX_RPM=true sh -s - --disable traefik
   ```

1. Create a kubeconfig file that the authenticated user can access:

   ```cmd
   K3S_KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
   USER_HOME=$(eval echo ~${SUDO_USER:-$USER})
   USER_NAME=${SUDO_USER:-$USER}
   GROUP_NAME=$(id -gn "$USER_NAME")

   mkdir -p $USER_HOME/.kube
   sudo cp $K3S_KUBECONFIG $USER_HOME/.kube/config
   sudo chown $USER_NAME:$GROUP_NAME $USER_HOME/.kube/config
   chmod 600 $USER_HOME/.kube/config

   echo "export KUBECONFIG=$USER_HOME/.kube/config" >> $USER_HOME/.bashrc
   export KUBECONFIG=$USER_HOME/.kube/config
   ```

1. Display the kubeconfig:

   ```bash
   cat $USER_HOME/.kube/config
   ```

1. Copy the kubeconfig output. You use it on your Windows PC.

> [!NOTE]
> Installing K3s requires elevated permissions because it installs services and writes system files.

#### Prepare the kubeconfig on your Windows PC

1. Install `kubectl` if it isn't installed already. For guidance, see [Install and Set Up kubectl on Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/).

1. Create a local kubeconfig file, such as `~/.kubeconfig`.

1. Paste the kubeconfig output into the file.

1. Replace the server IP address in the kubeconfig with the provisioned machine's IP address on your local network.

1. Open Command Prompt and set the `KUBECONFIG` environment variable:

    ```bash
    set KUBECONFIG=/your/path/to/.kubeconfig
    ```

1. Verify that `kubectl` can read the kubeconfig:

    ```bash
    kubectl config get-contexts
    kubectl config current-context
    ```

1. Update the cluster API server endpoint to use the provisioned machine IP address.

   The kubeconfig generated by K3s uses a local loopback address that only works from inside the provisioned machine. Replace it with the machine's reachable IP address on your local network.

   Example:

    ```bash
    kubectl config set-cluster default --server=https://<IP_ADDRESS>
    ```

> [!IMPORTANT]
> The kubeconfig generated by K3s points to a local endpoint on the device. Before you use it from your Windows PC, replace the server address with an IP address that your PC can reach.

#### Verify cluster access

From your Windows PC, run:

```cmd
kubectl get nodes
```

If the command succeeds, your workstation can reach the K3s API server.

#### Connect the K3s cluster to Azure Arc

From your Windows PC, run:

```azurecli
az connectedk8s connect --resource-group <ANY_RESOURCE_GROUP> --name <ANY_NAME>
```

This command deploys the required components to the K3s cluster and creates an Arc-enabled Kubernetes resource in Azure.

> [!TIP]
> Keep a second Cloud Shell session open if you want to cross-check resource details in the Azure portal during onboarding.

#### Review the K3s deployment

Confirm that:

- K3s is installed on the provisioned machine.
- `kubectl get nodes` returns the local cluster.
- Your Windows `kubeconfig` points to the machine IP address.
- The `az connectedk8s connect` command completes successfully.


## [AKS](#tab/AKS)

### Deploy and use AKS

Follow the [AKS on bare metal](/azure/aks/aksarc/aks-bare-metal-create-cluster-portal) directions to deploy an AKS cluster running on a small form factor deployment of Azure Local.

---


## Next steps

- Continue to [Deploy applications](small-form-factor-deploy-applications.md).
