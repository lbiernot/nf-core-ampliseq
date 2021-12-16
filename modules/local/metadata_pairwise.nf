process METADATA_PAIRWISE {
    tag "$metadata"
    label 'process_low'

    conda (params.enable_conda ? "bioconductor-dada2=1.20.0" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/bioconductor-dada2:1.20.0--r41h399db7b_0' :
        'quay.io/biocontainers/bioconductor-dada2:1.20.0--r41h399db7b_0' }"

    input:
    path(metadata)

    output:
    stdout

    script:
    """
    metadata_pairwise.r ${metadata}
    """
}
