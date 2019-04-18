#!/bin/bash
# clean garbage in trash
# garbage: files in TRASH_PAHT but not recorded in TRASH_DATA_FILE
source $HOME/bin/scripts/trash/trash.conf
source $HOME/bin/scripts/trash/utils.sh

USAGE="Usage: trash-clean [-h]\n
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

for i in $TRASH_PATH/*
do
    basename=$(basename $i)
    echo $basename
    if [ "$basename" == "README.txt" ]
    then  
        continue
    fi 
    lines=($( find_item -e $basename ))
    if [ ${#lines[@]} -eq 0 ]
    then 
        # not recorded in data file
        rm -d -r $i
        if [ -d $i ]
        then 
            echo "[INFO] Removed directory '$i'"
        else 
            echo "[INFO] Removed file '$i'"
        fi 
    fi 
done