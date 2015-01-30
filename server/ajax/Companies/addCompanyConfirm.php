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
	$businessName = $array['businessName'];
	$nit = $array['nit'];
	$email = $array['email'];
	// Important
	$geoID = $array['geoID'];
	// Other Values
	$businessOwner = $array['businessOwner'];
	$address = $array['address'];
	$phone = $array['phone'];
	
	$hoy = date("Y-m-d H:i:s");
	
	$message->setTo(array($email => $businessName));
	$message->setBody(
		'<html>' .
		' <head></head>' .
		' <body>' .
		' <img src="' .
		$message->embed(Swift_Image::fromPath('https://dl.dropboxusercontent.com/u/7734412/Samsung-Logo1.png')) .
		'" alt="SAMSUNG" />' .
		'<h1>Hola amigos de ' . $businessName . '!,</h1>' .
		'<h4><br>Su proveedor de compresores SAMSUNG ha ingresado su empresa a nuestro sistema de premios para vendedores y tecnicos.</h4>' .
		'<h5><br>Recuerde enviarle los datos de sus vendedores al proveedor para las creaciones de sus cuentas. Unicamente las cuentas de tenicos se pueden crear directamente en la pagina web.' .
		'<h4><br>http://www.caycasamsungcompresores.com</h4>' .
		' </body>' .
		'</html>',
		'text/html'
		);

	// Send the message
	$mailerResult = $mailer->send($message);

	$success = (array('Company' => 'Name: '. $businessName, 'EmailSended' => false));
	if ($mailerResult==3)
			$success = (array('Company' => 'Name: '. $businessName, 'EmailSended' => true));
	echo json_encode($success);
}
else
{
	// echo sizeof($array);
	echo $error = json_encode(array('Company' => 'Name: '. $businessName, 'EmailSended' => false));
}
?>