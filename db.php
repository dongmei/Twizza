<?php

$_con = mysql_connect("localhost:8889","dongmei","881213");
if (!$_con){
  die('Could not connect: ' . mysql_error());
}
  
mysql_select_db("Twizza", $_con);

function queryDB($query){
	return mysql_query($query);
}

function queryDB_array($query,$type=MYSQL_ASSOC){
	$result = queryDB($query);
	$data = array();
	while($row = mysql_fetch_array($result,$type)){
		$data[]= $row;
	}
	return $data;
}

function queryDB_json_list($query, $key){
    $result = queryDB_array($query);
	$data = array();
	foreach ($result as $row){
  		$data[] = $row[$key];
	}

	$dict = array();
	$dict[$key] = $data;
    return json_encode($dict);
}


