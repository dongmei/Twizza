<?php
include_once("common.inc");
twizza_log("logooo",'sdfds');

$user_id = $_GET['user_id'];
$topic_id = $_GET['topic_id'];

$query1 = "DELETE FROM user_topics WHERE topic_id='".$topic_id."' AND uid = '".$user_id."'";
twizza_log($query,"query delete topic from user_topics");
queryDB($query1);

$query2 = "DELETE FROM topics WHERE topic_id='".$topic_id."'";
twizza_log($query,"query delete topic from topics");
queryDB($query1);