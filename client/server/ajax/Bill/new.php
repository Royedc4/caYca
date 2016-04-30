<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$data =  ((file_get_contents("php://input")));
$array=json_decode($data, true);
$hoy = date("Y-m-d");


$queriesArray=array();
$errorsArray=array();
$affectedsArray=array();

$zGlobalResult=true; // our control variable 

for ($i = -2; $i < sizeof($array["serials"]); $i++) {
	if ($i==-2){
		$query="START TRANSACTION";
	}
	if ($i==-1){
		// CREATE PROCEDURE `bill-new` (IN I_seller_userID INT, IN I_buyer_companyID INT, IN I_date DATE, IN I_number VARCHAR(25), IN I_description VARCHAR(100))
		$query="CALL `bill-new`('" . $array["seller_userID"] . "','" . $array["number"] . "','" . $array["buyer_companyID"] . "','$hoy','" . $array["description"] . "')";
	}
	if($i>=0){
		// CREATE PROCEDURE `bill-newRows` (IN I_serial VARCHAR(25), IN I_seller_userID INT, IN I_number VARCHAR(25))
		$query="CALL `bill-newRows`('" . $array["serials"][$i] . "','" . $array["seller_userID"] . "','" . $array["number"] . "')";
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