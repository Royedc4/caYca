<?php 
require_once '../../secure/db.php'; // The mysql database connection script
header('Access-Control-Allow-Origin: *');  

$geoID = '%';
if(isset($_GET['geoID'])) 
	$geoID = $_GET['geoID'];

$outerQuery="SELECT * FROM city ORDER BY name";

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