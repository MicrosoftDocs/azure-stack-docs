---
ms.date: 10/23/2025
ms.author: omarrivera
author: g0r1v3r4
ms.topic: include
ms.service: azure-operator-nexus
---

## Required proxy settings to enable outbound connectivity

You must configure the proxy settings in the cloud-init script or manually within the virtual machine (VM).
The Cloud Service Network (CSN) proxy is used by the VM for outbound traffic, which should always be `http://169.254.0.11:3128`.

```bash
export HTTPS_PROXY=http://169.254.0.11:3128
export https_proxy=http://169.254.0.11:3128
export HTTP_PROXY=http://169.254.0.11:3128
export http_proxy=http://169.254.0.11:3128
```

Similarly, you must also configure the `NO_PROXY` environment variable to exclude the IP address `169.254.169.254`.
The Instance Metadata Service (IMDS) endpoint `169.254.169.254` is used by the VM to communicate with the platform's token service for managed identity token retrieval.
The `NO_PROXY` variable can have multiple comma-separated values, but at a minimum, it must include the IMDS IP address.
Add other addresses that you don't want to be proxied through the CSN proxy to the `NO_PROXY` variable as needed for your environment.

```bash
export NO_PROXY=localhost,127.0.0.1,::1,169.254.169.254
export no_proxy=localhost,127.0.0.1,::1,169.254.169.254
```
