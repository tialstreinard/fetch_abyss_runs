#!/bin/bash

# ============================================================================
# Author: Tial Streinard
# ============================================================================

# ============================================================================
# Usage: 
# chmod +x get_abyss_data.sh
# ./get_abyss_data.sh
# ============================================================================

# ============================================================================
# SETUP - Give names to the files we'll create
# ============================================================================

RESULTS_FILE="all_results.json"
# This is like saying "I'm going to call my messy data file 'all_results.json'"

TEMP_FILE="temp_results.json"
# This is a temporary holding area (like a trash can we'll throw away later)

CSV_FILE="abyssal_runs.csv"
# This is the final spreadsheet file we want to create

# ============================================================================
# STEP 1: GET THE DATA
# ============================================================================

echo "Step 1: Fetching data..."
# Print a message so we know what's happening

> "$TEMP_FILE"
# This clears the temp file (makes it empty, ready to fill)

# This is a loop - it repeats the same commands over and over
# skip=0 means start at 0
# skip<100 means stop when skip reaches 100
# skip+=20 means add 20 each time (0, 20, 40, 60, 80)
for ((skip=0; skip<100; skip+=20)); do
    echo "  Fetching skip=$skip..."
    # Print which batch we're getting
    
    # Go to the website and ask for 20 results starting at position 'skip'
    # | jq '.results[]' means "extract just the results part"
    # >> "$TEMP_FILE" means "add this data to our temp file"
    curl -s "https://webapi.abysstracker.com/Run/GetRuns?skip=$skip&take=20" | jq '.results[]' >> "$TEMP_FILE"
    
    sleep 1
    # Wait 1 second before asking for more (be nice to the server)
done

# ============================================================================
# STEP 2: FIX THE DATA FORMAT
# ============================================================================

echo "Step 2: Converting to valid JSON array..."
# Print a message

# jq -s '.' means "read all the messy data and turn it into a proper list"
# > "$RESULTS_FILE" means "save it to our final JSON file"
jq -s '.' "$TEMP_FILE" > "$RESULTS_FILE"

rm "$TEMP_FILE"
# Delete the temp file (we don't need it anymore)

# ============================================================================
# STEP 3: CREATE AN EMPTY SPREADSHEET WITH COLUMN NAMES
# ============================================================================

echo "Step 3: Creating CSV with headers..."
# Print a message

# echo writes text
# > "$CSV_FILE" means "create a new file with this text"
# The text is all the column names (id, characterId, etc.)
echo "id,characterId,characterName,type,state,dateAdded,hullType,lootValue,survived,timeSpend,abyssTier,abyssWeather,totalProfit,didEscalate,hullName" > "$CSV_FILE"

# ============================================================================
# STEP 4: FILL THE SPREADSHEET WITH DATA
# ============================================================================

echo "Step 4: Parsing JSON to CSV..."
# Print a message

# jq -r '.[] | [.id, .characterId, ...]' means "get each piece of data we need"
# | @csv means "format it as comma-separated values (spreadsheet format)"
# >> "$CSV_FILE" means "add this data to the end of our spreadsheet file"
jq -r '.[] | [.id, .characterId, .characterName, .type, .state, .dateAdded, .hullType, .lootValue, .survived, .timeSpendString, .abyssTier, .abyssWeather, .totalProfit, .didEscalate, .hullName] | @csv' "$RESULTS_FILE" >> "$CSV_FILE"

# ============================================================================
# DONE!
# ============================================================================

echo "Done!"
# Print a message

echo "Results: $RESULTS_FILE"
# Tell the user where the JSON file is

echo "CSV: $CSV_FILE ($(wc -l < "$CSV_FILE") lines)"
# Tell the user where the spreadsheet is and how many rows it has
# wc -l counts the lines
