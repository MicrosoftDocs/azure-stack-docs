---
title: GitOps with AKS Edge Essentials
description: Learn how to use GitOps with AKS Edge Essentials
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/07/2022
ms.custom: template-how-to
---

# Remote deployment and CI with GitOps and Flux

This article describes how to deploy applications to your Arc-enabled AKS-IoT cluster. The steps are as follows:

1. Point to your GitHub application in the Azure portal.
2. Push your application to your AKS-IoT cluster by installing GitOps configurations.
3. Commit a change to your GitHub application and show that your app updates automatically.

> [!NOTE]
> Make sure you have allocated at least 4GB of RAM and 4 CPU for the Linux VM as well as a service IP range greater than 0. You might also need a larger disk space than the default 10 GB, depending on your workloads.

## Step 1: Fork demo application

Go to the [Azure Arc Jumpstart repository](https://github.com/microsoft/azure-arc-jumpstart-apps) and fork it to your own GitHub account.

## Step 2: Creating configurations

Now, go to your cluster in the Azure portal and select **GitOps**. Next, create two configurations: a cluster-level configuration and a namespace-level configuration. Select **Create** and **Flux version 2**.

### Cluster-level configuration

| Attribute | Input |
| --- | --- |
| Configuration name | `config-nginx` |
| Namespace | `ingress-nginx` |
| Scope | Cluster |
| Source kind | Git repository |
| Repository URL | \<URL of your fork\>|
| Reference type | Branch |
| Branch | main |
| Repository type | Public |
| Sync interval | 1 |
| Sync timeout | 10 |
| **Kustomization** | |
| Instance name | `nginx` |
| Path | `./nginx/release` |
| Sync interval | 10 |
| Sync timeout | 10 |
| Prune | Enabled |
| Force | Not enabled |

Wait until the `config-nginx` has successfully been created and visible on your Azure portal GitOps before proceeding to create the namespace-level configuration (you can move on to creating the next configuration if the compliance is in pending state).

![Screenshot showing cluster-level configuration.](media/aks-lite/gitops-first-config.png)

### Namespace-level configuration

| Attribute | Input |
| --- | --- |
| Configuration name | `config-helloarc` |
| Namespace | `hello-arc` |
| Scope | Namespace |
| Source kind | Git Repository |
| Repository URL | \<URL of your fork\>|
| Reference type | Branch |
| Branch | main |
| Repository type | Public |
| Sync interval | 1 |
| Sync timeout | 10 |
| **Kustomization** | |
| Instance name | `app` |
| Path | `./hello-arc/releases/app` |
| Sync interval | 10 |
| Sync timeout | 10 |
| Prune | Enabled |
| Force | Not enabled |

![Screenshot showing namespace-level configuration.](media/aks-lite/gitops-second-config.png)

Refresh your configuration table and wait for the configurations to be in the installed state and compliant. Check using `kubectl` that the service is up.

```bash
kubectl get svc -n ingress-nginx
```

```bash
kubectl get pods -n hello-arc
```

![Screenshot showing hello-arc service.](media/aks-lite/hello-arc-pods-up.png)

Open a browser and navigate to your Node IP which is the `external-IP` of your `ingress-nginx-controller`.

![Screenshot of hello-arc application.](media/aks-lite/hello-arc-app-success.png)

## Step 3: Update your application using GitOps

1. In your fork of the **azure-arc-jumpstart-apps** repository, navigate to **hello-arc > releases > app > hello-arc.yaml**.
2. Make a change to this YAML file by selecting **Edit**. Change the replicaCount to 5. Change value to "Deploying to AKS on Windows IoT Gitops!"
3. Commit this change.

>[!NOTE]
> Because we have set the **sync interval** to **1 min** when creating the configurations, Flux will be pulling down changes from GitHub every minute.

![Screenshot showing hello-arc yaml.](media/aks-lite/edit-yaml.png)

4. Use `kubectl` to see the old pods terminate and new pods come online.

    ```bash
    kubectl get pods -n hello-arc -w
    ```

    ![Screenshot showing pods rolling update.](media/aks-lite/pods-rolling-update.png)

5. Refresh your application to see this change reflected as a rolling update.

    ![Screenshot showing updated hello-arc application.](media/aks-lite/app-update-success.png)

For more information about GitOps, see the [Azure Arc Jumpstart guide](https://azurearcjumpstart.io/azure_arc_jumpstart/azure_arc_k8s/day2/microk8s/local_microk8s_gitops_helm/#deploy-gitops-configurations-and-perform-helm-based-gitops-flow-on-microk8s-as-an-azure-arc-connected-cluster).


## Next steps

- [Overview](aks-lite-overview.md)
- [Uninstall AKS cluster](aks-lite-howto-uninstall.md)
