<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$data =  ((file_get_contents("php://input")));
$array=json_decode($data, true);
$hoy = date("Y-m-d H:i:s");

$queriesArray=array();
$errorsArray=array();
$affectedsArray=array();

$query="CALL `creditNote-new`('" . $array['companyID'] . "','" . $array['createdBy_userID'] . "','" . $array['creationDate'] . "','" . $array['registryDate'] . "','" . $array['country'] . "','" . $array['comment'] . "','" . $array['fileURL'] . "')";

$result=$mysqli->query($query) or die($mysqli->error.__LINE__);
if($result->num_rows > 0) {
	while($row = $result->fetch_assoc()) {
		$results = $row;
	}
}
array_push($queriesArray, $query);
array_push($errorsArray, $mysqli->error.__LINE__);
array_push($affectedsArray, $mysqli->affected_rows);

$resultObj = (object) array('arrayQueries' => $queriesArray, 'affectedsArray' => $affectedsArray, 'errorsArray' => $errorsArray, 'results' => $results, 'hoy' => $hoy);

echo $json_response = json_encode($resultObj);	
$mysqli->close(); 

?>