#!/bin/bash
OUTPUT_FILE=$2
echo "<?xml version=\"1.0\" encoding=\"utf-8\" ?>
<data>
 <group name=\"auto\">" > $OUTPUT_FILE
for f in $(find $1 -mindepth 2 -a -type f -a ! -path *.svn* -a ! -name .DS_Store -a ! -regex '.*[o|t]tf.*')
do
	node="\t<asset id=\""${f##*/}"\" url=\""${f#./}"\""
	if [[ $f == *.xml ]] || [[ $f == *.txt ]]; then
		node=$node" type=\"text\"/>"
	elif [[ $f == *.png ]] || [[ $f == *.jpg ]]; then
		node=$node" type=\"image\"/>"
	elif [[ $f == *.mp3 ]] || [[ $f == *.wav ]]; then
		node=$node" type=\"sound\"/>"
	else
		node=$node" type=\"raw\"/>"
	fi
	echo -e $node >> $OUTPUT_FILE
done
echo " </group>
</data>" >> $OUTPUT_FILE
