#!/bin/bash
OUTPUT_FILE=$2
echo "<?xml version=\"1.0\" encoding=\"utf-8\" ?>
<data>
 <group name=\"auto\">" > $OUTPUT_FILE
find $1 -a -type f -a ! -path *.svn* -a ! -name .DS_Store -a ! -regex '.*[o|t]tf.*' | while read f
do
	filename=${f##*/}
	filename=${filename%.*}
	url=${f//\/\//\/}
	url=${url#./}
	node="\t<asset id=\"$filename\" url=\""$url"\""
	if [[ $f == *spritesheets* ]]; then
		if [[ $f == *.xml ]]; then
			node=$node" type=\"spritesheet\"/>"
		else
			node=""
		fi
	elif [[ $f == *.xml ]] || [[ $f == *.txt ]]; then
		node=$node" type=\"text\"/>"
	elif [[ $f == *.png ]] || [[ $f == *.jpg ]]; then
		node=$node" type=\"image\"/>"
	elif [[ $f == *.mp3 ]] || [[ $f == *.wav ]]; then
		node=$node" type=\"sound\"/>"
	else
		node=$node" type=\"raw\"/>"
	fi
	if [[ $node != "" ]]; then
		echo -e $node >> $OUTPUT_FILE
	fi
done
echo " </group>
</data>" >> $OUTPUT_FILE
