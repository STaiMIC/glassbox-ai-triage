process AUDIT_BUNDLE {
    tag "$meta.id"
    label 'process_single'

    container 'python:3.11-slim'

    input:
    tuple val(meta), path(vcf), path(valid_jsonl), path(quarantine_jsonl)
    val rule_version
    val sarek_version

    output:
    tuple val(meta), path("${meta.id}.audit_bundle.json"), emit: audit_bundle
    path "versions.yml",                                    emit: versions

    script:
    """
    audit_bundle.py ${vcf} ${valid_jsonl} ${quarantine_jsonl} ${rule_version} ${sarek_version} ${meta.id}.audit_bundle.json

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python3 --version | sed 's/Python //')
    END_VERSIONS
    """
}