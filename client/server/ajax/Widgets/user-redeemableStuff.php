<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$postdata = file_get_contents("php://input");

if ( ($data =  $postdata)  != NULL )
{
	$array=json_decode($data, true);
	$userID = $array['userID'];

	$outerQuery="CALL `w-user-redeemableStuff` ('$userID')";
	
	$outerResult=$mysqli->query($outerQuery) or die($mysqli->error.__LINE__);
	$arr = array();
	if($outerResult->num_rows > 0) {
		while($row = $outerResult->fetch_assoc()) {
			$arr[] = $row;
		}
	}
	echo $json_response = json_encode($arr);
}
else
{
	echo array('error' => 'DATABASE ERROR!');
}
?>