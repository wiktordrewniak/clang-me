#!/bin/bash
echo $@ $# >> run.log
if [ "$#" -ne 4 ]; then
    echo "main.o: main.cpp test" > main.ii
else
    clang-tidy-6.0 main.cpp > main.o
fi
exit 0

