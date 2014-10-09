<?php 
require_once '../../secure/db.php'; // The mysql database connection script
header('Access-Control-Allow-Origin: *');  

$userTypeID = '%';
if(isset($_GET['userTypeID'])) 
	$userTypeID = $_GET['userTypeID'];


$outerQuery="SELECT userTypeID, name, description FROM userType WHERE userTypeID like '$userTypeID'";

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