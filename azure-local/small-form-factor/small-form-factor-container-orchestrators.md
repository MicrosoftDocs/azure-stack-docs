---
title: Container Orchestrators on Small Form Factor Deployments of Azure Local (preview)
description: Compare the container orchestration options supported in small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: concept-article
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Container orchestrators on small form factor deployments of Azure Local (preview)

This article describes how container orchestrators provide an application isolation layer on top of small form factor deployments of Azure Local. It covers the two primary options - K3s and Docker - and explains when to use each one.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Why use containers on small form factor devices?

Small form factor deployments of Azure Local are designed for edge locations where physical footprint, power, and cost are constrained. Traditional virtual machine (VM)-based workloads can be too resource-intensive for the hardware profiles that small form factor devices support.

Containers offer a lightweight alternative for running application workloads on small form factor devices:

- **Lower overhead**: Containers share the host OS kernel and consume significantly less memory and CPU than VMs, making better use of the limited resources on small form factor hardware.
- **Fast startup**: Container workloads start in seconds rather than minutes, which is critical for edge scenarios where rapid recovery matters.
- **Consistent packaging**: Container images provide a reproducible deployment unit that works the same way regardless of the underlying small form factor hardware model.
- **Isolation**: Containers isolate application processes, dependencies, and networking from each other and from the host OS, preventing conflicts between workloads.

Containers on small form factor devices act as an **application isolation layer** that sits on top of the Azure Local operating system. The host OS, managed through the [provisioned machine resource](small-form-factor-resource-overview.md), handles hardware management and Azure connectivity, while the container orchestrator manages application lifecycle above it.

:::image type="content" source="media/small-form-factor-container-orchestrators.png" alt-text="Diagram showing application workloads." border="true" lightbox="media/small-form-factor-container-orchestrators.png":::

## K3s

