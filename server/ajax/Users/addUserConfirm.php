<?php 
require_once '../../lib/swift_required.php'; //SwiftMail Library
require_once '../../secure/mailer.php'; // Account details

$data =  file_get_contents("php://input");
$array=json_decode($data, true);

if ( $data != NULL )
{
	// Required Values
	$email = $array['email'];
	$password = $array['password'];
	$fullName = $array['fullName'];

	// Create a message
	$message = Swift_Message::newInstance('cayca SAMSUNG compresores :: Nueva Cuenta')
	->setFrom(array('tecnologia@caycaSAMSUNGcompresores.com' => 'cayca SAMSUNG compresores'))
	->setBcc('tecnologia@caycaSAMSUNGcompresores.com');

	$message->setTo(array($email => $fullName));
	$message->setBody(
		'<html>' .
		'<head> ' .
		'<!-- NAME: 1 COLUMN --> ' .
		'<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> ' .
		'<meta name="viewport" content="width=device-width, initial-scale=1.0"> ' .
		'<style>' .
		' @media only screen and (max-width: 480px){        td[id=bodyCell]{            padding:10px !important;        }}   @media only screen and (max-width: 480px){        table[class=mcnTextContentContainer]{            width:100% !important;        }}   @media only screen and (max-width: 480px){        table[class=mcnBoxedTextContentContainer]{            width:100% !important;        }}   @media only screen and (max-width: 480px){        table[class=mcpreview-image-uploader]{            width:100% !important;            display:none !important;        }}   @media only screen and (max-width: 480px){        img[class=mcnImage]{            width:100% !important;        }}   @media only screen and (max-width: 480px){        table[class=mcnImageGroupContentContainer]{            width:100% !important;        }}   @media only screen and (max-width: 480px){        td[class=mcnImageGroupContent]{            padding:9px !important;        }}   @media only screen and (max-width: 480px){        td[class=mcnImageGroupBlockInner]{            padding-bottom:0 !important;            padding-top:0 !important;        }}   @media only screen and (max-width: 480px){        tbody[class=mcnImageGroupBlockOuter]{            padding-bottom:9px !important;            padding-top:9px !important;        }}   @media only screen and (max-width: 480px){        table[class=mcnCaptionTopContent],table[class=mcnCaptionBottomContent]{            width:100% !important;        }}   @media only screen and (max-width: 480px){        table[class=mcnCaptionLeftTextContentContainer],table[class=mcnCaptionRightTextContentContainer],table[class=mcnCaptionLeftImageContentContainer],table[class=mcnCaptionRightImageContentContainer],table[class=mcnImageCardLeftTextContentContainer],table[class=mcnImageCardRightTextContentContainer]{            width:100% !important;        }}   @media only screen and (max-width: 480px){        td[class=mcnImageCardLeftImageContent],td[class=mcnImageCardRightImageContent]{            padding-right:18px !important;            padding-left:18px !important;            padding-bottom:0 !important;        }}   @media only screen and (max-width: 480px){        td[class=mcnImageCardBottomImageContent]{            padding-bottom:9px !important;        }}   @media only screen and (max-width: 480px){        td[class=mcnImageCardTopImageContent]{            padding-top:18px !important;        }}   @media only screen and (max-width: 480px){        td[class=mcnImageCardLeftImageContent],td[class=mcnImageCardRightImageContent]{            padding-right:18px !important;            padding-left:18px !important;            padding-bottom:0 !important;        }}   @media only screen and (max-width: 480px){        td[class=mcnImageCardBottomImageContent]{            padding-bottom:9px !important;        }}   @media only screen and (max-width: 480px){        td[class=mcnImageCardTopImageContent]{            padding-top:18px !important;        }}   @media only screen and (max-width: 480px){        table[class=mcnCaptionLeftContentOuter] td[class=mcnTextContent],table[class=mcnCaptionRightContentOuter] td[class=mcnTextContent]{            padding-top:9px !important;        }}   @media only screen and (max-width: 480px){        td[class=mcnCaptionBlockInner] table[class=mcnCaptionTopContent]:last-child td[class=mcnTextContent]{            padding-top:18px !important;        }}   @media only screen and (max-width: 480px){        td[class=mcnBoxedTextContentColumn]{            padding-left:18px !important;            padding-right:18px !important;        }}   @media only screen and (max-width: 480px){        td[class=mcnTextContent]{            padding-right:18px !important;            padding-left:18px !important;        }}   @media only screen and (max-width: 480px){    /*    @tab Mobile Styles    @section template width    @tip Make the template fluid for portrait or landscape view adaptability. If a fluid layout doesnt work for you, set the width to 300px instead.    */        table[id=templateContainer],table[id=templatePreheader],table[id=templateHeader],table[id=templateBody],table[id=templateFooter]{            /*@tab Mobile Styles@section template width@tip Make the template fluid for portrait or landscape view adaptability. If a fluid layout doesnt work for you, set the width to 300px instead.*/max-width:600px !important;            /*@editable*/width:100% !important;        }}   @media only screen and (max-width: 480px){    /*    @tab Mobile Styles    @section heading 1    @tip Make the first-level headings larger in size for better readability on small screens.    */        h1{            /*@editable*/font-size:24px !important;            /*@editable*/line-height:125% !important;        }} ' .
		'</style> ' .
		'</head> ' .
		'<center>' .
		'<table align="center" border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" id="bodyTable" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;margin: 0;padding: 0;background-color: #eeeeee;height: 100% !important;width: 100% !important;">' .
		'<tr>' .
		'<td align="center" valign="top" id="bodyCell" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;margin: 0;padding: 20px;border-top: 0;height: 100% !important;width: 100% !important;">' .
		'<!-- BEGIN TEMPLATE // -->' .
		'<table border="0" cellpadding="0" cellspacing="0" width="600" id="templateContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;border: 0;">' .
		'<tr>' .
		'<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<!-- BEGIN PREHEADER // -->' .
		'<table border="0" cellpadding="0" cellspacing="0" width="600" id="templatePreheader" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #eeeeee;border-top: 0;border-bottom: 0;">' .
		'<tr>' .
		'<td valign="top" class="preheaderContainer" style="padding-top: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnTextBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody class="mcnTextBlockOuter">' .
		'<tr>' .
		'<td valign="top" class="mcnTextBlockInner" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><table align="left" border="0" cellpadding="0" cellspacing="0" width="600" class="mcnTextContentContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody><tr><td valign="top" class="mcnTextContent" style="padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 11px;line-height: 125%;text-align: left;"></td>' .
		'</tr>' .
		'</tbody></table></td>' .
		'</tr>' .
		'</tbody>' .
		'</table></td>' .
		'</tr>' .
		'</table>' .
		'<!-- // END PREHEADER -->' .
		'</td>' .
		'</tr>' .
		'<tr>' .
		'<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<!-- BEGIN HEADER // -->' .
		'<table border="0" cellpadding="0" cellspacing="0" width="600" id="templateHeader" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;border-top: 0;border-bottom: 0;">' .
		'<tr>' .
		'<td valign="top" class="headerContainer" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnImageBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody class="mcnImageBlockOuter">' .
		'<tr>' .
		'<td valign="top" style="padding: 0px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" class="mcnImageBlockInner">' .
		'<table align="left" width="100%" border="0" cellpadding="0" cellspacing="0" class="mcnImageContentContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody><tr>' .
		'<td class="mcnImageContent" valign="top" style="padding-right: 0px;padding-left: 0px;padding-top: 0;padding-bottom: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><img align="left" alt="" src="https://gallery.mailchimp.com/14b571d9471af0eafb7ef8f99/images/c063300e-62f0-4575-a4a0-de97948e82d7.jpg" width="600" style="max-width: 800px;padding-bottom: 0;display: inline !important;vertical-align: bottom;border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;" class="mcnImage"></td>' .
		'</tr>' .
		'</tbody></table>' .
		'</td>' .
		'</tr>' .
		'</tbody>' .
		'</table></td>' .
		'</tr>' .
		'</table>' .
		'<!-- // END HEADER -->' .
		'</td>' .
		'</tr>' .
		'<tr>' .
		'<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<!-- BEGIN BODY // -->' .
		'<table border="0" cellpadding="0" cellspacing="0" width="600" id="templateBody" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;border-top: 0;border-bottom: 0;">' .
		'<tr>' .
		'<td valign="top" class="bodyContainer" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnTextBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody class="mcnTextBlockOuter">' .
		'<tr>' .
		'<td valign="top" class="mcnTextBlockInner" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><table align="left" border="0" cellpadding="0" cellspacing="0" width="600" class="mcnTextContentContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody><tr><td valign="top" class="mcnTextContent" style="padding: 9px 18px;color: #FFFFFF;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;font-family: Helvetica;font-size: 15px;line-height: 150%;text-align: left;"><p class="p1" style="margin: 1em 0px;padding: 0px;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 22.5px;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;text-align: left;"><span style="font-size:14px"><span class="s1">Estimado ' . $fullName .  ' ,&nbsp;</span></span></p><p class="p1" style="margin: 1em 0;padding: 0;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 150%;text-align: left;"><span style="font-size:14px"><span class="s1">Bienvenido al <strong>Sistema de Rifas y Premios de Cayca SAMSUNG Compresores.</strong>&nbsp;</span></span></p><p class="p2" style="margin: 1em 0;padding: 0;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 150%;text-align: left;"><br>' .
		'<span style="font-size:14px"><span style="line-height:1.6em">Los datos de su cuenta son:<br>' .
		'Usuario: ' . $email . '<br>' .
		'Contraseña: ' . $password . '</span></span><br>' .
		'<br>' .
		'<span style="font-size:14px; line-height:1.6em">Dispone de 72 horas para activar esta cuenta, en caso contrario debe registrarse nuevamente. Para ello, simplemente acceda a nuestra página e inicie sesión: &nbsp;</span><span style="font-size:14px; line-height:1.6em"><a href="http://www.caycaSAMSUNGcompresores.com" target="_blank" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #91d1e0;font-weight: normal;text-decoration: underline;">www.caycaSAMSUNGcompresores.com</a></span></p><p class="p1" style="margin: 1em 0px;padding: 0px;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 22.5px;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;text-align: left;"><span style="font-size:14px">Le deseamos un feliz día,</span></p><p class="p3" style="margin: 1em 0px;padding: 0px;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 22.5px;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;text-align: left;"><span style="font-size:14px">Cordialmente,&nbsp;<br>' .
		'Cayca Samsung Compresores</span></p></td>' .
		'</tr>' .
		'</tbody></table></td>' .
		'</tr>' .
		'</tbody>' .
		'</table><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnFollowBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody class="mcnFollowBlockOuter">' .
		'<tr><div style="text-align:center;"><class="p1" style="margin:0px;padding:1em;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 22.5px;text-align:center;"><span style="font-size:13.5px;font-weight:bold"><span style="font-family:arial,helvetica neue,helvetica,sans-serif">Para mayor información, contáctanos por:</span></span></class="p1"></div><td align="center" valign="top" style="padding: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;" class="mcnFollowBlockInner">' .
		'<table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnFollowContentContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody><tr>' .
		'<td align="center" style="padding-left: 9px;padding-right: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnFollowContent" style="border: 1px solid #EEEEEE;background-color: #EEEEEE;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody><tr>' .
		'<td align="center" valign="top" style="padding-top: 9px;padding-right: 9px;padding-left: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody><tr>' .
		'<td valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><table align="left" border="0" cellpadding="0" cellspacing="0" class="mcnFollowStacked" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><tbody><tr>' .
		'<td align="center" valign="top" class="mcnFollowIconContent" style="padding-right: 10px;padding-bottom: 5px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<a href="http://facebook.com/caycaSAMSUNGcompresores-480268078793019" target="_blank" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><img src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-facebook-96.png" alt="Facebook" class="mcnFollowBlockIcon" width="48" style="width: 48px;max-width: 48px;display: block;border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;"></a>' .
		'</td>' .
		'</tr><tr>' .
		'<td align="center" valign="top" class="mcnFollowTextContent" style="padding-right: 10px;padding-bottom: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<a href="http://www.caycaSAMSUNGcompresores.com" target="_blank" style="color: #606060;font-family: Arial;font-size: 11px;font-weight: normal;line-height: 100%;text-align: center;text-decoration: none;word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">Facebook</a>' .
		'</td>' .
		'</tr></tbody></table><!--[if gte mso 6]>' .
		'</td>' .
		'<td align="left" valign="top">' .
		'<![endif]--><table align="left" border="0" cellpadding="0" cellspacing="0" class="mcnFollowStacked" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><tbody><tr>' .
		'<td align="center" valign="top" class="mcnFollowIconContent" style="padding-right: 10px;padding-bottom: 5px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<a href="http://www.caycasamsungcompresores.com" target="_blank" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><img src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-link-96.png" alt="Página Web" class="mcnFollowBlockIcon" width="48" style="width: 48px;max-width: 48px;display: block;border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;"></a>' .
		'</td>' .
		'</tr><tr>' .
		'<td align="center" valign="top" class="mcnFollowTextContent" style="padding-right: 10px;padding-bottom: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<a href="http://www.caycasamsungcompresores.com" target="_blank" style="color: #606060;font-family: Arial;font-size: 11px;font-weight: normal;line-height: 100%;text-align: center;text-decoration: none;word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">Página Web</a>' .
		'</td>' .
		'</tr></tbody></table><!--[if gte mso 6]>' .
		'</td>' .
		'<td align="left" valign="top">' .
		'<![endif]--><table align="left" border="0" cellpadding="0" cellspacing="0" class="mcnFollowStacked" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><tbody><tr>' .
		'<td align="center" valign="top" class="mcnFollowIconContent" style="padding-right: 10px;padding-bottom: 5px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<a href="mailto:contacto@caycasamsungcompresores.com" target="_blank" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><img src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-forwardtofriend-96.png" alt="Email" class="mcnFollowBlockIcon" width="48" style="width: 48px;max-width: 48px;display: block;border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;"></a>' .
		'</td>' .
		'</tr><tr>' .
		'<td align="center" valign="top" class="mcnFollowTextContent" style="padding-right: 10px;padding-bottom: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<a href="mailto:contacto@caycasamsungcompresores.com" target="_blank" style="color: #606060;font-family: Arial;font-size: 11px;font-weight: normal;line-height: 100%;text-align: center;text-decoration: none;word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">Email</a>' .
		'</td>' .
		'</tr></tbody></table><!--[if gte mso 6]>' .
		'</td>' .
		'<td align="left" valign="top">' .
		'<![endif]--><table align="left" border="0" cellpadding="0" cellspacing="0" class="mcnFollowStacked" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><tbody><tr>' .
		'<td align="center" valign="top" class="mcnFollowIconContent" style="padding-right: 0;padding-bottom: 5px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<a href="http://google.com/+Caycasamsungcompresores" target="_blank" style="word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><img src="http://cdn-images.mailchimp.com/icons/social-block-v2/color-googleplus-96.png" alt="Google Plus" class="mcnFollowBlockIcon" width="48" style="width: 48px;max-width: 48px;display: block;border: 0;outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;"></a>' .
		'</td>' .
		'</tr><tr>' .
		'<td align="center" valign="top" class="mcnFollowTextContent" style="padding-right: 0;padding-bottom: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<a href="http://www.caycasamsungcompresores.com" target="_blank" style="color: #606060;font-family: Arial;font-size: 11px;font-weight: normal;line-height: 100%;text-align: center;text-decoration: none;word-wrap: break-word;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">Google Plus</a>' .
		'</td>' .
		'</tr></tbody></table><!--[if gte mso 6]>' .
		'</td>' .
		'<td align="left" valign="top">' .
		'<![endif]--></td>' .
		'</tr>' .
		'</tbody></table>' .
		'</td>' .
		'</tr>' .
		'</tbody></table>' .
		'</td>' .
		'</tr>' .
		'</tbody></table></td>' .
		'</tr>' .
		'</tbody>' .
		'</table></td>' .
		'</tr>' .
		'</table>' .
		'<!-- // END BODY -->' .
		'</td>' .
		'</tr>' .
		'<tr>' .
		'<td align="center" valign="top" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<!-- BEGIN FOOTER // -->' .
		'<table border="0" cellpadding="0" cellspacing="0" width="600" id="templateFooter" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;background-color: #FFFFFF;border-top: 0;border-bottom: 0;">' .
		'<tr>' .
		'<td valign="top" class="footerContainer" style="padding-bottom: 9px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><table border="0" cellpadding="0" cellspacing="0" width="100%" class="mcnTextBlock" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody class="mcnTextBlockOuter">' .
		'<tr>' .
		'<td valign="top" class="mcnTextBlockInner" style="mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;"><table align="left" border="0" cellpadding="0" cellspacing="0" width="600" class="mcnTextContentContainer" style="border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">' .
		'<tbody><tr><td valign="top" class="mcnTextContent" style="padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;mso-table-lspace: 0pt;mso-table-rspace: 0pt;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;color: #606060;font-family: Helvetica;font-size: 11px;line-height: 125%;text-align: left;"><div style="text-align: center;">Copyright © &nbsp;2015.&nbsp;Cayca Samsung&nbsp;Compresores.&nbsp;<br>' .
		'Todos los derechos reservados.</div><div style="text-align: center;">&nbsp;</div></td>' .
		'</tr>' .
		'</tbody></table></td>' .
		'</tr>' .
		'</tbody>' .
		'</table></td>' .
		'</tr>' .
		'</table>' .
		'<!-- // END FOOTER -->' .
		'</td>' .
		'</tr>' .
		'</table>' .
		'<!-- // END TEMPLATE -->' .
		'</td>' .
		'</tr>' .
		'</table>' .
		'</center>' .		
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