---
title: AI Workloads on Azure Local Overview
description: Learn how Azure Local enables AI inference, document intelligence, and video analysis on your own infrastructure with cloud-consistent management.
author: cwatson-cat
ms.author: cwatson
ms.topic: concept-article
ms.date: 04/14/2026
ai-usage: ai-assisted
#CustomerIntent: As an IT admin or AI developer, I want to understand how Azure Local enables AI workloads on my own infrastructure so that I can process data locally while meeting latency, sovereignty, and compliance requirements.
---

# AI workloads on Azure Local

Azure Local brings Azure AI capabilities directly to your infrastructure so you can process data locally without sending it to the cloud. This article covers the AI workloads available on Azure Local and helps you pick the right one for your needs. Each workload runs on Azure Arc-enabled Kubernetes, so you get cloud-consistent management and security while keeping data processing local.

> [!IMPORTANT]
> Some AI workloads described in this article are currently in preview, including Foundry Local on Azure Local and Edge RAG. See the linked workload documentation and the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Run AI model inference on your infrastructure

Foundry Local on Azure Local, currently in preview, runs AI model inference on an Arc-enabled Kubernetes cluster. Use it to deploy and serve generative or predictive models from the Foundry model catalog.

Foundry Local uses a Kubernetes inference operator to manage the model lifecycle. The operator syncs metadata from the Foundry model catalog, deploys models through declarative custom resources, and serves requests through OpenAI-compatible API endpoints. Azure Arc provides the management connection, and the operator runs natively in Kubernetes.

### Capabilities

Foundry Local includes the core capabilities you need to run AI model inference on Azure Local.

| Capability | Description |
|-----------|-------------|
| **Model catalog sync** | Sync model metadata from the Foundry model catalog to your cluster so you can find and deploy models. |
| **CPU and GPU inference** | Deploy models on CPU-only or GPU-enabled nodes based on your workload needs. |
| **OpenAI-compatible API** | Send requests through `/v1/chat/completions` for generative tasks and `/v1/predict` for predictive tasks. |
| **Multi-model support** | Run multiple model deployments in one cluster with declarative configuration. |
| **Security** | Use API keys for authentication, TLS for encryption, and ingress for access control. |

### Use cases

Use Foundry Local when you need low-latency AI inference on local infrastructure for sensitive or operational workloads.

- Deploy chat and content generation models for internal applications that handle sensitive data.
- Serve predictive models for classification, scoring, or real-time decisions on the factory floor.
- Standardize AI serving with Kubernetes-native operations in your existing platform workflows.

For more information, see:

- [What is Foundry Local on Azure Local?](/azure/azure-sovereign-clouds/private/foundry-local/what-is-foundry-local-on-azure-local)
- [Deploy Foundry Local on Azure Local](/azure/azure-sovereign-clouds/private/foundry-local/deploy-foundry-local-on-azure-local)

## Search and reason over on-premises documents

Edge RAG Preview, enabled by Azure Arc, runs Retrieval Augmented Generation (RAG) on your on-premises data. It combines a language model with document retrieval so you can get answers grounded in your private data.

Edge RAG includes a data ingestion pipeline, embedding and vector storage, language models (hosted or bring your own), and a local developer portal for prompt design and evaluation.

### Capabilities

Edge RAG provides the core capabilities you need to build grounded AI experiences over local data.

| Capability | Description |
|-----------|-------------|
| **RAG pipeline** | Ingest, chunk, embed, store, and retrieve your documents and images in a single integrated pipeline. |
| **Local language models** | Choose hosted models or bring your own model. Supports CPU and GPU hardware. |
| **Multiple search types** | Deep search, full text, hybrid, multimodal, and vector search. |
| **Prompt tools** | Build, evaluate, and deploy custom chat solutions through a local developer portal. |
| **Azure RBAC** | Control access with Microsoft Entra integration and role-based permissions. |

### Use cases

Use Edge RAG when you need to search, summarize, and reason over private content that must stay on-premises.

- Query regulatory and compliance documents by using natural language to support permitting, zoning, and environmental review workflows.
- Run compliance checks and customer assistance workflows against financial data that must stay on-premises.
- Build troubleshooting assistants for factory floor technicians by using local operational and maintenance data.
- Summarize and generate training materials from classified or sensitive datasets.

For more information, see:

