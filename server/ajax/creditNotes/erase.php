<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$data = file_get_contents("php://input");
$array=json_decode($data, true);
$hoy = date("Y-m-d H:i:s");

// CALL `bill-delete`('22','Almacenista','Gallium', '2015-07-21 10:28:49', '24508')

$query="CALL `bill-delete`('" . $array["eraser_userID"] . "','" . $array["eraser_fullName"] . "','" . $array["eraser_businessName"] . "','$hoy','" . $array["billNumber"] . "')";

$outerResult= $mysqli->query($query) or die($mysqli->error.__LINE__);

echo $json_response = json_encode($outerResult);	
$mysqli->close(); 

?>