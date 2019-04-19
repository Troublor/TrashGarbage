#!/bin/bash
# Install shell script of 'trash' command familay

TRASH_ROOT_PATH=$(cd "$(dirname $0)"; pwd)

source $TRASH_ROOT_PATH/trash.conf


echo "[INFO] Create Recycle Bin Folder $TRASH_PATH"
if [ -e $TRASH_PATH ]
then
    echo -n "[WARN] Recycle Bin Folder $TRASH_PATH already exists. Are you sure to override it? (y/n) "
    read input
    if [ "$input" == "Y" -o "$input" == "y" ]
    then
        rm -d -r $TRASH_PATH
        echo "[INFO] Delete Recycle Bin Folder $TRASH_PATH"
    else
        echo "[INFO] Abort installation"
        exit 0
    fi
fi

echo "[INFO] Create Recycle Bin Folder $TRASH_PATH"
mkdir -p $TRASH_PATH

BIN_PATH=$TRASH_ROOT_PATH/bin
if [ ! -e $BIN_PATH ]
then
    mkdir -p $BIN_PATH
else
    rm $BIN_PATH/trash-*
fi
# Create soft link for each command
# Command: trash-del
echo "[INFO] Create command trash-del"
ln -s $TRASH_ROOT_PATH/scripts/delete.sh $BIN_PATH/trash-del
# Command: trash-undel
echo "[INFO] Create command trash-undel"
ln -s $TRASH_ROOT_PATH/scripts/undelete.sh $BIN_PATH/trash-undel
# Command: trash-ls
echo "[INFO] Create command trash-ls"
ln -s $TRASH_ROOT_PATH/scripts/list.sh $BIN_PATH/trash-ls
# Command: trash-clean
echo "[INFO] Create command trash-clean"
ln -s $TRASH_ROOT_PATH/scripts/clean.sh $BIN_PATH/trash-clean
# Command: trash-clear
echo "[INFO] Create command trash-clear"
ln -s $TRASH_ROOT_PATH/scripts/clear.sh $BIN_PATH/trash-clear
# Command: trash-search
echo "[INFO] Create command trash-search"
ln -s $TRASH_ROOT_PATH/scripts/search.sh $BIN_PATH/trash-search

chmod +x $BIN_PATH/trash-*


echo "[INFO] Installation finished. Please find executable command in ./bin!"