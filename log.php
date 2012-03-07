<?php 

include_once("db.php");

function twizza_log($info, $name="Default"){
	$query = "INSERT INTO log (name, info) VALUES ('%s','%s')";
	$sql = sprintf($query,$name, mysql_real_escape_string($info));
	queryDB($sql);
}

