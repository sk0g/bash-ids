#!/bin/bash

# Magic function does nothing. For now.
function createFiles() {
    mkdir "folder1"
    mkdir "publicfolder"
    echo "Random data 1" >text1.txt
    echo "Random data 2." >text2.txt
    echo "Random data, but now in a FOLDER" >folder1/text.txt
    echo "Not so secret data" >publicFolder/text.txt
}

function getFileInformation() {
    # Find all files/ folders under current directory
    # Exclude readme.md, script files, git-related shit, and go pkg (auto formatter dependencies)
    files=$(
        find . -type f \
            ! -name "*.sh" \
            ! -name "go.*" \
            ! -name "*.md" \
            ! -path './.git*'
    )

    for i in ${files[@]}; do
        fileData="$(ls -al $i) $(md5sum $i)"
        $(echo $fileData >>result.txt)
    done
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

    while true; do
        read -p "[Y]es, I have added/edited the files and want to scan them now " isReady

        if [[ "$isReady" == "Y" ]]; then
            break
        fi
    done
    echo "Scanning files and stuff now"
    getFileInformation
    ;;
*)
    echo "Invalid input detected. Please try to follow instructions."
    ;;
esac
