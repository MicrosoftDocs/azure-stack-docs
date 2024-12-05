---
title: Deploy an AI model on AKS Arc with the Kubernetes AI toolchain operator (preview)
description: Learn how to deploy an AI model on AKS Arc with the Kubernetes AI toolchain operator (KAITO).
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 12/03/2024
ms.reviewer: haojiehang
ms.lastreviewed: 12/03/2024

---

# Deploy an AI model on AKS Arc with the Kubernetes AI toolchain operator (preview)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article describes how to deploy an AI model on AKS Arc with the Kubernetes AI toolchain operator (KAITO). The AI toolchain operator (KAITO) is an add-on for AKS Arc, and it simplifies the experience of running OSS AI models on your AKS Arc clusters. To enable this feature, follow this workflow:

1. Deploy KAITO on an existing cluster.
1. Add a GPU node pool.
1. Deploy the AI model.
1. Validate the model deployment.

> [!IMPORTANT]
> These preview features are available on a self-service, opt-in basis. Previews are provided "as is" and "as available," and they're excluded from the service-level agreements and limited warranty. Azure Kubernetes Service, enabled by Azure Arc previews are partially covered by customer support on a best-effort basis.

## Prerequisites

Before you begin, make sure you have the following prerequisites:

1. The following details from your infrastructure administrator:

   - An AKS Arc cluster that's up and running. For more information, see [Create Kubernetes clusters using Azure CLI](aks-create-clusters-cli.md).
   - Make sure that the AKS Arc cluster runs on the Azure Local cluster with a supported GPU model. You must also identify the right GPU VM SKUs based on the model before you create the node pool. For more information, see [use GPU for compute-intensive workloads](deploy-gpu-node-pool.md).
   - We recommend using a computer running Linux for this feature.
   - Use `az connectedk8s proxy` to connect to your AKS Arc cluster.

