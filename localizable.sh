#!/bin/bash

filename='Localizable.strings'
file_without_format='strings_without_format.xml'
file_with_format='strings.xml'
replace_filename='replace.strings'

xml=""

if [ ! -f "$filename" ]
then
    echo "File $filename does not exist"
    exit
fi

# xml+=$(echo '<?xml version="1.0" encoding="utf-8"?>')
xml+=$(echo '<resources>')

echo "Wait..."

while read line; do
	key=$(echo $line | cut -d'"' -f2)
	value=$(echo $line | cut -d'"' -f4)

	# all characters are uppercase >> lowercase
	if [[ $key =~ ^[[:upper:]]+$ ]]; then
		key=$(echo "$key" | tr '[:upper:]' '[:lower:]')
	fi	

	# id contain '_' uppercase >> lowercase
	if [[ $key == *['!'_]* ]]; then
	   	key=$(echo "$key" | tr '[:upper:]' '[:lower:]')
	fi

	# get first letter and convert to lowercase
	firstLetterUpper=${key:0:1}
	firstLetterLower=$(echo "$firstLetterUpper" | tr '[:upper:]' '[:lower:]')

	# rest of characters
	characters="${key:1}"

	letters=""

	# loop of characters
	for ((i=1;i<=${#characters};i++)); do
		character=$(echo ${characters:$i-1:1})

		# if character is uppercase, it's changed to lowercase and '_' is added
	  	if [[ $character =~ [[:upper:]] ]]; then
			otherLetterLower=$(echo "$character" | tr '[:upper:]' '[:lower:]')
			letters+="_$otherLetterLower"
		else
			letters+=$character
		fi

	done

	# validate & character
	value=$(echo "$value" | sed -r "s/\&/\&amp;/g")

	# validate ' character
	value=$(echo "$value" | sed -r "s/\'/\&#8217;/g")

	# validate - character
	value=$(echo "$value" | sed -r "s/\-/\&#8211;/g")


	if [ ! -z "$value" ]
	then
		# concat new key
		newKey=$(echo "$firstLetterLower$letters")

		#validate newKey not equals continue (reserved keyboard)
		if [ $newKey == "continue" ]; then
			newKey+="_"
		fi	

		xml+=$(echo "  <string name=\"$newKey\">$value</string>")
		letters=""
	fi


done < <(cat $filename | egrep '^".+"\s?=\s?.+$')

xml+=$(echo '</resources>')

if [ -f "$file_without_format" ]
then
    rm $file_without_format
fi

# generate file without format
echo $xml >> $file_without_format

if [ -f "$file_with_format" ]
then
    rm $file_with_format
fi

# generate file with format
xmllint --format $file_without_format > $file_with_format
xmlstarlet format --indent-tab $file_without_format > $file_with_format

if [ -f "$file_without_format" ]
then
    rm $file_without_format
fi

echo "Check the file $file_with_format"