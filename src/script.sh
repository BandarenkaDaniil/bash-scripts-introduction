#!/bin/bash

function error()
{
	local scriptName=$1
	local errorType=$2
	local errorDescription=$3

	echo "$scriptName: $errorType: $errorDescription" >&2
	echo "Try to call the script with \"help\" argument."

	exit 0
}

function help()
{
	echo "The script requires three args: OwnerName SourceDirectory OutputFileName."

	exit 0
}

function main()
{
	local owner=$1
	local sourceDir=$2
	local outputFile=$3

	local INVALID_DIRECTORY_TYPE="dir error"
	local INVALID_DIRECTORY_DESC="$sourceDir is not a directory"
	local SCRIPT_NAME="$(basename $0)"

	if [[ !(-d $sourceDir) ]]
	then
		error "$SCRIPT_NAME" "$INVALID_DIRECTORY_TYPE" "$INVALID_DIRECTORY_DESC"
	fi

	local totalFiles=0
	local files=$(find $sourceDir -type f -user $owner)

	truncate -s 0 $outputFile

	for currFile in $files
	do
		echo "$(realpath $currFile) $(basename $currFile) $(stat -c %s $currFile)" >> $outputFile
		((totalFiles++))
	done

	echo $totalFiles
}

INVALID_ARGS_ERR_TYPE="args error"
INVALID_ARGS_ERR_DESC="Arguments can't be recognized."
SCRIPT_NAME="$(basename $0)"

if [[ $# -eq 1 ]] && [[ $1 == "help" ]]
then
	help
elif [[ $# -eq 3 ]]
then
	main $1 $2 $3
else
	error "$SCRIPT_NAME" "$INVALID_ARGS_ERR_TYPE" "$INVALID_ARGS_ERR_DESC"
fi
