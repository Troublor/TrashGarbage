#!/bin/bash
# tools useful in this repo
source $HOME/bin/scripts/trash/trash.conf

find_item(){
    precisely=false
    if [ "$1" == "-e" ]
    then
        precisely=true
        shift
    fi
    
    # find item in trash data file
    list=""
    n=1
    while read line
    do
        data=($line)
        if [ $precisely == "false" ]
        then
            if [ ${#data[@]} -eq 10 ] && [[ "${data[2]}" =~ ^${1}.*$ ]]
            then
                if [ -z $list ]
                then
                    list=$n
                else
                    list="$list $n"
                fi
            fi
        else
            if [ ${#data[@]} -eq 10 ] && [ "${data[2]}" == "$1" ]
            then
                if [ -z $list ]
                then
                    list=$n
                else
                    list="$list $n"
                fi
            fi
        fi
        
        ((n+=1))
    done < $TRASH_DATA_FILE
    echo "$list"
}

get_one_row(){
    echo "$(sed -n ${1}p $TRASH_DATA_FILE)"
}

join() {
    local IFS="$1"
    shift
    echo "$*"
}
