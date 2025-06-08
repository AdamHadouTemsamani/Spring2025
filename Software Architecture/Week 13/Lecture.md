# Lecture 13 - Dynamic Analysis

In the previous lectures we lookated the source code, version control, and the interesting information available there.

*However now it is for: the running system itself*.

**There are multiple ways in which we can analyze a running system**
* add ad hoc logging statements to the system
* instrument the code that is being executed by using reflection
* monitor network traffic for distributed systems

### Limitations of Static Analysis

*How are you going to run a dead code detection analysis*
* How are we going to do it with static analysis
* What are the limitations of static analysis in this particular problem?
  * code might look connected to the rest of the call graph but never be called in practice
  * code might look disconnected but be called using reflection, or be an entry point for testing, or ...

**Overestimates some relationships**
* One such example is runtime polymorphism - from studying the source code one can not know which of the many alternative implementations is actually used

**Some information is only really available at runtime**
* dynamic code evaluation
* code that is dependent on user-driven input
* usage of reflection
  
**Can not provide information execution properties**
* memory consumption, running times, and timing might be architecturally relevant

### What is Dynamic Analysis?

> A technique of program analysis that consists of observing the behavior of a program while it is executing. 

* Dynamic analysis collects execution traces = records of the sequence of actions that happened during an execution.


### How to instrument systems for analysis?

The key activity in dynamic analysis is instrumenting the system, that is, modifying the system such that we can extract information from its execution.

#### Logging

Adding log statements in the program can help collect traces of its execution

**Benefits**:
* Allows surgical precision
* Technology is straightforward to use

**Limitations**:
* Invasive
* Tracking logs in distirbuted systems is challenging
  * Solution 1:  tracing the sequence of messages in a distributed system
  * Solution 2: centralized logging


### Dynamic Behavior Modification

What if we could modify every method call to log it's call automatically. Not by adding a log statement at the beginning of every method, that would not scale.

#### Approach #1: Using Reflection

Reflection is the ability of a program to manipulate as data something representing the state of the program during its own execution

There are two kinds of reflections:
1. Introspection is the ability for a program to observe and therefore reason about its own state.
2. Intercession is the ability for a program to modify its own execution state or alter its own interpretation or meaning.


#### Runtime Instrumentation

RT is a technique that modifies the generated code representation in order to avoid modifying the actual code.

#### Network Traffic Analysis
Not considered as part of traditional dynamic analysis but becomes more relevant
* useful for service oriented architectures
* monitors the messages on the wire
* powerful approach for reverse engineering services

### How to Run the Instrumented Systems?

*Running the code itself might pose challenges*:
* Configuration
* Dependencies
* Unwritten rules
* Some systems don't have a clear entry point (e.g. libraries)

### Limitations of Dnyamic Analysis
*Limited by execution coverage*:
* A program does not reach an execution point... => no data (e.g. Word but user never uses the print option)
*Can slow down the application considerably*:
* Imagine dupling functions calls becuase of the print statement
*Can result in a large amount of date*
* For large and complex systems

### Benefits of dynamic analysis

Dynamic analysis is an essential complement for static analysis for dependency extraction.

The information extracted from dynamic analysis can be aggregated along the same axes as static.

