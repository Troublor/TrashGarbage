#!/bin/bash
# tools useful in this repo
source $HOME/bin/scripts/trash/trash.conf

find_item(){
    # find item in trash data file
    # return a list of line number (seperated by space): the line number of the record, -1 if it doesn't exist
    if [ $1 == "-e" ]
    then 
        # precisely match
        reg="^[F|D]\ +.+\ +$2\ *$"
    else 
        # prefix match
        reg="^[F|D]\ +.+\ +$1.*\ *$"
    fi
    
    raw=$(cat $TRASH_DATA_FILE | grep -n -E "$reg")
    OLD_IFS="$IFS"
    IFS=$'\n'
    list=""
    for line in $raw
    do
        echo $line
        list="$list ${line%%:*}"
    done
    IFS="$OLD_IFS"
    echo "$list"
}
