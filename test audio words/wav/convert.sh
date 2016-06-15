#!/bin/bash
for file in *.mp3
do
    filename=$(echo $file| cut -d'.' -f 1)
    echo $filename
    mpg123 -w "$filename.wav" "$file"
done
