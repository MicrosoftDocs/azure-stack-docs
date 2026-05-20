---
title: Run Containerized Workloads on a Provisioned Machine (preview)
description: Learn how to run containerized workloads on a provisioned machine (preview).
author: sipastak
ms.topic: how-to
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Run containerized workloads on a provisioned machine (preview)

This article describes how to run containerized workloads on a provisioned machine.

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

# [Docker](#tab/docker)

## Use Docker on the provisioned device

Docker is already installed on the provisioned device image, so you can start immediately.

Docker is a good fit when you want:

- A simple runtime on a single device
- A fast way to validate a containerized application
- A lightweight workflow for troubleshooting or early testing

### Verify that Docker is installed

Run the following command:

```azurecli
docker --version
```

### Pull and run a container from Azure Container Registry

If you don't already have an Azure Container Registry (ACR), complete step 1. Otherwise, skip to step 2.

1. Create an Azure Container Registry by following [Quickstart: Create a container registry in the portal](/azure/container-registry/container-registry-get-started-portal).

   > [!NOTE]
   > Use the same **Location** and **Resource Group** as your provisioned machine.

1. Sign in to your registry from the terminal:

   ```azurecli
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

   ```azurecli
   docker pull hello-world
   docker tag hello-world <YOUR_REGISTRY_NAME>.azurecr.io/hello-world:latest
   docker push <YOUR_REGISTRY_NAME>.azurecr.io/hello-world:latest
   ```

   > [!NOTE]
   > To confirm the push succeeded, open the registry in the Azure portal, select **Services** > **Repositories**, and verify that `hello-world` appears.

1. On your provisioned machine, pull and run the image from ACR.

   ```azurecli
   docker pull <YOUR_REGISTRY_NAME>.azurecr.io/hello-world:latest
   docker run <YOUR_REGISTRY_NAME>.azurecr.io/hello-world:latest
   ```

1. If the container runs successfully, you see the standard `Hello from Docker!` output.

      :::image type="content" source="media/small-form-factor-docker-output.png" alt-text="Screenshot showing the Hello from Docker output." border="true" lightbox="media/small-form-factor-docker-output.png":::

1. To list all containers, run:

   ```azurecli
   docker ps -a
   ```

### Review the deployment

Confirm that:

- Docker is installed on the provisioned device.
- Docker sign-in to ACR succeeds.
- The `hello-world` image is pushed to your registry.
- The provisioned machine pulls the image from ACR successfully.
- The container runs and displays `Hello from Docker!`.

# [K3s](#tab/k3s)

## Install and use open source K3s

If you want a lightweight Kubernetes environment on the device, install K3s.

### Connect to the machine over SSH

Follow the SSH steps in [Connect a provisioned machine from the Azure portal](small-form-factor-connect-portal.md#connect-to-the-machine-over-ssh).

### Install K3s

To remotely install open source K3s, connect the cluster to Azure Arc, and configure Azure RBAC, use the K3s Install + Azure Arc Connected Cluster Setup script. Otherwise, follow the steps in this section.

<details>
<summary>Expand this section to view the K3s Install + Azure Arc Connected Cluster Setup script.</summary>

```
#!/bin/bash
set -euo pipefail

###############################################################################
# K3s Install + Azure Arc Connected Cluster Setup Script
#
# This script:
#   1. Installs K3s on the local device
#   2. Configures kubeconfig for local API server access
#   3. Pulls the Azure CLI container image (no host install required)
#   4. Connects the K3s cluster to Azure Arc (az connectedk8s connect)
#   5. Enables Azure RBAC on the Arc-enabled cluster
#   6. Configures the K3s API server webhooks for Azure RBAC
#
# The Azure CLI runs entirely inside a container using K3s's bundled
# containerd runtime — nothing is installed on the host OS.
#
# Prerequisites:
#   - Linux device with root/sudo access
#   - Internet connectivity
#   - An Azure subscription (you'll be prompted to log in via device code)
#
# Usage:
#   chmod +x setup-k3s-arc.sh
#   sudo ./setup-k3s-arc.sh
#
# Or override defaults with environment variables:
#   RESOURCE_GROUP=myRG CLUSTER_NAME=myCluster LOCATION=eastus sudo -E ./setup-k3s-arc.sh
###############################################################################

# ── Configurable variables (override via environment) ────────────────────────
RESOURCE_GROUP="${RESOURCE_GROUP:-arc-k3s-rg}"
CLUSTER_NAME="${CLUSTER_NAME:-arc-k3s-cluster}"
LOCATION="${LOCATION:-eastus}"
K3S_VERSION="${K3S_VERSION:-}"            # leave empty for latest stable
ONBOARDING_TIMEOUT="${ONBOARDING_TIMEOUT:-1200}"
AZ_CLI_IMAGE="${AZ_CLI_IMAGE:-mcr.microsoft.com/azure-cli:latest}"
AZ_STATE_DIR="/tmp/az-cli-state"          # persists Azure login state between runs

