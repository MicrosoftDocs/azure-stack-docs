---
title: Known issue with AKS Arc VHD image download leading to Kubernetes cluster create or nodepool scale failure 
description:  Known issue with AKS Arc VHD image download leading to Kubernetes cluster create or nodepool scale failure 
ms.topic: troubleshooting
author: sethmanheim
ms.author: sethm
ms.date: 04/01/2025
ms.reviewer: abha

---

# Can't fully delete AKS Arc cluster with PodDisruptionBudget (PDB) resources

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

## Symptoms

You see the following error when you try creating the AKS cluster:

```output
Kubernetes version 1.29.4 is not ready for use on Linux. Please go to https://aka.ms/aksarccheckk8sversions for details of how to check the readiness of Kubernetes versions.
```

You may also see the following when attempting to scale a nodepool:

```output
error with code NodepoolPrecheckFailed occured: AksHci nodepool creation precheck failed. Detailed message: 1 error occurred:\n\t* rpc error: code = Unknown desc = GalleryImage not usable, health state degraded: Degraded
```

When you run `az aksarc get-versions` you see the following errors:

```output
...
              {

                "errorMessage": "failed cloud-side provisioning image linux-cblmariner-0.4.1.11203 to cloud gallery: {\n  \"code\": \"ImageProvisionError\",\n  \"message\": \"force failed to deprovision existing gallery image: failed to delete gallery image linux-cblmariner-0.4.1.11203: rpc error: code = Unknown desc = sa659p1012: rpc error: code = Unavailable desc = connection error: desc = \\\"transport: Error while dialing: dial tcp 10.202.244.4:45000: connectex: A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.\\\"\",\n  \"additionalInfo\": [\n   {\n    \"type\": \"providerImageProvisionInfo\",\n    \"info\": {\n     \"ProviderDownload\": \"True\"\n    }\n   }\n  ],\n  \"category\": \"\"\n }",
                "osSku": "CBLMariner",
                "osType": "Linux",
                "ready": false
              },
...
```

## Mitigation

This issue was fixed in [AKS on Azure Local, version 2503](aks-whats-new-23h2.md#release-2503).

If you're on an older build, please update to Azure Local, version 2503. Once you update to 2503, confirm that the images are ready by running the `az aksarc get-versions` command. You can then retry creating the AKS cluster. If the retry doesn't work, file a support case.

## Next steps

[Known issues in AKS enabled by Azure Arc](aks-known-issues.md)
