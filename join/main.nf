// Exercise: join() -- matched pairing by key (N,N -> N)
//
// Use case: each sample was sequenced from a different bacterial strain, so
// reads and reference genomes live in two separate channels keyed by sample
// id. join() matches emissions from two channels on a shared key, rather
// than crossing every combination the way combine() does.

process ALIGN {
    input:
    tuple val(sample), val(reads), val(reference)

    output:
    tuple val(sample), stdout

    script:
    """
    echo "aligned ${reads} for ${sample} against ${reference}"
    """
}

workflow {
    reads_ch = channel.fromList([
        ['sample_a', 'sample_a_R1.fq.gz'],
        ['sample_b', 'sample_b_R1.fq.gz'],
        ['sample_c', 'sample_c_R1.fq.gz'],
    ])

    // Deliberately out of order vs. reads_ch -- join() matches on sample id,
    // not on emission position.
    reference_ch = channel.fromList([
        ['sample_b', 'pseudomonas_aeruginosa.fasta'],
        ['sample_a', 'staph_aureus.fasta'],
        ['sample_c', 'ecoli.fasta'],
    ])

    // TODO: Use join() to pair each sample's reads with its matching reference
    // by sample id (the first tuple element), so ALIGN receives exactly one
    // reference per sample -- not the 3x3 cross product combine() would give.

    align_input_ch = reads_ch.join(reference_ch)

    align_input_ch.view { v -> "[join] $v" }
    align_input_ch.count().view { n -> "[join: count] $n" }  // 3, not 9

    ALIGN(align_input_ch)
}