# ── Helper functions ─────────────────────────────────────────────────────────
log()  { echo -e "\n\033[1;32m[INFO]\033[0m  $*"; }
warn() { echo -e "\n\033[1;33m[WARN]\033[0m  $*"; }
err()  { echo -e "\n\033[1;31m[ERROR]\033[0m $*" >&2; exit 1; }

# Run az CLI commands inside a container via K3s's bundled containerd.
# Mounts kubeconfig and a persistent Azure state dir so login survives
# across invocations.
run_az() {
  local container_id="az-cli-$(date +%s%N)"
  k3s ctr run \
    --rm \
    --net-host \
    --mount "type=bind,src=/etc/rancher/k3s/k3s.yaml,dst=/root/.kube/config,options=rbind:ro" \
    --mount "type=bind,src=${AZ_STATE_DIR},dst=/root/.azure,options=rbind:rw" \
    "${AZ_CLI_IMAGE}" \
    "${container_id}" \
    az "$@"
}

# Interactive variant for commands that need TTY (e.g., device-code login)
run_az_interactive() {
  local container_id="az-cli-$(date +%s%N)"
  k3s ctr run \
    --rm \
    --tty \
    --net-host \
    --mount "type=bind,src=/etc/rancher/k3s/k3s.yaml,dst=/root/.kube/config,options=rbind:ro" \
    --mount "type=bind,src=${AZ_STATE_DIR},dst=/root/.azure,options=rbind:rw" \
    "${AZ_CLI_IMAGE}" \
    "${container_id}" \
    az "$@"
}

check_root() {
  if [[ $EUID -ne 0 ]]; then
    err "This script must be run as root (use sudo)."
  fi
}

# ── Step 1: Install K3s ─────────────────────────────────────────────────────
install_k3s() {
  log "Step 1/6 — Installing K3s..."

  if command -v k3s &>/dev/null; then
    warn "K3s is already installed ($(k3s --version)). Skipping install."
  else
    local install_env="INSTALL_K3S_SKIP_SELINUX_RPM=true"
    if [[ -n "${K3S_VERSION}" ]]; then
      install_env="$install_env INSTALL_K3S_VERSION=${K3S_VERSION}"
    fi
    curl -sfL https://get.k3s.io | env $install_env sh -s - --disable traefik
    log "K3s installed successfully."
  fi

  # Wait for the K3s node to be Ready
  log "Waiting for K3s node to become Ready..."
  local retries=30
  while (( retries > 0 )); do
    if k3s kubectl get nodes 2>/dev/null | grep -q ' Ready'; then
      log "K3s node is Ready."
      break
    fi
    retries=$((retries - 1))
    sleep 5
  done
  if (( retries == 0 )); then
    err "Timed out waiting for K3s node to become Ready."
  fi
}

# ── Step 2: Configure kubeconfig for local API access ────────────────────────
configure_kubeconfig() {
  log "Step 2/6 — Configuring kubeconfig for local kube API server access..."

  local k3s_kubeconfig="/etc/rancher/k3s/k3s.yaml"
  if [[ ! -f "$k3s_kubeconfig" ]]; then
    err "K3s kubeconfig not found at $k3s_kubeconfig"
  fi

  # Set up kubeconfig so kubectl and az CLI can find it
  export KUBECONFIG="$k3s_kubeconfig"

  # Also make it accessible for non-root usage later
  local user_home="${SUDO_USER:+$(eval echo ~${SUDO_USER})}"
  if [[ -n "$user_home" ]]; then
    mkdir -p "$user_home/.kube"
    cp "$k3s_kubeconfig" "$user_home/.kube/config"
    chown "$(id -u "${SUDO_USER}")":"$(id -g "${SUDO_USER}")" "$user_home/.kube/config"
    chmod 600 "$user_home/.kube/config"
    log "Kubeconfig copied to $user_home/.kube/config"
  fi

  # Verify connectivity
  kubectl get nodes || err "Cannot reach the Kubernetes API server."
  log "Local kube API server access confirmed."
}

