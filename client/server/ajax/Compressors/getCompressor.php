<?php 
require_once '../../secure/db.php'; // The mysql database connection script
header('Access-Control-Allow-Origin: *');
$compressorID = '%';
$capacity = '%';
$refrigerant = '%';

if(isset($_GET['compressorID'])) 
	$compressorID = $_GET['compressorID'];
if(isset($_GET['capacity']))
	$capacity = $_GET['capacity'];
if(isset($_GET['refrigerant'])) 
	$refrigerant = $_GET['refrigerant'];

// Select
$outerQuery="SELECT compressorID, application, refrigerant, voltage, btuH, capacity, frequency, designType FROM COMPRESSOR WHERE compressorID like '$compressorID' AND capacity like '$capacity' AND refrigerant like '$refrigerant'";

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
