#!/bin/bash
# tools useful in this repo

CUR_DIR=$(dirname $0)
source $CUR_DIR/../trash.conf


get_abs_path(){
    tmp_path=$1
    if [ -d $tmp_path ]
    then
        cd $tmp_path
        path=$(pwd)
    else
        cd $(dirname $tmp_path)
        path=$(pwd)/$(basename $tmp_path)
    fi
    echo $path
}

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
