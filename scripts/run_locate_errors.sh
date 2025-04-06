#!/usr/bin/env bash
set -e
SCRIPT_DIR=$(cd $(dirname $0); pwd)
echo $SCRIPT_DIR
CTC_DIR=$SCRIPT_DIR/../CTC_evals

for dir in $CTC_DIR/*; do
    if [ -d "$dir" ]; then
        echo "Processing directory: $dir"
        cd "$dir"
        if [ "$(basename $dir)" = "00_4E" ] || [ "$(basename $dir)" = "02_improved_z" ] || [ "$(basename $dir)" = "04_improved_zt1" ] || [ "$(basename $dir)" = "05_improved_zt2" ]; then
            scale=1.24
        else
            scale=2.48
        fi
        echo "Scale: $scale"
        for j in {1..3}; do
            batch_dir="01_RES_detection_flow_batch_00$j"
            if [ -d "$batch_dir" ]; then
                echo "Processing batch directory: $batch_dir"
                python $SCRIPT_DIR/../src/locate_errors.py $batch_dir/DET_log.txt $SCRIPT_DIR/../outputs/$(basename $dir)/$batch_dir $scale
            fi
        done
    fi
done