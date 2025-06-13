# Lecture 10 - AI Performance Matters

### Needs to utilize resources efficiently

* Training resource consumption is increasingly relevant
* GPUs are only utilized 52% on average for 100,000 jobs

![alt text](images/traningcost.png)

### Machine Learning Pipeline

*Are we doing **Machine Learning** or **Data Science***?

![alt text](images/MLvsDS.png)

## What is data Loaling for ML?

![alt text](images/dataloading.png)

**Definition**:
> Supplying data to the machine learning loop, usually in batches.

## Reading from Storage

### Data Loading Overview

![alt text](images/dlo.png)

### Data available on the device

![alt text](images/daotd.png)


### Far Away Data

![alt text](images/farawaydata.png)

ML datasets are too large for expensive storage

### Requirement: Randomised Order

ML models rely on Stochastic Gradiet Descent. What hapens if we do not randomise the order of samples?

* dependencies between mini-batches due to otdering
* "bad" mini-batches persist

### Stalling

![alt text](images/stalling.png)

Loading from disk is expensive and slower than how fast the model can train

*How can we resolve this bottleneck*?
* Compute Throughput > Data Loading Throughput

We need to flip this by increasing data loading throughput.

Can be done by:

### Multi-worker

![alt text](images/multiworker.png)

**Data loading workers**
> Increasing the amount of data workers increases data loading throughput


## Preprocessing

### Data Loading Overview

![alt text](images/dlo.png)

### ETL

**Extract, Transform, Load**

![alt text](images/elt.png)

*Where do we transform the data*?

* Offine *data preperation* vs. Online *just-in-time*

### Improving our data intake

* A simple pipeline is fast
* Is a simple pipeline effective?

#### Data reduction and expansion

![alt text](images/DRvE.png)


### You control the data, not the patterns

![alt text](images/classifier.png)

#### Expansion: Data Augmentation

![alt text](images/dataaugmentation.png)

> artificially increasing the size and diversity of a training dataset by creating modified versions of existing data.


Has multiple uses cases:
* Medical Imaging
* Traffic Signs


#### Reduction: Selection 

> choosing a subset of features or data to simplify models, speed up training, and reduce overfitting.

![alt text](images/selection1.png)
![alt text](images/selection2.png)
![alt text](images/selection3.png)

**Watch out**: Traning vs. Inference

* We are augmenting to prevent fitting on unwanted features.
* Most data operations should not be applied on inference


Inference = the phase where a trained model is used to make predictions on new, unseen data.

## Sending to GPU

### Data Loading Overview

![alt text](images/dlo.png)

### Collate

*Why have the collate step during data loading at all?*

**to collate** to assemble in proper order
* The collate function packs loose data tensors into one big big continious tensor.

tensor = multi-dimensional array

#### Problem 1: GPU Architecture

![alt text](images/gpuvscpu.png)

**GPU Architecture**
> The GPU is a *massively-paralle architecture* that is great at doing many *simple* things in parallel


#### Problem 1: Parallel Data

![alt text](images/paralleldata.png)

**Coalesced access**
> GPU memory access is coalesced when a group of GPU threads access consecutive memory addresses at the same time. 

Coalesced memory access means multiple threads access memory in a single, efficient operation.

**The Problem**
Data is scattered, so GPU threads access non-consecutive memory, leading to uncoalesced, inefficient memory access.

#### Problem 2: GPUs are far away

![hello](images/daotd.png)


GPUs are very good at computing, but are *far way* and need to be fed data (fetch).


## Optimising data loading

**What are we looking for**?
* Loading data faster is important
* But loading better data is even better

### Accuracy

![alt text](images/accuracy.png)

**Overfitting:** learning features that don’t generalise well

![alt text](images/tta.png)

Time to Accuracy combines speed and performance

### How to measure data loading time?

![alt text](images/dataloadtime.png)

**Async Execution**
> It can be very difficult to find data loading due to overalpping computation

*We can however use trace plots*

**NVIDIA Nsight Systems**

![alt text](images/nsight.png)

**PyTorch profiler**

![alt text](images/pytorchprofiler.png)

### Data loading time

I am assuming that this is why asynch execution is mentioned, that we load concurrently/or in parallel

![alt text](images/dlt.png)

**Hiding what takes time**:

![alt text](images/hwtt.png)

**GPU Prefetching**
> GPU data pipelining/prefetching can hide data stalls

A **data stall **is simply a pause in GPU execution because the next batch (or needed tensor data) isn’t yet available in device 

By pipelining (a.k.a. prefetching), you decouple your I/O and your compute so that the GPU never sits idle waiting for data.

---

* Data preparation usually takes place on the host (CPU).
* Loaded on the GPU when required


### DALI

![alt text](images/dali.png)

![alt text](images/dali2.png)

DALI = Replace or skip CPU data processing

Use NVIDIA DALI (or similar) to perform decoding, augmentations and format conversions with GPU kernels instead of Python/CPU loops.
* Offloads (or entirely bypasses) your CPU‑based decoding, augmentation and preprocessing—so you feed ready‐to‑use tensors straight into the GPU, eliminating CPU bottlenecks.

### RAPIDS

![alt text](images/rapids.png)

Left (Without GPUDirect Storage):
* Data must travel NVMe ↔ CPU memory (via PCIe), then CPU stages it through a bounce buffer before a second PCIe transfer to the GPU.
* This incurs extra copy overhead, latency, and CPU load.

Right (With GPUDirect Storage):
* The GPU reads straight from NVMe over PCIe via DMA—no CPU memory or bounce buffer.
* Results in lower latency, higher throughput, and frees the CPU from data‑copy tasks.

### TensorSOcket: Collocated data journey

![alt text](images/tensorsocket1.png)

Collocation introduced data loading redundancies

### TensorSocket: Sharing the data pipeline

![alt text](images/tensorsocket2.png)

You “lift out” the heavy lifting into one shared pipeline: data is read, decoded and transformed once, then multicast into each GPU’s queue