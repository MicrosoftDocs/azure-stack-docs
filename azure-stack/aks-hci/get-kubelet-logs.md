---
title: Get Kubelet logs in Azure Kubernetes Service on Azure Stack HCI
description: Learn about how to get Kubelet logs in Azure Kubernetes Service on Azure Stack HCI.
author: mattbriggs
ms.topic: how-to
ms.date: 04/24/2022
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: oadeniji
# Intent: As an IT Pro, I need to learn how to obtain Kubelet logs in order to troubleshoot problems with my AKS on Azure Stack HCI cluster.  
# Keyword: kubelet logs cluster nodes troubleshooting

---

# Get kubelet logs from cluster nodes on AKS on Azure Stack HCI and Windows Server

As part of operating an AKS on Azure Stack HCI and Windows Server cluster, you may need to review logs at some point to troubleshoot a problem. You can [view logs](./view-logs.md) for AKS on Azure Stack HCI and Windows Server, and you may also need to get _kubelet_ logs from an AKS on Azure Stack HCI and Windows Server node for troubleshooting purposes. This topic shows you how to use `journalctl` to view the _kubelet_ logs on a node.

## Before you begin

This article assumes that you have an existing AKS on Azure Stack HCI and Windows Server cluster. If you need an AKS on Azure Stack HCI and Windows Server cluster, see this [quickstart](kubernetes-walkthrough-powershell.md) for deploying AKS on Azure Stack HCI and Windows Server.

## Create an SSH connection

First, you need to create a SSH connection with the node on which you need to view _kubelet_ logs. To sign in using SSH, see [connect with SSH](./ssh-connection.md) for Windows and Linux worker nodes.

## Get kubelet logs

Once you have connected to the node, run the following command to pull the _kubelet_ logs:

```console
sudo journalctl -u kubelet -o cat
```
The following sample output shows the kubelet log data:

```output
I0512 19:15:19.651370    1824 server.go:411] Version: v1.19.7
I0512 19:15:19.651680    1824 server.go:831] Client rotation is on, will bootstrap in background
I0512 19:15:19.709716    1824 dynamic_cafile_content.go:167] Starting client-ca-bundle::/etc/kubernetes/pki/ca.crt
I0512 19:15:19.867693    1824 server.go:640] --cgroups-per-qos enabled, but --cgroup-root was not specified.  defaulting to /
I0512 19:15:19.868130    1824 container_manager_linux.go:276] container manager verified user specified cgroup-root exists: []
I0512 19:15:19.868169    1824 container_manager_linux.go:281]
```

## Next steps

- [View logs to collect and review data](./view-logs.md) 
- [Monitor AKS on Azure Stack HCI and Windows Server clusters](./monitor-logging.md)
