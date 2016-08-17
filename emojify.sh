#!/bin/bash
if [ $# -lt 2 ]
  then echo 'Usage: ./emojify.sh <file> <dimension> (-u)';exit
fi
while getopts 'u' flag; do
  if [ "${flag}" == "u" ]
    then upload='true'
  fi
done
input_image=$1
dimensions=$2
name=`basename $input_image | sed 's/\.[^.]*$//'`
ext=`basename $input_image | sed 's/.*\.//'`
output=${3-$name}
width=$((128 * ($dimensions)))
dir="`pwd`/emoji/$name"
mkdir -p $dir
echo "Saving tiles to $dir/"
convert $input_image -resize $width $dir/tmp_$name
convert $dir/tmp_$name -crop 128x128 $dir/$output%d.$ext
rm $dir/tmp_$name
if [ $upload ]
  then python ./upload.py $dir/*
  else echo "To upload, run python upload.py ${dir}/*"
fi
