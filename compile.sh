#!/bin/bash

timing=0
scriptfolder="$HOME/Library/Application Scripts/com.omnigroup.OmniFocus3"
usage="$(basename "$0") [-h] DIRECTORY

where:
	-h         show this help and exit
	DIRECTORY  directory of the script"

while getopts ':ht' option; do
	case "$option" in
		t)  timing=1
				;;
		h) 	echo "$usage"
				exit
				;;
		\?) printf "illegal option: -%s\n" "$OPTARG" >&2
			  echo "$usage" >&2
				exit 1
				;;
	esac
done
shift $((OPTIND-1))

input=${1////}

if [ "$input" == "Library" ]; then
	srcone="Library/omnifocuslib.applescript"
	trgtone="$HOME/Library/Script Libraries/omnifocuslib.scpt"
	if [ -f "$trgtone" ]; then
		rm "$trgtone"
	fi
	if [ $timing == 1 ]; then
		srctwo="Library/timinglib.applescript"
		trgttwo="$HOME/Library/Script Libraries/timinglib.scpt"
		if [ -f "$trgttwo" ]; then
			rm "$trgttwo"
		fi
		cmd="osacompile -o \"$trgttwo\" \"$srctwo\""
	else
		cmd="printf \"\""
	fi
	osacompile -o "$trgtone" "$srcone" && eval "$cmd" && echo "DONE"
else
	lowercase=$(echo "$input" | tr '[:upper:]' '[:lower:]')
	bn=${lowercase//[[:blank:]]/}
	src="$input"/"$bn".applescript
	trgt="$scriptfolder"/"$bn".scpt
	if [ -f "$trgt" ]; then
		rm "$trgt"
	fi
	osacompile -o "$trgt" "$src" && echo "DONE"
fi
