<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$companyID = '%';
if(isset($_GET['companyID']))
	$companyID = $_GET['companyID'];

// Select
$outerQuery="CALL sUnlabeled('$companyID')";
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
