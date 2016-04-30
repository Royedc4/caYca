<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$outerQuery="SELECT geonameid, country, alternatename from country";
$outerResult=$mysqli->query($outerQuery) or die($mysqli->error.__LINE__);
$arr = array();
if($outerResult->num_rows > 1) {
	while($row = $outerResult->fetch_assoc()) {
		$arr[] = $row;	
	}
}
# JSON-encode the response
echo $json_response = json_encode($arr);
?>