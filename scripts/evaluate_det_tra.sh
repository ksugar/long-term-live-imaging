#!/usr/bin/env bash
set -e
SCRIPT_DIR=$(cd $(dirname $0); pwd)
echo $SCRIPT_DIR
CTC_DIR=$SCRIPT_DIR/../CTC_evals

for dir in $CTC_DIR/*; do
    if [ -d "$dir" ]; then
        echo "Processing directory: $dir"
        cd "$dir"
        for j in {1..3}; do
            batch_dir="01_RES_detection_flow_batch_00$j"
            if [ -d "$batch_dir" ]; then
                echo "Processing batch directory: $batch_dir"
                mv "$batch_dir" 01_RES
                $SCRIPT_DIR/../EvaluationSoftware/Linux/DETMeasure . 01 3
                $SCRIPT_DIR/../EvaluationSoftware/Linux/SEGMeasure . 01 3
                $SCRIPT_DIR/../EvaluationSoftware/Linux/TRAMeasure . 01 3
                $SCRIPT_DIR/summarize_det_errors.sh 01_RES/DET_log.txt
                $SCRIPT_DIR/summarize_tra_errors.sh 01_RES/TRA_log.txt
                mv 01_RES "$batch_dir"
            fi
        done
    fi
done