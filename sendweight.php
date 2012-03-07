<?php

include_once("common.inc");

$rawJsonData=file_get_contents('php://input');
twizza_log($rawJsonData);

//Get POST json data and insert into database
$decodedData = json_decode($rawJsonData);

$user_id= $decodedData->userID;
$topic_id = $decodedData->topicID;

$query = "UPDATE user_topics SET weight = weight+0.1,last_update_time = NOW() WHERE topic_id='".$topic_id."' AND uid='".$user_id."' ";
twizza_log($query,"send weight to update");
queryDB($query);

