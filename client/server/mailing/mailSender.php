<?php 
require_once '../../lib/swift_required.php'; //SwiftMail Library
require_once '../../secure/mailer.php'; // Account details

function sendCompanyConfirmation($companyDataArray) {

	if ( $companyDataArray != NULL )
	{
		// Required Values
		$businessName = $companyDataArray['businessName'];
		$nit = $companyDataArray['nit'];
		$email = $companyDataArray['email'];
		// Important
		$geoID = $companyDataArray['geoID'];
		// Other Values
		$businessOwner = $companyDataArray['businessOwner'];
		$address = $companyDataArray['address'];
		$phone = $companyDataArray['phone'];
		
		// //Este es el error =/
		// $message->setTo(array("$email" => $businessName));
		// $message->setBody(
		// 	'<html>' .
		// 	' <head></head>' .
		// 	' <body>' .
		// 	' <img src="' .
		// 	$message->embed(Swift_Image::fromPath('https://dl.dropboxusercontent.com/u/7734412/Samsung-Logo1.png')) .
		// 	'" alt="SAMSUNG" />' .
		// 	'<h1>Hola amigos de ' . $businessName . '!,</h1>' .
		// 	'<h4><br>Su proveedor de compresores SAMSUNG ha ingresado su empresa a nuestro sistema de premios para vendedores y tecnicos.</h4>' .
		// 	'<h5><br>Recuerde enviarle los datos de sus vendedores al proveedor para las creaciones de sus cuentas. Unicamente las cuentas de tenicos se pueden crear directamente en la pagina web.' .
		// 	'<h4><br>http://www.caycasamsungcompresores.com</h4>' .
		// 	' </body>' .
		// 	'</html>',
		// 	'text/html'
		// 	);

		// // Send the message
		// $mailerResult = $mailer->send($message);
		// echo $mailerResult;
	}
}


?>