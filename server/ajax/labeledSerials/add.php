<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$data = file_get_contents("php://input");
$array=json_decode($data, true);

// Var's
$hoy = date("Y-m-d H:i:s");
$queriesArray=array();
$errorsArray=array();
$affectedsArray=array();
$resultsArray=array();


$zGlobalResult=true; // our control variable 

for ($i = -1; $i < sizeof($array["token"]); $i++) {
	if ($i==-1){
		$query="START TRANSACTION";
	}
	else{
		$query="CALL `ls-Insert`('". $array["token"][$i] . "','" . $array["serial"][$i] .  "',NULL)";
	}





			// for ($i = 0; $i < sizeof($array["token"]); $i++) {
			// 	// echo "<br> Inserting " . $i . " ";
			// 	$query="CALL `ls-Insert`('". $array["token"][$i] . "','" . $array["serial"][$i] .  "',NULL)";
			// 	// $query="INSERT INTO token VALUES ('" . $array["token"][$i] . "','$hoy','" . $array["type"][$i] . "','" . $array["country"] . "')";
			// 	// echo $query;

	array_push($queriesArray, $query);
	array_push($errorsArray, $mysqli->error.__LINE__);
	array_push($affectedsArray, $mysqli->affected_rows);
	array_push($resultsArray, $mysqli->query($query) ? false : $zGlobalResult=false);
	// array_push($resultsArray, $mysqli->query($query) or die($mysqli->error.__LINE__));
	
	// $result = $mysqli->query($query) or die($mysqli->error.__LINE__);
	// $result = $mysqli->affected_rows;
	// $error 	= $mysqli->error.__LINE__;

	// echo $json_response = json_encode($query);		
}

$resultObj = (object) array('arrayQueries' => $queriesArray, 'affectedsArray' => $affectedsArray, 'errorsArray' => $errorsArray, 'zGlobalResult' => $zGlobalResult, 'hoy' => $hoy);


// $resultObj = (object) array('result' => $result,'query' => $query, 'error' => $error, 'hoy' => $hoy);
echo $json_response = json_encode($resultObj);	

?>