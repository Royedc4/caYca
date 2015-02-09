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
	
	$email = $array['email'];
	$password = $array['password'];
	$rightNow = date("Y-m-d H:i:s");

	// Select Stored Password of user
	$outerQuery="SELECT password FROM user WHERE email='$email'";
	$outerResult=$mysqli->query($outerQuery) or die($mysqli->error.__LINE__);

	// Defining Some shit arround
	$arr = array();
	$response = array();
	// $success = array('loggedIn' => true, 'success' => 'Fuck yeaH You are logged in.');
	$error = array('loggedIn' => false, 'error' => 'Error: email or password are incorrect.');


	if($outerResult->num_rows == 1) {
		while($row = $outerResult->fetch_assoc()) {
			$hashedStoredPassword = $row["password"];
		}}
		$is_match = password_verify($password, $hashedStoredPassword);
		if ($is_match){
			$successQuery="UPDATE user SET lastLogOn='$rightNow' WHERE email='$email'";
			$successResult=$mysqli->query($successQuery) or die($mysqli->error.__LINE__);
			$innerQuery="SELECT u.ID, u.email, u.passWord, u.fullName, u.address, u.celphone, u.phone, u.userTypeID, u.city_geoID, u.companyID, u.lastLogOn, u.userCreation, u.isActive, c.country FROM user u JOIN city c ON (c.geoID=u.city_geoID) where u.email='$email' and u.password COLLATE utf8_bin = '$hashedStoredPassword'";
			// should wait couple of seconds 4 security...
			$innerResult = $mysqli->query($innerQuery) or die($mysqli->error.__LINE__);
			while($row = $innerResult->fetch_assoc()) {
				// $success=$row;
				// $arr[] = $row;	
				$success = array('loggedIn' => true, $row);

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