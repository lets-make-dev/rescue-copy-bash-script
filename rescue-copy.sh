#!/bin/bash

# specify source and destination directories
src="/mnt/sbs/somepath/uploads/2023"
dest="uploads"
failed="failed-copy.txt"

# find all files in source directory
find "$src" -type f | while read -r file; do
    # get path to destination file
    destfile="$dest/${file#$src/}"

    # create parent directory for destination file
    mkdir -p "$(dirname "$destfile")"

    # If file exists in failed-copy.txt, skip copying
    if grep -Fxq "$file" "$failed"; then
        echo -e "\n⏩ $file already in $failed, skipping..."
        continue
    fi

    # If file exists and has same size, skip copying
    if [ -e "$destfile" ] && [ $(stat -c%s "$file") -eq $(stat -c%s "$destfile") ]; then
        echo -e "\n⏩ $file already exists and matches the source file size, skipping..."
        continue
    fi

    echo -e "\n🕛 Starting copy of $file to $destfile..."

    # start the copy command in the background
    cp "$file" "$destfile" &

    # save its PID
    cp_pid=$!

    # wait for the copy command to finish or timeout
    for i in {1..5}; do
        # check if the copy command is still running
        if kill -0 $cp_pid 2>/dev/null; then
            # it is, so wait for a second
            sleep 1
        else
            # it's not, so it must have finished copying
            echo -e "\n✅  Finished copying $file"
            continue 2
        fi
    done

    # if we get here, the copy command is still running
    # after 5 seconds, so kill it
    echo -e "\n❗ Copying $file took too long, adding to $failed and moving to next file..."
    echo "$file" >> "$failed"
    kill $cp_pid
done
