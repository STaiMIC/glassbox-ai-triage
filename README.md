# Glass-Box Rule-Based Triage After nf-core/sarek: An Auditable, Low-Cost Nextflow Pattern

This project provides a small, reusable Nextflow subworkflow pattern for deterministic, rule-based post-processing of variant-like test data after an nf-core/sarek-style workflow.

> **Note:** The current triage logic uses placeholder, deterministic rules for testing this reproducibility pattern. It is not a validated clinical method and must not be used to prioritise real clinical variants.

When testing reproducibility patterns for variant triage workflows, variability and lack of traceability create a major auditability problem. This repository demonstrates how a deterministic, rule-based triage step can produce structured outputs, validation results, and audit bundles that make each test decision easier to inspect and reproduce.

## Architecture

diagrams/Glass-Box_GlassBox.svg

*VCF-like test inputs are processed through a deterministic triage step, validated against a strict schema, and packaged with an audit trail before reaching final reports. Malformed outputs are quarantined rather than silently accepted.*

## Main Objectives

* **Strict Validation:** The triage process produces schema-constrained JSON output rather than free text.
* **Quarantine Control:** A subsequent JSON_VALIDATION step actively quarantines any malformed outputs instead of silently accepting them.
* **Full Auditability:** The AUDIT_BUNDLE process creates a receipt for every single test run.
* **Metadata Logging:** It records available execution metadata such as ruleset version, container digest, workflow commit, input hash, timestamp, and pass/fail status.
* **Low-Cost Accessibility:** The default development and testing path runs on GitHub Codespaces with Docker using CPU-only execution, keeping baseline usage low-cost.

## Test Data and Fixture Scope

The repository includes committed test fixtures used only for workflow testing and reproducibility checks. No claim is made here about the exact nf-core/sarek version or command used to generate any committed VCF fixture unless that provenance is explicitly documented in the repository.

## Project Structure

* `docs/`: Project documentation and notes.
* `diagrams/`: Architecture and workflow diagrams.
* `nextflow/`: Core pipeline code, including `modules/` and `subworkflow/`.
* `tests/`: Unit and integration tests for the pipeline.
* `examples/`: Example datasets and configurations.

## Getting Started

### Prerequisites

* Nextflow
* Docker

### Installation

Clone the repository:

```bash
git clone https://github.com/STaiMIC/glassbox-ai-triage.git
```

Navigate into the directory:

```bash
cd glassbox-ai-triage
```

## Usage

Run the main pipeline:

```bash
nextflow run main.nf -profile standard
```

## Testing

Instructions for how to run the files in the `tests/` directory.

## Contributing

Guidelines for how team members can contribute to this project.

## Status, Licensing and Attribution

Glass Box is an independent STAiMIC project and is not an official nf-core pipeline. It is not affiliated with, endorsed by, or sponsored by nf-core, the Nextflow project, or Seqera Labs.

Glass Box is implemented using Nextflow and is designed as a reproducibility and auditability pattern for processing workflow-style outputs. Nextflow® is a registered trademark of Seqera Labs, S.L., used here descriptively.

STAiMIC-authored code is licensed under Apache-2.0. Any third-party source code included in this repository remains under its original licence, as identified by the file headers and THIRD_PARTY_NOTICES.md.
