workflow {

    // Case 4: flatMap()
    //
    // TODO: Predict how many lines .view() will print below. Then run
    // this file and check.
    //
    // TODO: Add one line that calls .count() on ch_b and .view()s it.
    ch_a = channel.of(
        record(id: 'sample_a', reps: ['a_rep1.fq.gz', 'a_rep2.fq.gz', 'a_rep3.fq.gz']),
        record(id: 'sample_b', reps: ['b_rep1.fq.gz', 'b_rep2.fq.gz'])
    )
    ch_b = ch_a.flatMap { r -> r.reps.collect { fq -> record(id: r.id, fastq: fq) } }
    ch_b.view { v -> "[case 4] $v" }

    ch_b.count().view()

}
