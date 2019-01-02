#!/bin/sh

if [ "$1" != "" ] && [ "$2" != "" ]; then

    #Locale needs to be C in order to generate random strings using urandom and tr 
    export LC_CTYPE=C

    while IFS=., read -r f1 f2 f3 f4; 
		
	do

	 if [ ! "$f1" = "runid" ]; then

	  if [ ! -d "$f1" ]; then
	    # Create the directory
	    echo "Creating directory: "$f1""
	    mkdir "$f1"
	  fi

	  imgfname=$(head /dev/urandom | tr -dc [:lower:][:upper:]0-9 | head -c 8)

	  if [ "$(uname -a|grep -o Darwin)" == "Darwin" ]; then
	    #This is a MacOS/Darwin Machine - use Mac date commands
	    echo "Attempting MacOS-Darwin BSD style: (date -j -f '%m/%d/%Y %T' "$f2" +%Y%m%d%H%M.%S)"
	    newdate=$(date -j -f '%m/%d/%Y %T' "$f2" +%Y%m%d%H%M.%S)

	  else
	    #This is not a Mac - try GNU date commands
            echo "Attempting POSIX/GNU-style: (date -d "$f2" +%Y%m%d%H%M.%S)"
            newdate=$(date -d"$f2" +%Y%m%d%H%M.%S)

	  fi


          echo "Using date "$f2""

	  echo "Copying image "$2" to new filename: "$f1"/"$imgfname.jpg""
	  cp "$2" "$f1"/"$imgfname.jpg"
	 
	  echo "Re-dating file to "$newdate""
	  touch -t "$newdate" "$f1"/"$imgfname.jpg";

	fi

    done < "$1"

else
    echo "Requires a CSV filename as parameter #1 and an image filename as parameter #2"
    echo "Usage: mk-img.sh filename1.csv filename2.jpg"
fi
