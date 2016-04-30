<?php 
// header('Access-Control-Allow-Origin: *');  
// header("Access-Control-Allow-Headers: Content-Type, Origin, X-Requested-With, Accept");

// Create the Transport
	$transport = Swift_SmtpTransport::newInstance('mail.caycasamsungcompresores.com', 25)
	->setUsername('tecnologia@caycaSAMSUNGcompresores.com')
	->setPassword('nwzXNgQgf7q6rHWo')
	;

/*
You could alternatively use a different transport such as Sendmail or Mail:

// Sendmail
$transport = Swift_SendmailTransport::newInstance('/usr/sbin/sendmail -bs');

// Mail
$transport = Swift_MailTransport::newInstance();
*/

// Create the Mailer using your created Transport

$mailer = Swift_Mailer::newInstance($transport);

// Create a message
// $message = Swift_Message::newInstance('cayca SAMSUNG compresores :: Nueva Cuenta')
// ->setFrom(array('tecnologia@caycaSAMSUNGcompresores.com' => 'cayca SAMSUNG compresores'))
// ->setBcc('tecnologia@caycaSAMSUNGcompresores.com');

?>