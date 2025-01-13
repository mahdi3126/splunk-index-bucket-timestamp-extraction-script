# Splunk Index Bucket Timestamp Extraction Script

This bash script is designed for Splunk administrators to extract and report the start and end timestamps of raw bucket files in Splunk index directories (hot, warm, cold, or frozen). 
It helps administrators understand the exact timeframe of data contained within specific index buckets, which is valuable when deciding whether to rebuild, archive, or delete these buckets.



# Why This Script is Useful:

* Track Data Timestamps: Splunk's raw bucket files are typically organized in directories like hot, warm, cold, and frozen.
Each file has an associated start and end time (in epoch format) based on the events it contains. 
This script extracts these timestamps from the filenames, converts them into human-readable dates, 
and helps administrators identify the exact time range of each bucket.

* Plan Index Rebuilds or Deletion: When planning index rebuilds or deciding which buckets to delete, knowing the exact time range of
data in each bucket is crucial. This script makes it easy to determine which raw data files belong to specific time periods.

* Automated Output: The script outputs a file with a tab-separated table containing the file name, start and end timestamps (in epoch),
and human-readable timestamps. This is useful for auditing or performing further analysis.

# How to Use:
  1-Download the Script: Clone or download this repository to your Splunk server.

  2-Run the Script: Open a terminal and run the script with the following commands:

    chmod +x extract_bucket_timestamps.sh
    ./extract_bucket_timestamps.sh

  3-Enter Index and Location: The script will prompt you to enter the index name and location (hot, cold, or frozen).
  It will then generate an output file containing the detailed timestamp information for the buckets in the specified directory.

  4-Check the Output File: After execution, check the output file generated in the same directory for a table of bucket file timestamps.

# Script Features:
  * Converts epoch timestamps to human-readable date format.
  * Handles both hot, cold, and frozen directories in Splunk's file structure.
  * Automatically skips files with invalid timestamps.
  * Provides tab-separated output that can be easily parsed or used in other tools.

# Prerequisites:

  Bash shell (Unix-like systems)
  date command (for converting epoch timestamps)
  Basic permissions to access Splunk index directories and files

Example Output:
  
  |  File Name	                    |  Start Timestamp (Epoch)	  |  End Timestamp (Epoch)	    |  Start Time	                |  End Time               |
  ----------------------------------|-----------------------------|-----------------------------|-----------------------------|--------------------------
  |  rb_1672531200_1672617600	      |  1672531200	                |  1672617600	                |  2025-01-01 00:00:00 UTC	  |  2025-01-02 00:00:00 UTC|
  |  rb_1672617600_1672704000	      |  1672617600	                |  1672704000	                |  2025-01-02 00:00:00 UTC	  |  2025-01-03 00:00:00 UTC|
