#!/bin/bash
# clean garbage in trash
# garbage: files in TRASH_PATH but not recorded in TRASH_DATA_FILE
CUR_DIR=$(dirname $0)
source $CUR_DIR/../trash.conf
source $CUR_DIR/../scripts/utils.sh

echo $TRASH_PATH

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

# find item in trash data file
list=""
bad_lines=""
lost_lines=""
n=1
echo "[INFO] Cleaning trash data file..."
while read line
do
    data=($line)
    if [ ${#data[@]} -eq 10 ]
    then
        if [ ! -e "$TRASH_PATH/${data[3]}" ]
        then
        echo "$TRASH_PATH/${data[3]}"
            echo "[INFO] Delete lost-track record: $line"
            lost_lines="$lost_lines ${n}d"
        fi
    else
        echo "[INFO] Delete bad line: $line"
        bad_lines="$bad_lines ${n}d"
    fi
    ((n+=1))
done < $TRASH_DATA_FILE

lost_lines=("$lost_lines")
payload=$(join $";" $lost_lines)
sed -i "$payload" $TRASH_DATA_FILE
bad_lines=("$bad_lines")
payload=$(join $";" $bad_lines)
sed -i "$payload" $TRASH_DATA_FILE
echo "[INFO] Cleaning trash data file... done"
echo "----------------------------------------------------------------"
echo "[INFO] Cleaning untracked files..."
for i in $TRASH_PATH/*
do
    if [ "$i" == "$TRASH_PATH/*" ] 
    then 
    # Skip the process when the folder is empty. 
        continue
    fi
    basename=$(basename $i)
    if [ "$basename" == "README.txt" ]
    then
        continue
    fi
    find=false
    while read line
    do
        data=($line)
        if [ "$basename" == "${data[3]}" ]
        then
            find=true
            break
        fi
    done < $TRASH_DATA_FILE
    if [ "$find" == "false" ]
    then
        if [ -d $i ]
        then
            echo "[INFO] Remove untracked directory $i"
            rm -d -r $i
        else
            echo "[INFO] Remove untracked file $i"
            rm $i
        fi
    fi
done
echo "[INFO] Cleaning untracked files... done"