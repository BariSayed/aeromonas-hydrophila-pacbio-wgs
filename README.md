# aeromonas-hydrophila-pacbio-wgs

Long-read whole-genome assembly and annotation of *Aeromonas hydrophila* from publicly
available PacBio sequencing data, using the nf-core/bacass pipeline.

## Overview

This repository documents a reproducible long-read assembly and annotation workflow applied
to secondary (publicly archived) data. No new sequencing was generated. The input reads were
obtained from the European Nucleotide Archive (ENA); the pipeline, configuration files, run
script, and summary outputs are provided so the analysis can be reproduced.

## Input data

| | |
|---|---|
| Organism | *Aeromonas hydrophila* |
| Sequencing platform | PacBio CLR (Sequel) |
| ENA run accession | [`DRR153381`](https://www.ebi.ac.uk/ena/browser/view/DRR153381) |
| Reads | 139,663 |
| Read N50 | 9,508 bp |
| Approximate coverage | ~201x |

## Workflow

Pipeline: **nf-core/bacass 2.6.1**, executed with **Nextflow** and **Apptainer** containers.

1. Read QC and adapter trimming — Porechop and NanoPlot
2. De novo assembly — Flye (`--pacbio-raw`)
3. Long-read polishing — not applied (see note below)
4. Assembly QC — QUAST (contiguity) and BUSCO (`bacteria_odb10`, gene completeness)
5. Annotation — Prokka
6. Aggregate report — MultiQC

No long-read polishing was applied: PacBio reads are not compatible with Medaka (an ONT-specific polisher), and Flye's internal consensus was used as the final assembly.

### Running the workflow

```bash
nextflow run nf-core/bacass -r 2.6.1 \
  -profile apptainer \
  -c config/run.config \
  -params-file config/params.yaml \
  -work-dir work -resume
```

Parameters are defined in `config/params.yaml`. The sample sheet (`config/samplesheet.tsv`)
provides long reads only, so the short-read and Fast5 columns are set to `NA`.

## Results

| Metric | Value |
|---|---|
| Contigs | 2 |
| Total length | 4,997,227 bp |
| Largest contig | 4,958,012 bp |
| N50 | 4,958,012 bp |
| GC content | 61.05% |
| BUSCO completeness | C:99.2%[S:97.6%,D:1.6%],F:0.0%,M:0.8% (bacteria_odb10, n=124) |
| CDS (Prokka) | 4,405 |
| tRNA / rRNA | 125 / 31 |

The final assembly is provided at `results/assembly/aeromonas_pacbio-flye.assembly.fasta.gz`. Full QC and annotation outputs are in
`results/` (`qc/`, `annotation/`, and `multiqc_report.html`).

## Repository contents

```
config/        params.yaml, samplesheet.tsv, run.config
scripts/       run script for the pipeline
results/       assembly FASTA, QUAST and BUSCO summaries, read statistics,
               Prokka annotation, MultiQC report
```

Raw reads and large intermediate files (Nextflow `work/`, full `04_results/`) are not tracked;
see `.gitignore`.

## Tools and versions

Nextflow 26.04 · nf-core/bacass 2.6.1 · Apptainer 1.1.9 · Flye 2.9.5 · QUAST 5.3.0 ·
BUSCO 5.8.3 (bacteria_odb10) · Prokka · MultiQC 1.32 · seqkit 2.1.0

## Data availability and reproducibility

Input reads are publicly available from ENA under accession `DRR153381`:

```bash
wget -c https://ftp.sra.ebi.ac.uk/vol1/fastq/DRR153/DRR153381/DRR153381_subreads.fastq.gz
```

## License

Released under the MIT License. Input sequence data are public ENA records.
