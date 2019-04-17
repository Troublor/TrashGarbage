#!/bin/bash
# this is the implementation of a command
# which delete files by putting them into trash folder ($HOME/.trash)

source $HOME/bin/scripts/trash/trash.conf

USAGE="Usage: delete [-f] [-d] [-h] file [file [file ...]]\n
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

new_trash(){
    file_origin_path=$(get_abs_path $1)
    
    # delete existing information
    dirname=$(dirname $file_origin_path)
    basename=$(basename $file_origin_path)
    
    raw=$(cat $data_file | grep -n $basename)
    row=${raw%%:*}
    if [ ${#row} != 0 ] # the row exists
    then
        raw=${raw#*:}
        type=${raw%% *}
        if [ $type == "F" ]
        then
            rm $trash_folder/$basename
        elif [ $type == "D" ]
        then
            rm -d -r $trash_folder/$basename
        fi
        sed -i "${row}d" $data_file
    fi
    
    if [ -f $file_origin_path ]
    then
        echo "F $dirname $basename" >> $data_file
    elif [ -d $file_origin_path ]
    then
        echo "D $dirname $basename" >> $data_file
    fi
}

get_abs_path(){
    CURDIR=$(pwd)
    tmp_path=$CURDIR/$1
    if [ -d $tmp_path ]
    then
        cd $tmp_path
        path=$(pwd)
    elif [ -f $tmp_path ]
    then
        cd $(dirname $tmp_path)
        path=$(pwd)/$(basename $tmp_path)
    fi
    echo $path
}

force_remove(){
    for item in $@
    do
        if [ -d $item ]
        then
            if [ $delete_dir == true ]
            then
                cmd="rm -d -r $item"
                eval $cmd
                echo "[INFO] PERMANENTLY removing directory: $item"
            else
                echo "[ERROR] Remove dir not allowed"
            fi
        elif [ -f $item ]
        then
            cmd="rm $item"
            eval $cmd
            echo "[INFO] PERMANENTLY removing file: $item"
        else
            echo "[ERROR] Cannot remove '$item': No such file or directory"
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
    if [ -d $item ]
    then
        if [ $delete_dir == true ]
        then
            cmd="mv $item $HOME/.trash"
            new_trash $item
            eval $cmd
            echo "[INFO] Deleted directory $item"
        else
            echo "[ERROR] Failed to delete directory '$item': deleting directory not allowed, -d option can be used to delete directory."
        fi
    elif [ -f $item ]
    then
        cmd="mv $item $HOME/.trash"
        new_trash $item
        eval $cmd
        echo "[INFO] Deleted file $item"
    else
        echo "[ERROR] Cannot remove '$item': No such file or directory"
    fi
done
