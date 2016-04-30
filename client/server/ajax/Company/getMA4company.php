<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$postdata = file_get_contents("php://input");

if ( ($data =  $postdata)  != NULL )
{
	$array=json_decode($data, true);
	$companyID = $array['companyID'];
	
	$outerQuery="CALL `user-getMA4company`('$companyID',@ma4company)";

	$outerResult=$mysqli->query($outerQuery) or die($mysqli->error.__LINE__);
	$outerResult=$mysqli->query('SELECT @ma4company') or die($mysqli->error.__LINE__);
	$arr = array();
	if($outerResult->num_rows > 0) {
		while($row = $outerResult->fetch_assoc()) {
			$arr[] = $row;
		}
	}

	# JSON-encode the response
	echo $json_response = json_encode($arr);
}
else
{
	echo array('error' => 'DATABASE ERROR!');
}
?>