<?php 
require_once '../../secure/db.php'; // The mysql database connection script
$data =  file_get_contents("php://input");
$hoy = date("Y-m-d H:i:s");

$array=json_decode($data, true);

$query="CALL `redeems-newStatus`('" . $array['redemptionID'] . "','" . $array['newStatusID'] . "')";

$result=$mysqli->query($query) or die($mysqli->error.__LINE__);

$queries=$query;
$errors=$mysqli->error.__LINE__;
$affectedRows=$mysqli->affected_rows;


$resultObj = (object) array('arrayQueries' => $queries, 'affectedRows' => $affectedRows, 'errors' => $errors, 'hoy' => $hoy, 'result' => $result);
echo $json_response = json_encode($resultObj);	
$mysqli->close(); 

?>