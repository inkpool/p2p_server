<?php

class My_tools
{
	private $CI;

	public function __construct()
	{
		$this->CI =& get_instance();
	}
	
	public function output($code,$message)
	{
		$output=array(
				'error_code'=>$code,
				'error_meesage'=>$message,
		);
		echo json_encode($output);
		exit();
	} 
}