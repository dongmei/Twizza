<?php

$con = mysql_connect("localhost:8889","dongmei","881213");
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }
  
mysql_select_db("Twizza", $con);

//$id= $_GET['user_name'];
$id='zoeMeii';

//echo $_POST['user'];

//$user_id= 2;

//$query = "SELECT topics,user_name FROM usersPreference WHERE user_name='".$id."'";
$query = "SELECT topics,user_name FROM usersPreference";
$result = mysql_query($query);


$data = array();
while($row = mysql_fetch_array($result,MYSQL_ASSOC))
  {  
  	$name = $row['user_name'];
  	$data[$name][] = $row['topics'];
  }

  $dict = array();
  //$dict['topics'] = $data;
  echo json_encode($data);