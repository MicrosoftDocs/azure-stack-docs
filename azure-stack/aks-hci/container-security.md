---
title: Concepts about securing containers in Azure Kubernetes Service on Azure Stack HCI and Windows Server
description: Learn some of the methods you can use to implement security for containers in Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: sethmanheim
ms.topic: how-to
ms.date: 12/30/2021
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: EkeleAsonye
---

# Container security

This article covers some of the ways you can secure containers and avoid introducing security vulnerabilities. Containers are an effective way to package and deploy applications. They provide operational and security benefits because applications and services are separated within an environment. Containers also help to reduce the effects of system-wide failures because of their abstraction, which ensures uptime and prevents attacks that could compromise applications or services. Containers typically run on an abstracted layer on top of the host operating system, and the abstraction offers some barrier of separation and the opportunity to apply a layered defense model. 

You can also set up continuous container security by securing the container pipeline, the application, and the container deployment environment. Examples for implementing container security are described in this topic.

## Secure the images

Ensure that images are hosted on a secure and trusted registry to prevent unauthorized access. The images should have a TLS certificate with a trusted root CA, and the registry should use Role Based Access Control (RBAC) with strong authentication. You should include an image scanning solution when designing CI/CD for the container build and delivery. The image scanning solution helps identify Common Vulnerabilities and Exposures (CVEs) and ensures that exploitable images are not deployed without remediation.

## Hardening the host environment

An important aspect of container security is the need to harden the security of the systems that your containers are running on, and the way they act during runtime. Container security should focus on the entire stack, including your host and the daemons. You should remove services from the host that are non-critical, and you should not deploy non-compliant containers in the environment. By doing this, access to the host can only occur through the containers and control would be centralized to the container daemon, removing the host from the attack surface. These steps are especially helpful when you use proxy servers to access your containers, which could accidentally bypass your container security controls. 

## Limit container resources

When a container has been compromised, attackers may attempt to use the underlying host resources to perform malicious activities. It's a good practice to set memory and CPU usage limits to minimize the impact of breaches.

## Properly secure secrets

A secret is an object containing sensitive information that may need to be passed between the host and the container. Some examples of secrets include passwords, SSL/TLS certificates, SSH private keys, tokens, connection strings, and other data that should not be transmitted in plain text or stored unencrypted. You should keep all secrets out of the images and mount them through the container orchestration engine or an external secret manager.

## Practice isolation

Use isolation and do not use a privileged or root user to run the application in a container. You should avoid running containers in privileged mode because doing so could allow an attacker to easily escalate privileges if the container is compromised. Knowing the UID (Unique Identification Code) and GID (Group Identification Code) of the root user in a container can allow an attacker to access and modify the files written by the root on the host machine. It's also necessary to use the principle of least privileges where an application only has access to the secrets it needs. You can create an application user to run the application process. 

## Deploy runtime security monitoring

Since there's still the chance of getting compromised even after taking precautions against attacks on your infrastructure, it's important to continuously monitor and log the application's behavior to prevent and detect malicious activities. Tools, such as [Prometheus](https://github.com/prometheus/prometheus), provide an effective means to monitor your infrastructure.

## Next steps

- [Encrypt etcd secrets](encrypt-secrets.md) 
- [Secure communication with certificates](secure-communication.md)