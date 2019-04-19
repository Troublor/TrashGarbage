#!/bin/bash
# this is the implementation of a command
# which delete files by putting them into trash folder ($HOME/.trash)

CUR_DIR=$(dirname $0)
source $CUR_DIR/../trash.conf
source $CUR_DIR/../scripts/utils.sh

USAGE="Usage: trash-del [-f] [-d] [-h] file [file [file ...]]\n
\t  -f  use system rm command to delete\n
\t  -d  allow deleting directory\n
\t  -h  show this usage\n"

show_info=false
f_remove=false
delete_dir=false

trash_folder=$TRASH_PATH
data_file=$TRASH_DATA_FILE

if [ ! -a $data_file ]
then
    touch $data_file
fi

add_trash_info(){
    # add to trash data file
    # Data file format: TYPE DIRNAME BASENAME UUID TIME
    file_origin_path=$(get_abs_path $1)
    
    dirname=$(dirname $file_origin_path)
    basename=$(basename $file_origin_path)
    uuid=$2
    del_time=$(date)
    
    if [ -d $file_origin_path ]
    then
        echo "D $dirname $basename $uuid $del_time" >> $data_file
    elif [ -f $file_origin_path ]
    then
        echo "F $dirname $basename $uuid $del_time" >> $data_file
    elif [ -L $file_origin_path ]
    then
        echo "L $dirname $basename $uuid $del_time" >> $data_file
    fi
}

force_remove(){
    for item in $@
    do
        if [ ! -e $item ]
        then
            echo "[ERROR] Cannot remove '$item': No such file or directory"
        elif [ -d $item ]
        then
            if [ $delete_dir == true ]
            then
                cmd="rm -d -r $item"
                eval $cmd
                echo "[INFO] PERMANENTLY remove directory: $item"
            else
                echo "[ERROR] Remove dir not allowed"
            fi
        else
            cmd="rm $item"
            eval $cmd
            echo "[INFO] PERMANENTLY remove file: $item"
        fi
    done
}

count=0
while getopts "fdh" arg
do
    case $arg in
        f)
            let count+=1
            f_remove=true
        ;;
        h)
            echo -e $USAGE
            exit 0
        ;;
        d)
            let count+=1
            delete_dir=true
        ;;
        *)
            echo -e $USAGE
            exit 1
        ;;
    esac
done
shift $count

if [ $f_remove == true ]
then
    force_remove $@
    exit 0
fi

# remove by putting into $HOME/.trash folder
for item in $@
do
    # actually move
    if [ ! -e $item ]
    then
        echo "[ERROR] Cannot remove '$item': No such file or directory"
    elif [ -d $item ]
    then
        if [ $delete_dir == true ]
        then
            uuid=$(uuidgen)
            cmd="mv $item $HOME/.trash/$uuid"
            add_trash_info $item $uuid
            eval $cmd
            echo "[INFO] Delete directory $item"
        else
            echo "[ERROR] Failed to delete directory '$item': deleting directory not allowed, -d option can be used to delete directory."
        fi
    elif [ -f $item -o -L $item ]
    then
        uuid=$(uuidgen)
        cmd="mv $item $HOME/.trash/$uuid"
        add_trash_info $item $uuid
        eval $cmd
        echo "[INFO] Delete file $item"
    else
        echo "[ERROR] Cannot delete $item: only support directory, normal file and symbolic link file".
        continue
    fi
done
