<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$postdata = file_get_contents("php://input");
$hoy = date("Y-m-d H:i:s");


if ( ($data =  $postdata)  != NULL )
{
	$array=json_decode($data, true);
	$companyID = $array['companyID'];

	$outerQuery="CALL `w-companyStock` ('$companyID')";
	
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
	$resultObj = (object) array('$data' => $data, '$postdata' => $postdata, 'hoy' => $hoy);
	echo $json_response = json_encode($resultObj);	
}

	
?>