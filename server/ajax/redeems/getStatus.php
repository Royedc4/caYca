<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$outerQuery="SELECT * FROM redeemStatus WHERE redeemStatusID<10";

$outerResult=$mysqli->query($outerQuery) or die($mysqli->error.__LINE__);
$arr = array();
if($outerResult->num_rows > 0) {
	while($row = $outerResult->fetch_assoc()) {
		$arr[] = $row;
	}
}
	# JSON-encode the response
echo $json_response = json_encode($arr);


?>