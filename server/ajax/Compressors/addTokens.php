<?php 
require_once '../../secure/db.php'; // The mysql database connection script
header('Access-Control-Allow-Origin: *');  
header("Access-Control-Allow-Headers: Content-Type, Origin, X-Requested-With, Accept");

$data =  (json_decode($HTTP_RAW_POST_DATA));
$array=json_decode($data, true);
echo sizeof($array);
echo sizeof($array["type"]);
echo sizeof($array["token"]);

$success = array('loggedIn' => true, 'success' => 'Fuck yeaH... U did it.');

$hoy = date("Y-m-d H:i:s");

//Lopping
for ($i = 0; $i < sizeof($array["token"]); $i++) {
	// echo "<br> Inserting " . $i . " ";
	$query="INSERT INTO token VALUES ('" . $array["token"][$i] . "','$hoy','" . $array["type"][$i] . "','" . $array["country"] . "')";
	// echo $query;
	$result = $mysqli->query($query) or die($mysqli->error.__LINE__);
	$result = $mysqli->affected_rows;
	// echo $json_response = json_encode($query);		
}
echo $json_response = json_encode($result);	

?>