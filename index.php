<?php

//echo 'Hello ZC!';

$con = mysql_connect("localhost:8889","dongmei","881213");
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }
  
mysql_select_db("Twizza", $con);

$id= $_GET['tweetId'];
//$id= $_POST['tweetId'];

echo $_POST['user'];

$user_id= 2;

$result = mysql_query("SELECT e.user_name,e.content,t.location FROM `user_tweets` AS e JOIN `user_profile` AS t ON( t.user_name = e.user_name) where t.user_name=".$id." LIMIT 1" );
//$result = mysql_query("INSERT INTO user_tweets (user_name, content) VALUES (".$user_id.", 'morning ah')" );
//$result2 = mysql_query("SELECT e.user_name,e.content,t.location FROM `user_tweets` AS e JOIN `user_profile` AS t ON( t.user_name = e.user_name) where t.user_name=".$id." LIMIT 1" );

while($row = mysql_fetch_array($result,MYSQL_ASSOC))
  {
  //echo $row['id'] . " " . $row['user_name']." ".$row["screen_name"];
  //echo "<br />";
  echo json_encode($row);
  }