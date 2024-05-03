---
title: Get on-demand logs for troubleshooting
description: Learn how to get full on-demand logs in AKS enabled by Arc and send them to Microsoft.
author: sethmanheim
ms.topic: how-to
ms.date: 01/17/2024
ms.author: sethm 
ms.lastreviewed: 1/14/2024
ms.reviewer: guanghu

# Intent: As an IT Pro, I need to learn how to obtain full on-demand logs in order to troubleshoot problems with my Azure Kubernetes Service in AKS enabled by Arc.  
# Keyword: on-demand logs cluster nodes troubleshooting

---

# Get on-demand logs for troubleshooting

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)], AKS enabled by Azure Arc on VMware (preview)

This article describes how to collect full on-demand logs and send them to Microsoft support for troubleshooting issues with AKS enabled by Azure Arc.

## Prepare the SSH key

Before log collection, you must have the SSH key you obtained when you created the cluster. It is usually saved under the **~/.ssh** path; for example, **C:\Users\HciiDeploymentUser\.ssh\id_rsa**. If the SSH key is lost, the log can't be collected.

## Collect logs

You can collect logs using IPs or the `kubeconfig` parameter. If an IP is used, it collects the log from a particular node. If `kubeconfig` is used, it collects logs from all cluster nodes. This command generates a .zip file on the local disk. For other parameters, see the [Az CLI reference](/cli/azure/aksarc/logs#az-aksarc-logs-hci).

```azurecli
az aksarc logs hci --ip 192.168.200.25 --credentials-dir ./.ssh --out-dir ./logs
```

Or

```azurecli
az aksarc logs hci --kubeconfig ./.kube/config --credentials-dir ./.ssh --out-dir ./logs
```

## Send logs to Microsoft Support

Contact Microsoft Support to send the logs to Microsoft. If the environment is disconnected, you must recover the network first.

## Next steps

- [Get kubelet logs](get-kubelet-logs.md)
- [View logs to collect and review data](./view-logs.md)
- [Monitor Kubernetes clusters in AKS](./aks-monitor-logging.md)
