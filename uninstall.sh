#!/bin/bash
# Uninstall the command family

# delete the trash folder

TRASH_ROOT_PATH=$(cd "$(dirname $0)"; pwd)

source $TRASH_ROOT_PATH/trash.conf

# ask confirmation
echo -n "[WARN] Do you want to delete Trash Garbage Folder $TRASH_PATH? (y/n) "
read input
if [ $input == "Y" -o $input == "y" ]
then
    rm -d -r $TRASH_PATH
    echo "[INFO] Delete Trash Garbage Folder $TRASH_PATH"
fi

echo "[INFO] Delete all trash-* commands"
rm $TRASH_ROOT_PATH/bin/trash-*