[K3s](https://k3s.io/) is a lightweight, CNCF-certified Kubernetes distribution built for resource-constrained environments. It's a strong fit for small form factor devices because it delivers the full Kubernetes API with a fraction of the resource footprint of standard Kubernetes distributions.

### Why use K3s on small form factor devices

- **Low resource footprint**: K3s ships as a single binary under 100 MB and runs with approximately 512 MB of RAM, making it suitable for the 32–128 GB memory range of low-capacity small form factor hardware.
- **Bundled containerd runtime**: K3s includes containerd as its container runtime, so you don't need to install a separate container engine on the host.
- **Kubernetes-compatible**: K3s passes the full Kubernetes conformance tests, which means standard Kubernetes manifests, Helm charts, and tooling work without modification.
- **Built-in components**: K3s includes a local storage provider, CoreDNS, and a service load balancer out of the box, reducing the number of components you need to install and manage separately.

### Azure Arc integration

You can connect K3s clusters running on small form factor devices to **Azure Arc-enabled Kubernetes**, bringing cloud-based management to the edge cluster. By using Arc integration, you can:

- **View and monitor** the cluster in the Azure portal alongside your other Azure resources.
- **Apply Azure Policy** to enforce configuration standards across your edge Kubernetes clusters.
- **Deploy workloads** by using GitOps (Flux) for automated, source-controlled application delivery.
- **Enable Azure RBAC** so that Microsoft Entra ID identities and role assignments control access to the Kubernetes API, eliminating the need to manage separate kubeconfig credentials.

To connect a K3s cluster to Azure Arc, you use the `az connectedk8s connect` command. Because small form factor devices typically don't have the Azure CLI installed on the host, the CLI can be run from inside a container using K3s's bundled containerd runtime. This approach avoids installing additional software on the host OS. For a script that can remotely install K3s, start the cluster, and Arc-enable the cluster, see the [`setup-k3s-arc.sh` script](https://github.com/Azure-Samples/AzureLocal/blob/main/small-form-factor/setup-k3s-arc.sh).

### When to use K3s

Use K3s when your workloads benefit from Kubernetes-native capabilities:

- You want to deploy Azure IoT Operations or Azure Foundry Local.
- You need to run multiple interdependent services with service discovery and load balancing.
- You want declarative, self-healing deployments with rolling updates.
- You plan to use Helm charts or Kubernetes operators from the ecosystem.
- You need Azure Arc-enabled Kubernetes integration for centralized management.
- You want to use GitOps for automated workload deployment across a fleet of edge devices.

## Docker

[Docker](https://www.docker.com/) provides a simpler container runtime for running individual containers or small groups of containers on a small form factor device. Compared to K3s, Docker has less operational overhead but also fewer orchestration capabilities.

### Why Docker on small form factor devices

- **Simplicity**: Docker uses a straightforward `docker run` model that doesn't require knowledge of Kubernetes concepts like pods, deployments, or services.
- **Lower operational complexity**: There's no cluster state to manage, no etcd database, and no control plane components. Docker runs containers directly on the host.
- **Familiar tooling**: Docker is widely adopted, and most development teams already have experience building and running Docker containers.
- **Compose for multi-container apps**: Docker Compose allows you to define and run multi-container applications using a single YAML file, which is sufficient for many edge workloads.

### Limitations compared to K3s

Docker on its own doesn't provide:

- **Automatic restart and rescheduling**: If a container crashes, Docker can restart it (with `--restart` policies), but it doesn't reschedule workloads or perform health-based failover.
- **Service discovery and load balancing**: Containers can communicate over Docker networks, but there's no built-in DNS-based service discovery or automatic load balancing across replicas.
- **Declarative desired-state management**: Docker Compose provides basic declarative configuration, but it doesn't continuously reconcile actual state against desired state the way Kubernetes does.
- **Azure Arc-enabled Kubernetes integration**: Docker containers can't be managed through Azure Arc-enabled Kubernetes. Centralized fleet management requires additional tooling.

### When to use Docker

Use Docker when your workloads are simple and don't require Kubernetes orchestration:

- You're running a single application or a small number of independent containers.
- You want the fastest path to getting a containerized workload running on the device.
- Your team is familiar with Docker but not Kubernetes.
- You don't need centralized fleet management through Azure Arc-enabled Kubernetes.

## Choosing between K3s and Docker

The following table summarizes the key differences to help you choose the right container orchestrator for your small form factor deployment:

| Capability | K3s | Docker |
|---|---|---|
| Kubernetes API compatibility | Yes (CNCF certified) | No |
| Resource overhead | ~512 MB RAM | ~100 MB RAM |
| Multi-container orchestration | Built-in (pods, deployments, services) | Docker Compose |
| Self-healing and auto-restart | Yes (declarative reconciliation) | Restart policies only |
| Service discovery | Built-in (CoreDNS) | Manual or Docker networks |
| Azure Arc-enabled Kubernetes | Yes (`az connectedk8s connect`) | No |
| Rolling updates | Built-in | Manual |
| Learning curve | Moderate (Kubernetes knowledge required) | Low |
| Best for | Multi-service apps, fleet management, GitOps | Single-app deployments, prototyping |

> [!TIP]
> If you're unsure which to choose, start with K3s. Its resource overhead is manageable on small form factor hardware, and it gives you a path to Azure Arc integration and fleet management as your edge deployment grows. You can always run simple single-container workloads on K3s - you don't need to use advanced Kubernetes features to benefit from it.

## Small form factor devices should only run one container orchestrator

A small form factor device should run either K3s or Docker, not both. Make this decision early in your deployment planning, before you begin deploying containerized workloads. Deploy all of your applications using the chosen orchestrator.

### Why not both?

While you can technically install both K3s and Docker on the same device, doing so creates problems that compound over time:

- **Resource contention**: Small form factor devices operate within tight resource constraints (as few as 14 physical cores and 32 GB of RAM). Each container orchestrator reserves memory and CPU for its own runtime components. Running both means you pay overhead cost twice - K3s's control plane components (API server, scheduler, controller manager, etcd) alongside Docker's daemon - leaving less capacity for actual application workloads.

- **Port conflicts**: Both orchestrators manage container networking and port allocation independently. When two separate systems map container ports to the host, conflicting port bindings become likely, especially on devices with a single network interface. Debugging which orchestrator owns which port adds unnecessary operational friction.

- **Conflicting container runtimes**: K3s bundles its own containerd runtime, while Docker runs its own containerd instance (or, in older versions, its own runtime). Two container runtimes on the same host can interfere with each other's storage, networking, and process management. Container images pulled by one runtime aren't visible to the other, leading to duplicated image storage on an already storage-constrained device.

- **Split operational model**: Running both orchestrators means your team must maintain two different sets of deployment practices, monitoring approaches, and troubleshooting procedures for the same device. Containers managed by K3s are visible through `kubectl` and Azure Arc. Containers managed by Docker are visible through `docker ps`. There's no unified view across both, making it difficult to understand the full workload picture on a device.

- **Unpredictable update behavior**: OS-level updates applied through the provisioned machine lifecycle might interact differently with each container runtime. Having a single orchestrator simplifies the update matrix and reduces the risk of one runtime breaking after a host OS change.

### Make the decision early

Changing container orchestrators after you deploy workloads is disruptive. It typically requires:

1. Repackaging application deployment configurations (converting between Docker Compose files and Kubernetes manifests, or vice versa).
1. Migrating persistent data from volumes managed by one runtime to the other.
1. Updating any CI/CD pipelines, monitoring integrations, and operational runbooks.
1. Coordinating downtime for the migration, which may not be acceptable at always-on edge locations.

For these reasons, choose your container orchestrator before deploying your first workload. Evaluate your requirements against the [comparison table](#choosing-between-k3s-and-docker), considering not just your current needs but where your edge deployment is headed. If there's any chance you'll need Azure Arc-enabled Kubernetes management or fleet-wide GitOps in the future, starting with K3s avoids a costly migration later.

### One orchestrator per fleet, not just per device

If you're deploying small form factor devices across multiple sites, standardize on the same container orchestrator across your entire fleet. A mixed fleet — some devices running K3s, others running Docker — multiplies the operational burden:

- Deployment tooling must support both orchestrators.
- Troubleshooting playbooks diverge per device type.
- Fleet-wide monitoring requires separate integrations for Kubernetes-based and Docker-based devices.
- Training and staffing requirements increase, as operators need expertise in both systems.

Standardizing on a single orchestrator keeps your fleet operationally uniform and lets you invest in one set of tooling, training, and automation.

### Switch device to a different container runtime

Switching to a new container runtime is straightforward. With `az provisionedmachine reset`, your machine is good as new—reset it, install a fresh OS image, and treat it like a brand new machine.

## Networking considerations

Regardless of which container orchestrator you choose, consider the following networking aspects for small form factor deployments:

- **Host networking**: For workloads that need to bind directly to the device's network interfaces (for example, network discovery protocols), both K3s and Docker support host networking mode.
- **Ingress**: K3s includes a built-in service load balancer. For Docker, you expose container ports directly to the host using port mapping (`-p` flag).
- **Firewall and proxy**: Small form factor devices at edge locations may sit behind restrictive firewalls. Ensure that the required endpoints for your container registry and (if applicable) Azure Arc are accessible.

## Security considerations

Running containers on small form factor devices introduces a shared-kernel security model. Keep the following in mind:

- **Image provenance**: Pull container images only from trusted registries. Use image signing and vulnerability scanning where possible.
- **Least privilege**: Avoid running containers as root unless required. Both K3s and Docker support running containers with reduced privileges.

## Learn more

- [Run containerized workloads on a provisioned machine](small-form-factor-containerized-workloads.md)
- [Deploy applications](small-form-factor-deploy-applications.md)
