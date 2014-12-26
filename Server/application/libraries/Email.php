<?php
require 'PHPMailerAutoload.php';

class Email{
	
	private $CI;
	
	public function __construct()
	{
		$this->CI =& get_instance();
	}

	public function sendReset($email)
	{
		$mail = new PHPMailer;
		
		$mail->SMTPDebug = 3;                               // Enable verbose debug output
		
		$mail->isSMTP();                                      // Set mailer to use SMTP
		$mail->CharSet='UFT-8';
		$mail->Host = 'smtp.yeah.net';  // Specify main and backup SMTP servers
		$mail->SMTPAuth = true;                               // Enable SMTP authentication
		$mail->Username = 'hustpter';                 // SMTP username
		$mail->Password = 'test.123';                           // SMTP password
		$mail->SMTPSecure = 'ssl';                            // Enable TLS encryption, `ssl` also accepted
		//$mail->Port = 587;                                    // TCP port to connect to
		$mail->Port = 465;
		
		$mail->From = 'hustpter@yeah.net';
		$mail->FromName = 'Mailer';
		$mail->addAddress($email, $email);     // Add a recipient
		
		
		$url="www.speakaloud.org/beerich/index.php/login/resetPassword";
		
		// 	$mail->addAttachment('/tmp/image.jpg', 'new.jpg');    // Optional name
		$mail->isHTML(true);                                  // Set email format to HTML
		
		$mail->Subject = 'Password Reset';
		$mail->Body    = '点击下面的url重制密码:\n'.$url;
		$mail->AltBody = 'This is the body in plain text for non-HTML mail clients';
		
		if(!$mail->send()) {
			return -1;
		} else {
			return 0;
		}	
	}
}