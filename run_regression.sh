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

# compile all regression tests in src folder to regression folder
for file in src/*.cpp; do
    g++ -o "regression/$(basename "$file" .cpp)" "$file" -O2 -std=c++20
done

# run all regression tests
for file in regression/*; do
    ./"$file"
    check_regression $?
done
