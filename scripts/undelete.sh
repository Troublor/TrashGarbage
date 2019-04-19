#!/bin/bash

CUR_DIR=$(dirname $0)
source $CUR_DIR/../trash.conf
source $CUR_DIR/../scripts/utils.sh

USAGE="Usage: trash-undel [-h] [-i Index] | [file [file [file ...]]]\n
\t  -i  undelete items using index\n
\t  -h  show this usage\n"

by_index=false

while getopts "ih" arg
do
    case $arg in
        i)
            by_index=true
            shift
        ;;
        h)
            echo -e $USAGE
            exit 0
        ;;
        *)
            echo -e $USAGE
            exit 1
        ;;
    esac
done

trash_folder=$TRASH_PATH
data_file=$TRASH_DATA_FILE

undelete_by_index(){
    if [ ! "$1" -gt 0 ]
    then
        echo "[ERROR] Wrong index to undelete: '$1'"
        return
    fi
    data=$(get_one_row $1)
    data=($data)
    if [ ${#data[@]} -eq 0 ]
    then
        echo "[ERROR] Cannot find a item with Index '$1' in trash garbage."
        return
    fi
    origin_dir=${data[1]}
    item=${data[2]}
    uuid=${data[3]}
    if [ ! -d $origin_dir ]
    then
        mkdir -p $origin_dir
    fi
    if [ -e $origin_dir/$item ]
    then
        # ask whether override
        echo -n "[WARN] '$origin_dir/$item' exists, continue to override? (y/n) "
        read input
        if [ ! $input == "Y" -a ! $input == "y" ]
        then
            echo "[INFO] Skip $item"
            return
        else
            rm -d -r $origin_dir/$item
        fi
    fi
    mv $trash_folder/$uuid $origin_dir/$item
    sed -i "${1}d" $data_file
    echo "[INFO] Retrieve '$item' to '$origin_dir'"
    return
}

undelete_by_name(){
    lines=$(find_item -e $1)
    lines=($lines)
    if [ ${#lines[@]} -eq 0 ]
    then
        echo "[ERROR] Cannot find item '$1' in trash garbage."
    elif [ ${#lines[@]} -eq 1 ]
    then
        undelete_by_index ${lines[0]}
    else
        echo "[ERROR] Item '$1' has multiple versions in trash garbage, please use 'trash-search $1' and 'trash-undel -i [Index]' to specify which one to undelete."
    fi
}

undelete_items(){
    for i in $@
    do
        if [ $by_index == "true" ]
        then
            undelete_by_index $i
        else
            undelete_by_name $i
        fi
    done
}

main(){    
    undelete_items $@
}

cd $TRASH_PATH
main "$@"
