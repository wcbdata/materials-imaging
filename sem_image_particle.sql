CREATE TABLE `sem_image_particle`(
  `runid` varchar(10), 
  `ts` varchar(30), 
  `xloc` int, 
  `yloc` int, 
  `xdim` int, 
  `ydim` int)
CLUSTERED BY ( 
  runid) 
INTO 3 BUCKETS
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
TBLPROPERTIES (
  'transactional'='true')

