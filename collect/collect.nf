// Exercise: collect() -- many-to-one gather (N -> 1)
//
// Use case: fold all per-replicate FastQC reports into a single MultiQC call.
// Reuses the flatMap() unpacking from ../flatMap so there's real per-replicate
// output to gather.

process FASTQC {
    input:
    val replicate

    output:
    stdout

    script:
    """
    echo "FastQC report for ${replicate.id} (${replicate.fastq})"
    """
}

process MULTIQC {
    input:
    val reports

    output:
    stdout

    script:
    """
    echo "MultiQC summarizing ${reports.size()} FastQC reports"
    """
}

workflow {
    runs_ch = channel.fromList([
        record(id: 'sample_a', reps: ['a_rep1.fq.gz', 'a_rep2.fq.gz', 'a_rep3.fq.gz']),
        record(id: 'sample_b', reps: ['b_rep1.fq.gz', 'b_rep2.fq.gz']),
    ])

    per_replicate_ch = runs_ch.flatMap { r -> r.reps.collect { fq -> record(id: r.id, fastq: fq) } }
    per_replicate_ch.count().view { n -> "[per-replicate: count] $n" }  // 5

    fastqc_reports_ch = FASTQC(per_replicate_ch)

    // collect(): fold all 5 independent report emissions into one list emission.
    // 5 emissions in -> 1 emission out, MULTIQC runs exactly once.
    collected_ch = fastqc_reports_ch.collect()

    collected_ch.view { v -> "[collect: many->1] $v" }
    collected_ch.count().view { n -> "[collect: count] $n" }  // 1

    multiqc_report_ch = MULTIQC(collected_ch)
    multiqc_report_ch.view { r -> "[MultiQC output] ${r.trim()}" }
}
