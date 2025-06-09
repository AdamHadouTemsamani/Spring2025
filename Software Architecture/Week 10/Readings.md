# Symphony - View-Driven Software Architecture Reconstruction

## 1. Overview

- **Purpose of Symphony:**
    
    To provide a systematic, view-driven process for reconstructing a software system’s architecture. This process supports tasks like migration, auditing, integration, and impact analysis when existing architecture documentation is outdated or unavailable.
    
- **Motivation:**
    - Architecture reconstruction is needed when the implementation and existing documentation diverge.
    - Provides a common framework to report, compare, and refine reconstruction efforts.
    - Aids in continuous conformance checking and serves as a research tool to explore new reconstruction techniques.

---

## 2. Key Concepts and Terminology

### 2.1 Architectural Views and Viewpoints

- **View:**
    
    A representation of a system from the perspective of a related set of concerns.
    
    *(E.g., module structure, runtime configuration, data flow)*
    
- **Viewpoint:**
    
    The rules, conventions, and methods used to create and analyze a view. IEEE 1471 defines the relationship between views and viewpoints.
    
- **Types of Views in Reconstruction:**
    - **Source View:** Extracted directly from the system’s artifacts (e.g., source code, configuration files). May include low-level details like syntax trees or control flow graphs.
    - **Target View:** Represents the as-implemented architecture; it is an abstraction that contains the information needed to address a specific problem.
    - **Hypothetical View:** A reference or baseline view (often derived from stakeholder interviews or existing documentation) used to compare with the reconstructed target view.

### 2.2 Mapping and Relationships

- **Mapping Rules:**
    
    Formal and informal rules that describe how to transform information from the source view into the target view.
    
    - They may use formal techniques (e.g., relational algebra) or heuristic guidelines.
    - In some cases, mappings must be populated manually to account for non-automated details.
- **Example – Reflexion Model:**
    - Uses relationships such as convergence, divergence, and absence to compare the recovered source information with a hypothetical high-level design.
    - Serves as a concrete example of how source and target views can be related via mapping rules.

---

## 3. The Symphony Process

Symphony is divided into two main stages: **Reconstruction Design** and **Reconstruction Execution**. These stages are often iterated to refine both the understanding of the problem and the reconstruction process.

### 3.1 Reconstruction Design

### A. Problem Elicitation

- **Goal:**
    
    Identify and understand the architectural issues that necessitate a reconstruction (e.g., performance problems, maintenance difficulties, integration issues).
    
- **Activities:**
    - Conduct structured workshops and interviews with stakeholders (developers, testers, managers, users).
    - Collect and summarize experiences, high-level documentation, and problems in a short memorandum.
    - Integrate diverse technical viewpoints into a cohesive problem statement.

### B. Concept Determination

- **Goal:**
    
    Define what architectural information is needed to address the identified problems.
    
- **Activities:**
    - **Identify Potentially Useful Viewpoints:**
        
        Review stakeholder input and existing libraries of viewpoints (e.g., Module, Code Architecture, Execution, Conceptual) to select relevant ones.
        
    - **Define/Refine the Target Viewpoint:**
        
        Establish which relationships and architectural elements must appear in the target view. This may involve:
        
        - Listing candidate views.
        - Prioritizing relationships (e.g., usage dependencies, containment).
        - Refining or creating new viewpoints if standard ones do not suffice.
    - **Define/Refine the Source Viewpoint:**
        
        Determine the artifacts and details to be extracted from the system (e.g., directory structure, function calls, build configurations).
        
    - **Define/Refine Mapping Rules:**
        
        Establish how to convert data from the source view into the target view using formal or heuristic rules.
        
    - **Determine the Role of the Hypothetical View:**
        
        Decide if a baseline (hypothetical) view is needed to guide or compare the reconstruction process.
        

### 3.2 Reconstruction Execution

Uses an extract–abstract–present cycle to obtain and transform the architectural information.

### A. Data Gathering

- **Objective:**
    
    Collect low-level data from system artifacts to build the source view.
    
- **Techniques:**
    - **Static Analysis:**
        
        E.g., lexical analysis (using grep, awk, perl), syntactic parsing (using parsers or island grammars).
        
    - **Dynamic Analysis:**
        
        E.g., runtime tracing and profiling to capture execution paths and dynamic interactions.
        
    - **Manual Inspection:**
        
        Using expert knowledge to observe directory structures, build files, etc.
        
- **Outcome:**
    
    A populated repository containing extracted facts from the source code and other artifacts.
    

### B. Knowledge Inference

- **Objective:**
    
    Abstract and condense the detailed source view into higher-level architectural information to produce the target view.
    
- **Activities:**
    - **Create the Map:**
        
        Combine domain knowledge with data to define how elements in the source view relate to architectural constructs in the target view.
        
    - **Apply Mapping Rules:**
        
        Use formal techniques (e.g., relational algebra, Prolog, SQL) or semi-automatic methods to infer architectural relationships.
        
    - **Iterative Refinement:**
        
        Refine the map based on results, domain expertise, and hidden dependencies discovered during inference.
        

### C. Information Interpretation

- **Objective:**
    
    Present and analyze the target view so stakeholders can draw actionable conclusions.
    
- **Techniques and Considerations:**
    - **Visualization:**
        
        Graphs (e.g., UML diagrams, object graphs) are common for showing architectural relations. Visualizations should support navigation (zooming, filtering, cross-referencing).
        
    - **Traceability:**
        
        Ensure that each inferred architectural fact can be traced back to the original data, enhancing credibility and usability.
        
    - **Interaction:**
        
        Provide interactive elements so users can query, refine, and better understand the architecture.
