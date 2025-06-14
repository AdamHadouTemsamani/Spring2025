# Project 1

## Partitioning Techniques


### Independent Output 
> Gives each thread its own private buffer per partition (no synchronization needed). 
>
> Buffer Structure:
> * There are N threads and P partitions, so the system allocates an N × P array of buffers.
> * Each thread has its own private buffer for every partition.
>     * For example, Thread 0 has buffers: buf[0][0], buf[0][1], ..., buf[0][P-1]
>     * Thread 1 has its own: buf[1][0], buf[1][1], ..., buf[1][P-1]
> * These buffers are completely disjoint — no sharing, so no synchronization is needed.

#### How Indexing Works:
> Each thread:
> 1. Maintains its **own local write index** for each partition buffer.
> 2. When processing a tuple:
>     - It hashes the key to find the partition `p`.
>     - It writes the tuple to its own `buf[thread_id][p][index]`.
>     - It increments its **local index for partition** `p`.

> Example:
> Thread 2 processing a tuple that hashes to partition 5:
> * Writes to: `buf[2][5][local_index]`
> * Increments its local index_2_5
> 
> No other thread touches this buffer or this index.


### Concurrent Output 
> Uses a single shared buffer per partition protected by a mutex (threads lock on write)
>
> > The **partition buffer** is a **shared array**, and each thread writes to **different indexes**—managed by a shared index variable and synchronized via a mutex.

## Affinity Strategies
Three thread placement modes were tested: 
* No Affinity (default OS scheduling),
* Core Affinity (pin threads to specific CPU cores), and 
* NUMA Affinity (bind threads and their memory to particular NUMA nodes)

> These strategies aim to improve **cache locality** and reduce **context switches**.

## Main findings
### Independent Output
> Throughput was very high for small partition counts. At 1 hash-bit (2 partitions per thread) throughput peaked (~500 MT/s), then dropped sharply at 2–3 bits due to working sets overflowing the L1/L2 caches and TLB
>
> It recovered at moderate partition counts (4–7 bits) as buffers fit better in cache, before gradually declining again beyond ~8 bits as cache-line evictions and TLB pressure increased

#### With Core-pinning
>Changing thread affinity had little effect on throughput. For Independent Output, pinning threads to cores (Core Affinity) did not increase throughput, and unexpectedly introduced more CPU migrations than the free-scheduling case.

#### With Numa affinity
>NUMA binding yielded an almost identical throughput curve, only slightly reducing the low-bit performance dip by keeping threads on one socket.


### Concurrent Output
> Throughput stayed much lower, peaking around 100 MT/s (similar to the paper’s result).
> At low hash-bits (few partitions), many threads contended on the same mutexes. This caused frequent context-switches and cache-line invalidations, severely throttling throughput.
>
> As hash-bits increased (more partitions), contention fell and throughput climbed (rising from ~7 bits and peaking around 12 bits)
> Beyond that, the overhead of managing many tiny partitions (fragmentation) increased TLB and cache misses, and throughput dropped again.
>
> In short, **lock contention** dominated at **low partition** counts, while **cache/TLB** pressure dominated at **high partition counts**.

#### With Core-pinning
> Core-pinning eliminated most migrations (as expected) but did not improve throughput or reduce cache misses

#### With Numa affinity
> NUMA affinity again showed no throughput gain – in fact, once threads exceeded one socket, the OS’s NUMA rebalancer caused erratic migrations.

### Affinity comparison short
> In all cases, affinity mainly affected where threads ran (migrations), but the dominant bottlenecks (cache/TLB misses and lock contention) remained.

## Performance Insights with perf
> **Perf Counter Observations**: The Linux perf data revealed the causes of performance trends. 
>
> **Independent output**
> In Independent runs, L1/L2 cache misses and dTLB-load misses spiked exactly where throughput fell. For example, at 2–3 hash-bits the working sets could not fit in L1/L2 or TLB, causing a wave of TLB misses and page walks. Similarly, beyond ~12 bits the aggregate partitions exceeded the TLB, again spiking misses.
>
> **Concurrent output**
> In Concurrent runs, context-switch counts peaked at low hash-bits (threads blocking on locks), and L1/L2 misses were elevated from cache-line bouncing on the shared buffers.
> Core affinity runs showed that pinning threads essentially eliminated migration events, yet cache/TLB miss rates stayed the same. NUMA-binding runs exhibited erratic migration counts once thread count exceeded one socket, but again cache/dTLB metrics were unchanged. 
> These measurements confirm that cache/TLB behavior and lock contention – not scheduling overhead – dictated performance.

## Hardware Impact
> Our modern hardware significantly reduced microarchitectural stalls compared to the original system. The paper’s machine (1 GHz, 8 cores) is far less powerful than ours (2 GHz, 16 cores).
> 
> Accordingly, our Independent Output peak was ~500 MT/s vs their 140 MT/s. We attribute this to higher clock speed, more cores, and larger caches (fewer cache/TLB misses).
>
> In practice, this means our run times are much lower, but it also highlights that *synchronization* and *memory-effects*, rather than raw CPU speed, become the limiting factors on modern hardware.

## Conclusions
The experiments confirmed the expected behavior of both partitioning methods. **Independent Output** is highly effective up to a point: throughput is maximized when buffers are small enough to fit in cache/TLB, but degrades when partitioning is either too coarse (cache-thrashing) or too fine (fragmentation).

**Concurrent Output** is inherently limited by synchronization; low-bit configurations suffered heavy mutex contention, and the peak throughput (~100 MT/s) only matched the original study’s because lock overhead is the bottleneck.

>In our tests, Independent Output consistently outperformed Concurrent Output, at the cost of higher memory usage.

