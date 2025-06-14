# Project 2 

## Main findings
### C++ (TBB)
> Parallel merge sort in C++ saw very limited speedups at small input sizes. For example, at 2<sup>12</sup> elements, all thread-counts achieved only ~0.4–1.5 MiPS (million items/sec) because “the overhead of thread creation and management outweighs any benefit”
> As input size grows, more threads help: peak throughput plateaus at roughly 1.7 MiPS (2 threads), 3 MiPS (4 threads), 5.8 MiPS (8 threads), 10 MiPS (16 threads), and 17 MiPS (32 threads)
> Single-threaded performance remained ≈1 MiPS, highlighting the lack of parallelism.

### Rust (Rayon)
> The Rust version behaved similarly to C++. At tiny sizes (2<sup>12</sup>), 32 threads performed worse (~3.9 MiPS) than 8–16 threads due to scheduling overhead on a 16-core machine.
> For larger inputs, throughput scaled up: with 1–2 threads it plateaued around ~1.2–3.0 MiPS, with 4–8 threads around ~5.5–9.4 MiPS, and with 16–32 threads around ~13.7–18.4 MiPS at very large sizes.
> As in C++, extra threads only paid off on sufficiently large arrays.

### C# (.NET TPL)
> The C# implementation was dramatically slower – about 17× slower than C++/Rust. Even with JIT warm-up it peaked at only ~0.9 MiPS (with 8 threads on large inputs).
> A “cold” run achieved ~0.2 MiPS and a “steady” (post-JIT) run ~0.4 MiPS at 2<sup>12</sup> elements, showing some JIT benefit. Beyond 8 threads there was almost no gain; e.g., at 2<sup>16</sup> elements 16 threads (0.65 MiPS) slightly outperformed 32 threads (0.60 MiPS).
> Interestingly, at very large sizes (≈2<sup>22</sup> elements) 4 threads actually outperformed 16 and 32 threads, suggesting that extra threads only added overhead. Overall, the C# throughput remained far below the native languages, with only a modest cold-to-steady improvement.

### Scaling with threads and size
> Both C++ and Rust showed that adding threads has no benefit on small arrays due to overhead, but yields roughly exponential speedup up to a point. In both cases, once the per-thread workload is large enough (roughly beyond 2<sup>14</sup>–2<sup>18</sup> elements), throughput climbs with more threads and eventually plateaus when all threads are fully utilized.
> Beyond that point, increasing array size or thread count gives no further gain. In C#, thread-scaling saturated much earlier (around 8 threads) and even declined at very large sizes.

### Notable observations
> Contrary to our expectations, the Rust implementation slightly outperformed C++ at every thread count.
This surprising result is attributed to Rayon’s more efficient task scheduling. 

> Another counterintuitive finding in C# was that using 4 threads eventually gave higher throughput than 16–32 threads for the largest arrays, because heavy scheduling and GC overhead made extra threads detrimental. In general, all languages saw diminishing returns: high thread counts only helped when data sizes were large enough (otherwise “overhead of parallel execution outweighs its benefits”)

## Thread Pool and Task-Management Techniques

### C++ (Intel TBB)
> The C++ version uses Intel TBB. At each merge-split, it calls `tg.run` twice, enqueuing two task objects into TBB’s work-stealing queues. 
> Each task spawn incurs object construction, an atomic enqueue, and a scheduler invocation, and `tg.wait` then blocks until both tasks complete. 
> In practice, every split doubles this overhead, so thousands of splits create heavy scheduling cost. 

### Rust (Rayon)
> Rust’s Rayon uses `rayon::join`. At each split, it pushes one new task into the local queue and immediately processes the other half itself. 
> This means only one task object is created/enqueued per split (versus two in C++), roughly halving the scheduling overhead. 
> The trade-off is that Rayon then has many smaller tasks in the deques, leading to more frequent work-stealing by idle workers. Indeed, the measurements showed more context switches under Rust (due to frequent steals) but fewer total instructions and mispredictions. 
> Overall this gave better load balancing and higher throughput despite the extra steals.

