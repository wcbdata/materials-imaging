#!/bin/sh

if [ "$1" != "" ] ; then


    #Local Variables
    # export XXX=yyy

	  echo "Copying image files to target: "$1""
	  scp -i ~/.ssh/field.pem -r 3482360.csv cloudbreak@$1:~/.
	  scp -i ~/.ssh/field.pem -r 3482359.csv cloudbreak@$1:~/.
	  scp -i ~/.ssh/field.pem -r 8572.csv cloudbreak@$1:~/.
	  scp -i ~/.ssh/field.pem -r 8571.csv cloudbreak@$1:~/.
	  scp -i ~/.ssh/field.pem -r hortonsocks.jpg cloudbreak@$1:~/.
	  scp -i ~/.ssh/field.pem -r 238-07.jpg cloudbreak@$1:~/.
	  scp -i ~/.ssh/field.pem -r 1095-00.jpg cloudbreak@$1:~/.
	  scp -i ~/.ssh/field.pem -r mk-img.sh cloudbreak@$1:~/.
	  scp -i ~/.ssh/field.pem -r build-sources.sh cloudbreak@$1:~/.

else
    echo "Requires the target hostname or IP as parameter #1"
    echo "Usage: copy-files.sh [ip-address]|[hostname]"
fi
