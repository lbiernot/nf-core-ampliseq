process QIIME2_ANCOM_ASV {
    tag "${table.baseName}"
    label 'process_medium'
    label 'single_cpu'
    label 'process_long'
    label 'error_ignore'

    conda (params.enable_conda ? { exit 1 "QIIME2 has no conda package" } : null)
    container "quay.io/qiime2/core:2022.8"

    input:
    tuple path(metadata), path(table)

    output:
    path("ancom/*")     , emit: ancom
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    export XDG_CONFIG_HOME="\${PWD}/HOME"

    qiime composition add-pseudocount \\
        --i-table ${table} \\
        --o-composition-table comp-${table}
    qiime composition ancom \\
        --i-table comp-${table} \\
        --m-metadata-file ${metadata} \\
        --m-metadata-column ${table.baseName} \\
        --o-visualization comp-${table.baseName}.qzv
    qiime tools export --input-path comp-${table.baseName}.qzv \\
        --output-path ancom/Category-${table.baseName}-ASV

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qiime2: \$( qiime --version | sed '1!d;s/.* //' )
    END_VERSIONS
    """
}
