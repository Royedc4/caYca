<?php 
require_once '../../secure/db.php'; // The mysql database connection script

header('Access-Control-Allow-Origin: *');  
header("Access-Control-Allow-Headers: Content-Type, Origin, X-Requested-With, Accept");

$data =  (json_decode($HTTP_RAW_POST_DATA));
$array=json_decode($data, true);

if ( $data != NULL )
{
	// Required Values
	$ID = $array['ID'];
	$email = $array['email'];
	$password = $array['password'];
	$fullName = $array['fullName'];
	$userTypeID = $array['userTypeID'];
	// Important
	$geoID = $array['geoID'];
	$companyID = $array['companyID'];
	// Other Values
	$address = $array['address'];
	$phone = $array['phone'];
	$celphone = $array['celphone'];

	$lastLogOn = 'NULL';

	// Hashing Password
	$hashed_password = password_hash($password, PASSWORD_BCRYPT);
	
	$hoy = date("Y-m-d H:i:s");

	$query="INSERT INTO user VALUES (NULL, '$userTypeID','$ID', '$email', '$hashed_password', '$fullName',  '$geoID', NULL, '$address', '$celphone', '$phone', NULL, '$hoy', DEFAULT, NULL, NULL)";

	$result = $mysqli->query($query) or die($mysqli->error.__LINE__);
	$result = $mysqli->affected_rows;

	if ($result==1)
	{
		$success = (array('AddUser' => true, 'AddUserInfo' => 'Roy says: '. $email .' Inserted Successfully.'));
		echo json_encode($success);
	}
	else
		echo $json_response = json_encode($result);
}
else
{
	echo sizeof($array);
	echo $error = json_encode(array('AddUser' => false, 'error' => 'Roy says error: Missing Parameters.'));
}
?>