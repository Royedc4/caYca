<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$data =  ((file_get_contents("php://input")));
$array=json_decode($data, true);
$hoy = date("Y-m-d H:i:s");


$queriesArray=array();
$errorsArray=array();
$affectedsArray=array();

$zGlobalResult=true; // our control variable 

for ($i = -1; $i < sizeof($array["token"]); $i++) {
	if ($i==-1){
		$query="START TRANSACTION";
	}
	else{
		$query="CALL `newRaffleCoupon`('" . $array["token"][$i] . "','" . $array["userID"] . "','" . $array["country"] . "','" . $array["userTypeID"] . "','" . $array["createdBy"] . "','$hoy')";
	}
	$mysqli->query($query) ? false : $zGlobalResult=false;
	array_push($queriesArray, $query);
	array_push($errorsArray, $mysqli->error.__LINE__);
	array_push($affectedsArray, $mysqli->affected_rows);
}

$resultObj = (object) array('arrayQueries' => $queriesArray, 'affectedsArray' => $affectedsArray, 'errorsArray' => $errorsArray, 'zGlobalResult' => $zGlobalResult, 'hoy' => $hoy);
$zGlobalResult ? $mysqli->commit() : $mysqli->rollback(); 
echo $json_response = json_encode($resultObj);	
$mysqli->close(); 

?>