### C# (.NET TPL)
> The C# version uses the .NET Task Parallel Library (TPL) via async/await. Unlike C++/Rust, .NET’s thread pool is not optimized for spawning huge numbers of tiny tasks. Each MergeSortAsync call allocates several Task objects on the heap (roughly 4 tasks per split). 
> All these heap allocations must eventually be reclaimed by the garbage collector (GC). In a merge sort of N elements, that is on the order of O(N) task objects. This heavy allocation burden imposes large pauses: in one experiment (32 threads, 2<sup>26</sup> elements) ~73% of the total runtime was spent in GC. Thus the .NET thread pool “is not designed for CPU-bound, fine-grained, very short-running tasks”.


### Overhead and bottlenecks
> In summary, C++/TBB faced overhead from two tasks per split, with expensive atomic operations.
>
> Rust/Rayon cut that nearly in half but incurred more context switches from stealing.
>
> In C#, the main bottleneck was memory management: allocating and later collecting millions of small Task objects (and temporary merge buffers) caused massive GC pressure. The async/await machinery (state machines) and array zeroing added extra overhead, but by far the biggest cost was garbage collection.
>
> In all cases, using a fixed thread pool meant that once all cores were busy, further splitting only added scheduling cost, matching the observed plateaus.

## Conclusions

### Best-performing language
> Rust emerged with the highest throughput, slightly edging out C++. We expected C++ to be fastest, but in practice “the Rust implementation consistently achieved a slightly higher throughput.
> This is attributed to Rayon’s more efficient task scheduling (one task spawn per split) versus TBB’s two. C++ was a close second, hindered by the extra scheduling overhead per split.

### C# performance (GC and JIT)
> The C# implementation lagged far behind. Garbage collection and .NET’s memory model were the main culprits.
> As noted, GC pauses accounted for the majority of execution time (e.g. ~72.8% in one run). Just-In-Time compilation provided a modest boost: after warming up, throughput roughly doubled at small sizes (from ~0.2 to 0.4 MiPS at 2<sup>12</sup>). However, beyond the initial warm-up, JIT optimizations did not close the gap. 
> 
> In short, GC overhead and the ineffectiveness of the .NET thread pool for fine-grained work kept C# far slower than C++/Rus.


### Memory hierarchy effects
> For very large inputs (~2<sup>22</sup> elements, ~16 MiB), both C++ and Rust suffered sharp increases in cache and TLB misses. 
> This matches the hardware limits: an 11 MiB L3 cache and limited TLB entries. Once the working set no longer fit in cache, merge-sort’s random-access pattern caused many evictions and page-table lookups, driving up dTLB misses.

### Parallel algorithm implications
> A key takeaway is that task granularity matters. High thread counts only improved throughput when each thread had enough work to amortize scheduling costs.
> For small to medium problems, the overhead of spawning and syncing threads often outweighed any parallel gain. Hence, parallel merge sort (and similar divide-and-conquer algorithms) should be tuned so that recursive splitting stops when segments are large enough. 
> More broadly, the results suggest choosing the right language/runtime for concurrency: systems like Rust (with efficient work-stealing) or well-managed C++ can exploit many cores on large tasks, whereas high-level runtimes with heavy GC may struggle unless tasks are coarse-grained.


## Questions
### Conceptual Understanding
**Language and Design Choices**
> Q: Why were C++, Rust, and C# selected for the parallel merge sort comparison?
>
> A: 
> Because they represent different programming paradigms:
> * C++ offers low-level manual memory control,
> * Rust offers safety without garbage collection using ownership,
> * C# offers high-level abstractions with managed memory and garbage collection.

> Q: What makes merge sort naturally suited for parallel execution?
>
> A: Merge sort uses a divide-and-conquer strategy, recursively splitting the array into halves. These sub-arrays can be sorted independently in parallel, making it ideal for multithreading.


**Basic Definitions**
> Q: What is a thread pool, and why is it used in parallel merge sort implementations?
>
> A: A thread pool is a set of pre-initialized threads reused for executing tasks. It's used to avoid the overhead of frequent thread creation/destruction in recursive algorithms like merge sort.

> Q: What are dTLB load misses, and why are they important to monitor?
>
> A: A dTLB load miss occurs when a data address cannot be found in the data Translation Lookaside Buffer (TLB). This forces a page table walk, increasing memory access latency — especially critical in large datasets.

