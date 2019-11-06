#!/bin/sh

for FILE in *.webm;
do
    echo -e "Processing video '\e[32m$FILE\e[0m'";
    ffmpeg -i "${FILE}" -vn -y "${FILE%.webm}.ogg"
done
for FILE in *.mp4;
do
    echo -e "Processing video '\e[32m$FILE\e[0m'";
    ffmpeg -i "${FILE}" -vn -y "${FILE%.webm}.ogg"
done
