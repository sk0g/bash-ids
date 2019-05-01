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
    # -f suppresses missing file warnings. Gotta be ninja
    rm folder1 -rf
    rm publicFolder -rf
    rm text*.txt -f
    rm result.txt -f
    rm current.txt -f
}

function getFileInformation() {
    # Find all files/ folders under current directory
    # Exclude readme.md, script files, git-related shit, and go pkg (auto formatter dependencies)
    echo $(
        find . -type f \
            ! -name "*.sh" \
            ! -name "go.*" \
            ! -name "result.txt" \
            ! -name "current.txt" \
            ! -name "*.md" \
            ! -path './.git*'
    )
}

function recordFileInformationTo() {
    # first argument is filename to save results to
    files=$(getFileInformation)
    rm $1 -f
    for i in ${files[@]}; do
        fileData="$(ls -al $i) \
            $(md5sum $i | awk '{ print $1 }')"
        # Awk step removes the filename at the end
        $(echo $fileData >>$1)
    done
}

function compareCurrentToResult() {
    echo $(diff result.txt current.txt)
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
    echo "Scanning the folder now..."
    recordFileInformationTo "result.txt"
    ;;
"-D")
    echo "Cleaning up the directory..."
    deleteFiles
    echo "Done!"
    ;;
"-O")
    echo "Scanning the folder now..."
    recordFileInformationTo "current.txt"
    echo "Done. Checking against the existing record now..."
    compareCurrentToResult
    ;;
*)
    # Default case fires even when no argument is supplied at all
    echo "Invalid input detected. Please try to follow instructions."
    echo -e "Here they are again. \n"
    displayParameters
    ;;
esac
