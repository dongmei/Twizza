<?php 

include_once("common.inc");

/*
//weight = weight*0.9 for all topics;
$query1 = "UPDATE user_topics SET weight = weight*0.9,last_update_time = NOW()";
$query1 .= "WHERE uid = '".$user_id."'";
twizza_log($query1,"update weight for all topics");
queryDB($query1);
*/

//test, weight = weight*0.9 if not updated for 15 min;
$query1 = "UPDATE user_topics SET weight = weight*0.9,last_update_time = NOW()";
$query1 .= "WHERE TIMEDIFF(NOW(), last_update_time)>15";
twizza_log($query1,"update weight for all topics");
queryDB($query1);

//weight = weight*0.8 if topic has not been updated for 3 days
$query2 = "UPDATE user_topics SET weight = weight*0.8,last_update_time = NOW()";
$query2 .= "WHERE DATEDIFF(NOW(), last_update_time)>3";
twizza_log($query2,"update weight if >3");
queryDB($query2);

//weight = weight*0.8 if topic has not been updated for 7 days
$query3 = "UPDATE user_topics SET weight = weight*0.8,last_update_time = NOW()";
$query3 .= "WHERE DATEDIFF(NOW(), last_update_time)>7";
twizza_log($query3,"update weight if >7");
queryDB($query3);