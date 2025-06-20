# DevOps Handbook Part I

# Part I – DevOps: Foundations and the Three Ways

## 1. Introduction and Background

- **Convergence of Movements:**
DevOps emerged from the intersection of several management and technology trends such as Lean manufacturing, Agile development, Continuous Delivery, and Toyota Kata. These movements brought lessons in flow, quality, and organizational change.
- **Historical Context:**
    - **Lean Movement:** Emphasized value stream mapping, small batch sizes, and reducing lead times.
    - **Agile Manifesto:** Introduced frequent, incremental delivery and small, high‐trust teams.
    - **Continuous Delivery & Infrastructure as Code:** Evolved practices that allow code (and infrastructure) to be always in a deployable state.
    - **Toyota Kata:** Focused on continuous improvement through routine, scientific experimentation.

---

## 2. Value Streams: From Manufacturing to Technology

- **Manufacturing Value Stream:**
    - Defined as the sequence of activities (from customer request to delivery) that transforms raw materials into finished goods.
    - Emphasizes flow, reducing waste, and minimizing delays.
- **Technology Value Stream:**
    - Transforms a business idea or hypothesis into a technology-enabled service.
    - Begins with work entering the backlog and ends when working code is deployed in production.
- **Key Metrics:**
    - **Lead Time:** Total time from when a request is made until it’s fulfilled (what the customer experiences).
    - **Processing (or Task) Time:** Only the active time spent working on the request, excluding waiting times.
    - Reducing waiting time (i.e., the ratio of processing time to lead time) is crucial for fast flow.

---

## 3. The Three Ways: Core Principles of DevOps

### The First Way: Flow

- **Objective:** Accelerate the left-to-right flow from Development to Operations to the customer.
- **Key Practices:**
    - **Make Work Visible:**
    Use visual boards (e.g., kanban) to display work items across the entire value stream.
    - **Limit Work in Process (WIP):**
    Set strict limits on the number of active items to reduce multitasking and context switching.
    - **Reduce Batch Sizes:**
    Work in small, incremental batches (or even single-piece flow) to lower rework and detect defects early.
    - **Minimize Handoffs:**
    Decrease the number of transitions between teams to reduce delays, miscommunication, and lost context.
    - **Continually Identify & Elevate Constraints:**
    Use techniques like value stream mapping to find bottlenecks and address them systematically.
    - **Eliminate Waste and Hardships:**
    Identify non–value-added work (e.g., excessive documentation, waiting, unnecessary approvals) and remove it.

---

### The Second Way: Feedback

- **Objective:** Create fast, continuous, and high-quality feedback loops from right to left.
- **Key Practices:**
    - **Rapid Detection of Issues:**
    Integrate automated testing, continuous integration, and pervasive telemetry to detect errors early.
    - **Work Safely in Complex Systems:**
    Recognize that in a complex, interconnected system, small failures can cascade—feedback loops help prevent or contain these.
    - **Swarm and Solve:**
    When problems occur, teams “swarm” them (similar to the Toyota Andon cord approach) to diagnose, fix, and capture learning immediately.
    - **Push Quality Closer to the Source:**
    Empower teams (including developers) to perform their own testing and quality checks rather than relying solely on downstream QA or Ops.

---

### The Third Way: Continual Learning and Experimentation

- **Objective:** Build a high-trust culture that values learning, scientific experimentation, and resilience.
- **Key Practices:**
    - **Foster a Culture of Experimentation:**
    Encourage teams to take calculated risks, run controlled experiments, and learn from both successes and failures.
    - **Institutionalize Learning:**
    Use practices like blameless post-mortems to turn incidents into learning opportunities and share findings across the organization.
    - **Transform Local Discoveries into Global Improvements:**
    Codify individual insights (via documentation, shared repositories, etc.) so that improvements benefit the entire organization.
    - **Inject Resilience Patterns:**
    Regularly simulate failures (e.g., Game Day exercises, Chaos Monkey) to test system resilience and ensure rapid recovery.
    - **Leadership’s Role:**
    Leaders should coach and support teams by reinforcing a learning culture, setting clear improvement targets, and facilitating iterative, scientific problem solving (often via methods like the Improvement Kata).

---

## 4. Key Lean and Agile Principles in DevOps

- **Small Batch Sizes & WIP Reduction:**
Both Lean and Agile emphasize minimizing work in progress to lower defects and improve flow.
- **Continuous Improvement:**
Daily, iterative enhancements and quick feedback cycles lead to safer, more reliable outcomes.
- **Empowerment and High Trust:**
High-performing teams are built on trust—both in decision making and in sharing responsibility for quality and improvement.
- **Alignment to Global Goals:**
Every step in the value stream should be optimized not just for local efficiency but for overall customer value and business objectives.

---

## Conclusion

Part I lays the foundation for understanding how DevOps transforms technology work by:

- Reducing deployment lead times from months to minutes,
- Enhancing flow, feedback, and continual learning,
- Drawing on decades of Lean, Agile, and manufacturing principles,
- And creating a culture where every team member is empowered to learn, experiment, and improve.

# Ansible Versus Bash

Ansible and a simple Vagrant shell provisioner represent two very different approaches to configuring a machine. Here are the key differences:

**1. Declarative vs. Imperative:**

- **Ansible:** Uses a declarative YAML-based language in playbooks, where you specify the *desired state* of the system. Ansible figures out how to achieve that state.
- **Bash Provisioning:** Involves writing imperative shell scripts that list commands to be executed step by step. You must manually handle order, error checking, and state management.

**2. Idempotence and Reliability:**

- **Ansible:** Tasks are typically designed to be idempotent, meaning that re-running a playbook won’t change the system if it’s already in the desired state. This minimizes errors during repeated provisioning.
- **Bash Provisioning:** Shell scripts are not inherently idempotent. Extra effort is needed to add checks (e.g., “if not installed, then install”) to avoid duplicate operations or unintended changes.

**3. Modularity and Reusability:**

- **Ansible:** Offers roles, modules, and playbooks that allow you to break down configuration into reusable, modular components. This makes it easier to manage complex setups or reuse code across projects.
- **Bash Provisioning:** Scripts tend to be monolithic, meaning that reusing parts of your provisioning logic across different projects can require significant manual rework.

**4. Ecosystem and Community Support:**

- **Ansible:** Comes with a rich ecosystem of modules for common tasks (installing packages, managing files, configuring services, etc.) and benefits from a large, active community sharing best practices and roles.
- **Bash Provisioning:** Relies on your own scripts and manual commands, which means you’re responsible for handling all nuances without the support of a dedicated module system.

**5. Error Handling and Maintenance:**

- **Ansible:** Built-in error handling and reporting make it easier to detect issues and maintain configurations over time. You can also use variables, conditionals, and loops to simplify complex logic.
- **Bash Provisioning:** Requires you to implement error handling manually, which can make the scripts harder to debug and maintain as they grow in complexity.

**6. Scalability and Orchestration:**

- **Ansible:** Designed to manage multiple machines simultaneously, making it a good choice for both local development and production environments where consistent configuration across many hosts is needed.
- **Bash Provisioning:** Typically used for provisioning a single VM in a Vagrant environment, and scaling beyond that scenario usually means writing additional, often repetitive, scripts.