### Implementation & Methodology
**Thread Pool Techniques**
> Q: Compare the task scheduling approaches of Intel TBB (C++), Rayon (Rust), and .NET TPL (C#). How does each handle task creation at recursive splits?
>
> A: 
> * C++ (TBB): Spawns 2 tasks per split with higher atomic scheduling overhead.
> * Rust (Rayon): Spawns 1 task and works on the other half directly — lower overhead.
> * C# (.NET TPL): Uses async/await, spawning multiple heap-allocated Task objects per split, causing heavy GC load.

> Q: What are the consequences of spawning two tasks per split (as in C++) versus one task (as in Rust)?
>
> A: Because it reduces the number of task constructions, enqueues, and atomic operations by half, minimizing scheduling overhead and boosting throughput.

**Memory Management**
> Q: Why did the C# implementation suffer from severe garbage collection overhead in this study?
>
> A: Each recursive call created multiple Task objects and temporary arrays on the heap. These short-lived allocations overwhelmed the garbage collector, consuming up to 73% of runtime.

> Q: How does Rust's ownership model contribute to safe and efficient parallelism?
>
> A: Rust enforces safe access to memory at compile time, disallowing data races by default. This ensures safe multithreading without runtime checks or garbage collection.

### Performance Analysis
**Throughput Behavior**
> Q: Describe the throughput trends observed for C++, Rust, and C# as thread count and array size increased.
>
> A: 
> * Small arrays: parallel overhead outweighs benefits (all languages).
> * Medium/large arrays: throughput scales with threads.
> * Very large arrays: throughput plateaus as threads are fully utilized.



> Q: Why does throughput plateau at high array sizes, even as thread count increases?
>
> A: 
> Because the CPU cores and thread pool are fully saturated — adding more data or threads doesn't reduce computation time further due to resource limits.

**Performance Bottlenecks**
> Q: Why did C++ not outperform Rust, despite having manual memory control?
>
> A: Rust's Rayon scheduler uses 1 task per split, reducing overhead. It also achieves better load balancing through work-stealing. C++'s TBB had more instructions and branch mispredictions.

> Q: Explain why higher thread counts reduced performance in the C# implementation at large array sizes.
>
> A: More threads meant more Tasks and allocations, increasing GC pressure. The .NET thread pool is not optimized for many short, CPU-bound tasks, leading to scheduling inefficiency.

### Interpretation of Results
> Q: What were the key hardware limitations that affected all three implementations at large input sizes?
>
> A: The L3 cache (11 MiB) and TLB size. At array sizes ~2²², the working set exceeded these limits, causing increased cache and TLB misses, and thus reduced performance.

> Q: How did the memory access pattern of merge sort contribute to cache and TLB pressure?
>
> A: It alternates between sub-arrays, reducing spatial locality and increasing page-table lookups, which worsens cache behavior and raises dTLB miss rates at large sizes.

### Critical Thinking / Application
> Q: If tasked with optimizing the C# implementation, what strategies might reduce garbage collection overhead?
>
> A: 
> * Reduce number of Task allocations per split.
> * Use a custom thread pool tuned for CPU-bound work.
> * Avoid allocating temporary arrays in every merge.
> * Tune GC settings or use structs to minimize heap pressure.

> Q: Suppose you were designing a new parallel sorting library—what characteristics of the Rust/Rayon approach would you adopt, and why?
>
> A:
> * Use 1 task per recursive split to cut overhead.
> * Prefer work-stealing for load balancing.
> * Process one half synchronously to reduce idle threads.

### Comparison & Evaluation
> Q: Based on the results, which language is best suited for CPU-bound, recursive parallel tasks and why?
>
> A: Rust — due to efficient task scheduling in Rayon, safe memory handling without GC, and fewer synchronization overheads.

> Q: What does this study reveal about the trade-offs between low-level control (C++) and safe abstractions (Rust) in high-performance computing?
>
> A: 
> * C++: More control, but more prone to memory errors and harder to manage safely.
> * Rust: Slightly less control, but enforces safety and offers modern parallel tools with lower runtime cost.
