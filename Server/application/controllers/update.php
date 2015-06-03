<?php

define('latest_ver',1); 
define('download_url',"http://wwww.baidu.com");

class Update extends CI_Controller {
	public function index(){
		$cur_ver=intval($this->input->post('version'));
		if($cur_ver<latest_ver)
		{
			$output=array(
					'state'=>1,
					'url'=>download_url,
			);
			echo json_encode($output);
		}
		else {
			$output=array(
					'state'=>0,
			);
			echo json_encode($output);
		}
		
	}
	
}