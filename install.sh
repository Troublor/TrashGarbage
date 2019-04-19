#!/bin/bash
# Install shell script of 'trash' command familay

# the file to put environment variables in
env_path="$HOME/.bashrc"

TRASH_PATH='$HOME/.trash'
TRASH_ROOT_PATH="$(dirname $0)"

payload="# [Trash] This is env variables for 'trash' command family, which is a trash garbage tool for linux"
echo $payload >> $env_path
payload="TRASH_PATH=$TRASH_PATH"
echo $payload >> $env_path
payload="TRASH_ROOT_PATH=$TRASH_ROOT_PATH"
echo $payload >> $env_path
echo -e "\n" >> $env_path

# Create soft link for each command
# Command: trash-del
ln -s $TRASH_ROOT_PATH/delete.sh $HOME/bin/trash-del
# Command: trash-undel
ln -s $TRASH_ROOT_PATH/undelete.sh $HOME/bin/trash-undel
# Command: trash-ls
ln -s $TRASH_ROOT_PATH/list.sh $HOME/bin/trash-ls
# Command: trash-clean
ln -s $TRASH_ROOT_PATH/clean.sh $HOME/bin/trash-clean
# Command: trash-clear
ln -s $TRASH_ROOT_PATH/clear.sh $HOME/bin/trash-clear
# Command: trash-search
ln -s $TRASH_ROOT_PATH/search.sh $HOME/bin/trash-search

echo [INFO] Installation finished. Please reopen the terminal to use Trash!