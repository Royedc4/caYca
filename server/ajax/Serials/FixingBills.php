<?php 
require_once '../../secure/db.php'; // The mysql database connection script
$hoy = date("Y-m-d H:i:s");

// GETTING serials

// 4billRow 	serial, seller_userID, number
// INSERT INTO `billrow`(`serial`,`seller_userID`,`number`)VALUES();

// 4bill 		seller_userID, number, buyer_companyID, date, description
// INSERT INTO `bill`(`seller_userID`,`number`,`buyer_companyID`,`date`,`description`) VALUES (1,1,20,'$hoy','SAMSUNG --> Gallium De Colombia');


$outerQuery="SELECT serial,companyID,compressorID FROM serial WHERE companyID='20' LIMIT 25";

$outerResult=$mysqli->query($outerQuery) or die($mysqli->error.__LINE__);

$arr = array();

$row_cnt = $outerResult->num_rows;

printf("Result set has %d rows.\n", $row_cnt);

if($outerResult->num_rows > 0) {
	while($row = $outerResult->fetch_assoc()) {
		$arr[] = $row;
		printf ("\n%s (%s)", $row["serial"], $row["compressorID"]);
	}
}

// $zGlobalResult=true; // our control variable 

// for ($i = -2; $i < sizeof($array["serials"]); $i++) {
// 	if ($i==-2){
// 		$query="START TRANSACTION";
// 	}
// 	if ($i==-1){
// 		// CREATE PROCEDURE `bill-new` (IN I_seller_userID INT, IN I_buyer_companyID INT, IN I_date DATE, IN I_number VARCHAR(25), IN I_description VARCHAR(100))
// 		$query="CALL `bill-new`('" . $array["seller_userID"] . "','" . $array["number"] . "','" . $array["buyer_companyID"] . "','$hoy','" . $array["description"] . "')";
// 	}
// 	if($i>=0){
// 		// CREATE PROCEDURE `bill-newRows` (IN I_serial VARCHAR(25), IN I_seller_userID INT, IN I_number VARCHAR(25))
// 		$query="CALL `bill-newRows`('" . $array["serials"][$i] . "','" . $array["seller_userID"] . "','" . $array["number"] . "')";
// 	}
// 	$mysqli->query($query) ? false : $zGlobalResult=false;
// 	array_push($queriesArray, $query);
// 	array_push($errorsArray, $mysqli->error.__LINE__);
// 	array_push($affectedsArray, $mysqli->affected_rows);
// }

// $resultObj = (object) array('arrayQueries' => $queriesArray, 'affectedsArray' => $affectedsArray, 'errorsArray' => $errorsArray, 'zGlobalResult' => $zGlobalResult, 'hoy' => $hoy);
// $zGlobalResult ? $mysqli->commit() : $mysqli->rollback(); 
// echo $json_response = json_encode($resultObj);	


# JSON-encode the response
// echo $json_response = json_encode($arr);
?>
