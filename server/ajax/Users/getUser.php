<?php 
require_once '../../secure/db.php'; // The mysql database connection script
header('Access-Control-Allow-Origin: *');  
header("Access-Control-Allow-Headers: Content-Type, Origin, X-Requested-With, Accept");


// Cochino style
// if(isset($_GET['email']) && isset($_GET['password'])){
// 	$email = $_GET['email'];
// 	$password = $_GET['password'];
// }

if (  ($data =  (json_decode($HTTP_RAW_POST_DATA)) ) != NULL )
{
	$array=json_decode($data, true);
	// echo ($array['password']);
	
	$email = $array['email'];
	$password = $array['password'];

// Select Stored Password of user
$outerQuery="SELECT password FROM user WHERE email='$email'";
$outerResult=$mysqli->query($outerQuery) or die($mysqli->error.__LINE__);

// $hashed_password = password_hash($password, PASSWORD_BCRYPT);
// Defining Some shit arround
$arr = array();
$response = array();
$success = array('loggedIn' => true, 'success' => 'Fuck yeaH You are logged in.');
$error = array('loggedIn' => false, 'error' => 'Error: email or password are incorrect.');


if($outerResult->num_rows == 1) {
	while($row = $outerResult->fetch_assoc()) {
		$hashedStoredPassword = $row["password"];
		// echo "Stored: " . $hashedStoredPassword;	
	}}
	$is_match = password_verify($password, $hashedStoredPassword);
	if ($is_match){
		$innerQuery="SELECT email,passWord,fullName,address,celphone,phone,position,userTypeID,cityID,companyID,lastLogOn,userCreation,isActive FROM user where email='$email' and password COLLATE utf8_bin = '$hashedStoredPassword'";
		// should wait couple of seconds 
		$innerResult = $mysqli->query($innerQuery) or die($mysqli->error.__LINE__);
		while($row = $innerResult->fetch_assoc()) {
			$arr[] = $row;	
		}
		$response[]=$success;
		// echo "Login: " . ($is_match ? 'correct' : 'wrong');
	}
	else{
		$response[]=$error;
	}
	# JSON-encode the response
	echo $json_response = json_encode($response);
}
else
{
	
}

	?>