> **Core and NUMA affinity** had no meaningful benefit for throughput. Pinning threads (Core Affinity) or binding memory (NUMA Affinity) simply removed extra migrations without alleviating cache or locking delays

> In summary, the dominant performance cost was data partition management – the cache/TLB footprint of output buffers and the cost of synchronization – rather than CPU scheduling or migrations. 
> The key bottlenecks remain cache/TLB evictions and lock contention, which were clearly diagnosed by the perf metrics. These insights underscore that optimizing memory access patterns and minimizing synchronization are critical for high throughput in such parallel partitioning algorithms.

## Questions
### Conceptual Understanding
**Partitioning Techniques**
>Q: Explain the main differences between the Independent Output and Concurrent Output partitioning techniques. What are the trade-offs between them?
>
>A: 
>* Independent Output: each thread has a private buffer per partition—no synchronization needed, more memory usage, maximizes parallelism.
>* Concurrent Output: uses a shared buffer per partition with mutex locks—lower memory usage, but incurs synchronization overhead.

>Q: Why does the Independent Output strategy not require any synchronization mechanisms?
>
> A: Each thread writes to its own private buffer, so no other thread can read or write to it. This eliminates the need for synchronization (e.g., locks).

**Affinity Strategies**
>Q: What is NUMA affinity, and how does it theoretically improve performance?
>
> A: It binds threads and their memory allocations to specific NUMA nodes. This reduces remote memory access latency and cross-socket cache traffic.

> Q: How does core affinity differ from NUMA affinity, and what were the observed effects on performance in the experiment?
>
> A: Core affinity pins threads to specific CPU cores, improving cache locality. However, in this study, it had little impact on throughput but reduced CPU migrations.

### Experimental Design and Methodology
**Setup**
> Q: Describe the hardware setup used in this project. How might it have influenced the results compared to the original paper?
>
> A: Intel Xeon Silver 4109T (32 logical CPUs, 126 GB RAM). Compared to the paper’s 1 GHz 8-core system, the modern setup resulted in higher throughput and fewer cache/TLB stalls.

> Q: What were the experimental parameters and how were the runs structured?
>
> A: Two algorithms × 3 affinity modes × 6 thread counts × 18 hash-bits × 5 repeats = 3240 total runs.Each run processed 16 million 16-byte tuples.

**Metrics**
> Q: What performance metrics were collected using the perf tool, and why are each of them relevant in evaluating multi-threaded performance?
>
> A:
> * *Throughput*: Measures system speed.
> * *CPU cycles*: Total work done.
> * *Cache misses*: Indicates memory efficiency.
> * *dTLB-load misses*: Virtual memory efficiency.
> * *Page faults, CPU migrations, context switches*: Show OS and thread behavior overheads.


### Performance Analysis
**Throughput Trends**
> Q: Why does throughput drop at low hash-bit values for both partitioning techniques?
>
> A: Few partitions mean large buffers per thread, causing cache and TLB overflows (misses), increasing latency and reducing throughput.

> Q: Describe the throughput curve observed in the Independent Output strategy. What causes the dip and the eventual decline?
>
> A:
> * High throughput at 1-bit (buffers fit in cache).
> * Drop at 2–3 bits (working sets exceed cache/TLB).
> * Recovery at mid bits (better cache use).
> * Decline at high bits (too many tiny partitions = fragmentation + TLB pressure).

**Synchronization and Fragmentation**
> Q: What role did mutex contention play in the performance of the Concurrent Output strategy?
>
> A: At low partition counts, many threads try to lock the same buffer. This leads to blocking, context switches, and cache line invalidations—hurting throughput.

> Q: How does increasing the number of hash bits eventually hurt throughput in both strategies?
>
> A: Too many partitions cause fragmentation: buffers span multiple pages and cache lines, increasing TLB/cache pressure and reducing performance.

### Interpretation of Results
> Q: Based on the perf metrics, what were the dominant performance bottlenecks identified for each partitioning method?
>
> A: 
> * Independent Output: Cache and TLB misses due to large or fragmented working sets.
> * Concurrent Output: Mutex contention (low bits) and memory fragmentation (high bits).


> Q: Why did core and NUMA affinities have minimal impact on throughput despite reducing CPU migrations?
>
> A: They reduced migrations but didn't affect memory access patterns, cache line evictions, or lock contention—so throughput stayed mostly unchanged.

### Critical Thinking and Application
> Q: Suppose you had to redesign the Concurrent Output strategy to reduce synchronization overhead. What alternatives to mutexes might you consider?
>
> A: Use lock-free structures (e.g., atomic counters, concurrent queues), per-thread intermediate buffers with merge phase, or fine-grained locks.

> Q: If your hardware only had a single NUMA node, how would that change the interpretation of the NUMA affinity results?
>
> A: NUMA affinity would have no effect since all memory access would already be local—no inter-node latency to reduce.

> Q: How would you expect the throughput and perf metrics to behave if tuple size was significantly increased?
>
> A: Larger tuples increase working set size, causing more cache/TLB misses sooner and potentially lowering peak throughput.

### 6. Comparison and Generalization
> Q: Compare the throughput patterns of Independent and Concurrent Output strategies. In what scenarios would one be preferred over the other?
>
> A: 
> * Independent: Better for high-throughput, memory-rich systems where contention is costly.
> * Concurrent: Useful when memory is limited or simpler implementation is preferred.

> Q: What general lessons about multi-threaded memory performance can be learned from this experiment?
>
> A: 
> * Synchronization and memory access patterns dominate performance.
> * Cache/TLB locality is critical.
> * Thread placement matters less than data layout and access patterns.


