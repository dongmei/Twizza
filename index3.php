<?php


$con = mysql_connect("localhost:8889","dongmei","881213");
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }
  
mysql_select_db("Twizza", $con);

$rawJsonData=file_get_contents('php://input');

error_log("log!");
error_log($rawJsonData);

//Get POST json data and insert into database
$decodedData = json_decode($rawJsonData);

$user_id= $decodedData->user_name;
$topic = $decodedData->topic;

$query = "INSERT INTO user_topics (topic, user_name) VALUES ('topic', ".$user_id.")" ;

error_log($query);
mysql_query($query);


/*
//Insert data through php
$user_id= $_GET['userID'];
$content = $_GET['content'];

//$result = mysql_query("SELECT e.user_name,e.content,t.location FROM `user_tweets` AS e JOIN `user_profile` AS t ON( t.user_name = e.user_name) where t.user_name=".$id." LIMIT 1" );
$query = "INSERT INTO user_tweets (user_name, content) VALUES (".$user_id.", '$content')" ;
echo $query;
mysql_query($query);
*/

