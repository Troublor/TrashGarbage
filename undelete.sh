#!/bin/bash
source $HOME/bin/scripts/trash/trash.conf

USAGE="Usage: undelete [-h] file [file [file ...]]\n
\t  -h  show this usage\n"

while getopts "h" arg
do
    case $arg in
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

undelete_item(){
    raw=$(cat $data_file | grep -n $item)
    row=${raw%%:*}
    if [ ${#row} != 0 ] # the row exists
    then
        raw=${raw#*:}
        raw=${raw#* }
        origin_dir=${raw%% *}
        if [ ! -d $origin_dir ]
        then
            mkdir -p $origin_dir
        fi
        if [ -d $origin_dir/$item -o -f $origin_dir/$item ]
        then
            # ask whether override
            echo -n "warning\n[WARN] $origin_dir/$item exists, continue to override? (y/n) "
            read input
            if [ ! $input == "Y" -a ! $input == "y" ]
            then
                echo "[INFO] Skip $item"
                exit 0
            else
                rm -d -r $origin_dir/$item
            fi
        fi
        mv $trash_folder/$item $origin_dir
        sed -i "${row}d" $data_file
        echo "[INFO] Retrieved $item to $origin_dir"
    else
        echo "[ERROR] Undelete failed: cannot find '$item'"
    fi
}

main(){
    if [ $# -ge 1 ]
    then
        for item in $@
        do
            # echo $item
            undelete_item $item
        done
    else
        raw=$(sed -n '$p' $TRASH_DATA_FILE)
        item=${raw##* }
        undelete_item $item
    fi
}

cd $TRASH_PATH
main "$@"
