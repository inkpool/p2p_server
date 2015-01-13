<?php

class Sync extends CI_Controller {
	
	private function ifExists($user_name,$add_time)
	{
		$query=$this->db->select('*')->from('my_records')->where('userName',$user_name)->where('addTime',$add_time);
		$num=$query->count_all_results();
		return $num;
	}
	
	private function getState($user_name,$add_time)
	{
		$query=$this->db->select('*')
						->from('my_records')
						->where('userName',$user_name)
						->where('addTime',$add_time);
		$row=$query->get()->result_array();
		return $row[0]['state'];
	}
	
	private function getIfDeleted($user_name,$add_time)
	{
		$query=$this->db->select('*')
		->from('my_records')
		->where('userName',$user_name)
		->where('addTime',$add_time);
		$row=$query->get()->result_array();
		return $row[0]['ifDeleted'];
	}
	
	private function insertRecord($user_name,$platform,$product,
			$capital,$minRate,$maxRate,$calType,$startDate,$endDate,
			$state,$add_time,$ifDeleted,$earning,$takeout,$calTime,$balance){
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
				'ifDeleted'=>$ifDeleted,
				'earning'=>$earning,
				'takeout'=>$takeout,
				'calTime'=>$calTime,
				'balance'=>$balance,
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
		$ifDeleted=$this->input->post('ifDeleted');
		
		$earning=$this->input->post('earning');
		$takeout=$this->input->post('takeout');
		$calTime=$this->input->post('timeStampEnd');
		$balance=$this->input->post('rest');

		if($this->ifExists($user_name,$add_time))
		{
			//$db_ifDeleted=$this->getIfDeleted($user_name, $add_time);
			if($ifDeleted)
			{
				$update_data=array(
						'ifDeleted'=>$ifDeleted,
				);
				$this->db->where('userName',$user_name)
						 ->where('addTime',$add_time)
						 ->update('my_records',$update_data);
				$this->output(0, "Deleted record. DB updated.");
			}
				
			$db_state=$this->getState($user_name, $add_time);
			if(intval($db_state)<intval($state))
			{
				$update_data=array(
						'state'=>$state,
				);
				$this->db->where('userName',$user_name)
						 ->where('addTime',$add_time)
						 ->update('my_records',$update_data);
				$this->output(0, "Updated.");
			}
			$this->output(0, "Already exists, jumped.");		
		}
		else{
			$this->insertRecord($user_name,$platform,$product,
			$capital,$minRate,$maxRate,$calType,$startDate,$endDate,
			$state,$add_time,$ifDeleted,$earning,$takeout,$calTime,$balance);
			$this->output(0, "Inserted.");
		}
	}
	
	public function fromCloud()
	{
		//post 用户名、第几条、往后多少条
		$user_name=$this->input->post('user_name');
		$index=$this->input->post('index');
		$number=$this->input->post('number');
		
		$query=$this->db->select('*')
						->from('my_records')
						->where('userName',$user_name)
						->limit($number,$index)
						->order_by('id','desc');
		$result=$query->get()->result();
		echo json_encode($result);
	}
	
	public function cloudAmount()
	{
		$user_name=$this->input->post('user_name');
		$query=$this->db->select('*')->from('my_records')->where('userName',$user_name);
		$num=$query->count_all_results();
		echo $num;
	}
	
	public function test()
	{
		echo ($this->getState('xuxin@qq.com',1413725078));
	}
	
	
}