# ── Step 3: Pull Azure CLI container image + install extension + login ────────
setup_azure_cli() {
  log "Step 3/6 — Setting up Azure CLI container and connectedk8s extension..."

  # Create persistent state dir for Azure login tokens
  mkdir -p "$AZ_STATE_DIR"

  # Pull the Azure CLI image into K3s's containerd
  log "Pulling Azure CLI container image: ${AZ_CLI_IMAGE}..."
  k3s ctr images pull "${AZ_CLI_IMAGE}"

  log "Azure CLI container image ready."
  run_az version --query '"azure-cli"' -o tsv && \
    log "Azure CLI version confirmed." || err "Failed to run az CLI from container."

  # Install the connectedk8s extension inside a persistent state dir
  # The extension is stored in ~/.azure so it persists across runs
  log "Installing connectedk8s extension..."
  run_az extension add --name connectedk8s --yes 2>/dev/null || \
    run_az extension update --name connectedk8s --yes 2>/dev/null || true

  # Log in to Azure via device code (no browser on the device)
  if ! run_az account show &>/dev/null; then
    log "Please log in to Azure using a device code..."
    run_az_interactive login --use-device-code
  else
    log "Already logged in to Azure."
  fi

  # Ensure the resource group exists
  if ! run_az group show --name "$RESOURCE_GROUP" &>/dev/null 2>&1; then
    log "Creating resource group '$RESOURCE_GROUP' in '$LOCATION'..."
    run_az group create --name "$RESOURCE_GROUP" --location "$LOCATION" -o none
  else
    log "Resource group '$RESOURCE_GROUP' already exists."
  fi
}

# ── Step 4: Connect the cluster to Azure Arc ─────────────────────────────────
connect_to_arc() {
  log "Step 4/6 — Connecting K3s cluster to Azure Arc..."

  # Check if already connected
  if run_az connectedk8s show -g "$RESOURCE_GROUP" -n "$CLUSTER_NAME" &>/dev/null 2>&1; then
    warn "Cluster '$CLUSTER_NAME' is already connected to Azure Arc. Skipping."
    return
  fi

  run_az connectedk8s connect \
    --name "$CLUSTER_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --distribution k3s \
    --infrastructure generic \
    --kube-config /root/.kube/config \
    --onboarding-timeout "$ONBOARDING_TIMEOUT"

  log "Cluster successfully connected to Azure Arc."

  # Verify the connection
  run_az connectedk8s show -g "$RESOURCE_GROUP" -n "$CLUSTER_NAME" -o table
}

# ── Step 5: Enable Azure RBAC on the cluster ─────────────────────────────────
enable_azure_rbac() {
  log "Step 5/6 — Enabling Azure RBAC on the Arc-enabled cluster..."

  # Get the cluster's managed identity principal ID
  local cluster_msi_id
  cluster_msi_id=$(run_az connectedk8s show \
    -g "$RESOURCE_GROUP" \
    -n "$CLUSTER_NAME" \
    --query identity.principalId -o tsv)

  if [[ -z "$cluster_msi_id" ]]; then
    err "Could not retrieve the cluster managed identity principal ID."
  fi
  log "Cluster MSI Principal ID: $cluster_msi_id"

  # Get the cluster ARM resource ID
  local cluster_arm_id
  cluster_arm_id=$(run_az connectedk8s show \
    -g "$RESOURCE_GROUP" \
    -n "$CLUSTER_NAME" \
    --query id -o tsv)

  # Assign the Connected Cluster Managed Identity CheckAccess Reader role
  log "Assigning 'Connected Cluster Managed Identity CheckAccess Reader' role..."
  run_az role assignment create \
    --role "Connected Cluster Managed Identity CheckAccess Reader" \
    --assignee "$cluster_msi_id" \
    --scope "$cluster_arm_id" \
    -o none 2>/dev/null || warn "Role assignment may already exist."

  # Enable Azure RBAC feature
  log "Enabling azure-rbac feature on the connected cluster..."
  run_az connectedk8s enable-features \
    -n "$CLUSTER_NAME" \
    -g "$RESOURCE_GROUP" \
    --features azure-rbac \
    --kube-config /root/.kube/config

  log "Azure RBAC enabled on the cluster."
}

