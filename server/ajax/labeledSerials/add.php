<?php 
require_once '../../secure/db.php'; // The mysql database connection script

$data =  ((file_get_contents("php://input")));
$array=json_decode($data, true);

for ($i = 0; $i < sizeof($array["token"]); $i++) {
	// echo "<br> Inserting " . $i . " ";
	$query="CALL `ls-Insert`('". $array["token"][$i] . "','" . $array["serial"][$i] .  "',NULL)";
	// $query="INSERT INTO token VALUES ('" . $array["token"][$i] . "','$hoy','" . $array["type"][$i] . "','" . $array["country"] . "')";
	// echo $query;
	$result = $mysqli->query($query) or die($mysqli->error.__LINE__);
	$result = $mysqli->affected_rows;
	// echo $json_response = json_encode($query);		
}
echo $json_response = json_encode($result);	

?>