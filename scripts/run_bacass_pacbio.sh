#!/usr/bin/env bash
set -euo pipefail
BASE=$HOME/bacterial_wgs/pacbio_aeromonas
export NXF_APPTAINER_CACHEDIR=$HOME/apptainer_cache
export APPTAINER_CACHEDIR=$HOME/apptainer_cache
cd "$BASE"
nextflow run nf-core/bacass -r 2.6.1 \
  -profile apptainer \
  -c "$BASE/config/run.config" \
  -params-file "$BASE/config/params.yaml" \
  -work-dir "$BASE/work" \
  -resume