- [What is Edge RAG Preview?](/azure/azure-arc/edge-rag/overview)
- [Complete the prerequisites](/azure/azure-arc/edge-rag/complete-prerequisites)
- [Deploy Edge RAG](/azure/azure-arc/edge-rag/deploy-overview)

## Analyze video and audio at the edge

Azure AI Video Indexer enabled by Azure Arc runs video and audio analysis on edge devices. It supports transcription in more than 35 languages, object and scene detection, and summarization. The solution includes the Phi language model for generative AI tasks such as text summaries.

Azure AI Video Indexer enabled by Azure Arc also supports live video analysis. Prebuilt agents handle tasks such as retail operations monitoring, safety detection, and queue tracking. You use a conversational interface (AI Video Assistant) to route your questions to the right agent.

### Capabilities

Azure AI Video Indexer enabled by Azure Arc provides capabilities for video and audio analysis on edge infrastructure.

| Capability | Description |
|-----------|-------------|
| **Comprehensive AI presets** | Transcription, translation, captioning, key frame detection, object detection, scene and shot detection, and summarization. |
| **Live video analysis** | Analyze live video feeds in real time by using prebuilt agents for retail, safety, and operational monitoring. |
| **Custom AI models** | Define detection logic by using natural language to monitor specific objects or conditions. |
| **Bring your own model** | Extend built-in capabilities with custom models for specialized detection tasks. |
| **Data governance** | All video data stays on-premises. Only system metadata is sent to Microsoft. |

### Use cases

Use Azure AI Video Indexer enabled by Azure Arc when you need to analyze live or recorded media locally for operational, safety, or compliance scenarios.

- Monitor retail store conditions with live video feeds. Detect shelf conditions, safety hazards, and queue lengths, then generate end-of-shift summaries.
- Run quality control and worker safety analysis on manufacturing floor video.
- Index an on-premises video archive for search and retrieval before selectively uploading content to the cloud.

For more information, see:

- [Azure AI Video Indexer enabled by Azure Arc overview](/azure/azure-video-indexer/azure-video-indexer-enabled-by-arc-overview)
- [Quickstart: Deploy Azure AI Video Indexer enabled by Azure Arc](/azure/azure-video-indexer/azure-video-indexer-enabled-by-arc-quickstart)

## Operate AI in disconnected and sovereign environments

Azure Local supports disconnected operations in environments with limited or no cloud connectivity. Your clusters can run without continuous Azure connectivity and then sync after connectivity returns.

Before your production rollout, confirm which AI workloads support fully disconnected mode.

All three AI workloads process data on-premises:

- **Foundry Local** processes inference requests locally. Model artifacts are stored in your cluster.
- **Edge RAG** runs the entire RAG pipeline, including ingestion, retrieval, and generation, within your network boundaries.
- **Video Indexer** processes all video and audio locally. No media data is sent to the cloud.

## Common requirements

All three AI workloads require:

- **Azure subscription**: Used to register and manage your resources.
- **Azure Arc-enabled Kubernetes cluster**: Runs on Azure Local and connects to Azure through Azure Arc.
- **Azure CLI**: Used to manage deployments and extensions.
- **Network connectivity**: Outbound connectivity to Azure for control plane operations, billing, and monitoring (except during disconnected operations).

Before your production rollout, verify the network and connectivity requirements for each workload. Each workload has its own hardware and software prerequisites. See the individual workload documentation for more information.

## Choose the right workload

Use the following table to match each AI scenario to the best-fit workload on Azure Local, and plan to combine workloads when your environment has multiple data and application needs.

| If you need to... | Consider |
|-------------------|----------|
| Serve AI models for chat, generation, or prediction | Foundry Local on Azure Local (preview) |
| Build a chat assistant over on-premises documents | Edge RAG Preview |
| Analyze video or audio content in real time or from archives | Azure AI Video Indexer enabled by Azure Arc |
| Process sensitive data that can't leave your premises | Any of the three, depending on your data type |
| Operate fully disconnected or air-gapped | Not supported. |

## Related content

- [Azure Arc-enabled Kubernetes overview](/azure/azure-arc/kubernetes/overview)
- [What is Foundry Local on Azure Local?](/azure/azure-sovereign-clouds/private/foundry-local/what-is-foundry-local-on-azure-local)
- [What is Edge RAG Preview?](/azure/azure-arc/edge-rag/overview)
- [What is Azure AI Video Indexer enabled by Azure Arc?](/azure/azure-video-indexer/azure-video-indexer-enabled-by-arc-overview)
