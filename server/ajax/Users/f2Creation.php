<?php 
require_once '../../secure/db.php'; // The mysql database connection script
$postdata = file_get_contents("php://input");
$results = array();
if ( ($data =  $postdata)  != NULL )
{
	$array=json_decode($data, true);
	$email = $array['email'];
	$pToken = $array['pToken'];

	$outerQuery="CALL `user-f2Creation`('$pToken', '$email')";
	$result=$mysqli->query($outerQuery) or die($mysqli->error.__LINE__);
	if($result->num_rows > 0) {
		while($row = $result->fetch_assoc()) {
			$results = $row;
		}
	}
	echo json_encode($results);
	$mysqli->close(); 
}
?>
