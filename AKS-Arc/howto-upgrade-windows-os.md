---
title: Upgrade the Windows Server version on your node pools
description: Upgrade the Windows Server version on your node pools
ms.topic: how-to
author: rcheeran
ms.date: 09/22/2025
ms.author: rcheeran 
ms.lastreviewed: 09/22/2025
ms.reviewer: sethm

---

# Upgrade the OS version for your Windows node pool on AKS enabled by Azure Arc

This article describes the steps to upgrade the OS version for Windows workloads on AKS Arc. While this example focuses on the upgrade from Windows Server 2019 to Windows Server 2022, the same process can be followed to upgrade from any Windows Server version to another.

## Windows Server OS version support

When a new version of the Windows Server operating system is released, AKS Arc is committed to supporting it and recommending you upgrade to the latest version to take advantage of the fixes, improvements, and new functionality.

> [!IMPORTANT]
> Windows Server 2019 will retire in March 2026. Azure Local version 2510 will be the last release to include the Windows Server 2019 VHDs. The last Kubernetes version available on Windows Server 2019 is 1.32. Windows Server 2019 will not be supported on 1.33 and above. For more information, see [Windows Server 2019 node pool retirement](https://techcommunity.microsoft.com/blog/containers/announcing-the-3-year-retirement-of-windows-server-2019-on-azure-kubernetes-serv/3777341).
> Windows Server 2022 will retire in October 2026. Azure Local version 2603 will be the last release to include the Windows Server 2022 VHDs. The last Kubernetes version available on Windows Server 2019 is 1.34. Windows Server 2022 will not be supported on 1.35 and above.

### Before you begin

- Update the FROM statement in your Dockerfile to the new OS version.
- Check your application and verify the container app works on the new OS version.
- Deploy the verified containerized application on AKS Arc in a development or testing environment.
- Take note of the new image name or tag for use in this article.
- Ensure that the [Windows node pool feature is enabled](./howto-enable-windows-nodepools.md) on your AKS Arc cluster.

### Add a new Windows-based node pool to an existing cluster

Select the right OS SKU and create a new [Windows-based node pool](./howto-create-windows-nodepool.md) on your AKS Arc cluster.

### Update the application YAML to use the new OS SKU

Node Selector is the most common and recommended option for placement of Windows pods on Windows nodes.

1. Update the `nodeSelector` field in your application's deployment YAML to match the label of the new Windows node pool.  

```yml
nodeSelector:
        "kubernetes.azure.com/os-sku": Windows2022
```

This enforces the placement of the pod on a Windows node thats running the latest OS version.

1. Once you update the `nodeSelector` in the YAML file, you also need to update the container image you want to use. You can get this information from the previous step in which you created a new version of the containerized application by changing the FROM statement on your Dockerfile.

> [!NOTE]
> You should use the same YAML file you used to initially deploy the application. This ensures that no other configuration changes besides the nodeSelector and container image.

### Apply the updated YAML file to the existing workload

1. View the nodes on your cluster using the kubectl get nodes command.

```bash
kubectl get nodes -o wide
```

This shows all the nodes on your cluster, including the new node pool you created and the existing node pools.

1. Apply the updated YAML file to the existing workload using the kubectl apply command and specify the name of the YAML file.

```bash
kubectl apply -f <filename>
```

At this point, AKS Arc starts the process of terminating the existing pods and deploying new pods to the Windows Server 2022 nodes.

1. Check the status of the deployment using the `kubectl get pods` command.

```bash
kubectl get pods -o wide
```

You should now see the pods  running on the new Windows node pool you created. You can now delete the old Windows node pool thats running on the older Windows SKU.

## Next steps

- [Delete a node pool](/azure/aks/aksarc/manage-node-pools#delete-a-node-pool)
- [Manage multiple node pools](/azure/aks/aksarc/manage-node-pools)
