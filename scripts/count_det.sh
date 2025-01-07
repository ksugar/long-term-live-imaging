#!/bin/bash

# Function to display help
display_help() {
    echo "Usage: $0 [option] <file_path>"
    echo
    echo "Options:"
    echo "  -h, --help   Show this help message and exit"
    echo
    echo "Arguments:"
    echo "  file_path    Path to the log file"
}

# Check if the first argument is -h or --help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# Check if the file path is provided
if [[ -z "$1" ]]; then
    echo "Error: No file path provided."
    display_help
    exit 1
fi

# File path
FILE_PATH=$1

# Check if the file exists
if [[ ! -f "$FILE_PATH" ]]; then
    echo "Error: File not found."
    display_help
    exit 1
fi

# Extract and count lines using sed
split_ops_count=$(sed -n '/----------Splitting Operations (Penalty=5)----------/,/----------False Negative Vertices (Penalty=10)----------/p' "$FILE_PATH" | grep -c "T=")
fn_vertices_count=$(sed -n '/----------False Negative Vertices (Penalty=10)----------/,/----------False Positive Vertices (Penalty=1)----------/p' "$FILE_PATH" | grep -c "T=")
fp_vertices_count=$(sed -n '/----------False Positive Vertices (Penalty=1)----------/,/----------/p' "$FILE_PATH" | grep -c "T=")

# Print the counts
echo "Splitting Operations: $split_ops_count"
echo "False Negative Vertices: $fn_vertices_count"
echo "False Positive Vertices: $fp_vertices_count"