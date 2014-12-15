<?php 

class Login extends CI_Controller {
	
	public function output($code,$message)
	{
		$output=array(
				'error_code'=>$code,
				'error_meesage'=>$message,
		);
		echo json_encode($output);
	}
	
	public function index()
	{
		$user_name=$this->input->post('user_name');
		$password=$this->input->post('password');
		$this->db->select('password')->from('my_users')->where('user_name',$user_name);
		$num=$this->db->count_all_results();
		if($num)
		{
			$row=$this->db->get()->row();
			if(strcmp($password, $row->password))
			{
				$this->output(2, 'Password wrong!');
			}else{
				$this->output(0,'Login successfully.');
			}
		}
		else
		{
			$this->output(1, 'Username not exists.');
		}
	}
	
	
	//http://128.199.226.246/beerich/index.php/login/register
	public function register()
	{
		$user_name=$this->input->post('user_name');
		$password=$this->input->post('password');
		$this->db->select('password')->from('my_users')->where('user_name',$user_name);
		$num=$this->db->count_all_results();
		if($num)
		{
			$this->output(3, 'Username exists.');
		}
		else{
			
			$userData = array(
					'index' => '',
					'user_name' => $user_name ,
					'password' => $password ,
			);
			$this->db->insert('my_users', $userData);
			$this->output(0, 'Register successfully.');
		}
		
	}
}