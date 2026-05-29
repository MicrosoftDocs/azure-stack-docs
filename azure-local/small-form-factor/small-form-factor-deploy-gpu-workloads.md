---
title: Deploy GPU-Enabled Workloads on a Provisioned Machine (preview)
description: Deploy GPU-enabled workloads on a provisioned machine for small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: how-to
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Deploy GPU-enabled workloads on a provisioned machine (preview)

This article describes how to deploy GPU-enabled containerized workloads on a provisioned machine for small form factor deployments of Azure Local.

[Containerized workloads](small-form-factor-containerized-workloads.md) establishes your container platform by verifying Docker or installing open-source K3s. This article builds on that foundation to enable NVIDIA GPU acceleration for the workloads that you deploy in module 5.

Docker is supported for single-node GPU workloads. If you want a lightweight Kubernetes environment for orchestrated GPU workloads, you can also use the open-source K3s distribution. To compare these options before you choose one, see [Container orchestrators](small-form-factor-container-orchestrators.md).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure that you:

- Have a provisioned machine that you can reach over SSH.
- Complete the steps in [Connect a provisioned machine from the Azure portal](small-form-factor-connect-portal.md).
- Complete the steps in [Run containerized workloads on a provisioned machine](small-form-factor-containerized-workloads.md).
- Have supported hardware with an NVIDIA GPU installed in the provisioned machine.
- Installed NVIDIA GPU drivers on the host OS.
- Have a Windows PC on the same local network as the provisioned machine.
- Installed and signed into Azure CLI.
- Have internet connectivity available to install packages and pull container images.

If you use Docker, make sure that:

