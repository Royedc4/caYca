<?php 
require_once '../../secure/db.php'; // The mysql database connection script
$hoy = date("Y-m-d H:i:s");

$postdata = file_get_contents("php://input");
$results = array();

if ( ($data =  $postdata)  != NULL )
{
	$array=json_decode($data, true);
	$pToken = $array['pToken'];
	$password = $array['password'];

	$hashed_password = password_hash($password, PASSWORD_BCRYPT);

	$outerQuery="CALL `user-f4changePass`('$hashed_password','$pToken')";
	$result=$mysqli->query($outerQuery) or die($mysqli->error.__LINE__);
	if($result->num_rows >= 0) {
		while($row = $result->fetch_assoc()) {
			$results = $row;
		}
	}
	echo json_encode($results);
	$mysqli->close(); 
}
?>
