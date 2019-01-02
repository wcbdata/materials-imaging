#!/bin/sh

#Image and data file sources
	cd ~
	sudo mkdir /etc/imaging
	sudo cp * /etc/imaging
	sudo chown -R nifi:hadoop /etc/imaging

	cd /etc/imaging

	sudo -u nifi ./mk-img.sh 3482359.csv 238-07.jpg
	sudo -u nifi ./mk-img.sh 3482360.csv 238-07.jpg
	sudo -u nifi ./mk-img.sh 8572.csv 1095-00.jpg
	sudo -u nifi ./mk-img.sh 8571.csv 1095-00.jpg


#Config files to NiFi
	cd /etc/nifi/conf
	sudo -u nifi cp /etc/hbase/2.6.2.0-205/0/hbase-site.xml .
	sudo -u nifi cp /etc/hive/2.6.2.0-205/0/hive-site.xml .
	sudo -u nifi cp /etc/hadoop/2.6.2.0-205/0/hdfs-site.xml .
	sudo -u nifi cp /etc/hadoop/2.6.2.0-205/0/core-site.xml .
	
	cd /usr/hdf/3.0.0.0-453/nifi/ext/
	sudo -u nifi curl -O https://raw.githubusercontent.com/apache/nifi/master/nifi-nar-bundles/nifi-standard-bundle/nifi-standard-processors/src/main/resources/default-grok-patterns.txt
	sudo chown nifi:nifi default-grok-patterns.txt

#For HDFS locations
	HADOOP_USER_NAME=hdfs hdfs dfs -mkdir /apps/imaging
	HADOOP_USER_NAME=hdfs hdfs dfs -mkdir /apps/imaging/images
	HADOOP_USER_NAME=hdfs hdfs dfs -mkdir /apps/imaging/data
	HADOOP_USER_NAME=hdfs hdfs dfs -chown -R nifi:hdfs /apps/imaging
	HADOOP_USER_NAME=hdfs hdfs dfs -chmod -R g+w /apps/imaging

#Start HBASE REST daemon
	sudo /usr/hdp/current/hbase-client/bin/hbase-daemon.sh start rest -p 16050 --infoport 16051

