#!/usr/bin/env bash

module load cdo

# Load configs
source $(dirname "$0")/configs.sh

# Set years and months
YEARS_TO_PROCESS=$(seq 2000 2000)
MONTHS_TO_PROCESS=$(seq 1 12)
VARIABLE_NAME_SHORT="q"
VARIABLE_NAME_LONG="specific_humidity"

for year in $YEARS_TO_PROCESS; do
  for month in $MONTHS_TO_PROCESS; do
    month=$(printf "%02d" $month)
    echo "Processing Year: $year :: Month: $month"
    year_month_dir=${DATA_DIR_3D}/${year}${month}

    # get files corresponding to variable
    files=$(find "$year_month_dir" -type f -name "e5.oper.an.pl.1*_${VARIABLE_NAME_SHORT}.*.nc" | sort)
    # Check if the 'files' variable is empty
    if [ -z "$files" ]; then
        echo "No files found in $year_month_dir for pattern e5.oper.an.pl.1*_${VARIABLE_NAME_SHORT}.*.nc"
        exit 1  # Exit with status 1 if no files are found
    else
        echo "Found files: $files"
        for file in $files; do
        echo ${file}
        # output_file="${file%.nc}_dailymean.nc"


        # # Use cdo to compute daily means
        # cdo daymean "$file" "$output_file"
        # echo "Created daily mean file: $output_file"
        done 
    fi
  done
done

