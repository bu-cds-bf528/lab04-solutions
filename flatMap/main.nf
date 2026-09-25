#!usr/bin/env nextflow

params.samplesheet = "${projectDir}/samplesheet.csv"

include {FASTQC} from './modules/fastqc'

workflow {

    // fromPath() + splitCsv() reads the samplesheet as one emission per row
    // each row is created as a map, not a record

    samplesheet_ch = channel.fromPath(params.samplesheet)
    .splitCsv(header: true)
    .map { row -> record(name: row.sample, r1: file(row.r1), r2: file(row.r2)) }
    
    // TODO: Use flatMap to transform fastqc_input_ch so that it contains 4 separate
    // elements (1 for each FASTQ file)

    fastqc_input_ch = samplesheet_ch.flatMap { it -> [record(name: it.name, fastq: it.r1), record(name: it.name, fastq: it.r2)] }

    // TODO: Call the FASTQC process on your newly created channel

    fastqc = FASTQC(fastqc_input_ch)
    

}
