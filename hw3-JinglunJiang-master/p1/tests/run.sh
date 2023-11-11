#! /user/bin/env 

set -o nounset 

echo "Running Problem 1 Tests" 
echo "-------------------------" 
for file in *.in; do 
    diff -w <(source $file) ${file%.in}.ans &> /dev/null
    if [[ "$?" -eq 0 ]]; then 
        printf "\tTest (%s) passed\n" $file 
    else 
        printf "\tTest (#%s) failed\n-----------\n" $file 
        diff -w <(source $file) ${file%.in}.ans 
        echo "-----------"
    fi 
done 