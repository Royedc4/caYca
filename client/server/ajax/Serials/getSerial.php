<?php 
require_once '../../secure/db.php'; // The mysql database connection script
$serialID = '%';
$countryID = '%';
$compressorID = '%';

if(isset($_GET['serialID'])) 
	$serialID = $_GET['serialID'];
if(isset($_GET['countryID']))
	$countryID = $_GET['countryID'];
if(isset($_GET['compressorID'])) 
	$compressorID = $_GET['compressorID'];

// Select
$outerQuery="SELECT serialID,countryID,compressorID FROM serial WHERE serialID like '$serialID' AND countryID like '$countryID' AND compressorID like '$compressorID'";

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
