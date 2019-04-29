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

if [ -z "$1" ]; then # If no parameters have been passed in
    echo "This is an Intrusion Detection System"
    echo -e "Please supply one of the following parameters: \n"
    # -e needed to ensure newline gets printed as an actual line break, instead of "\n"
    echo "  -i | creates base files to monitor"
    echo "  -c | records file details into a verification file"
    echo "  -d | deletes the non-script related files, to give you a clean slate to work with"
    echo -e "  -o | scans the local files for changes, displays the results, and stores them into a file \n"
fi

# Uppercase the first parameter passed in (ignore the rest)
decision=${1^^}

# Figure out what the input is
case $decision in
"-D")
    echo "Cleaning up the directory..."
    ./cleanup.sh
    echo "Done!"
    ;;
"-C")
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
