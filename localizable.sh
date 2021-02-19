#!/bin/bash

filename='Localizable.strings'
file_without_format='strings_without_format.xml'
file_with_format='strings.xml'
replace_filename='replace.strings'

# AMPERSAND="&amp;"
# MINOR_SYMBOL="&lt;"
# MAJOR_SYMBOL="&gt;"

xml=""

if [ ! -f "$filename" ]
then
    echo "File $filename does not exist"
    exit
fi

# xml+=$(echo '<?xml version="1.0" encoding="utf-8"?>')
xml+=$(echo '<resources>')

# sed -e "s/&/$AMPERSAND/g; s/\</$MINOR_SYMBOL/g; s/\>/$MAJOR_SYMBOL/g" $filename > $replace_filename

# echo $replace_filename

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

	# concat new key
	newKey=$(echo "$firstLetterLower$letters")
	xml+=$(echo "  <string name=\"$newKey\">$value</string>")
	letters=""

done < <(cat $filename | egrep '^".+"\s?=\s?.+$')

xml+=$(echo '</resources>')

if [ -f "$file_without_format" ]
then
    rm $file_without_format
fi

echo $xml

# generate file without format
echo $xml >> $file_without_format

# error with symbols &, < and >
# --------------------------------

# if [ -f "$file_with_format" ]
# then
#     rm $file_with_format
# fi

# generate file with format
# xmllint --format $file_without_format > $file_with_format
# xmlstarlet format --indent-tab $file_without_format > $file_with_format

# if [ -f "$file_without_format" ]
# then
#     rm $file_without_format
# fi
