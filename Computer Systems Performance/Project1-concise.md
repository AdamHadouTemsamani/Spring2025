# Project 1

## What to talk about
* Graphs => How to preset results.
* We want to partition $2^{24}$ (16 million) tuples. 
* Hashbit amount determine number of partitions.
### Independent output
* Tuples are split to threads.
* Each thread has own private partition buffer (huge).
* Cache line = 64B. Tuple = 16B. 4 tuples / per cache line
  * Would be nice if we know how many tuples fit in L1, L2, and L3.
* Cache misses.
* **Use more memory**
  * Threads independent parition size are the same as the original.
  * >If we have 16 B size with 16 threads, each thread does not have a buffer of size 1/16 B. They all have private buffer sizes of 16 B.
  * Each thread should be able to have all partitions.
  * **Thread A might get all partitions.**
  * More pressure on L3 cache.
    * Scales with number of threads.
  * What happens if one thread gets partitions?

### Concurrent output
* **Less memory**
  * We have the same amount of buffers.
  * Less pressure on L3 cache.
    * Does not scale with the number of threads.
  * All threads needs to 
  * Worst case, all threads needs all partions in their cache.
* High lock contension at **low hashbits**.
  * => **cache invalidations** 
  * Thread A writes to a **cache line**, making other Threads that use this cache line to be **invalid**.
  * Next time Thread B see its cache line is invalid, causing a cache miss.
* **High hashbits** => 
  * Low lock contension
  * Does not hit same partition
  * **Not** Fragmentation, but TLB miss
    * => More page walks.


## Partitioning Techniques

### Independent Output
* Each thread has a **private buffer** per partition (N × P buffers).
* No synchronization: threads write only to their own buffers.
* Indexing: each thread maintains **local write indices** for each partition.

>Example: Thread 2 writing to partition 5 uses buf[2][5][index].

### Concurrent Output
* All threads share one buffer per partition.
* Uses **mutex locks** for synchronization.
* Threads contend for locks, especially at low partition counts.

## Affinity Strategies
* **No Affinity**: OS decides thread placement.
* **Core Affinity**: Pins threads to specific cores.
* **NUMA Affinity**: Binds threads and memory to specific NUMA nodes.

>Aimed to improve locality and reduce context switches.

## Main Findings
### Independent Output
* Peaked at ~500 MT/s at low partition counts (1-bit hash).
* Throughput dipped at 2–3 bits due to cache/TLB overflows.
* Recovered mid-range (4–7 bits), declined again past 8 bits due to fragmentation.

#### Affinity Effects:
* Core/NUMA affinity had **little to no impact** on throughput.
* Core-pinning increased migrations unexpectedly.
* NUMA helped slightly at low bits by keeping threads on the same socket.

### Concurrent Output
* Peaked at ~100 MT/s.
* **Low bits**: heavy lock contention, context switches, and cache-line bouncing.
* **High bits**: fragmentation and TLB/cache pressure lowered performance.

#### Affinity Effects:
* Core-pinning reduced migrations, but not throughput.
* NUMA binding caused erratic migrations beyond one socket.

### Affinity Summary
* Affinity reduced migrations but **did not improve** cache or locking performance.
* Major bottlenecks were **cache/TLB misses and lock contention**.

## Performance Analysis with perf
### Independent Output
* Cache and TLB misses aligned with throughput dips.

### Concurrent Output
* Context switches peaked at low bits.
* Cache-line contention caused L1/L2 misses.

### Affinity
* Eliminated migrations, but didn't affect cache/TLB performance.

## Hardware Impact
* Modern 16-core, 2 GHz CPU outperformed older 8-core, 1 GHz setup.
* Higher throughput mainly due to better hardware (more cores, faster clocks, bigger caches).
* Still, **memory effects and synchronization**, not CPU speed, limited performance.

## Conclusions
* **Independent Output**: High throughput, memory-hungry, cache/TLB sensitive.

* **Concurrent Output**: Simpler, but bottlenecked by synchronization.

* **Affinity strategies**: Minimal benefit—bottlenecks lie in data access, not scheduling.

Key lesson: Optimize memory access and reduce synchronization for throughput.