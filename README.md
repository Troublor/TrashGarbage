## The Trasher Linux Command Family

Trasher is a command family on Linux especially Ubuntu, which contains the following commands: 

`trash-del`, `trash-undel`, `trash-ls`, `trash-search`, `trash-clear`, `trash-clean`

Trasher is aimed to implement the functionality of Recycle Bin of Windows. 

---

### Features 

1. `trash-del`: Delete files and directories and save the deleted items in recycle bin.
2. `trash-undel`: Undelete files and directories in recycle bin. 
3. `trash-ls`: List all the items in recycle bin.
4. `trash-search`: Search items in recycle bin.
5. `trash-clear`: Clear the recycle bin, permanently removing everything in recycle
6. `trash-clean`: Clean the recycle bin, removing some files not tracked by Trasher or useless trash records in Trasher.

Every command has a `-h` option to explain the usage of itself. 

--- 

### Configuration

**Configurations need to be done BEFORE installation.**

There is a file in the project called `trash.conf` which contains some configurations of Trasher.

Currently, there are two variables needed to specify in `trash.conf`: 

`TRASH_PATH`: The path of recycle bin directory. By default, the value is `$HOME/.trash`
`TRASH_DATA_FILE`: The data file of Trasher which containing the information of files and directories in recycle bin and will be used when undelete items. By default, the value is `$TRASH_PATH/.trash.dat` 

**Users are recommended to only modify `TRASH_PATH`.**

---

### Prerequisite

Trasher uses `bash` shell. You may need `bash` to use this command family. 

---

### Installation

**First:** Clone the repository: 
```
git clone https://github.com/Troublor/Trasher.git
```

**Second:** Run the install.sh script
```
cd Trasher
chmod +x install.sh
./install.sh
```

After the execution of `install.sh` complete, a directory named `bin` will show up, which contains all the commands in Trasher command family. 

**Third (optional):** Add the directory `bin` into your PATH environment variable.

---

### Uninstallation

In the directory Trasher, run the `uninstall.sh` script: 
```
chmod +x uninstall.sh
./uninstall.sh
```

This script will help you delete the recycle bin as well as the commands created in installation process. 

**However, the changes you make in your PATH enviroment variable will still need your manual deletion.**

---

### More Features to Come

1. Clear recycle bin by only removing files older than some specified time.
2. Add settings to Trasher which can allow user to only keep files deleted within the past certain period of time in recycle bin. 
