<?php
class Record_model extends CI_Model{
	
	//insert a record.
	function insert($user_name,$platform,$product,$moneyFromPlatform,$moneyFormNew,$minRate,
			$maxRate,$calType,$startDate,$endDate,$state,$timestamp,$updateTime,$isDeleted,
			$timestampEnd,$renewAward,$manageFee){
		$data=array(
				'id'=>'',
				'username'=>$user_name,
				'platform'=>$platform,
				'product'=>$product,
				'money_from_platform'=>$moneyFromPlatform,
				'money_from_new'=>$moneyFormNew,
				'min_rate'=>$minRate,
				'max_rate'=>$maxRate,
				'cal_type'=>$calType,
				'start_date'=>$startDate,
				'end_date'=>$endDate,
				'state'=>$state,
				'timestamp'=>$timestamp,
				'update_time'=>$updateTime,
				'is_deleted'=>$isDeleted,
				'timestamp_end'=>$timestampEnd,
				'renew_award'=>$renewAward,
				'management_fee'=>$manageFee,
		);
		$this->db->insert('my_records',$data);
	}
	
	//查询某条记录是否存在
	//根据用户名和时间戳
	function ifExists($username,$timestamp){
		$query=$this->db->select('*')
					->from('my_records')
					->where('username',$username)
					->where('timestamp',$timestamp);
		$num=$query->count_all_results();
		return $num;
	}
	
	//查询记录状态，ifDeleted为删除状态标志位。
	//注意删除并不是删除这条记录。
	function ifDeleted($username,$timestamp)
	{
		$query=$this->db->select('*')
		->from('my_records')
		->where('username',$username)
		->where('timestamp',$timestamp);
		$row=$query->get()->result_array();
		return $row[0]['if_deleted'];
	}
	
	//注意删除不是真正意义上的删除
	//将if_deleted置为1
	function deleteRecord($username,$timestamp)
	{
		$update_data=array(
				'if_deleted'=>1,
		);
		$this->db->where('username',$username)
		->where('timestamp',$timestamp)
		->update('my_records',$update_data);
	}
	
	//获取record的最新修改时间
	function getUpdateTime($username,$timestamp)
	{
		$query=$this->db->select('*')
		->from('my_records')
		->where('username',$username)
		->where('timestamp',$timestamp);
		$row=$query->get()->result_array();
		return $row[0]['update_time'];
	}
	
	//获得记录条数
	function getAmount($username)
	{
		$query=$this->db->select('*')->from('my_records')->where('username',$username);
		$num=$query->count_all_results();
		return $num;
	}
	
	//获取记录
	function getRecords($username,$index)
	{
		$query=$this->db->select('*')
		->from('my_records')
		->where('username',$username)
		->limit(10,$index)
		->order_by('id','desc');
		$result=$query->get()->result();
		return $result;
	}
	
	function update($update_data,$username,$timestamp){
		$this->db->where('username',$username)
				->where('timestamp',$timestamp);
		$this->db->update('my_records',$update_data);
	}
}