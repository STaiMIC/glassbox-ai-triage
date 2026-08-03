#!/usr/bin/env python3
"""
ai_triage.py
~~~~~~~~~~~~
Rule-based, deterministic variant triage. No AI model calls, CPU-only.
Reads a VCF, applies simple scoring rules per variant, writes one JSON object per variant (matching docs/schema.json) as JSON Lines.
"""
import sys
import json
import gzip
from datetime import datetime, timezone

RULE_VERSION = "v1.0.0"


def open_vcf(path):
    if path.endswith(".gz"):
        return gzip.open(path, "rt")
    return open(path, "r")


def score_variant(chrom, pos, ref, alt, qual, filt, info):
    """Deterministic rule-based scoring. Returns (score, rules_triggered)."""
    score = 0
    rules = []

    # Rule 1: passed VCF filtering
    if filt == "PASS":
        score += 3
        rules.append("passed_filter")

    # Rule 2: high quality call
    try:
        if qual != "." and float(qual) >= 30:
            score += 2
            rules.append("high_quality_call")
    except ValueError:
        pass

    # Rule 3: indel (often higher functional impact than simple SNPs)
    if len(ref) != len(alt):
        score += 3
        rules.append("indel_variant")

    # Rule 4: reasonable read depth, if present in INFO
    for field in info.split(";"):
        if field.startswith("DP="):
            try:
                dp = int(field.split("=")[1])
                if dp >= 10:
                    score += 2
                    rules.append("adequate_depth")
            except (ValueError, IndexError):
                pass

    score = min(score, 10)
    return score, rules


def main(vcf_path, out_path):
    timestamp = datetime.now(timezone.utc).isoformat()

    with open_vcf(vcf_path) as vcf, open(out_path, "w") as out:
        for line in vcf:
            if line.startswith("#"):
                continue
            fields = line.rstrip("\n").split("\t")
            if len(fields) < 8:
                continue

            chrom, pos, _id, ref, alt, qual, filt, info = fields[:8]
            variant_id = f"{chrom}_{pos}_{ref}_{alt}"

            score, rules = score_variant(chrom, pos, ref, alt, qual, filt, info)

            record = {
                "variant_id": variant_id,
                "priority_score": score,
                "rules_triggered": rules,
                "rule_version": RULE_VERSION,
                "timestamp": timestamp,
            }
            out.write(json.dumps(record) + "\n")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit("Usage: ai_triage.py <input.vcf[.gz]> <output.jsonl>")
    main(sys.argv[1], sys.argv[2])