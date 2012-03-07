<?php

include_once("common.inc");

$id= $_GET['user_id'];
$query = "SELECT topic_name,topic_keyword,topics.topic_id,type";
$query .= " FROM topics INNER JOIN user_topics";
$query .= " ON user_topics.topic_id = topics.topic_id AND user_topics.uid='".$id."'";
$query .= " ORDER BY weight DESC";


twizza_log($query,"query display topic");
$raw = queryDB_array($query);

$data = array();
for ($i=0;$i<count($raw);$i++){
	$row = $raw[$i];
	$keywords = explode(',', $row['topic_keyword']);
	$data[] = array(
				"topic_id" => $row['topic_id'],
				"topic_type" => $row['type'],
				"topic_name"=>$row['topic_name'],
				"topic_keyword" => $keywords
				);	
}	

echo json_encode($data);