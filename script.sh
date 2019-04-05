#!/bin/bash

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
    ;;
"N")
    echo "Very well, create the files"
    ;;
*)
    echo "Invalid input detected. Please try to follow instructions."
    ;;
esac

# Magic function does nothing. For now.
function createFiles() {
    echo "Just out here, creating files and stuff"
}
