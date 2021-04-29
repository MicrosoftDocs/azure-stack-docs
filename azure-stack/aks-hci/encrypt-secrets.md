---
title: Encrypt etcd secrets in AKS on Azure Stack HCI
description: Learn how to encrypt etcd secrets in AKS on Azure Stack HCI
author: aabhathipsay
ms.topic: how-to
ms.date: 02/02/2021
ms.author: aathipsa
ms.reviewer: 
---

# Encrypt etcd secrets in AKS on Azure Stack HCI clusters

A secret in Kubernetes is an object that contains a small amount of sensitive data, such as passwords and SSH keys. In the Kubernetes API server, secrets are stored in _etcd_, which is a highly available key values store used as the Kubernetes backing store for all cluster data. AKS on Azure Stack HCI comes with encryption of etcd secrets and automates the management and rotation of encryption keys.

## Monitor and troubleshoot

To simplify application deployment on Kubernetes clusters, review the [documentation and scripts](https://github.com/microsoft/AKS-HCI-Apps) that are available.

- To set up logging using Elasticsearch, Fluent Bit and Kibana, follow the steps to [install the tools and set up logging](https://github.com/microsoft/AKS-HCI-Apps/tree/main/Logging)
- To use the monitoring tool Prometheus, follow the steps to [install Prometheus in a Kubernetes cluster](https://github.com/microsoft/AKS-HCI-Apps/tree/main/Monitoring#certs-and-keys-monitoring)

> [!NOTE]
> You can find the logs on the control plane node under `/var/log/pods`.

## Additional resources

- [Encrypting secret data at rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data)
- [Using a KMS provider for data encryption](https://kubernetes.io/docs/tasks/administer-cluster/kms-provider/)

## Next steps

In this how-to guide, you learned how to monitor and troubleshoot the encryption of etcd secrets for management and workload clusters. Next, you can:
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).
