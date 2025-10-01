---
title: Customize DNS for an Azure Operator Nexus Kubernetes cluster
description: Learn how to customize DNS.
ms.service: azure-operator-nexus
author: jcroth
ms.topic: how-to
ms.date: 10/9/2023
ms.author: jcroth

---

# Customize DNS on a Nexus Kubernetes cluster

Nexus Kubernetes clusters use a combination of CoreDNS and [node-local-dns](https://kubernetes.io/docs/tasks/administer-cluster/nodelocaldns/) for cluster DNS management and resolution, with node-local-dns taking precedence for name resolution outside the cluster. 

Azure Operator Nexus is a managed service, so you can't modify the main configuration for CoreDNS or node-local-dns. Instead, you use a Kubernetes *ConfigMap* to override the default settings. To see the default CoreDNS and node-local-dns ConfigMaps, use the `kubectl get configmaps --namespace=kube-system coredns -o yaml` or `kubectl get configmaps --namespace=kube-system node-local-dns -o yaml`command.

This article shows you how to use ConfigMaps for basic DNS customization options in your Nexus Kubernetes cluster.

## Prerequisites

Before proceeding with this how-to guide, it's recommended that you:

   * Refer to the Nexus Kubernetes cluster [QuickStart guide][qs] for a
     comprehensive overview and steps involved.
   * Ensure that you meet the outlined prerequisites to ensure smooth
     implementation of the guide.

[qs]: ./quickstarts-kubernetes-cluster-deployment-bicep.md
## The ConfigMap data format

Both CoreDNS and node-local-DNS use a Kubernetes `ConfigMap` to store configuration options. To see the default CoreDNS and node-local-dns `ConfigMap`s, use `kubectl`:

<code>```console</code>
kubectl get configmaps --namespace=kube-system coredns -o yaml
kubectl get configmaps --namespace=kube-system node-local-dns -o yaml
<code>```</code>

When you create configurations like the examples below, the names in the `data` field *must* end in `.server` or `.override`.

<!-- ## Plugin support

All built-in CoreDNS plugins are supported. No add-on/third party plugins are supported. -->

<!-- ## Rewrite DNS

You can customize CoreDNS with AKS to perform on-the-fly DNS name rewrites.

1. Create a file named `corednsms.yaml` and paste the following example configuration. Make sure to replace `<domain to be rewritten>` with your own fully qualified domain name.

     ```yaml
     apiVersion: v1
     kind: ConfigMap
     metadata:
       name: coredns-custom
       namespace: kube-system
     data:
       test.server: |
         <domain to be rewritten>.com:53 {
         log
         errors
         rewrite stop {
           name regex (.*)\.<domain to be rewritten>.com {1}.default.svc.cluster.local
           answer name (.*)\.default\.svc\.cluster\.local {1}.<domain to be rewritten>.com
         }
         forward . /etc/resolv.conf # you can redirect this to a specific DNS server such as 10.0.0.10, but that server must be able to resolve the rewritten domain name
         }
     ```

     > [!IMPORTANT]
     > If you redirect to a DNS server, such as the CoreDNS service IP, that DNS server must be able to resolve the rewritten domain name.

2. Create the ConfigMap using the [`kubectl apply configmap`][kubectl-apply] command and specify the name of your YAML manifest.

     ```console
     kubectl apply -f corednsms.yaml
     ```

3. Verify the customizations have been applied using the [`kubectl get configmaps`][kubectl-get] and specify your *coredns-custom* ConfigMap.

     ```console
     kubectl get configmaps --namespace=kube-system coredns-custom -o yaml
     ```

4. To reload the ConfigMap and enable Kubernetes Scheduler to restart CoreDNS without downtime, perform a rolling restart using [`kubectl rollout restart`][kubectl-rollout].

     ```console
     kubectl -n kube-system rollout restart deployment coredns
     ``` -->

## Custom forward server

If you need to specify a forward server for your network traffic, you can create a `ConfigMap` to customize DNS.

1. Create a file named `customdns.yaml` and paste the following example configuration. Make sure to replace the `forward` name and the address with the values for your own environment.  The `bind 169.254.20.10` line is required and should not be changed. 

     ```yaml
     apiVersion: v1
     kind: ConfigMap
     metadata:
       name: coredns-custom
       namespace: kube-system
     data:
       test.server: | # you can select any name here, but it must end with the .server file extension
         <domain to be rewritten>.com:53 {
             forward foo.com 1.1.1.1
             bind 169.254.20.10
         }
     ```

2. Create the `ConfigMap`.

     ```console
     kubectl apply -f customdns.yaml
     ```

3. Restart CoreDNS without downtime by performing a `Daemonset` rollout.

     ```console
     kubectl rollout restart -n kube-system daemonset/node-local-dns
     ```

## Use custom domains

You might want to configure custom domains that can only be resolved internally. For example, you might want to resolve the custom domain `puglife.local`, which isn't a valid top-level domain. Without a custom domain `ConfigMap`, the Nexus Kubernetes cluster can't resolve the address.

1. Create a new file named `customdns.yaml` and paste the following example configuration. Make sure to update the custom domain and IP address with the values for your own environment.  The `bind 169.254.20.10` line is required and should not be modified. 

     ```yaml
     apiVersion: v1
     kind: ConfigMap
     metadata:
       name: coredns-custom
       namespace: kube-system
     data:
       puglife.server: | # you can select any name here, but it must end with the .server file extension
         puglife.local:53 {
             errors
             cache 30
             forward . 192.11.0.1  # this is my test/dev DNS server
             bind 169.254.20.10
         }
     ```

2. Create the `ConfigMap`.

     ```console
     kubectl apply -f customdns.yaml
     ```

3. Restart CoreDNS without downtime by performing a `Daemonset` rollout.

     ```console
     kubectl rollout restart -n kube-system daemonset/node-local-dns
     ```

## Stub domains

CoreDNS can also be used to configure stub domains.

1. Create a file named `customdns.yaml` and paste the following example configuration. Make sure to update the custom domains and IP addresses with the values for your own environment.  The `bind 169.254.20.10` line is required and should not be modified. 

     ```yaml
     apiVersion: v1
     kind: ConfigMap
     metadata:
       name: coredns-custom
       namespace: kube-system
     data:
       test.server: | # you can select any name here, but it must end with the .server file extension
         abc.com:53 {
          errors
          cache 30
          forward . 1.2.3.4
          bind 169.254.20.10
         }
         my.cluster.local:53 {
          errors
          cache 30
          forward . 2.3.4.5
          bind 169.254.20.10
         }

     ```

2. Create the `ConfigMap`.

     ```console
     kubectl apply -f customdns.yaml
     ```

3. Restart CoreDNS without downtime by performing a `Daemonset` rollout.

     ```console
     kubectl rollout restart -n kube-system daemonset/node-local-dns
     ```

## Hosts plugin

The hosts plugin is available to customize as well.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns-custom # this is the name of the configmap you can overwrite with your changes
  namespace: kube-system
data:
    test.override: | # you can select any name here, but it must end with the .override file extension
          hosts { 
              10.0.0.1 example1.org
              10.0.0.2 example2.org
              10.0.0.3 example3.org
              fallthrough
          }
```

## Troubleshooting
<!-- 
For general CoreDNS troubleshooting steps, such as checking the endpoints or resolution, see [Debugging DNS resolution][coredns-troubleshooting]. -->


### Enable DNS query logging

1. Add the following configuration to your coredns-custom `ConfigMap`:

   ```yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: coredns-custom
     namespace: kube-system
   data:
     log.override: | # you can select any name here, but it must end with the .override file extension
           log
   ```

2. Apply the configuration changes, and restart CoreDNS without downtime by performing a `Daemonset` rollout.:

     ```console
     # Apply configuration changes
     kubectl apply -f customdns.yaml

     # Force CoreDNS to reload the ConfigMap
     kubectl rollout restart -n kube-system daemonset/node-local-dns
     ```

3. View the CoreDNS debug logging using the `kubectl logs` command.

   ```console
   kubectl logs --namespace kube-system -l k8s-app=node-local-dns
   ```

<!-- ## Next steps -->


<!-- LINKS - external -->

<!-- LINKS - internal -->
