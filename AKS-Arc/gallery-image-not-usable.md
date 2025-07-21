---
title: Kubernetes cluster create or nodepool scale failing due to AKS Arc image issues  
description: Learn about a known issue with Kubernetes cluster create or nodepool scale failing due to AKS Arc VHD image download issues.
ms.topic: troubleshooting
author: sethmanheim
ms.author: sethm
ms.date: 07/17/2025
ms.reviewer: rcheeran

---

# Can't create AKS cluster or scale node pool because of issues with AKS Arc images

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

## Symptoms

You see the following error when you try to create the AKS cluster:

```output
Kubernetes version 1.29.4 is not ready for use on Linux. Please go to https://aka.ms/aksarccheckk8sversions for details of how to check the readiness of Kubernetes versions.
```

You might also see the following error when you try to scale a nodepool:

```output
error with code NodepoolPrecheckFailed occured: AksHci nodepool creation precheck failed. Detailed message: 1 error occurred:\n\t* rpc error: code = Unknown desc = GalleryImage not usable, health state degraded: Degraded
```

When you run `az aksarc get-versions`, you see the following errors:

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

This issue was fixed in [AKS on Azure Local, version 2507](/azure/azure-local/whats-new?view=azloc-2507&preserve-view=true#features-and-improvements-in-2507). Upgrade your Azure Local deployment to the 2507 build. 

- Upgrade your Azure Local deployment to the 2507 build.
- Once updated, confirm that the images were downloaded successfully by running the `az aksarc get-versions` command.
- You can now use the listed Kubernetes versions while creating or updating your AKS Arc clusters.
- If you continue to encounter issue, please file a support case.

## Next steps

[Known issues in AKS enabled by Azure Arc](aks-known-issues.md)
