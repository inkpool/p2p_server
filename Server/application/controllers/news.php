

<?php

header('Content-Type:text/html;charset=uft8');

class News extends CI_Controller {
	
	public function index()
	{
		$last_timestamp=$this->input->post('last_timestamp');
		//$last_timestamp=0;
		$query=$this->db->select('*')
					->from('my_news')
					->where('add_time >',$last_timestamp)
					->limit(10,0)
					->order_by('index','desc');
		$result=$query->get()->result();
		echo json_encode($result);
		
	}
		
	public function getRecommend()
	{
		$index=$this->input->post('average_');
		$index=$this->input->post('average_');
	}
	
	public function feedback()
	{
		$type=$this->input->post('type');
		$content=$this->input->post('content');
		$extra=$this->input->post('extra');
		$data=array(
				'id'=>'',
				'type'=>$type,
				'content'=>$content,
				'extra'=>$extra,
		);
		$this->db->insert('my_feedbacks',$data);
		$this->output(0, "Feedback success.");
	}
	private function output($code,$message)
	{
		$output=array(
				'error_code'=>$code,
				'error_meesage'=>$message,
		);
		echo json_encode($output);
		exit();
	}
}