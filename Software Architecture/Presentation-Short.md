### Architectural Evaluation (Slide 1)

- Designed Early, critical design decisions
- Evaluates, impact on QA; scalability, security, maintainability, usability
- ATAM; scenario-based (QAS) vs aSQA (QA), not enough empirical evidence
- Skip Step 1-4

---

### Quality Attribute Utility Tree (Slide 2)
- Step 5: Utility tree, refine important QA goals + priotitization
  - Business Importance vs. Difficulty in Achieving (H, M, L)
- Highest ranked scenarious
- Time constraint/quality

---

### Analyze Architectural Approaches (Slide 3)
- Scalability: must process all tickets within 3 minutes
- Security: invalid/reused ticket must be flagged correctly
- Documented scenario/quality requirement with architectural approaches (tactics/patterns)
  - How are they realized
- Catalogued in Risk, Non-Risk, Sensitivity, Trade-off
- Results shown in table/cards   

---

### Results of Architectural Evaluation (Slide 4)

- Three major risk themes:
  - Performance bottlenecks, SPoF, Resource exchaustion
  - Can result in: user frustration, lost sales, reputational damage
- Trade off points
  - Security vs. Performnce
  - Have to be tuned correctly
