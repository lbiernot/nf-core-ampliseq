process QIIME2_EXPORT_RELASV {
    label 'process_low'

    conda (params.enable_conda ? { exit 1 "QIIME2 has no conda package" } : null)
    container "quay.io/qiime2/core:2022.8"

    input:
    path(table)

    output:
    path("rel-table-ASV.tsv"), emit: tsv
    path "versions.yml"      , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    export XDG_CONFIG_HOME="\${PWD}/HOME"

    #convert to relative abundances
    qiime feature-table relative-frequency \\
        --i-table ${table} \\
        --o-relative-frequency-table relative-table-ASV.qza

    #export to biom
    qiime tools export \\
        --input-path relative-table-ASV.qza \\
        --output-path relative-table-ASV

    #convert to tab separated text file "rel-table-ASV.tsv"
    biom convert \\
        -i relative-table-ASV/feature-table.biom \\
        -o rel-table-ASV.tsv --to-tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qiime2: \$( qiime --version | sed '1!d;s/.* //' )
    END_VERSIONS
    """
}
