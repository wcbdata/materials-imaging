#!/usr/bin/env bash

export AMBARI_HOST=$(hostname -f)
echo "*********************************AMABRI HOST IS: $AMBARI_HOST"

export CLUSTER_NAME=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/clusters |grep cluster_name|grep -Po ': "(.+)'|grep -Po '[a-zA-Z0-9\-_!?.]+')
echo "*********************************CLUSTER NAME IS: $CLUSTER_NAME"

export HIVESERVER_HOST=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/clusters/$CLUSTER_NAME/services/HIVE/components/HIVE_SERVER|grep "host_name"|grep -Po ': "([a-zA-Z0-9\-_!?.]+)'|grep -Po '([a-zA-Z0-9\-_!?.]+)')
echo "*********************************HIVE HOST IS: $HIVESERVER_HOST"


pushSchemasToRegistry (){

  export SCHEMA=sem_meta_10021
    echo "*********************************Uploading $SCHEMA schema and first version to $AMBARI_HOST"
	curl -u admin:admin -i -H "content-type: application/json" -d @$SCHEMA.schema.json -X POST http://$AMBARI_HOST:7788/api/v1/schemaregistry/schemas
	curl -u admin:admin -i -H "Content-Type: multipart/form-data" --header "Accept: application/json" -F file=@sem_meta_10021.avro.json -F description="SEM metadata schema for device type 10021." -X POST http://$AMBARI_HOST:7788/api/v1/schemaregistry/schemas/$SCHEMA/versions/upload

    export SCHEMA=sem_meta_10083
    echo "*********************************Uploading $SCHEMA schema and first version to $AMBARI_HOST"
	curl -u admin:admin -i -H "content-type: application/json" -d @$SCHEMA.schema.json -X POST http://$AMBARI_HOST:7788/api/v1/schemaregistry/schemas
	curl -u admin:admin -i -H "Content-Type: multipart/form-data" --header "Accept: application/json" -F file=@$SCHEMA.avro.json -F description="SEM metadata schema for device type 10083." -X POST http://$AMBARI_HOST:7788/api/v1/schemaregistry/schemas/$SCHEMA/versions/upload

    export SCHEMA=sem_meta_10083_data
    echo "*********************************Uploading $SCHEMA schema and first version to $AMBARI_HOST"
	curl -u admin:admin -i -H "content-type: application/json" -d @$SCHEMA.schema.json -X POST http://$AMBARI_HOST:7788/api/v1/schemaregistry/schemas
	curl -u admin:admin -i -H "Content-Type: multipart/form-data" --header "Accept: application/json" -F file=@$SCHEMA.avro.json -F description="SEM metadata schema for device type 10083 without particle data." -X POST http://$AMBARI_HOST:7788/api/v1/schemaregistry/schemas/$SCHEMA/versions/upload

    export SCHEMA=sem_meta_10083_particle
    echo "*********************************Uploading $SCHEMA schema and first version to $AMBARI_HOST"
	curl -u admin:admin -i -H "content-type: application/json" -d @$SCHEMA.schema.json -X POST http://$AMBARI_HOST:7788/api/v1/schemaregistry/schemas
	curl -u admin:admin -i -H "Content-Type: multipart/form-data" --header "Accept: application/json" -F file=@$SCHEMA.avro.json -F description="SEM metadata schema for particle data identified by device type 10083." -X POST http://$AMBARI_HOST:7788/api/v1/schemaregistry/schemas/$SCHEMA/versions/upload

    export SCHEMA=sem_meta_10083_preprocess
    echo "*********************************Uploading $SCHEMA schema and first version to $AMBARI_HOST"
	curl -u admin:admin -i -H "content-type: application/json" -d @$SCHEMA.schema.json -X POST http://$AMBARI_HOST:7788/api/v1/schemaregistry/schemas
	curl -u admin:admin -i -H "Content-Type: multipart/form-data" --header "Accept: application/json" -F file=@$SCHEMA.avro.json -F description="SEM metadata schema for device type 10083 preprocessing. Treats particle data as an unparsed string." -X POST http://$AMBARI_HOST:7788/api/v1/schemaregistry/schemas/$SCHEMA/versions/upload

    echo "*********************************SCHEMAS LOADED:"
    curl -s -D "/dev/stderr" -X GET --header 'Accept: application/json' "http://$AMBARI_HOST:7788/api/v1/schemaregistry/schemas" | jq '.'

}

createHbaseTables () {
	#Create Hbase Tables

	echo "create 'images', {NAME => 'image', IS_MOB => true, MOB_THRESHOLD => 102400},'metadata'" | hbase shell
}

createHiveTables () {

    beeline -u jdbc:hive2://$HIVESERVER_HOST:10000 -n hive -f ./sem_image_data.sql
    beeline -u jdbc:hive2://$HIVESERVER_HOST:10000 -n hive -f ./sem_image_particle.sql
}


echo "********************************* Registering Schemas"
pushSchemasToRegistry

echo "********************************* Creating Hbase Tables"
createHbaseTables

echo "********************************* Creating Hive Tables"
createHiveTables