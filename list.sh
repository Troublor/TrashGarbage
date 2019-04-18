#!/bin/bash
# list the items in trash

source $HOME/bin/scripts/trash/trash.conf

# set -x

USAGE="Usage: trash-ls [-a] [-h]\n
\t  -a  list detailed information of every item in trash\n
\t  -h  show this usage\n"

detailed=false

while getopts "ah" arg
do
    case $arg in
        a)
            detailed=true
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

list=""
while read line
do
    item=${line##* }
    raw=${line% *}
    origin_dir=${raw##* }
    type=${line%% *}
    if [ $detailed == true ]
    then
        list="$type $item $origin_dir\n$list"
    else
        list="$list $item"
    fi
done < $TRASH_DATA_FILE

if [ $detailed == true ]
then
    data=$(echo -e $list | sort)
    list="Type Item OriginDir\n$list"
    echo -e $list | column -s " " -t 
else
    echo $list | tr ' ' '\n' | sort | tr '\n' ' '
    echo ""
fi