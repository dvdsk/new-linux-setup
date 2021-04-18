#!/bin/bash
# By: David
# Date: Oktober 2e, 2018
#
# Usage: call in any directory, this will try to find a main.py file. If it 
#        can it will execute it using python3. Else it will run the 
#        last changed .py file in in the current or any subdir will be
#
#        Requires: python3

#try to find a main file
path=`find -name main.py`

#if no main file was found find the last changed .py file
if [[ -z  $path ]]; then
    path=`find . -type f -name "*.py" -printf '%T@ %p\n' \
        | sort -n           \
        | tail -1           \
        | cut -f2- -d" "    \
        | cut -c 3-`
fi

workingdir=$(dirname "${path}")
filename=$(basename "${path}")

echo 'python3' $path
#switch to the dir in which the file was found, so the working 
#dir for the python program is consistant with running it from its 
#location

#then run python with the file as input
(cd $workingdir; python3 $filename)

