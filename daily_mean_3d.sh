#!/usr/bin/env bash

export TMPDIR=${SCRATCH}/temp
mkdir -p ${TMPDIR}

module load cdo

# Load configs
source $(dirname "$0")/configs.sh

# Set years and months
YEARS_TO_PROCESS=$(seq 2000 2000)
MONTHS_TO_PROCESS=$(seq 1 1)
VARIABLE_NAME_SHORT="q"
VARIABLE_NAME_LONG="specific_humidity"

OUT_PATH="${OUTPUT_DIR}/daily_means/${VARIABLE_NAME_LONG}"
mkdir -p ${OUT_PATH}

for year in $YEARS_TO_PROCESS; do
  for month in $MONTHS_TO_PROCESS; do
    month=$(printf "%02d" $month)
    echo "Processing Year: $year :: Month: $month"
    year_month_dir=${DATA_DIR_3D}/${year}${month}

    # Get files corresponding to variable
    files=$(find "$year_month_dir" -type f -name "e5.oper.an.pl.1*_${VARIABLE_NAME_SHORT}.*.nc" | sort)

    # Check if the 'files' variable is empty
    if [ -z "$files" ]; then
        echo "No files found in $year_month_dir for pattern e5.oper.an.pl.1*_${VARIABLE_NAME_SHORT}.*.nc"
        exit 1  # Exit with status 1 if no files are found
    else
        for file in ${files}; do
            file_base=$(basename "$file")
            cdo remapcon,r360x180 ${file} ${TMPDIR}/remap.${file_base}
            cdo daymean ${TMPDIR}/remap.${file_base} ${TMPDIR}/daymean.${file_base}
        done
        cdo mergetime daymean* "${OUT_PATH}/daily.${year}.${month}.nc"
    fi
  done
done