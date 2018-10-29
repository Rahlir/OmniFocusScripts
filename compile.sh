#!/bin/bash

scriptfolder="$HOME/Library/Application Scripts/com.omnigroup.OmniFocus3"
usage="$(basename "$0") [-h] DIRECTORY

where:
	-h         show this help and exit
	DIRECTORY  directory of the script"

while getopts ':h' option; do
	case "$option" in
		h) 	echo "$usage"
				exit
				;;
		\?) printf "illegal option: -%s\n" "$OPTARG" >&2
			  echo "$usage" >&2
				exit 1
				;;
	esac
done

input=${1////}

if [ "$input" == "Library" ]; then
	src="Library/omnifocuslib.applescript"
	trgt="$HOME/Library/Script Libraries/omnifocuslib.scpt"
else
	lowercase=$(echo "$input" | tr '[:upper:]' '[:lower:]')
	bn=${lowercase//[[:blank:]]/}
	src="$input"/"$bn".applescript
	trgt="$scriptfolder"/"$bn".scpt
fi

osacompile -o "$trgt" "$src" && echo "DONE"