1. Make sure that **helm** and **kubectl** are installed on your local machine.

   - If you need to install or upgrade, see [Install Helm](https://helm.sh/docs/intro/install/).
   - If you need to install **kubectl**, see [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).  

## Deploy KAITO from GitHub

You must have a running AKS Arc cluster with a default node pool. To deploy the KAITO operator, follow these steps:

1. Clone the [KAITO repo](https://github.com/Azure/kaito.git) to your local machine.
1. Install the KAITO operator using the following command:

   ```bash
   helm install workspace ./charts/kaito/workspace --namespace kaito-workspace --create-namespace
   ```

## Add a GPU node pool

Before you add a GPU node, make sure that Azure Local is enabled with a supported GPU model, and the GPU drivers are installed on all the host nodes. To create a GPU node pool using the Azure portal or Azure CLI, follow these steps:

### [Azure portal](#tab/portal)

To create a GPU node pool using the Azure portal, follow these steps:

1. Sign in to the Azure portal and find your AKS Arc cluster.
1. Under **Settings** and **Node pools**, select **Add**. During the preview, we only support Linux nodes. Fill in the other required fields and create the node pool.

   :::image type="content" source="media/deploy-ai-model/nodepools-portal.png" alt-text="Screenshot of node pools portal page." lightbox="media/deploy-ai-model/nodepools-portal.png":::

### [Azure CLI](#tab/azurecli)

To create a GPU node pool using Azure CLI, run the following command. The GPU VM SKU used in the following example is for the **A16** model; for the full list of VM SKUs, see [Supported VM sizes](deploy-gpu-node-pool.md#supported-vm-sizes).

```azurecli
az aksarc nodepool add --name "samplenodepool" --cluster-name "samplecluster" --resource-group "sample-rg" --node-vm-size "Standard_NC16_A16" --os-type "Linux"
```

---

### Validate the node pool deployment

After the node pool creation succeeds, you can confirm whether the GPU node is provisioned using `kubectl get nodes`. In the following example, the GPU node is **moc-l1i9uh0ksne** and the other node is from the default node pool that was created during the cluster creation:

```bash
kubectl get nodes
```

Expected output:

```output
NAME            STATUS   ROLES                  AGE   VERSION
moc-l09jexqpg2k Ready    <none>                 31d   v1.29.4
moc-l1i9uh0ksne Ready    <none>                 26s   v1.29.4
moc-lkp2603zcvg Ready    control-plane          31d   v1.29.4
```

You should also ensure that the node has allocatable GPU cores:

```bash
kubectl get node moc-l1i9uh0ksne -o yaml | grep -A 10 "allocatable:"
```

Expected output:

```output
allocatable:
  cpu: 15740m
  ephemeral-storage: "95026644016"
  hugepages-1Gi: "0"
  hugepages-2Mi: "0"
  memory: 59730884Ki
  nvidia.com/gpu: "2"
  pods: "110"
capacity:
  cpu: "16"
  ephemeral-storage: 103110508Ki
```

## Deploy the AI model

To deploy the AI model, follow these steps:

1. Create a YAML file using the following template. KAITO supports popular OSS models such as Falcon, Phi3, Llama2, and Mistral. This list might increase over time.

   - The **PresetName** is used to specify which model to deploy, and you can find its value in the [supported model file](https://github.com/Azure/kaito/blob/main/presets/models/supported_models.yaml) in the GitHub repo. In the following example, `falcon-7b-instruct` is used for the model deployment.
   - We recommend using `labelSelector` and `preferredNodes` to explicitly select the GPU node by name. In the following example, `app: llm-inference` is used for the GPU node `moc-le4aoguwyd9`. You can choose any node label you want, as long as the labels match. The next step shows how to label the node.

   ```yaml
   apiVersion: kaito.sh/v1alpha1
   kind: Workspace
   metadata:
    name: workspace-falcon-7b
   resource:
    labelSelector:
      matchLabels:
        apps: llm-inference
    preferredNodes:
    - moc-le4aoguwyd9
   inference:
    preset:
      name: "falcon-7b-instruct"
   ```

1. Label the GPU node using **kubectl**, so that the YAML file knows which node can be used for deployment:

   ```bash
   kubectl label node moc-le4aoguwyd9 app=llm-inference
   ```

1. Apply the YAML file and wait until the workplace deployment completes:

   ```bash
   kubectl apply -f sampleyamlfile.yaml
   ```

## Validate the model deployment

To validate the model deployment, follow these steps:

1. Validate the workspace using the `kubectl get workspace` command. Also make sure that both the `ResourceReady` and `InferenceReady` fields are set to **True** before testing with the prompt:

   ```bash
   kubectl get workspace
   ```

   Expected output:

   ```output
   NAME                 INSTANCE               RESOURCEREADY   INFERENCEREADY   JOBSTARTED   WORKSPACESUCCEEDED   AGE
   workspace-falcon-7b  Standard_NC16_A16      True            True                          True                 18h
   ```

1. After the resource and inference is ready, the **workspace-falcon-7b** inference service is exposed internally and can be accessed with a cluster IP. You can test the model with the following prompt. For more information about features in the KAITO inference, see the [instructions in the KAITO repo](https://github.com/kaito-project/kaito/blob/main/docs/inference/README.md#inference-workload).

   ```bash
   export CLUSTERIP=$(kubectl get svc workspace-falcon-7b -o jsonpath="{.spec.clusterIPs[0]}") 

   kubectl run -it --rm --restart=Never curl --image=curlimages/curl -- curl -X POST http://$CLUSTERIP/chat -H "accept: application/json" -H "Content-Type: application/json" -d "{\"prompt\":\"<sample_prompt>\"}"
   ```

   Expected output:

   ```bash
   usera@quke-desktop: $ kubectl run -it -rm -restart=Never curl -image=curlimages/curl - curl -X POST http
   ://$CLUSTERIP/chat -H "accept: application/json" -H "Content-Type: application/json" -d "{\"prompt\":\"Write a short story about a person who discovers a hidden room in their house .? \"}"
   If you don't see a command prompt, try pressing enter.
   {"Result": "Write a short story about a person who discovers a hidden room in their house .? ?\nThe door is lo
   cked from both the inside and outside, and there appears not to be any other entrance. The walls of the room
   seem to be made of stone, although there are no visible seams, or any other indication of where the walls e
   nd and the floor begins. The only furniture in the room is a single wooden chair, a small candle, and what a
   ppears to be a bed. (The bed is covered entirely with a sheet, and is not visible from the doorway. )\nThe on
   ly light in the room comes from a single candle on the floor of the room. The door is solid and does not app
   ear to have hinges or a knob. The walls seem to go on forever into the darkness, and there is a chill, wet f
   eeling in the air that makes the hair stand up on the back of your neck. \nThe chair sits on the floor direct
   ly across from the door. The chair"}pod "curl" deleted
   ```

## Troubleshooting

If the pod is not deployed properly or the **ResourceReady** field shows empty or **false**, it's usually because the preferred GPU node isn't labeled correctly. Check the node label with `kubectl get node <yourNodeName> --show-labels`. For example, in the YAML file, the following code specifies that the node must have the label `apps=llm-inference`:

```yaml
labelSelector:
  matchLabels:
    apps: llm-inference
```

## Next steps

In this article, you learned how to deploy an AI model on AKS Arc with the Kubernetes AI toolchain operator (KAITO). For more information about the KAITO project, see the [KAITO GitHub repo](https://github.com/kaito-project/kaito).
