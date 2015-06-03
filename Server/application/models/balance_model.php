<?php

class Balance_model extends CI_Model{
	
	//insert a record.
	function insert($user_name,$createTime,$platform,$name,$type,
					$money,$timestamp,$updateTime,$isDeleted){
		$data=array(
				'id'=>'',
				'username'=>$user_name,
				'create_time'=>$createTime,
				'platform'=>$platform,
				'name'=>$name,
				'type'=>$type,
				'money'=>$money,
				'timestamp'=>$timestamp,
				'update_time'=>$updateTime,
				'is_deleted'=>$isDeleted,
		);
		$this->db->insert('my_balance',$data);
	}
	
	//查询某条记录是否存在
	//根据用户名和时间戳
	function ifExists($username,$createTime){
		$query=$this->db->select('*')
					->from('my_balance')
					->where('username',$username)
					->where('create_time',$createTime);
		$num=$query->count_all_results();
		return $num;
	}
	
	//查询记录状态，ifDeleted为删除状态标志位。
	//注意删除并不是删除这条记录。
	function ifDeleted($username,$createTime)
	{
		$query=$this->db->select('*')
		->from('my_balance')
		->where('username',$username)
		->where('create_time',$createTime);
		$row=$query->get()->result_array();
		return $row[0]['is_deleted'];
	}
	
	//注意删除不是真正意义上的删除
	//将if_deleted置为1
	function deleteRecord($username,$createTime)
	{
		$update_data=array(
				'is_deleted'=>1,
		);
		$this->db->where('username',$username)
		->where('create_time',$createTime)
		->update('my_balance',$update_data);
	}
	
	//获取record的状态，处理或未处理
	function getUpdateTime($username,$createTime)
	{
		$query=$this->db->select('*')
		->from('my_balance')
		->where('username',$username)
		->where('create_time',$createTime);
		$row=$query->get()->result_array();
		return $row[0]['update_time'];
	}
	
	//获得记录条数
	function getAmount($username)
	{
		$query=$this->db->select('*')->from('my_balance')->where('username',$username);
		$num=$query->count_all_results();
		return $num;
	}
	
	//获取记录
	function getRecords($username,$index)
	{
		$query=$this->db->select('*')
		->from('my_balance')
		->where('username',$username)
		->limit(10,$index)
		->order_by('id','desc');
		$result=$query->get()->result();
		return $result;
	}
	
	function update($update_data,$username,$createTime){
		$this->db->where('username',$username)
		->where('create_time',$createTime)
		->update('my_balance',$update_data);
	}
	
}
