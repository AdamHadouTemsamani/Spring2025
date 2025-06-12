# Introduction to operating systems
## What happens when a program runs
> When a program runs, it executes instructions—millions or billions per second. The CPU:
>* Fetches an instruction from memory
>* Decodes it
>* Executes it (e.g., adds numbers, jumps to a function, accesses memory)

This cycle continues until the program finishes.

To manage programs and system resources, we use the Operating System (OS).

## What the OS Does
> The OS:
>* **Virtualizes hardware** (CPU, memory, disk) into easy-to-use, powerful abstractions
>* Provides **APIs and system calls** to interact with hardware (e.g., running programs, accessing files)
>* Acts as a **resource manager**, ensuring fair and efficient use of CPU, memory, and I/O devices

## Persistence
> Since main memory (like DRAM) is volatile, data is lost on shutdown or crash. To preserve data:
>* **Hardware** provides persistent storage (e.g., HDDs, SSDs)
>* **The file system** manages this storage, maintaining data reliably and efficiently

## OS Design Goals
> An OS aims to:
> * Build useful **abstractions**
>* Offer **high performance** and **low overhead**
>* Ensure **protection** between apps and the OS
>* Be **reliable** and always running
>* Support **security**, **energy-efficiency**, and **mobility**




