workflow {

    // Case 1: channel.of()
    //
    // TODO: Predict how many lines .view() will print below. Then run
    // this file and check.
    //
    // TODO: Add one line that calls .count() on ch_a and .view()s it.
    ch_a = channel.of('sample_a', 'sample_b', 'sample_c', 'sample_d')
    ch_a.view { v -> "[case 1] $v" }
    ch_a.count().view()

}
