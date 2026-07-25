# Glass-Box AI Triage After nf-core/sarek: An Auditable, Low-Cost Nextflow Pattern

This project provides a small, reusable Nextflow subworkflow that sits immediately after an unmodified `nf-core/sarek` run to triage genetic variants. 

When using AI to flag important variants in a patient's genome, variability and lack of traceability create a major "trust problem." This pattern solves that by ensuring every triage decision is highly reproducible, completely traceable, and strictly formatted, which is especially critical for small research groups in low- and middle-income countries requiring affordable infrastructure.

### Main Objectives
* **Strict Validation:** The `AI_TRIAGE` process forces the output into a schema-constrained JSON format rather than free text. A subsequent `JSON_VALIDATION` step actively quarantines any malformed outputs instead of silently accepting them.
* **Full Auditability:** The `AUDIT_BUNDLE` process creates a "receipt" for every single run. It securely logs the exact model version, prompt version, container digest, `sarek` commit, input hash, timestamp, and pass/fail status.
* **Low-Cost Accessibility:** The default deployment runs entirely on GitHub Codespaces with Docker (CPU-only) requiring zero cloud budget ($0). AWS deployment remains available as an optional scale-up path.

## Project Structure
* `docs/`: Project documentation and notes.
* `diagrams/`: Architecture and workflow diagrams.
* `nextflow/`: Core pipeline code, including `modules/` and `subworkflow/`.
* `tests/`: Unit and integration tests for the pipeline.
* `examples/`: Example datasets and configurations.

##  Getting Started

### Prerequisites
* [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html) (version x.x.x)
* Docker

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/STaiMIC/glassbox-ai-triage.git
