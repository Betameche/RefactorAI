#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${INPUT_FILE}.old"

RESUME_PROMPT="I want to refactor this code. It must remain functional, but I want to make it more readable and maintainable. keep changes to a minimum. output only the code, i will use your output as the new file with a script."

AI_DATA=$( ( echo "$RESUME_PROMPT" ; cat "$INPUT_FILE" ) | ollama run deepseek-r1:14b )

# Remove everything inside the <think> and </think> tags
AI_DATA=$(echo "$AI_DATA" | sed 's/<think>.*<\/think>//g')

echo "$AI_DATA" > "$OUTPUT_FILE"