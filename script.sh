#!/bin/bash

echo "This is an Intrusion Detection System"
echo "Do you want to let this program create files?"
echo "[Y]es, I want the program to create the files. [N]o, I'll do it myself"
read decision

case $decision in
    "Y") echo "Creating files now..." ;;
    "N") echo "Very well, create the files" ;;
    *) echo "Invalid input detected. Please try to follow instructions.";;
esac