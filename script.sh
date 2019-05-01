#!/bin/bash

function createFiles() {
    mkdir "folder1"
    mkdir "publicfolder"
    echo "Random data 1" >text1.txt
    echo "Random data 2." >text2.txt
    echo "Random data, but now in a FOLDER" >folder1/text.txt
    echo "Not so secret data" >publicFolder/text.txt
}

function deleteFiles() {
    rm folder1 -rf
    rm publicFolder -rf
    rm text*.txt -f
    rm result.txt -f
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

    rm result.txt -f
    for i in ${files[@]}; do
        fileData="$(ls -al $i) \
            $(md5sum $i | awk '{ print $1 }')"
        # Awk step removes the filename at the end
        $(echo $fileData >>result.txt)
    done
}

function displayParameters() {
    echo "This is an Intrusion Detection System"
    echo -e "Please supply one of the following parameters: \n"
    # -e needed to ensure newline gets printed as an actual line break, instead of "\n"
    echo "  -i | creates base files to monitor"
    echo "  -c | records file details into a verification file"
    echo "  -d | deletes the non-script related files, to give you a clean slate to work with"
    echo -e "  -o | scans the local files for changes, displays the results, and stores them into a file \n"
}

if [ -z "$1" ]; then # If no parameters have been passed in
    displayParameters
fi

# Uppercase the first parameter passed in (ignore the rest)
decision=${1^^}

# Figure out what the input is
case $decision in
"-I")
    echo "Creating files now..."
    createFiles
    echo "Folders and files have been created."
    ;;
"-C")
    echo "Scanning the folder now"
    getFileInformation
    # TODO: Write details to file when done
    ;;
"-D")
    echo "Cleaning up the directory..."
    deleteFiles
    echo "Done!"
    ;;
"-O")
    echo "Should probably do scanning here, hey?"
    # TODO: Actually like, anything, here
    ;;
*)
    echo "Invalid input detected. Please try to follow instructions."
    echo -e "Here they are again. \n"
    displayParameters
    ;;
esac
