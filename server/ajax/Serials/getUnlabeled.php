<?php 
require_once '../../secure/db.php'; // The mysql database connection script
header('Access-Control-Allow-Origin: *');  

$serial = '%';
$companyID = '%';
$compressorID = '%';

if(isset($_GET['serial'])) 
	$serial = $_GET['serial'];
if(isset($_GET['companyID']))
	$companyID = $_GET['companyID'];
if(isset($_GET['compressorID'])) 
	$compressorID = $_GET['compressorID'];

// Select
$outerQuery="SELECT serial, companyID, compressorID FROM serial WHERE serial like '$serial' AND companyID like '$companyID' AND compressorID like '$compressorID' AND isLabeled=0";
// $outerQuery="SELECT serialID,countryID,compressorID FROM serial WHERE serialID like '$serialID' AND countryID like '$countryID' AND compressorID like '$compressorID' AND serialID NOT IN (SELECT DISTINCT(serialID) FROM labeled)";

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
