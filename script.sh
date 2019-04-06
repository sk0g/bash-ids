#!/bin/bash

# Magic function does nothing. For now.
function createFiles() {
    mkdir "folder1"
    mkdir "publicfolder"
    echo "Random data 1" >text1.txt
    echo "Random data 2." >text2.txt
    echo "Random data 3..." >text3.txt
    echo "Random data, but now in a FOLDER" >folder1/text.txt
    echo "Not so secret data" >publicFolder/text.txt
}

# Prompt
echo "This is an Intrusion Detection System"
echo "Do you want to let this program create files?"
echo "[Y]es, I want the program to create the files. [N]o, I'll do it myself"
read decision

# Uppercase the $decision
decision=${decision^^}

# Figure out what the input is
case $decision in
"Y")
    echo "Creating files now..."
    createFiles
    echo "Folders and files have been created."
    ;;
"N")
    echo "Very well, create the files"
    ;;
*)
    echo "Invalid input detected. Please try to follow instructions."
    ;;
esac
