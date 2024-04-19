#!/bin/bash

# Input: File with patterns (one pattern per line)
read -p "Enter the path to the file with patterns (default is patterns.txt): " patterns_file

# Use default if no input is provided
patterns_file=${patterns_file:-"patterns.txt"}

# Check if the file exists
if [ ! -f "$patterns_file" ]; then
    echo "Error: Patterns file not found."
    exit 1
fi

# Read patterns from the file into an array
patterns=($(<"$patterns_file"))

# Get the number of patterns
num_patterns=${#patterns[@]}

# Input: File with table data
read -p "Enter the path to the table file (default is ../Gokir_pan.red.txt): " input_file

# Use default if no input is provided
input_file=${input_file:-"../Gokir_pan.red.txt"}

# Check if the file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Table file not found."
    exit 1
fi

# Output: File for result (optional)
read -p "Enter the path to the output file (leave blank for no output file): " output_file

# Iterate through each line in the input file
while IFS= read -r line; do
    # Initialize a counter for matching patterns
    match_count=0

    # Check if the line contains each pattern
    for pattern in "${patterns[@]}"; do
        if [[ $line =~ $pattern ]]; then
            ((match_count++))
        fi
    done

    # If all patterns are found in the line, print the line
    if [ "$match_count" -eq "$num_patterns" ]; then
        echo "$line"

        # Append the line to the output file if specified
        if [ -n "$output_file" ]; then
            echo "$line" >> "$output_file"
        fi
    fi
done < "$input_file"

