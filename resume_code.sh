#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${INPUT_FILE}.summary"

RESUME_PROMPT="extract from this code information that would be needed to refactor a big project"

AI_DATA=$( ( echo "$RESUME_PROMPT" ; cat "$INPUT_FILE" ) | ollama run deepseek-r1:14b )

# Remove everything inside the <think> and </think> tags
AI_DATA=$(echo "$AI_DATA" | sed 's/<think>.*<\/think>//g')

echo "$AI_DATA" > "$OUTPUT_FILE"