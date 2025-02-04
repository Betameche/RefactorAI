#!/bin/bash

# func to check if regression passed
function check_regression {
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
    if [[ "$file" != *_regress.cpp ]]; then
        regress_file="src/$(basename "$file" .cpp)_regress.cpp"
        if [ ! -f "$regress_file" ]; then
            ./create_regression.sh "$file"
        fi
    fi
done

# compile all regression tests in src folder to regression folder
for file in src/*_regress.cpp; do
    g++ -o "regression/$(basename "$file" _regress.cpp)" "$file" -O2 -std=c++20
done

# run all regression tests
for file in regression/*; do
    ./"$file"
    check_regression $?
done
