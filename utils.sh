#!/bin/bash
# tools useful in this repo
source $HOME/bin/scripts/trash/trash.conf

find_item(){
    # find item in trash data file
    # return a list of line number (seperated by space): the line number of the record
    # use option -e to precisely match item, by default it matches items with prefix
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
    arr=($raw)
    for ((i=0;i<=${#arr[@]};i++))
    do
        line=${arr[$i]}
        number=${line%%:*}
        if [ $i -eq 0 ]
        then
            list=$number
            continue
        fi
        list="$list $number"
    done
    IFS="$OLD_IFS"
    echo "$list"
}
