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
		$query=$this->db->select('*')->from('my_users')->where('user_name',$user_name);
		$num=$query->count_all_results();
		if($num)
		{
			$row=$this->db->select('password')->from('my_users')->where('user_name',$user_name)->get()->row();
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
		$query=$this->db->select('*')->from('my_users')->where('user_name',$user_name);
		$num=$query->count_all_results();
		if(intval($num))
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
	
	public function createTicket($email)
	{
		//插入请求重置密码的数据表
	}
	
	public function recoverPassword()
	{
		$user_name=$this->input->post('user_name');
		if(empty($user_name))
		{
			die();
		}
		$query=$this->db->select('*')->from('my_users')->where('user_name',$user_name);
		$num=$query->count_all_results();
		if(intval($num))
		{
			$timestamp=time();
			//$ticket=$this->createTicket($user_name,$timestamp);
			$ticket=100;
			$token=md5($timestamp);
			$data=base64_encode($user_name.':'.$ticket.':'.$token);
			header("location: http://128.199.226.246/beerich/email/sendEmail.php?data=$data");
			$this->output(0, "Request sent.");
			//send a email
		}else 
		{
			$this->output(1, "Username not exists!");
		}
	}
	
	public function reset(){
		$ticket=$this->input->get('ticket');
		$token=$this->input->get('token');
	}
	
}