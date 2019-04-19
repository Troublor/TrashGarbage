#!/bin/bash

CUR_DIR=$(dirname $0)
source $CUR_DIR/../trash.conf
source $CUR_DIR/../scripts/utils.sh

USAGE="Usage: trash-search [-e] [-h] keyword\n
\t  -e  presicely search keyword (without this option, it will search for prefix)\n
\t  -h  show this usage\n"

precisely=false

while getopts "eh" arg
do
    case $arg in
        e)
            precisely=true
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

if [ $# -ne 1 ]
then
    echo "[ERROR] trash-search requires one argument."
    echo -e $USAGE
    exit 1
fi

keyword=$1

if [ $precisely == 'true' ]
then
    echo "[INFO] Search for '$keyword' precisely in trash garbage."
else
    echo "[INFO] Search for prefix '$keyword' in trash garbage."
fi

if [ $precisely == 'true' ]
then
    lines=$(find_item -e $keyword)
else
    lines=$(find_item $keyword)
fi
line_numbers=($lines)

if [ ${#line_numbers[@]} -eq 0 ]
then
    echo "[ERROR] Cannot find any item in trash garbage."
    exit 0
fi

list=""
for i in ${line_numbers[@]}
do
    data=$(get_one_row $i)
    data=($data)
    time=$(echo ${data[@]:4:6} | tr ' ' '-')
    list="$list\n${data[2]} $i ${data[0]} ${data[1]} $time"
done

echo ""
list=$(echo -e $list | sort)
list="|Item| |Index| |Type| |OriginDir| |DeleteTime|\n$list"
echo -e "$list" | column -s " " -t
echo ""
echo "[INFO] Please use trash-undel -i [Index] to specifiy the item to undelete. "



