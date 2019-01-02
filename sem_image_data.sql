CREATE TABLE `sem_image_data`(
  `runid` varchar(10), 
  `ts` varchar(30), 
  `partnum` varchar(10), 
  `equipid` varchar(10), 
  `hv` int, 
  `mag` int, 
  `wd` double, 
  `det` varchar(10), 
  `tilt` double, 
  `feat1` double, 
  `feat2` double, 
  `feat3` double, 
  `curr` int, 
  `hfw` double)
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
