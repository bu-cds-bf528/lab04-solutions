// Exercise: map() -- per-sample transform (1:1)
//
// Use case: normalize a samplesheet into inputs for per-sample FastQC.
// map() is cardinality-preserving: N records in, N records out, just transformed.

params.samplesheet = "${projectDir}/samplesheet.csv"

include { FASTQC } from './modules/fastqc'

workflow {
    // fromPath() + splitCsv() reads the samplesheet as one emission per row
    // each row is created as a linked hashmap, not a record

    // TODO: Use map to transform each element produced by .splitCsv to a record
    // matching the requirement for FASTQC

    fastqc_input_ch = channel.fromPath(params.samplesheet)
    .splitCsv(header: true)
    .map { row -> record(name: row.sample, fastq: file(row.fq))}
    

    // TODO: Run Fastqc on the channel you created

    fastqc_out = FASTQC(fastqc_input_ch)
    

    


}
