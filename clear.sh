#!/bin/bash
# clear the trash folder

source $HOME/bin/scripts/trash/trash.conf

sed -i '1,$d' $TRASH_DATA_FILE

for i in $TRASH_PATH/*; do
    # echo "$i"
    if [ $(basename $i) == $(basename $TRASH_DATA_FILE) -o $(basename $i) == "README.txt" ]
    then
        # echo "sys"
        continue
    elif [ -d $i ]
    then
        # echo "dir"
        rm -d -r $i
    else
        # echo "file"
        rm $i
    fi
done
