---
title: AKS Arc telemetry pod consumes too much memory and CPU
description: Learn how to troubleshoot when AKS Arc telemetry pod consumes too much memory and CPU.
ms.topic: troubleshooting
author: sethmanheim
ms.author: sethm
ms.date: 04/01/2025
ms.reviewer: abha

---
# Troubleshoot issue where AKS Arc telemetry pod consumes too much memory and CPU

## Symptoms

The **akshci-telemetry** pod in a AKS Arc cluster can over time consume a lot of CPU and memory resources. If metrics are enabled, you can verify the CPU and memory usage using the following `kubectl` command:

```bash
kubectl -n kube-system top pod -l app=akshci-telemetry
```

You might see an output similar to this:

```output
NAME                              CPU(cores)   MEMORY(bytes)
akshci-telemetry-5df56fd5-rjqk4   996m         152Mi
```

## Mitigation

This issue was fixed in AKS on [Azure Local, version 2507](/azure/azure-local/whats-new?view=azloc-2507&preserve-view=true#features-and-improvements-in-2507). Upgrade your Azure Local deployment to the 2507 build.

### Workaround for Azure Local versions 2506 and older

To resolve this issue, set default **resource limits** for the pods in the `kube-system` namespace.

#### Important notes

- Verify if you have any pods in the **kube-system** namespace that might require more memory than the default limit setting. If so, adjustments might be needed.
- The **LimitRange** is applied to the **namespace**; in this case, the `kube-system` namespace. The default resource limits also apply to new pods that don't specify their own limits.
- **Existing pods**, including those that already have resource limits, aren't affected.
- **New pods** that don't specify their own resource limits are constrained by the limits set in the next section.
- After you set the resource limits and delete the telemetry pod, the new pod might eventually hit the memory limit and generate **OOM (Out-Of-Memory)** errors. This is a temporary mitigation.
  
To proceed with setting the resource limits, you can run the following script. While the script uses `az aksarc get-credentials`, you can also use `az connectedk8s proxy` to get the proxy kubeconfig and access the Kubernetes cluster.

#### Define the LimitRange YAML to set default CPU and memory limits

```powershell
# Set the $cluster_name and $resource_group of the aksarc cluster
$cluster_name = ""
$resource_group = ""

# Connect to the aksarc cluster
az aksarc get-credentials -n $cluster_name -g $resource_group --admin -f "./kubeconfig-$cluster_name"

$limitRangeYaml = @'
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-mem-resource-constraint
  namespace: kube-system
spec:
  limits:
  - default: # this section defines default limits for containers that haven't specified any limits
      cpu: 250m
      memory: 250Mi
    defaultRequest: # this section defines default requests for containers that haven't specified any requests
      cpu: 10m
      memory: 20Mi
    type: Container
'@

$limitRangeYaml | kubectl apply --kubeconfig "./kubeconfig-$cluster_name" -f -

kubectl get pods -l app=akshci-telemetry -n kube-system --kubeconfig "./kubeconfig-$cluster_name"
kubectl delete pods -l app=akshci-telemetry -n kube-system --kubeconfig "./kubeconfig-$cluster_name"

sleep 5
kubectl get pods -l app=akshci-telemetry -n kube-system --kubeconfig "./kubeconfig-$cluster_name"
```

#### Validate if the resource limits were applied correctly

1. Check the resource limits in the pod's YAML configuration:

   ```powershell
   kubectl get pods -l app=akshci-telemetry -n kube-system --kubeconfig "./kubeconfig-$cluster_name" -o yaml
   ```

1. In the output, verify that the `resources` section includes the limits:

   ```yaml
   resources:
     limits:
       cpu: 250m
       memory: 250Mi
     requests:
       cpu: 10m
       memory: 20Mi
   ```

## Next steps

[Known issues in AKS enabled by Azure Arc](aks-known-issues.md)
