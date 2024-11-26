---
title: Deploy an AI model on AKS Arc with the Kubernetes AI toolchain operator (preview)
description: Learn how to deploy an AI model on AKS Arc with the Kubernetes AI toolchain operator (KAITO).
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 11/26/2024

---

# Deploy an AI model on AKS Arc with the Kubernetes AI toolchain operator (preview)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article describes how to deploy an AI model on AKS Arc with the Kubernetes AI toolchain operator (KAITO). The AI toolchain operator (KAITO) is an add-on for AKS Arc, and it simplifies the experience of running OSS AI models on your AKS Arc clusters. To enable this feature, follow this workflow:

1. Create a nodepool with GPU.
1. Deploy KAITO operator.
1. Deploy AI model.
1. Validate the model deployment.

The following deployment instructions are also available in [the KAITO repo](https://github.com/kaito-project/kaito/blob/main/docs/How-to-use-kaito-in-aks-arc.md).

> [!IMPORTANT]
> These preview features are available on a self-service, opt-in basis. Previews are provided "as is" and "as available," and they're excluded from the service-level agreements and limited warranty. Azure Kubernetes Service, enabled by Azure Arc previews are partially covered by customer support on a best-effort basis.

## Prerequisites

Before you begin, make sure you have the following prerequisites:

1. The following details from your infrastructure administrator:

   - An AKS Arc cluster that's up and running.
   - We recommend using a Linux machine for this feature.
   - Your local **kubectl** environment configured to point to your AKS Arc cluster.
     - Run `az aksarc get-credentials --resource-group <ResourceGroupName> --name <ClusterName>  --admin` to download the **kubeconfig** file.

1. Make sure your AKS Arc cluster is enabled with GPUs. You can ask your infrastructure administrator to set it up for you. You must also identify the right VM SKUs for your AKS Arc cluster before you create the nodepool. For instructions, see [use GPU for compute-intensive workloads](deploy-gpu-node-pool.md).
1. Make sure that **helm** and **kubectl** are installed on your local machine.

   - If you need to install or upgrade, see [Install Helm](https://helm.sh/docs/intro/install/).
   - If you need to install **kubectl**, see [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

## Create a GPU nodepool

To create a GPU nodepool using the Azure portal, follow these steps:

1. Sign in to the Azure portal and find your AKS Arc cluster.
1. Under **Settings** and **Node pools**, select **Add**. During the preview, we only support Linux. Fill in the other required fields and create the nodepool resource.

   :::image type="content" source="media/deploy-ai-model/nodepools-portal.png" alt-text="Screenshot of nodepools portal page." lightbox="media/deploy-ai-model/nodepools-portal.png":::

To create a GPU nodepool using the Azure CLI, run the following command:

```azurecli
az aksarc nodepool add --name "samplenodepool" --cluster-name "samplecluster" --resource-group "sample-rg" –node-vm-size "samplenodepoolsize" –os-type "Linux"
```

### Validate the GPU nodepool

After the nodepool creation command succeeds, you can confirm whether the GPU node is provisioned using `kubectl get nodes`. The new node is displayed, and you can know which node is new by looking at the **AGE** value:

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

## Deploy KAITO operator from GitHub

To deploy the KAITO operator, follow these steps:

1. Clone the [KAITO repo](https://github.com/Azure/kaito.git) to your local machine.
1. Install the KAITO operator using the following command:

   ```bash
   helm install workspace ./charts/kaito/workspace --namespace kaito-workspace --create-namespace
   ```

## Deploy the AI model

To deploy the AI model, follow these steps:

1. Create a YAML file with the following template. KAITO supports popular OSS models such as Falcon, Phi3, Llama2, and Mistral. This list might increase over time.

   - The **PresetName** is used to specify which model to deploy, and its value can be found from the [supported model file](https://github.com/Azure/kaito/blob/main/presets/models/supported_models.yaml) in the repo.
   - We recommend using `labelSelector` and `preferredNodes` to select the GPU nodes. The `instanceType` value is used by the **NodeController** for GPU auto-provisioning, which isn't currently supported on AKS Arc.
   - Make sure to replace the other placeholders with your own information.

   ```yaml
   apiVersion: kaito.sh/v1alpha1
   kind: Workspace
   metadata:
     name: <Your_Deployment_Name>
   resource:
     labelSelector:
       matchLabels:
         {Your_Node_Label}: {Your_Node_Label_Value}
     preferredNodes:
     - {Your_Node_Name}
   inference:
     preset:
       name: {Your_Preset_Name}
   ```

1. Label your GPU node **Kubectl label node samplenode YourNodeLabel=YourNodeLabelValue**, then apply the YAML file:

   ```bash
   kubectl apply -f sampleyamlfile.yaml
   ```

   ```yaml
   apiVersion: kaito.sh/v1alpha1
   kind: Workspace
   metadata:
     name: workspace-falcon-7b
   resource:
     labelSelector:
       matchLabels:
         app: llm-inference
     preferredNodes:
     - moc-le4aoguwyd9
   inference:
     preset:
       name: "falcon-7b-instruct"
   ```

## Validate the model deployment

To validate the model deployment, follow these steps:

1. Validate the workspace using the `kubectl get workspace` command. Also make sure that both the `ResourceReady` and `InferenceReady` fields are set to **True** before testing with the sample prompt.

   ```output
   NAME                 INSTANCE               RESOURCEREADY   INFERENCEREADY   JOBSTARTED   WORKSPACESUCCEEDED   AGE
   workspace-falcon-7b  Standard_NC12s_v3      True            True                          True                 18h
   ```

1. Test the model with the following sample prompt:

   ```bash
   export CLUSTERIP=$(kubectl get svc workspace-falcon-7b -o jsonpath="{.spec.clusterIPs[0]}") 

   kubectl run -it --rm --restart=Never curl --image=curlimages/curl -- curl -X POST http://$CLUSTERIP/chat -H "accept: application/json" -H "Content-Type: application/json" -d "{\"prompt\":\"<sample_prompt>\"}"
   ```

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

If the pod does not get deployed, or **ResourceReady** is empty or **false** when **kubectl** retrieves workspaces, it's usually because the preferred node isn't labeled correctly. Check the node label by running `kubectl get node <yourNodeName> --show-labels`.

For example, in your YAML file, the following code specifies that the node must have the label `apps=falcon-7b`:

```yaml
labelSelector:
  matchLabels:
    apps: falcon-7b
```

## Next steps

In this article, you learned how to deploy an AI model on AKS Arc with the Kubernetes AI toolchain operator (KAITO). For more information about the KAITO project, see the [KAITO GitHub repo](https://github.com/kaito-project/kaito).
