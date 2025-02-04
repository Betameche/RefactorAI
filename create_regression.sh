#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${INPUT_FILE%.cpp}_regress.cpp"
AI_DATA_FILE="${INPUT_FILE%.cpp}_regress.txt"
TIME_LOG_FILE="time.csv"

RESUME_PROMPT="Please generate regression tests for the following code. Ensure that the tests are comprehensive and cover all functionalities. The entire code should be in one file. Output only the code in a single C block, with one function per test. here is the code:"

START_TIME=$(date +%s)

AI_DATA=$( ( echo "$RESUME_PROMPT" ; cat "$INPUT_FILE" ) | ollama run deepseek-r1:14b )

# Remove everything inside the <think> and </think> tags
AI_DATA=$(echo "$AI_DATA" | perl -0777 -pe 's/<think>.*?<\/think>//gs')

# keep only the code between ```c and ``` tags
CODE=$(echo "$AI_DATA" | perl -0777 -ne 'print "$1\n" if /```c(.*?)```/s')

echo "$AI_DATA" > "$AI_DATA_FILE"
echo "$CODE" > "$OUTPUT_FILE"

END_TIME=$(date +%s)
TOTAL_TIME=$((END_TIME - START_TIME))

# Log the input file name and total time to time.csv
echo "$INPUT_FILE,$TOTAL_TIME" >> "$TIME_LOG_FILE"