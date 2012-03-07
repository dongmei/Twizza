<?php 

include_once("common.inc");

$query = "SELECT * FROM log ORDER BY log_time DESC LIMIT 15";
$data = queryDB_array($query);

foreach ($data as $row){
	$time = $row['log_time'];
	echo "<div style='margin-top:30px;'>Time: $time</div>";
	echo $row['name']."<br>".$row['info']."<br>";
}