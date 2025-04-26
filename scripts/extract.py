import os
import pandas as pd

# Define the directory containing the reports
reports_dir = os.path.join(os.path.dirname(__file__), '../reports')

# Ensure the directory exists
if not os.path.exists(reports_dir):
    print(f"Directory {reports_dir} does not exist.")
    exit(1)

# Iterate through files in the directory
for filename in os.listdir(reports_dir):
    if filename.endswith(".csv"):  # Process only .txt files (adjust as needed)
        file_path = os.path.join(reports_dir, filename)
        print(f"Processing file: {filename}")
        
        # Extract fields separated by underscores
        fields = filename.split('_')
        print(f"Extracted fields: {fields}")

        b = fields[2][1:]
        c = fields[3][1:]
        mr = fields[4][1:]
        k = fields[5][1:]
        # Read space-delimited file and clean up
        df = pd.read_csv(file_path, delim_whitespace=True, skiprows=4)  # Adjust skiprows if needed
        df = df.dropna(axis=1, how='all')  # Drop empty columns
        print(df.head())