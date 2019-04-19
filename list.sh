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
n=1
while read line
do
    line=($line)
    item=${line[2]}
    origin_dir=${line[1]}
    type=${line[0]}
    time=$(echo ${line[@]:4:6} | tr ' ' '-')
    if [ $detailed == true ]
    then
        list="$item $n $type $origin_dir $time\n$list"
    else
        list="$list $item"
    fi
    ((n+=1))
done < $TRASH_DATA_FILE
if [ $detailed == true ]
then
    data=$(echo -e $list | sort)
    list="|Item| |Index| |Type| |OriginDir| |DeleteTime|\n$list"
    echo -e "$list" | column -s " " -t
else
    echo $list | tr ' ' '\n' | sort | tr '\n' ' '
    echo ""
fi