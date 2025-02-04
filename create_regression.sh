#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${INPUT_FILE%.cpp}_regress.cpp"
AI_DATA_FILE="${INPUT_FILE%.cpp}_regress.txt"
TIME_LOG_FILE="time.csv"

RESUME_PROMPT="I want to refactor this code. First i need you to create regression test to ensure that the code is working as expected. output only the code, i will use your output as the new file with a script. the whole code should be in one file with on function per test. One file means one c block in your output."

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