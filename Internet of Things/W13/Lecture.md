# Lecture 13 - Satellite IoT


### Context & Motivation

- Goal: Enable global IoT connectivity for remote, autonomous, and low-power devices
- Focused on "things" (not people), often in inaccessible areas
- Data needs are small – not broadband

---

### Why Satellite LoRa Is New

- Traditional satellite systems (e.g., Iridium, Starlink) are high power, high cost
- LoRa offers low power, low cost, long-range connectivity
- Satellite LoRa is optimized for small data and energy efficiency

---

### Terrestrial LPWAN Overview

- LPWAN = Low Power Wide Area Networks
- Dominant standards: LoRa and NB-IoT
- LoRa advantages:
  - High link budgets (150–160+ dB)
  - Uses license-free ISM bands
  - Open, flexible ecosystem (LoRaWAN)

---

### LoRa Technical Overview

- LoRa (Layer 1 - PHY)
  - Chirp Spread Spectrum (CSS)
  - Frequencies: 433, 868/915 MHz, 2.4 GHz
  - Bandwidth: 125/250/500 kHz
  - Data rates: Up to 11 kbps

- LoRaWAN (Layer 2 - MAC)
  - Open standard built on LoRa
  - Supports public, private, and hybrid networks (e.g., TTN, Helium)

- Duty cycle regulations (Europe):
  | Band | Duty Cycle |
  |------|------------|
  | K    | 0.1%       |
  | L/M/Q | 1%         |
  | N    | 0.1%       |
  | P    | 10%        |

---

### Terrestrial LoRa Performance Highlights

- TTN (The Things Network): ~20,000 gateways, mainly in Europe
- Examples:
  - Sea cruise tracking: up to 200 km
  - Longest recorded LoRa link: 1336 km
  - Moon bounce using LoRa (with high-power amp)

---

### Satellite Orbits

| Orbit | Altitude         | Typical Use     |
|-------|------------------|-----------------|
| LEO   | 160–2000 km      | Satellite IoT   |
| MEO   | 2000–35786 km    | Navigation      |
| GEO   | 35786 km         | Communication   |

- Polar orbits offer full Earth coverage, including remote regions

---

### Satellite IoT Operation

- IoT devices send data:
  - Direct-to-satellite (DTS)
  - Or via aggregator/gateway
- Satellite gateways can integrate with terrestrial networks like TTN

---

### Cubesats and Costs

- Cubesats: Small (10x10x10 cm), ~2 kg
- Launch cost: ~$10k–20k per kg
- Build cost (DIY): $100–1000 using COTS parts
- Pre-built cubesats: ~€10,000
- Hidden costs: admin, licensing, coordination

---

### Use Cases for Satellite LoRa

- Application areas:
  - Agriculture, energy, logistics, pipelines, conservation, maritime, tourism, utilities
- Special environments:
  - Polar, mountainous, remote

---

### Projects and Constellations

- Lacuna.space: EU868 deployment, up to 1700 km
- Swarm (acquired by SpaceX): Discontinued sub-GHz
- Echostar: Using LoRa to GEO (S-band, ISM)
- TinyGS:
  - Ground stations using ESP32 TTGO (~$30)
  - 1500+ stations
  - ~30 satellites on 430/400/915 MHz
- DISCOSAT (Denmark): Student-built cubesat with ML; LoRa planned for DISCOSAT-2

---

### Capacity Challenges and LR-FHSS

- LoRa has limited capacity:
  - ~5k to 150k packets/day per channel (based on spreading factor and ADR)
- Satellite passes offer short windows → congestion risk
- LR-FHSS (LoRa + frequency hopping) solves this:
  - Higher capacity
  - Supports simultaneous packet reception
  - Supported by chipsets like LR1110

---

### Regulations

- Currently governed by SRD (Short Range Device) rules
  - Bodies: ITU, ETSI, FCC
- Ongoing debate:
  - Should satellite IoT be regulated separately from terrestrial IoT?
  - Example: Will Kenya adopt EU868?

---

### Space Is Getting Crowded

- LEO is becoming congested with satellites
- De-orbiting doesn’t fully prevent space traffic issues
- Collision avoidance is increasingly important

---

### Conclusion: Why Satellite LoRa Matters

- Enables IoT where no terrestrial network exists
- Device cost: ~$100
- Operating cost: $/month/device
- Long battery life, compatible with energy harvesting
- Integrates with existing LoRaWAN infrastructure
