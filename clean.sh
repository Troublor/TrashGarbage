#!/bin/bash
# clean garbage in trash
# garbage: files in TRASH_PAHT but not recorded in TRASH_DATA_FILE
source $HOME/bin/scripts/trash/trash.conf

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
    
done