rule glori_trim_dedup:
    input:
        unpack(get_raw_fastq),
    output:
        clean_fastq="results/{sample}/gloritools/cleandata/{sample}_rmdup.fq.gz",
        fastp_html="results/{sample}/gloritools/cleandata/{sample}_rmdup.html",
        fastp_json="results/{sample}/gloritools/cleandata/{sample}_rmdup.json",
    params:
        params=config["gloritools"]["fastp"],
    threads: config["threads"]["fastp"]
    conda:
        "../envs/fastp.yaml"
    log:
        log="logs/gloritools/{sample}_fastp.log",
        err="logs/gloritools/{sample}_fastp.err",
    benchmark:
        "benchmarks/gloritools/{sample}_fastp.txt"
    shell:
        " fastp --in1 {input.fastq} "
        " --out1 {output.clean_fastq} "
        " --json {output.fastp_json} "
        " --html {output.fastp_html} "
        " --thread {threads} 1>{log.log} 2>{log.err} "


rule glori_uncompress_fastq:
    input:
        clean_fastq="results/{sample}/gloritools/cleandata/{sample}_rmdup.fq.gz",
        fastp_html="results/{sample}/gloritools/cleandata/{sample}_rmdup.html",
        fastp_json="results/{sample}/gloritools/cleandata/{sample}_rmdup.json",
    output:
        output_fastq=temp("results/{sample}/gloritools/cleandata/{sample}_rmdup.fastq"),
    threads: 1
    conda:
        "../envs/fastp.yaml"
    log:
        log="logs/gloritools/{sample}_uncompressed_fastq.log",
    benchmark:
        "benchmarks/gloritools/{sample}_uncompressed_fastq.txt"
    shell:
        " gzip -dc {input.clean_fastq} > {output.output_fastq} && echo date > {log.log} "


rule glori_trim_umi:
    input:
        rmdup_fastq="results/{sample}/gloritools/cleandata/{sample}_rmdup.fastq",
    output:
        rmumi_fastq="results/{sample}/gloritools/cleandata/{sample}_rmumi.fq",
    params:
        params=config["gloritools"]["fastx_trimmer"],
    threads: config["threads"]["fastx_trimmer"]
    conda:
        "../envs/fastx_toolkit.yaml"
    log:
        log="logs/gloritools/{sample}_fastx_trimmer.log",
        err="logs/gloritools/{sample}_fastx_trimmer.err",
    benchmark:
        "benchmarks/gloritools/{sample}_fastx_trimmer.txt"
    shell:
        "fastx_trimmer {params.params} -i {input.rmdup_fastq} -o {output.rmumi_fastq} 1>{log.log} 2>{log.err}"