- Docker is already available on the provisioned machine, as described in [Run containerized workloads on a provisioned machine](small-form-factor-containerized-workloads.md#use-docker-on-the-provisioned-device).

If you use K3s, make sure that:

- Open-source K3s is installed and running.
- `kubectl` access to the K3s cluster is configured, as described in [Run containerized workloads on a provisioned machine](small-form-factor-containerized-workloads.md#prepare-the-kubeconfig-on-your-windows-pc).

## Choose your approach

- Use Docker if you want the fastest way to run a GPU-enabled container on a single device.
- Use K3s if you want Kubernetes APIs, `kubectl` workflows, GPU scheduling, or lightweight orchestration capabilities.

Choose the same container platform that you prepared in [Run containerized workloads on a provisioned machine](small-form-factor-containerized-workloads.md). If you verified Docker, continue with the Docker path in this article. If you installed K3s and configured `kubectl`, continue with the K3s path.

## How GPU-enabled workloads work

GPU-enabled container workloads rely on multiple layers working together correctly.

The following components must be configured:

1. NVIDIA GPU drivers
1. NVIDIA kernel modules and device nodes
1. NVIDIA Container Toolkit
1. Container runtime configuration
1. GPU-enabled workload configuration

K3s workloads also require:

- NVIDIA Kubernetes device plugin
- Kubernetes RuntimeClass configuration

If any layer is missing or misconfigured, GPU workloads might fail to start or might not detect GPU resources correctly.

## Validate NVIDIA GPU access on the host

1. Confirm that the operating system can detect the NVIDIA GPU.

    ```bash
    lspci | grep -i nvidia
    ```

    Example output:

    ```output
    01:00.0 VGA compatible controller: NVIDIA Corporation Device
    ```

1. Validate that the NVIDIA drivers are functioning correctly:

    ```bash
    nvidia-smi
    ```

    Example output:

    ```output
    +-----------------------------------------------------------------------------+
    | NVIDIA-SMI 550.xx.xx                                                        |
    | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
    +-----------------------------------------------------------------------------+
    ```

## Troubleshoot nvidia-smi

If `nvidia-smi` fails, the NVIDIA kernel modules or device nodes might not be initialized correctly.

1. Load the required NVIDIA kernel modules:

    ```bash
    sudo modprobe nvidia
    sudo modprobe nvidia_uvm
    ```

1. Validate that the NVIDIA device nodes exist:

    ```bash
    ls /dev/nvidia*
    ```

1. If the device nodes are missing, create them manually:

    ```bash
    sudo mknod -m 666 /dev/nvidia0 c 195 0
    sudo mknod -m 666 /dev/nvidiactl c 195 255
    ```

1. Run the command again:

    ```bash
    nvidia-smi
    ```

> [!NOTE]
> In production environments, NVIDIA device nodes should be managed through proper driver installation and udev rules rather than manual device creation.

## Install the NVIDIA Container Toolkit

The NVIDIA Container Toolkit enables containers to access GPU devices from the host system.

1. Add the NVIDIA repository:

    ```bash
    sudo curl -fsSL \
    https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo \
    -o /etc/yum.repos.d/nvidia-container-toolkit.repo
    ```

1. Update the repository configuration.

    Due to a repository metadata signature validation issue on Azure Linux with `tdnf`, update the NVIDIA repository configuration before refreshing package metadata.

    ```bash
    sudo sed -i 's|^repo_gpgcheck=1|repo_gpgcheck=0|' \
    /etc/yum.repos.d/nvidia-container-toolkit.repo

    sudo sed -i 's|^gpgcheck=0|gpgcheck=1|' \
    /etc/yum.repos.d/nvidia-container-toolkit.repo
    ```

1. Refresh package metadata:

    ```bash
    sudo tdnf clean all
    sudo tdnf makecache
    ```

1. Install the toolkit:

    ```bash
    sudo tdnf install -y nvidia-container-toolkit
    ```

1. Verify the installation:

    ```bash
    nvidia-ctk --version
    ```

## Run a GPU-enabled workload

# [Docker](#tab/docker)

Docker workloads can access GPUs directly through the NVIDIA container runtime.

Use this path if you followed the Docker workflow in [Run containerized workloads on a provisioned machine](small-form-factor-containerized-workloads.md#use-docker-on-the-provisioned-device).

1. Configure the NVIDIA runtime for Docker:

    ```bash
    sudo nvidia-ctk runtime configure --runtime=docker
    ```

1. Restart Docker:

    ```bash
    sudo systemctl restart docker
    ```

    > [!NOTE]
    > This article uses the NVIDIA CUDA sample image hosted in the NVIDIA GPU Cloud (NGC) catalog: [NVIDIA CUDA Sample Container Image](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/k8s/containers/cuda-sample?version=vectoradd-cuda12.5.0-ubi8).

1. Run the sample workload:

    ```bash
    sudo docker run --rm --gpus all \
      nvcr.io/nvidia/k8s/cuda-sample:vectoradd-cuda12.5.0-ubi8
    ```

    > [!NOTE]
    > If you run Docker commands without `sudo`, you may see a permission denied error when connecting to `/var/run/docker.sock`. Use `sudo docker ...` for the command, or configure Docker access for the current user.

    Successful output resembles:

    ```text
    [Vector addition of 50000 elements]
    Test PASSED
    Done
    ```

    The `Test PASSED` message confirms that:

    - Docker successfully accessed the NVIDIA GPU.
    - The NVIDIA runtime was configured correctly.
    - The container successfully used the GPU.

# [K3s](#tab/k3s)

K3s environments that use `containerd` must be configured to expose the NVIDIA runtime to containers.

Use this path if you installed K3s and configured cluster access in [Run containerized workloads on a provisioned machine](small-form-factor-containerized-workloads.md#install-and-use-open-source-k3s).

1. Restart K3s:

    ```bash
    sudo systemctl restart k3s
    ```

1. Some K3s environments automatically detect the NVIDIA runtime configuration. Check for NVIDIA runtime entries:

    ```bash
    sudo grep -i nvidia /var/lib/rancher/k3s/agent/etc/containerd/config.toml
    ```

   If the command returns entries similar to the following, the NVIDIA runtime is already configured and you can skip the manual containerd configuration steps.

   ```toml
   [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.'nvidia']
   [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.'nvidia'.options]
     BinaryName = "/usr/bin/nvidia-container-runtime"
   ```

If no NVIDIA runtime is present, configure it manually.

1. Create the configuration directory:

    ```bash
    sudo mkdir -p \
    /var/lib/rancher/k3s/agent/etc/containerd/config-v3.toml.d
    ```

1. Create the runtime configuration file:

    ```bash
    sudo nano \
    /var/lib/rancher/k3s/agent/etc/containerd/config-v3.toml.d/99-nvidia.toml
    ```

1. Add the following configuration:

    ```toml
    [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.'nvidia']
    runtime_type = "io.containerd.runc.v2"

    [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.'nvidia'.options]
    BinaryName = "/usr/bin/nvidia-container-runtime"
    SystemdCgroup = true
    ```

1. Restart K3s again:

    ```bash
    sudo systemctl restart k3s
    ```

### Create the NVIDIA RuntimeClass

A Kubernetes `RuntimeClass` allows workloads to explicitly request the NVIDIA runtime.

1. Create a file named `runtimeclass-nvidia.yaml`:

    ```yaml
    apiVersion: node.k8s.io/v1
    kind: RuntimeClass
    metadata:
      name: nvidia
    handler: nvidia
    ```

1. Apply the configuration:

    ```bash
    kubectl apply -f runtimeclass-nvidia.yaml
    ```

    > [!NOTE]
    > If the `RuntimeClass` already exists, you may see a warning that the resource is missing the `kubectl.kubernetes.io/last-applied-configuration` annotation. This warning is expected when the resource wasn't originally created with `kubectl apply`. If the output includes `runtimeclass.node.k8s.io/nvidia configured`, the RuntimeClass was updated successfully.

### Install the NVIDIA Kubernetes device plugin

The NVIDIA Kubernetes device plugin exposes GPU resources to Kubernetes as `nvidia.com/gpu`.

1. Deploy the device plugin:

    ```bash
    kubectl apply -f \
    https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.14.5/nvidia-device-plugin.yml
    ```

1. Verify that the device plugin pod is running:

    ```bash
    kubectl -n kube-system get pods
    ```

1. Wait until the NVIDIA device plugin reaches the `Running` state.

### Generate the NVIDIA CDI configuration

Some containerd environments use the Container Device Interface (CDI) for GPU device injection.

1. Generate the NVIDIA CDI specification:

    ```bash
    sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
    ```

   Example success output:

   ```text
   INFO[0001] Generated CDI spec with version 0.5.0
   ```

    > [!NOTE]
    > During CDI generation, you might see warnings about optional Vulkan, X11, MPS, or Fabric Manager components not being present. These warnings are expected in lightweight or headless environments and don't necessarily prevent GPU compute workloads from functioning correctly.

1. Verify that the CDI specification was created:

   ```bash
   ls -l /etc/cdi/nvidia.yaml
   ```

1. Configure the runtime:

    ```bash
    sudo nvidia-ctk runtime configure \
    --runtime=containerd \
    --config=/var/lib/rancher/k3s/agent/etc/containerd/config.toml
    ```

   Example output:

   ```text
   INFO[0000] Wrote updated config to /etc/containerd/conf.d/99-nvidia.toml
   ```

1. Restart K3s:

    ```bash
    sudo systemctl restart k3s
    ```

1. Verify that K3s detected the NVIDIA runtime configuration:

   ```bash
   sudo grep -i nvidia /var/lib/rancher/k3s/agent/etc/containerd/config.toml
   ```

   Example output:

   ```text
   [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.'nvidia']
   [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.'nvidia'.options]
     BinaryName = "/usr/bin/nvidia-container-runtime"
   ```

### Verify GPU visibility in Kubernetes

1. Verify that the NVIDIA device plugin pod is running:

   ```bash
   kubectl get pods -n kube-system | grep nvidia
   ```

1. Verify that Kubernetes can detect allocatable GPU resources:

    ```bash
    kubectl get nodes -o jsonpath='{.items[*].status.allocatable.nvidia\.com/gpu}'
    ```

    Example output:

    ```text
    1
    ```

1. If the command returns no output, check the NVIDIA device plugin logs:

   ```bash
   kubectl logs -n kube-system daemonset/nvidia-device-plugin-daemonset
   ```

   If the logs show `could not load NVML library: libnvidia-ml.so.1`, patch the device plugin DaemonSet to use the NVIDIA `RuntimeClass`:

   ```bash
   kubectl patch daemonset nvidia-device-plugin-daemonset -n kube-system \
     --type='json' \
     -p='[{"op":"add","path":"/spec/template/spec/runtimeClassName","value":"nvidia"}]'
   ```

   Restart K3s:

   ```bash
   sudo systemctl restart k3s
   ```

   Verify that the device plugin registered successfully:

   ```bash
   kubectl logs -n kube-system daemonset/nvidia-device-plugin-daemonset
   ```

   Expected log output includes:

   ```text
   Detected NVML platform: found NVML library
   Registered device plugin for 'nvidia.com/gpu' with Kubelet
   ```

1. You can also inspect the node configuration:

    ```bash
    kubectl describe node
    ```

1. Verify that `nvidia.com/gpu` appears under:

   - Capacity
   - Allocatable

   Example output:

   ```text
   Capacity:
     nvidia.com/gpu: 1

   Allocatable:
     nvidia.com/gpu: 1
   ```

### Deploy a sample GPU-enabled K3s workload

1. Create a file named `cuda-vectoradd.yaml`:

    ```yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
      name: cuda-vectoradd
    spec:
      template:
        spec:
          runtimeClassName: nvidia
          restartPolicy: Never
          containers:
          - name: cuda-vectoradd
            image: nvcr.io/nvidia/k8s/cuda-sample:vectoradd-cuda12.5.0-ubi8
            resources:
              limits:
                nvidia.com/gpu: 1
      backoffLimit: 1
    ```

1. Deploy the sample workload:

    ```bash
    kubectl apply -f cuda-vectoradd.yaml
    ```

1. Verify that the job completed successfully:

    ```bash
    kubectl get jobs
    ```

1. View the workload logs:

    ```bash
    kubectl logs job/cuda-vectoradd
    ```

    Successful output resembles:

    ```text
    [Vector addition of 50000 elements]
    Test PASSED
    Done
    ```

The `Test PASSED` message confirms that:

- Kubernetes successfully scheduled the workload to a GPU-enabled node.
- The NVIDIA runtime was configured correctly.
- The container successfully accessed the GPU.

### Clean up the sample workload

Delete the sample workload:

```bash
kubectl delete job cuda-vectoradd
```

---

## Troubleshooting

### nvidia-smi fails on the host

Verify that:

- NVIDIA drivers are installed.
- NVIDIA kernel modules are loaded.
- `/dev/nvidia0` and `/dev/nvidiactl` exist.

### GPU resources aren't visible in Kubernetes

Verify that:

- The NVIDIA device plugin is running.
- The NVIDIA runtime exists in the containerd configuration.
- K3s was restarted after runtime changes.

### Docker containers can't access the GPU

Verify that:

- Docker was restarted after runtime configuration.
- `nvidia-container-toolkit` is installed.
- The `--gpus all` flag is specified.

### Pods or jobs remain in Pending

This issue usually indicates:

- GPU resources are unavailable.
- `nvidia.com/gpu` isn't allocatable.
- The NVIDIA runtime isn't configured correctly.
- The workload requests more GPUs than are available on the node.

## Next steps

- Return to [Deploy applications to your cluster](small-form-factor-deploy-applications.md) to choose the workload path that you want to run next.