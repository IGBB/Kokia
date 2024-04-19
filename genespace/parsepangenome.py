#parse REF_pan.txt files from GENESPACE
#python parsepangenome.py kirkii_pan.42 list
#change values in [9:51] to match REF_pan.txt
#create folder 'list'

import os
import sys

def process_table(input_file, output_folder):
    print(f"Processing input file: {input_file}")
    print(f"Output folder: {output_folder}")

    # Create the output directory if it doesn't exist
    os.makedirs(output_folder, exist_ok=True)

    # Read the input file and process each line
    with open(input_file, 'r') as file:
        for line_number, line in enumerate(file, start=1):
            print(f"Processing line {line_number}: {line}")

            # Split the line into columns using tab as the separator
            columns = line.strip().split('\t')

            # Extract columns 9 to 12
            selected_columns = columns[9:13]  # Python uses 0-based indexing

            # Create the output file name
            output_file = f"{output_folder}/SynOG{line_number}.txt"

            # Write the selected columns to the output file
            with open(output_file, 'w') as output:
                output.write('\n'.join(selected_columns))

    print("Files created successfully.")

if __name__ == "__main__":
    # Check if the correct number of command-line arguments is provided
    if len(sys.argv) != 3:
        print("Usage: python script.py input_file output_folder")
        sys.exit(1)

    # Get input file and output folder from command-line arguments
    input_file_path = sys.argv[1]
    output_folder_path = sys.argv[2]

    # Call the process_table function with the provided arguments
    process_table(input_file_path, output_folder_path)

