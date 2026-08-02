GlassBox Rule-Based Triage — Nextflow Summit Abstract: Draft Sections

Problem

Genomic variant triage is an important post-processing step after sequencing pipelines such as nf-core/sarek (1), but even lightweight downstream prioritisation workflows can become difficult to audit if their inputs, execution environment, validation rules, and outputs are not captured consistently. This creates a provenance gap: prioritisation outputs may not be reliably traced back to the exact conditions that produced them, making it harder to audit a decision, reproduce a result, or attribute inconsistencies to their true source. Reproducibility challenges of this kind are recognised as a fundamental obstacle in biomedical data science and in the responsible evaluation of computational methods (2). For small research groups and teams operating with limited computational infrastructure, including those in low- and middle-income research settings, the absence of affordable, auditable tooling represents a meaningful barrier to reproducible variant analysis. A lightweight, Nextflow-native pattern that enforces output reproducibility and captures full execution provenance with measurable overhead would address this gap directly.

Note: the current triage logic uses placeholder, deterministic rules for testing this reproducibility pattern. It is not a validated clinical method and must not be used to prioritise real clinical variants.

Methods

A committed test VCF is processed through a bespoke post-processing Nextflow subworkflow implementing a lightweight, deterministic rule-based triage step. The current triage logic uses fixed placeholder rules for testing the reproducibility and provenance-capture pattern; it does not use a machine learning model, large language model, or probabilistic inference component.

Triage is applied under two experimental conditions. In the minimally controlled standard condition, the rule-based triage step is executed without systematic provenance capture or output validation. In the glass-box condition, triage output is constrained to a fixed JSON schema enforced by a dedicated validation process, JSON_VALIDATION, and a structured audit bundle is generated for every run, AUDIT_BUNDLE. The audit bundle records the rule-set version, container image digest, workflow commit hash, input file hash, and execution timestamp. Any output that fails schema validation is quarantined rather than passed downstream.

Each condition is executed in ten independent repeat runs from identical inputs to assess whether the workflow produces stable, reproducible outputs under repeated execution. A baseline run without downstream triage quantifies the computational overhead attributable to the subworkflow. Primary outcome measures include exact and field-level output concordance across replicate runs; schema-pass and quarantine rates; provenance completeness, defined as the proportion of decisions for which a full audit trail can be reconstructed; and per-run wall-clock time. These are assessed using evaluation approaches appropriate for computational workflows and reproducibility testing. A future cloud deployment path remains a possible extension but is outside the scope of the current comparison.

References

1. Hanssen F, Garcia MU, Folkersen L, et al. Scalable and efficient DNA sequencing analysis on different compute infrastructures aiding variant discovery. NAR Genomics and Bioinformatics. 2024;6:lqae031. doi:10.1093/nargab/lqae031.

2. Han H. Challenges of reproducible AI in biomedical data science. BMC Medical Genomics. 2025;18(Suppl 1):8. doi:10.1186/s12920-024-02072-6.

3. Di Tommaso P, Chatzou M, Floden EW, Prieto Barja P, Palumbo E, Notredame C. Nextflow enables reproducible computational workflows. Nature Biotechnology. 2017;35:316-319. doi:10.1038/nbt.3820.

4. Ewels PA, Peltzer A, Fillinger S, Patel H, Alneberg J, Wilm A, Garcia MU, Di Tommaso P, Nahnsen S. The nf-core framework for community-curated bioinformatics pipelines. Nature Biotechnology. 2020;38(3):276-278. doi:10.1038/s41587-020-0439-x.

5. Miller C, Portlock T, Nyaga DM, O'Sullivan JM. A review of model evaluation metrics for machine learning in genetics and genomics. Frontiers in Bioinformatics. 2024;4:1457619. doi:10.3389/fbinf.2024.1457619.
