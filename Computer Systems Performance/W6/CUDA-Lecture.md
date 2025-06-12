# Notes

GPU are slower at doing a single thing. How do we get the performance from GPU, so we do all of instruction on independent data at once.

Homogeneous = one kind of device

Heterogeneus = devices that are working together are not the same time

Host = CPU, get the data back and fourth (cpy data to gpu)

Device = GPU (doing the parallel procressing)

NVCC = nividida cuda compil codeer

- GPU side (PTX high level GPU langauge → then to SASS (gpu binary))
- CPU side

/_global_ is the function that a GPU will run

thread and threadblocks

- Inside a threadblock there are threads, for each thread and threadblock we have id
- why is it important to know the id of threads and threadblocks that we are launching?
    - when we are doing paralleling processing we need to know which thread does what work, especially when we need to synchronize

<<<10, 100>>> num of thread blocks (10) and how many treads inside of it (100).

If we don’t have large data that isn’t paralellizable its better to use CPU.

- Example: if SIMD can do everything in one “loop” then it is faster than doing it with SIMT
    - Since there is overhead from bringing data to GPU + GPU clockspeed is slower

### Lecture 6 - CUDA Programming

### CUDA

**Compute Unified Device Architecture**

CUDA C/C++
* Based on standard C/C++
* Set of extensions enabling heterogeneous programming


### Heterogenous COmputing

*Terminology*:

* **Host**: The CPU and its memory (host memory)
* **Device**: The GPU and its memory (devicde memory)


![alt text](images/hc.png)

### Single Processing Flow

1. Copy input data from CPU memory to CPU memory
2. Load GPU program and execute, caching data on chip for performance
3. Copy results form GPU memory to CPU memory

![alt text](images/spf.png)

### Code to Execution (CUFA PROCESS)

![alt text](images/compilation.png)

### Hello World! Code Example

```c++

__global__ void helloWorld(void) {
    printf("Hello from thread %d from block %d\n",
        threadIdx.x, blockIdx.x);
}

int main(void) {
    helloWorld<<<10,100>>>();

    return 0;
    }

```

### Adding two Arrays

![alt text](images/adding1.png)
![alt text](images/adding2.png)


* **Grid**: Contains several Thread Blocks


