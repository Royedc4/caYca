<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$postdata = file_get_contents("php://input");

$userTypeID = '%';
$country='%';

if ( ($data =  $postdata)  != NULL )
{
	$array=json_decode($data, true);
	if (isset($array['userTypeID']))
		$userTypeID = $array['userTypeID'];
	if (isset($array['country']))
		$country = $array['country'];

	$outerQuery="CALL `user-listFiltered`('$userTypeID','$country')";

	$outerResult=$mysqli->query($outerQuery) or die($mysqli->error.__LINE__);
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
	echo array('error' => 'Error getting fron FRONTEND!');
}
?>