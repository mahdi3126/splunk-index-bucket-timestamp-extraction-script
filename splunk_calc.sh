#!/bin/bash

# Prompt the user for the index name
read -p "Enter the index name: " INDEX_NAME
read -p "Enter the Location (hot, cold, or frozen): " LOCATION

# Convert index name and location to lowercase
INDEX_NAME=$(echo "$INDEX_NAME" | tr '[:upper:]' '[:lower:]')
LOCATION=$(echo "$LOCATION" | tr '[:upper:]' '[:lower:]')

# Define uppercase version of LOCATION
LOCATION_UPPER=$(echo "$LOCATION" | tr '[:lower:]' '[:upper:]')

# Handle "hot" input by setting LOCATION to an empty string
if [ "$LOCATION" == "hot" ]; then
    LOCATION=""
    LOCATION_UPPER="HOT" # Keep LOCATION_UPPER consistent for file paths
fi

# Get the current date in the format YYYY-MM-DD
CURRENT_DATE=$(date +"%Y-%m-%d")

# Define the directory path based on the provided index name
LOCATION_DIR="/${LOCATION_UPPER}/${INDEX_NAME}/${LOCATION}db"

# Define the output file path
OUTPUT_DIR="/${LOCATION_UPPER}/${INDEX_NAME}/${LOCATION}db"
OUTPUT_FILE="${OUTPUT_DIR}/Output_${LOCATION_UPPER}_${INDEX_NAME}_${CURRENT_DATE}.txt"

# Check if the directory exists
if [[ ! -d "$LOCATION_DIR" ]]; then
    echo "The specified ${LOCATION_UPPER} directory does not exist: $LOCATION_DIR. Please check the index name and try again."
    exit 1
fi

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR" || { echo "Failed to create output directory: $OUTPUT_DIR"; exit 1; }

# Clear the output file if it already exists
> "$OUTPUT_FILE"

# Print table headers to the output file
echo -e "File Name\tStart Timestamp (Epoch)\tEnd Timestamp (Epoch)\tStart Time\tEnd Time" >> "$OUTPUT_FILE"

# Iterate through each file in the directory
for file in "$LOCATION_DIR"/*; do
    # Check if the file is a directory and the name starts with 'rb' (raw bucket)
    if [[ -d "$file" && $(basename "$file") == rb_* ]]; then
        # Extract the start and end epoch timestamps from the filename
        FILE_NAME=$(basename "$file")
        START_TIMESTAMP=$(echo "$FILE_NAME" | cut -d'_' -f2)
        END_TIMESTAMP=$(echo "$FILE_NAME" | cut -d'_' -f3)

        # Validate that both timestamps are valid numbers
        if [[ ! "$START_TIMESTAMP" =~ ^[0-9]+$ ]] || [[ ! "$END_TIMESTAMP" =~ ^[0-9]+$ ]]; then
            echo "Invalid timestamps in file: $FILE_NAME"
            continue
        fi

        # Convert epoch timestamps to human-readable format (swapped)
        START_TIME=$(date -d @"$END_TIMESTAMP" +"%Y-%m-%d %H:%M:%S %Z") || { echo "Failed to parse START_TIMESTAMP: $START_TIMESTAMP"; continue; }
        END_TIME=$(date -d @"$START_TIMESTAMP" +"%Y-%m-%d %H:%M:%S %Z") || { echo "Failed to parse END_TIMESTAMP: $END_TIMESTAMP"; continue; }

        # Print the extracted information into the output file as a tab-separated line
        echo -e "$FILE_NAME\t$START_TIMESTAMP\t$END_TIMESTAMP\t$START_TIME\t$END_TIME" >> "$OUTPUT_FILE"
    fi
done

# Notify the user that the process is complete
echo "Timestamp extraction complete. Check the file: $OUTPUT_FILE"
