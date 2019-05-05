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
            ! -name "diff.txt" \
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

function printChangeInFile() {
    : ' Arg number: what it is. Add 9 to indexfor next line (if exists)
    2: permissions
    3: number of links
    4: username owner
    5: username group
    6: size
    7: month  modified
    8: date modified
    9: time modified
    10: filename
    11: md5
    '
    echo "Intrusion detected at $1"

    if [[ -z ${12} ]]; then
        if [[ $2 == +-* ]]; then
            echo "New file, created by $4 on $9 at $8 $7"
        elif [[ $2 == --* ]]; then
            echo "File has been deleted"
        fi
    else
        if [[ ${11} != ${21} ]]; then
            echo "MD5 hash change: ${11} -> ${21}"
        fi
        if [[ $4 != ${14} ]] || [[ $5 != ${15} ]]; then
            echo "Ownership change: $4 $5 -> ${14} ${15}"
        fi
        if [[ $9 != ${19} ]] || [[ $8 != ${18} ]] || [[ $7 != ${17} ]]; then
            echo "Timestamp change: $9 $8 $7 -> ${19} ${18} ${17}"
        fi
    fi
    echo "---"
}

function compareCurrentToResult() {
    difference=$(diff -uBr result.txt current.txt)
    if [ -z "$difference" ]; then
        echo "No intrusions detected."
    else
        echo "There has been an intrusion. Processing the result..."
        echo "$difference" >diff.txt

        declare -A files

        # First three lines are sorta filler information, skip
        while read line; do
            # if line is add/ delete line
            if [[ $line == +-* ]] || [[ $line == --* ]]; then
                # Access the filename
                fileName=$(echo $line | cut -d' ' -f9)
                files[$fileName]+="$line "
            fi
        done < <(sed 1,3d diff.txt)

        # For every key in the associative array..
        for KEY in "${!files[@]}"; do
            printChangeInFile $KEY ${files[$KEY]}
        done
        rm diff.txt
    fi
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
