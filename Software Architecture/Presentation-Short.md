### Architectural Evaluation (Slide 1)
- Architecture must be defined early, embedding critical design decisions  
- Those decisions directly impact our key quality attributes:  
  - Scalability  
  - Security  
  - Maintainability  
  - Usability  
- We chose **ATAM** because:  
  - It’s scenario-based, leveraging our existing Quality Attribute Scenarios  
  - We lack enough prototyping for aSQA’s empirical scoring  
  - It excels at exposing clear trade-offs in scenarios  
- *(Skipping ATAM steps 1–4 due to time and prior coverage of business drivers, system overview, and tactics)*

---

### Quality Attribute Utility Tree (Slide 2)
- Utility tree turns vague quality goals into concrete, prioritized scenarios  
- Scenarios rated as (Business Importance, Difficulty): H/M/L  
  - High importance = top priority in this project phase  
  - Priorities can change over time  
- Only the top-ranked scenarios advanced to detailed analysis (two chosen due to time):  
  1. **Scalability**: process every ticket request (success or failure) within 3 minutes under peak load  
  2. **Security**: under high load, flag 100 % of invalid or replayed tickets  

---

### Analyze Architectural Approaches (Slide 3)
- Documented for each scenario: relevant patterns and tactics  
- Catalogued each approach by:  
  - **Risk**: potential negative consequences when applied  
  - **Non-Risk**: well-understood patterns with low uncertainty  
  - **Sensitivity**: impact strength on the target attribute  
  - **Trade-off**: which other attributes it may weaken  
- *(Details shown in the tables/cards on this slide)*

---

### Results of Architectural Evaluation (Slide 4)
- **Major Risk Themes**:  
  - Performance bottlenecks  
  - Single points of failure  
  - Resource exhaustion  
- **Business Impacts**:  
  - User frustration  
  - Lost sales/revenue  
  - Reputational damage  
- **Key Trade-offs**:  
  - Strong encryption, MFA, intrusion detection → better security but added latency & complexity  
- **Residual Business Risks**:  
  - Mis-tuned or delayed security measures → fraud, unauthorized access, revenue leakage
