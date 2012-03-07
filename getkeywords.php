<?php

include_once("common.inc");

$id= $_GET['user_id'];
$query = "SELECT topic_keyword FROM topics INNER JOIN user_topics ON user_topics.topic_id = topics.topic_id AND user_topics.uid='".$id."'";


twizza_log($query,"query display topic");
//$json_data = queryDB_json_list($query);
$json_data = queryDB_json_list($query,'topic_keyword');
//queryDB($query);
echo $json_data;