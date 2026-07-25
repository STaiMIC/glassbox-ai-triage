include { AI_TRIAGE }       from '../modules/ai_triage.nf'
include { JSON_VALIDATION } from '../modules/json_validation.nf'
include { AUDIT_BUNDLE }    from '../modules/audit_bundle.nf'

workflow GLASSBOX_TRIAGE {

    take:
    ch_vcf          // channel: [ val(meta), path(vcf) ]
    ch_schema       // path: docs/schema.json
    sarek_version   // val: string, e.g. "sarek-3.9.0"

    main:
    ch_versions = Channel.empty()

    //
    // Step 1: rule-based triage
    //
    AI_TRIAGE(ch_vcf)
    ch_versions = ch_versions.mix(AI_TRIAGE.out.versions)

    //
    // Step 2: schema validation + quarantine
    //
    JSON_VALIDATION(AI_TRIAGE.out.triage_jsonl, ch_schema)
    ch_versions = ch_versions.mix(JSON_VALIDATION.out.versions)

    //
    // Step 3: audit bundle — join original vcf with validation outputs
    //
    ch_for_audit = ch_vcf
        .join(JSON_VALIDATION.out.valid_jsonl)
        .join(JSON_VALIDATION.out.quarantine_jsonl)

    AUDIT_BUNDLE(
        ch_for_audit,
        AI_TRIAGE.out.triage_jsonl.map { meta, jsonl -> "v1.0.0" }.first(),
        sarek_version
    )
    ch_versions = ch_versions.mix(AUDIT_BUNDLE.out.versions)

    emit:
    valid_jsonl      = JSON_VALIDATION.out.valid_jsonl
    quarantine_jsonl = JSON_VALIDATION.out.quarantine_jsonl
    audit_bundle     = AUDIT_BUNDLE.out.audit_bundle
    versions         = ch_versions
}