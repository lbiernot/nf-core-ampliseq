process SBDIEXPORT {
    tag "${asvtable},${taxonomytable},${metadata}"
    label 'process_low'

    conda (params.enable_conda ? "/root/miniconda/envs/r-tidyverse" : null)

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/r-tidyverse:1.2.1' :
        '432304291388.dkr.ecr.us-east-1.amazonaws.com/nextflow:r-tidyverse-1.2.1' }"

    input:
    path asvtable
    path taxonomytable
    path metadata

    output:
    path "*.tsv"       , emit: sbditables
    path "versions.yml", emit: versions

    script:
    def args = task.ext.args ?: ''
    """
    sbdiexport.R $args $asvtable $taxonomytable $metadata

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        R: \$(R --version 2>&1 | sed -n 1p | sed 's/R version //' | sed 's/ (.*//')
    END_VERSIONS
    """
}
