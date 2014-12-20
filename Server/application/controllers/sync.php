<?php

class Sync extends CI_Controller {
	
	private function ifExists($user_name,$add_time)
	{
		$query=$this->db->select('*')->from('my_records')->where('userName',$user_name)->where('addTime',$add_time);
		$num=$query->count_all_results();
		return $num;
	}
	
	private function insertRecord($user_name,$platform,$product,
			$capital,$minRate,$maxRate,$calType,$startDate,$endDate,
			$state,$add_time){
		$data=array(
				'id'=>'',
				'userName'=>$user_name,
				'platform'=>$platform,
				'product'=>$product,
				'capital'=>$capital,
				'minRate'=>$minRate,
				'maxRate'=>$maxRate,
				'calType'=>$calType,
				'startDate'=>$startDate,
				'endDate'=>$endDate,
				'state'=>$state,
				'addTime'=>$add_time,
		);
		$this->db->insert('my_records',$data);
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
	
	//从本地上传所有记录到云端
	public function index()
	{
// 		$this->insertRecord('xmc','test','test2',
// 				1000,8.3,10.4,1,'2010-10-9','2014-1-3',
// 				0,1418724601);
		$user_name=$this->input->post('user_name');
		$platform=$this->input->post('platform');
		$product=$this->input->post('product');
		$capital=$this->input->post('capital');
		$minRate=$this->input->post('minRate');
		$maxRate=$this->input->post('maxRate');
		$calType=$this->input->post('calType');
		$startDate=$this->input->post('startDate');
		$endDate=$this->input->post('endDate');
		$state=$this->input->post('state');
		$add_time=$this->input->post('add_time');

		if($this->ifExists($user_name,$add_time))
		{
			$this->output(0, "Already exists, jumped.");
		}
		else{
			$this->insertRecord($user_name,$platform,$product,
			$capital,$minRate,$maxRate,$calType,$startDate,$endDate,
			$state,$add_time);
			$this->output(0, "Inserted.");
		}
	}
	
	public function fromCloud()
	{
		$user_name=$this->input->post('user_name');
		$index=$this->input->post('index');
		$number=$this->input->post('number');
		
		
	}
	
	public function cloudAmount()
	{
		$user_name=$this->input->post('user_name');
		$query=$this->db->select('*')->from('my_records')->where('userName',$user_name);
		$num=$query->count_all_results();
		echo $num;
	}
	
	
}