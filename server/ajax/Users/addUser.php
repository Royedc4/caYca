<?php 
require_once '../../secure/db.php'; // The mysql database connection script
require_once '../../lib/swift_required.php'; //SwiftMail Library
require_once '../../secure/mailer.php'; // Account details
header('Access-Control-Allow-Origin: *');  
header("Access-Control-Allow-Headers: Content-Type, Origin, X-Requested-With, Accept");

// Haciendolo cochinito por GET
// if(isset($_GET['email']) && isset($_GET['password']) && isset($_GET['fullName']) && isset($_GET['userTypeID']) ){
	// // Required Values
	// $email = $_GET['email'];
	// $password = $_GET['password'];
	// $fullName = $_GET['fullName'];
	// $userTypeID = $_GET['userTypeID'];

$data =  (json_decode($HTTP_RAW_POST_DATA));
$array=json_decode($data, true);

if ( $data != NULL )
{
	// echo ($array['password']);


	// Required Values
	$email = $array['email'];
	$password = $array['password'];
	$fullName = $array['fullName'];
	$userTypeID = $array['userTypeID'];
	// Important
	$geoID = $array['geoID'];
	$companyID = $array['companyID'];
	// $companyID ='NULL';
	// if(isset($array['companyID']))
	// 	$companyID = $array['companyID'];
	// Other Values
	$address ='NULL';
	$celphone ='NULL';
	$phone ='NULL';
	$lastLogOn = 'NULL';
	//Getting
	if(isset($_GET['address']))
		$address = $_GET['address'];
	if(isset($_GET['celphone']))
		$celphone = $_GET['celphone'];
	if(isset($_GET['phone']))
		$phone = $_GET['phone'];
	
	// Hashing Password
	$hashed_password = password_hash($password, PASSWORD_BCRYPT);
	// echo "Hashed Pass: " . $hashed_password;
	// echo "<br />";
									// (<{userID: }>,<{userTypeID: }>,<{email: }>,<{passWord: }>,<{fullName: }>,<{city_geoID: }>,<{companyID: }>,<{address: }>,<{celphone: }>,<{phone: }>,<{lastLogOn: }>,<{userCreation: }>,<{isActive: 1}>,<{addi1: }>,<{addi2: }>);

	$hoy = date("Y-m-d H:i:s");
	// echo $json_response = ('Time: ' . $hoy . "<br />");
	$query="INSERT INTO user VALUES (NULL, '$userTypeID','$email', '$hashed_password', '$fullName',  '$geoID', NULL, '$address', '$celphone', '$phone', NULL, '$hoy', DEFAULT, NULL, NULL)";
	// $query="INSERT INTO user VALUES (NULL, '$userTypeID','$email', '$hashed_password', '$fullName',  '$geoID', '$companyID', '$address', '$celphone', '$phone', NULL, '$hoy', DEFAULT, NULL, NULL)";
	// $query="INSERT INTO user  VALUES (NULL, '$email', '$hashed_password', '$fullName', '$address', '$celphone', '$phone', '$position', '$userTypeID',". $geoID .", ". $companyID .", NULL, '$hoy', DEFAULT, NULL, NULL)";
	$result = $mysqli->query($query) or die($mysqli->error.__LINE__);
	$result = $mysqli->affected_rows;
	// echo $json_response = json_encode($query);
	if ($result==1)
	{
		$message->setTo(array($email => $fullName));
		$message->setBody(
			'<html>' .
			' <head></head>' .
			' <body>' .
			' <img src="' .
			$message->embed(Swift_Image::fromPath('https://dl.dropboxusercontent.com/u/7734412/Samsung-Logo1.png')) .
			'" alt="SAMSUNG" />' .
			'<h1>Hola ' . $fullName . '!,</h1>' .
			'<h4><br>Bienvenido al sistema de garantias de compresores SAMSUNG caYca.</h4>' .
			'<h5><br>Los datos de tu cuenta son:' .
			'<br><br>Correo Electronico: ' . $email . 
			'<br>Contraseña: ' . $password . 
			'<br><br>Haciendo clic en el siguiente enlace podras acceder a tu cuenta... </h5>' .
			'<br>http://www.samsungcayca.com' .
			' </body>' .
			'</html>',
			'text/html'
			);

		// Send the message
		$mailerResult = $mailer->send($message);
		// echo json_encode($mailerResult);
		$success = (array('AddUser' => true, 'AddUserInfo' => 'Roy says: '. $email .' Inserted Successfully.', 'EmailSend' => false, 'EmailSendInfo' => 'Roy says: Email Not Sended.', 'Mensaje' => $message));
		if ($mailerResult==3)
			$success = (array('AddUser' => true, 'AddUserInfo' => 'Roy says: '. $email .' Inserted Successfully.', 'EmailSend' => true, 'EmailSendInfo' => 'Roy says: Email Send Successfully.', 'Mensaje' => $message));
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