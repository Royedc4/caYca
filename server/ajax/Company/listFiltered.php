<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$postdata = file_get_contents("php://input");

$isFactory = false;
$isImporter = false;
$isWholesaler = false;
$isRetailer = false;
$country='%';

if ( ($data =  $postdata)  != NULL )
{
	$array=json_decode($data, true);
	if (isset($array['isFactory']))
		$isFactory = $array['isFactory'];
	if (isset($array['isImporter']))
		$isImporter = $array['isImporter'];
	if (isset($array['isWholesaler']))
		$isWholesaler = $array['isWholesaler'];
	if (isset($array['isRetailer']))
		$isRetailer = $array['isRetailer'];
	if (isset($array['country']))
		$country = $array['country'];

	$outerQuery="CALL `company-listFiltered`('$isFactory','$isImporter','$isWholesaler','$isRetailer', '$country')";

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