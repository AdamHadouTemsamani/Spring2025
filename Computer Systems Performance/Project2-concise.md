# Project 2
## What to talk about
* Goal: add we use thread pools.
* Thread pool overhead > sorting

### C++ and Rust
* **Low input size**:
  * Minimal gain from parallelism.
  * Overhead of synchonizatioon outweight the benefit of parallelism 
    * $creation \;and\; management > execution$.
  * **Larger input size**:
    * Workload per thread is large enough for the thread overhead and efficient thread pool usage.
  * Plateau input size no longer leads to gain in performance.

## Main Findings
### Performance Overview
* **C++ (TBB)**: Minimal gains at small sizes (e.g. 2¹² elements ≈1 MiPS). Throughput improved with threads and input size: plateaued around 17 MiPS with 32 threads. Overhead from spawning 2 tasks per split.

* **Rust (Rayon)**: Slightly outperformed C++. Used 1 task per split, reducing scheduling overhead. Reached ~18.4 MiPS at 32 threads on large inputs.

* **C# (.NET TPL)**: Much slower (~17× behind). Peaked at ~0.9 MiPS. Heavy GC and task allocation costs, poor scalability beyond 8 threads.

### Scaling Trends
* **C++/Rust**: Parallelism helped only at larger sizes (2¹⁴+). Throughput scaled until CPU saturation, then plateaued.

* **C#**: Threading saturated early. Extra threads hurt performance due to GC and scheduling overhead.

### Key Observations
* Rust outperformed C++ due to more efficient task scheduling and better load balancing.
* C# sometimes performed better with fewer threads, due to high GC/scheduling cost at scale.
* All languages showed diminishing returns at high thread counts without enough work per thread.

### Thread Management & Overhead
* **C++/TBB**: Two tasks per split = high overhead (object creation, atomics, blocking waits).
* **Rust/Rayon**: One task per split; better scheduling, but more context switches from work-stealing.
* **C#/.NET TPL**: Four+ heap-allocated tasks per split; high GC pressure. At large sizes, ~73% runtime spent in GC.

### Conclusions
* **Best performer**: Rust. Slightly faster than C++ due to leaner scheduling.
* **C# bottlenecks**: Excessive GC, JIT gave minor improvement but couldn’t close the gap.
* **Memory effects**: At ~2²² elements, cache/TLB misses spiked as working set exceeded hardware limits.
* **Takeaway**: Granularity matters. Effective parallelism requires enough work per thread to offset overhead.