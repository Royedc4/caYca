<?php 
require_once '../../lib/swift_required.php'; //SwiftMail Library
require_once '../../secure/mailer.php'; // Account details

header('Access-Control-Allow-Origin: *');  
header("Access-Control-Allow-Headers: Content-Type, Origin, X-Requested-With, Accept");

$data =  (json_decode($HTTP_RAW_POST_DATA));
$array=json_decode($data, true);

if ( $data != NULL )
{
	// Required Values
	$email = $array['email'];
	$password = $array['password'];
	$fullName = $array['fullName'];

	$message->setTo(array($email => $fullName));
	$message->setBody(
		'<html>' .
		' <head></head>' .
		' <body>' .
		' <img src="' .
		$message->embed(Swift_Image::fromPath('https://dl.dropboxusercontent.com/u/7734412/Samsung-Logo1.png')) .
		'" alt="SAMSUNG" />' .
		'<h1>Hola ' . $fullName . '!,</h1>' .
		'<h4><br>Bienvenido al sistema de RIFAS y CANJEOS de compresores SAMSUNG.</h4>' .
		'<h5><br>Los datos de tu cuenta son:' .
		'<br><br>Correo Electronico: ' . $email . 
		'<br>Contraseña: ' . $password . 
		'<br><br>Haciendo clic en el siguiente enlace podras acceder a tu cuenta... </h5>' .
		'<br>http://www.caYcaSAMSUNGcompresores.com' .
		' </body>' .
		'</html>',
		'text/html'
		);

	// Send the message
	$mailerResult = $mailer->send($message);

	$success = (array('1AddUserInfo' => 'Roy says: '. $email .' Inserted Successfully.', 'EmailSendInfo' => 'Roy says: Email Not Sended.' ));
	if ($mailerResult==3)
		$success = (array('1AddUserInfo' => 'Roy says: '. $email .' Inserted Successfully.', 'EmailSendInfo' => 'Roy says: Email Send Successfully.' ));
	echo json_encode($success);	
}
else
{
	echo $error = json_encode(array('error' => 'Roy says error: Missing Parameters.'));
}
?>