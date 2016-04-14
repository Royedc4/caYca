<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$outerQuery="CALL `compressor-rotInfo`()";

$outerResult=$mysqli->query($outerQuery) or die($mysqli->error.__LINE__);
$arr = array();
if($outerResult->num_rows > 0) {
	while($row = $outerResult->fetch_assoc()) {
		$arr[] = $row;
	}
}
echo $json_response = json_encode($arr);
?>
