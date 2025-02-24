#!/bin/sh

# func to check if regression passed
check_regression() {
    if [ "$1" -eq 0 ]; then
        echo "Regression passed"
    else
        echo "Regression failed"
    fi
}

# create regression folder, empty if it exists
if [ -d "regression" ]; then
    rm -rf regression/*
else
    mkdir regression
fi

# create regression tests if they don't exist in src folder
for file in src/*.cpp; do
    case "$file" in
        *_regress.cpp) continue ;;
    esac
    regress_file="src/$(basename "$file" .cpp)_regress.cpp"
    if [ ! -f "$regress_file" ]; then
        "$(dirname "$0")/create_regression.sh" "$file"
    fi
done

# compile all regression tests in src folder to regression folder
for file in src/*_regress.cpp; do
    g++ -o "regression/$(basename "$file" _regress.cpp)" "$file" -O2 -std=c++20
done

# run all regression tests
passed=0
failed=0

for file in regression/*; do
    ./"$file"
    if [ $? -eq 0 ]; then
        passed=$((passed + 1))
    else
        failed=$((failed + 1))
    fi
done

total=$((passed + failed))
echo "Passed: $passed"
echo "Failed: $failed"
echo "Total: $total"
