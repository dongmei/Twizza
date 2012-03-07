<?php

include_once("common.inc");

$rawJsonData=file_get_contents('php://input');
twizza_log($rawJsonData);

//Get POST json data and insert into database
$decodedData = json_decode($rawJsonData);

$user_id= $decodedData->userID;
$topic_name = $decodedData->topicName;
$keywords = $decodedData->keywordString;

$query1 = "INSERT INTO topics (type, topic_name, topic_keyword) VALUES ('1', '$topic_name', '".$keywords."')";
twizza_log($query1,"query add new topic into topic list");
queryDB($query1);

$topic_id = mysql_insert_id();

$query2 = "INSERT INTO user_topics (topic_id, uid) VALUES ('".$topic_id."', '".$user_id."')" ;
twizza_log($query2,"add topic to user");
queryDB($query2);
