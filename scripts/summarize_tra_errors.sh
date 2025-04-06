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
fp_edges_count=$(sed -n '/----------Redundant Edges To Be Deleted (Penalty=1)----------/,/----------Edges To Be Added (Penalty=1.5)----------/p' "$FILE_PATH" | grep -c "T=")
fn_edges_count=$(sed -n '/----------Edges To Be Added (Penalty=1.5)----------/,/----------Edges with Wrong Semantics (Penalty=1)----------/p' "$FILE_PATH" | grep -c "T=")
wrong_semantics_edges_count=$(sed -n '/----------Edges with Wrong Semantics (Penalty=1)----------/,/----------/p' "$FILE_PATH" | grep -c "T=")

# Print the counts
echo "Redundant Edges To Be Deleted (FP): $fp_edges_count"
echo "Edges To Be Added (FN): $fn_edges_count"
echo "Edges with Wrong Semantics: $wrong_semantics_edges_count"
