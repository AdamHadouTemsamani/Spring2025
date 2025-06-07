# Readings week 3

## Availability Patterns
> **Active Redundancy (Hot Spare)**: All nodes process the same inputs in parallel, enabling instant failover. Commonly used for high availability.

> **Passive Redundancy (Warm Spare)**: Only active nodes process inputs; backups receive periodic updates. Offers a tradeoff between performance and cost.

> **Cold Spare**: Backup is off until needed; slow recovery, low cost.

> **Triple Modular Redundancy (TMR)**: Three components vote on output. Increases reliability with moderate cost.

> **Circuit Breaker**: Prevents endless retries on failed services. Enhances system stability during faults.

> **Process Pairs**: Use checkpointing and rollback to enable fast failover.

> **Forward Error Recovery**: Corrects errors using data redundancy to move to a safe state.

## Modifiability Tactics
> **Coupling**: Reduce inter-module dependencies to ease changes.

> **Cohesion**: Keep module responsibilities focused for easier maintenance.

> **Size**: Smaller modules are easier and safer to change.

To Improve Modifiability:

> **Increase Cohesion**: Split modules; redistribute responsibilities.

> **Reduce Coupling**: Use intermediaries, encapsulation, restrict dependencies.

## Performance Tactics
> **Control Resource Demand**: 
> * Limit incoming work (e.g., SLAs, sampling rate).
> * Cap event response rates to maintain performance.
> * Prioritize critical events.

> **Reduce Overhead**:
>* Remove intermediaries.
>* Co-locate resources.
>* Periodically clean up inefficiencies.

> **Bound Execution Time**: Limit algorithm iterations to control latency.

> **Increase Resource Efficiency**: Optimize key algorithms.

> **Manage Resources**:
>* Add or scale resources.
>* Use concurrency.
>* Load balance across servers.
>* Replicate and cache data.
>* Limit queue sizes.
>* Schedule access to resources.

## Security Tactics
> **Detect Attacks**: Intrusion detection, service denial patterns, message integrity checks, delivery anomaly monitoring.

> **Resist Attacks**: 
> * Identify, authenticate, and authorize actors.
>* Limit access and exposure (e.g., firewalls, DMZs).
>* Encrypt data.
>* Separate entities.
>* Validate inputs.
>* Change default credentials.

> **React to Attacks**:
> Revoke access and restrict logins on suspicious behavior.

> **Recover from Attacks**:
>* *Audit*: Log and analyze actions.
>* *Nonrepudiation*: Ensure accountability in communications.