# ── Step 6: Configure K3s API server for Azure RBAC webhooks ─────────────────
configure_rbac_webhooks() {
  log "Step 6/6 — Configuring K3s API server for Azure RBAC webhooks..."

  # Extract the guard webhook configs from the Kubernetes secret
  sudo mkdir -p /etc/guard

  kubectl get secrets azure-arc-guard-manifests -n kube-system -o json \
    | jq -r '.data."guard-authn-webhook.yaml"' | base64 -d > /etc/guard/guard-authn-webhook.yaml

  kubectl get secrets azure-arc-guard-manifests -n kube-system -o json \
    | jq -r '.data."guard-authz-webhook.yaml"' | base64 -d > /etc/guard/guard-authz-webhook.yaml

  log "Guard webhook configs written to /etc/guard/"

  # For K3s, configure the API server via the K3s config file
  local k3s_config="/etc/rancher/k3s/config.yaml"

  # Back up existing config if present
  if [[ -f "$k3s_config" ]]; then
    cp "$k3s_config" "${k3s_config}.bak.$(date +%s)"
    log "Backed up existing K3s config."
  fi

  # Check if kube-apiserver-arg already exists in the config
  if [[ -f "$k3s_config" ]] && grep -q 'kube-apiserver-arg' "$k3s_config"; then
    warn "kube-apiserver-arg entries already exist in $k3s_config."
    warn "Please manually verify the following args are present:"
    cat <<'ARGS'
  - authentication-token-webhook-config-file=/etc/guard/guard-authn-webhook.yaml
  - authentication-token-webhook-cache-ttl=5m0s
  - authentication-token-webhook-version=v1
  - authorization-webhook-config-file=/etc/guard/guard-authz-webhook.yaml
  - authorization-webhook-cache-authorized-ttl=5m0s
  - authorization-webhook-version=v1
  - authorization-mode=Node,RBAC,Webhook
ARGS
  else
    # Append the webhook configuration to the K3s config
    cat >> "$k3s_config" <<'EOF'

# Azure Arc RBAC webhook configuration
kube-apiserver-arg:
  - "authentication-token-webhook-config-file=/etc/guard/guard-authn-webhook.yaml"
  - "authentication-token-webhook-cache-ttl=5m0s"
  - "authentication-token-webhook-version=v1"
  - "authorization-webhook-config-file=/etc/guard/guard-authz-webhook.yaml"
  - "authorization-webhook-cache-authorized-ttl=5m0s"
  - "authorization-webhook-version=v1"
  - "authorization-mode=Node,RBAC,Webhook"
EOF
    log "K3s API server webhook args written to $k3s_config"
  fi

  # Restart K3s to apply the new API server configuration
  log "Restarting K3s to apply webhook configuration..."
  systemctl restart k3s

  # Wait for K3s to come back up
  log "Waiting for K3s to restart..."
  local retries=30
  while (( retries > 0 )); do
    if kubectl get nodes &>/dev/null 2>&1; then
      log "K3s is back up and running."
      break
    fi
    retries=$((retries - 1))
    sleep 5
  done
  if (( retries == 0 )); then
    err "Timed out waiting for K3s to restart after webhook configuration."
  fi
}

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
  echo "============================================================"
  echo "  K3s + Azure Arc Connected Cluster Setup"
  echo "============================================================"
  echo ""
  echo "  Resource Group : $RESOURCE_GROUP"
  echo "  Cluster Name   : $CLUSTER_NAME"
  echo "  Location       : $LOCATION"
  echo ""

  check_root
  install_k3s
  configure_kubeconfig
  setup_azure_cli
  connect_to_arc
  enable_azure_rbac
  configure_rbac_webhooks

  echo ""
  log "============================================================"
  log "  Setup complete!"
  log "  Cluster '$CLUSTER_NAME' is connected to Azure Arc with"
  log "  Azure RBAC enabled."
  log ""
  log "  Verify with:"
  log "    run_az connectedk8s show -g $RESOURCE_GROUP -n $CLUSTER_NAME -o table"
  log "    kubectl get pods -n azure-arc"
  log "============================================================"
}

main "$@"
```

</details>

1. Install K3s and disable Traefik:

   ```azurecli
   curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_SELINUX_RPM=true sh -s - --disable traefik
   ```

1. Create a kubeconfig file that the authenticated user can access:

   ```azurecli
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

   ```azurecli
   cat $USER_HOME/.kube/config
   ```

1. Copy the kubeconfig output. You use it on your Windows PC.

> [!NOTE]
> Installing K3s requires elevated permissions because it installs services and writes system files.

### Prepare the kubeconfig on your Windows PC

1. Install `kubectl` if it isn't installed already. For guidance, see [Install and Set Up kubectl on Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/).
1. Create a local kubeconfig file, such as `~/.kubeconfig`.
1. Paste the kubeconfig output into the file.
1. Replace the server IP address in the kubeconfig with the provisioned machine's IP address on your local network.

> [!IMPORTANT]
> The kubeconfig generated by K3s points to a local endpoint on the device. Before you use it from your Windows PC, replace the server address with an IP address that your PC can reach.

### Verify cluster access

From your Windows PC, run:

```azurecli
kubectl get nodes
```

If the command succeeds, your workstation can reach the K3s API server.

### Connect the K3s cluster to Azure Arc

From your Windows PC, run:

```azurecli
az connectedk8s connect --resource-group <ANY_RESOURCE_GROUP> --name <ANY_NAME>
```

This command deploys the required components to the K3s cluster and creates an Arc-enabled Kubernetes resource in Azure.

> [!TIP]
> Keep a second Cloud Shell session open if you want to cross-check resource details in the Azure portal during onboarding.

### Review the K3s deployment

Confirm that:

- K3s is installed on the provisioned machine.
- `kubectl get nodes` returns the local cluster.
- Your Windows `kubeconfig` points to the machine IP address.
- The `az connectedk8s connect` command completes successfully.\

---

## Next steps

- Continue to [Deploy applications](small-form-factor-deploy-applications.md)