### Architectural Evaluation (Slide 1)

Architecture needs to be designed early. This means that we have to make critical design decisions early. These decisions needs to be evaluated, as they have impact on our quality attributes. Specifically the ones that we deemed architecturally significant: scalability, security, maintainability, and usability. 

To assess this impact we used the Architecture Tradeoff Analysis Method (ATAM for short). We devided to use ATAM as it is a scenario based method. Allowing us to leverage and use our already existing Quality Attribute Scenarios. Additionally we did not feel that have done enough prototyping to have empirical evidence that could allow aSQA to effictlively score and evaluate our architecture. 
Addtionally, there are clear trade-offs in our QAS, which ATAM exeels in. 

I am skipping going through step 1-4 of ATAM due to time constraints, as well as these can be argued to have been done in the presentation so far (present ATAM, present business drivers from QAW and system overview, and present architecture through 3+1, as well as tactics and patterns)

### Quality Attribute Utility Tree (Slide 2)

Next, a utility tree tree was generated. These make our architectrual requirements more concrete than simply explaining the quality attributes to involved parties. Split in Quality Attributes, and further categories.

These were rated in terms of business importancee (left) and difficulty in achieving (right): high (H), medium (M), and low (L).
High business importance represents a high priority for the system to support in the current phase of the project. These can obviously change. 
Afrter deciding the priority of the scenarios, only the highest ranked scnearios were used in the next steps of ATAM; only two were chosen due to time constraints and quality of analysis/evaluation.

Specifically: (next slide)

### Analyze Architectural approaches (slide 3)

Scalability: The system must process all ticket requests as either successful or failed within 3 minutes of issuance
Security: Even under high load, 100% of invalid or reused tickets are correctly flagged when verified by venue security. 

We documented the relevant architectural approaches for the given QAS, and catalogued them into Risk or Non-Risk, Sensitivity points, Trade-off. Which were also analyzed in step 8.

Risks: potential negative consequences/risks when applying a pattern
Non-Risks: well-understood patterns that carry minimal uncertainty
Sensitivity: How strongly this decision affects the target attribute.
Trade-off:  what other attributes may be weakened as a result.

These can be in the tables/cards seen here.

### Results of Architectural Evaluation

Our ATAM analysis found three major risk themes:

Performance bottlenecks, single points of failure, and resource exhaustion—which directly threaten our business drivers by causing user frustration, lost sales, and reputational damage. 

We also uncovered trade-off:

Strong encryption, multi-factor authentication, and proactive intrusion detection bolster security but introduce latency and complexity, which can hurt response times and usability.

If these are mis-tuned or delayed (due to lead), could lead to fraud, unauthorized access, and even revenue leackage. 


