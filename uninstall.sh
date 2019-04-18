#!/bin/bash
# Uninstall shell script of 'trash' command familay

env_path="$HOME/.bashrc"

delete_row(){
    raw=$(cat $1 | grep -n $2)
    if [ -n "$raw" ]
    then
        line=${raw%%:*}
        sed -i "${line}d" $1
    fi
}

echo "[INFO] Delete env decleration"
delete_row $env_path "\[Trash\]"
delete_row $env_path "TRASH_PATH"
delete_row $env_path "TRASH_ROOT_PATH"

commands=("trash-del" "trash-undel" "trash-ls" "trash-clean" "trash-clear")
for c in ${commands[@]}
do
    if [ -f $HOME/bin/$c ]
    then
        echo "[INFO] Delete $HOME/bin/$c"
        rm $HOME/bin/$c
    fi
done
echo '[INFO] Uninstall complete'