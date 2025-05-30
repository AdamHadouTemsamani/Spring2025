# Questions

## W1 Introduction
```
What are the three major challenges in IoT system design?
```
A: Challenges in IoT
- Immense Scale
  - Billions of tiny devices expected.
  - Must be miniaturized, autonomous, and energy-efficient.
- Limited Access
   - Devices often placed in remote or inaccessible areas.
   - Must operate without human intervention.
- Extreme Dynamics
  - Environmental factors affect communication and function.
  - Need real-time response with low power consumption.


```
Why is self-organization crucial in large-scale IoT deployments?
```

## W2 OS for IoT devices

Which is NOT required in IoT OS?
- A. Real-time Capabilities
- B. Unlimited Memory
- C. Security
- D. Energy Efficiency

A: B

## W3 Smart sensors for IoT

```
What is a smart sensor?
```
A: They detect physical phenomena and often include on-board processing and networking.

```
What are the characteristics of smart sensors?
```
A: Accuracy, sensitivity, response time, range.

## W4 Network Models and Wireless Communication
```
Compare OSI and TCP/IP
```
A: 
- OSI: 7 layers
- TCP/IP: 4 layers

```
Which OSI layer has no equivalent in TCP/IP?

A. Transport
B. Session
C. Application
D. Network
```

A: B

## W5 LPWAN and LoRaWAN

```
What is LPWAN? 
```
A: Long-range, low-power communication for IoT.

```
What is the difference between LoRa and LoRaWAN.
```
A:
- LoRa: Physical layer
- LoRaWAN: Protocol for secure communication

```
What does a LoRaWAN gateway do?
A. Act as a sensor
B. Route packets to server
C. Encrypt application data
D. Power devices
```
A: B

## W6 Time Series Databases and Data Ingestion
```
What Are Time Series Databases (TSDBs)?
```
A: Specialized databases for storing and analyzing time-stamped data.
Examples: InfluxDB, Prometheus, OpenTSDB.

- Key features
  - High write throughput.
  - Compression for time-series data.
  - Support for retention policies and downsampling.
- Tools
  - InfluxDB: Lightweight TSDB.
  - Grafana: Visualization tool for metrics.
  - Used to monitor sensor data, detect trends, visualize performance.

```
Which is NOT a feature of TSDBs?
A. High read latency
B. Data retention policies
C. Time-based queries
D. Downsampling
```
A: A

## W7 Edge Data and Analytics

```
What is Edge Computing?
```
A: Processing data near the source (sensors, edge devices).
- Reduces latency, bandwidth, and improves privacy.

```
Types of Analytics
Descriptive: What happened?

Predictive: What will happen?

Prescriptive: What should be done?
```

```
Which is NOT a benefit of edge computing?
A. Lower latency
B. Reduced bandwidth use
C. Unlimited cloud storage
D. Real-time processing
```
A: C

## W8 Sustainability and the Cloud
```
What are the environmental impacts?
```
A: Data centers consume large amounts of electricity and water.
- Contribute to $CO_2$ emissions (carbon footprint).


## W9 TinyML and Optimization

```
What is TinyML?
```
A: Deploying machine learning models on microcontrollers and constrained devices.

```
What are optimization techniques for TinyML?
```
A:
- Quantization
- Pruning
- Weight clustering

## W10 IoT Security

```
What are the attack surfaces and security challenges in IoT?
```
A: Attack surfaces: Network, devices, software
- Challenges: Limited resources restrict use of traditional security techniques.

```
Name some Security Principles for IoT.
```
A: 
- Least privilege
- Fail-safe defaults
- Psychological acceptability
- No single point of failure