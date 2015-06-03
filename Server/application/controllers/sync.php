<?php

class Sync extends CI_Controller {
	
	//从本地上传所有记录到云端
	public function index()
	{
		$this->load->model('Record_model','record');
// 		$this->insertRecord('xmc','test','test2',
// 				1000,8.3,10.4,1,'2010-10-9','2014-1-3',
// 				0,1418724601);
		$user_name=$this->input->post('username');
		$platform=$this->input->post('platform');
		$product=$this->input->post('product');
		$moneyFromPlatform=$this->input->post('moneyFromPlatform');
		$moneyFormNew=$this->input->post('moneyFromNew');
		$minRate=$this->input->post('minRate');
		$maxRate=$this->input->post('maxRate');
		$calType=$this->input->post('calType');
		$startDate=$this->input->post('startDate');
		$endDate=$this->input->post('endDate');
		$state=$this->input->post('state');
		$timestamp=$this->input->post('timestamp');
		$updateTime=$this->input->post('updateTime');
		$isDeleted=$this->input->post('isDeleted');
		$timestampEnd=$this->input->post('timestampEnd');
		$renewAward=$this->input->post('renewAward');
		$manageFee=$this->input->post('manageFee');

		if($this->record->ifExists($user_name,$timestamp))
		{
			//$db_ifDeleted=$this->getIfDeleted($user_name, $add_time);
			if($isDeleted)
			{
				$update_data=array(
						'is_deleted'=>$isDeleted,
						'update_time'=>$updateTime,
				);
				$this->record->update($update_data,$user_name,$timestamp);
				$this->my_tools->output(0, "Deleted record. DB updated.");
			}
				
			$dbUpdateTime=$this->record->getUpdateTime($user_name, $timestamp);
			if(intval($dbUpdateTime)<intval($updateTime))
			{
				$update_data=array(
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
						'update_time'=>$updateTime,
						'is_deleted'=>$isDeleted,
						'timestamp_end'=>$timestampEnd,
						'renew_award'=>$renewAward,
						'management_fee'=>$manageFee,
				);
				$this->record->update($update_data,$user_name,$timestamp);
				$this->my_tools->output(0, "Updated.");
			}
			$this->my_tools->output(0, "Already exists, jumped.");
		}
		else{
			$this->record->insert($user_name,$platform,$product,$moneyFromPlatform,$moneyFormNew,$minRate,
			$maxRate,$calType,$startDate,$endDate,$state,$timestamp,$updateTime,$isDeleted,
			$timestampEnd,$renewAward,$manageFee);
			$this->my_tools->output(0, "Inserted.");
		}
	}
	
	public function balanceSync(){
		$this->load->model('Balance_model','balance');
		
		
		$user_name=$this->input->post('username');
		$createTime=$this->input->post('createTime');
		$platform=$this->input->post('platform');
		$name=$this->input->post('name');
		$type=$this->input->post('type');
		$money=$this->input->post('money');
		$timestamp=$this->input->post('timestamp');
		$updateTime=$this->input->post('updateTime');
		$isDeleted=$this->input->post('isDeleted');
		
		if($this->balance->ifExists($user_name,$createTime))
		{
			if($isDeleted)
			{
				$update_data=array(
						'is_Deleted'=>$isDeleted,
						'update_time'=>$updateTime,
				);
				$this->balance->update($update_data,$user_name,$createTime);
				$this->my_tools->output(0, "Deleted record. DB updated.");
			}
		
			$dbUpdateTime=$this->balance->getUpdateTime($user_name, $createTime);
			if(intval($dbUpdateTime)<intval($updateTime))
			{
				$update_data=array(
						'platform'=>$platform,
						'name'=>$name,
						'type'=>$type,
						'money'=>$money,
						'timestamp'=>$timestamp,
						'update_time'=>$updateTime,
						'is_deleted'=>$isDeleted,
				);
				$this->balance->update($update_data,$user_name,$createTime);
				$this->my_tools->output(0, "Updated.");
			}
			$this->my_tools->output(0, "Already exists, jumped.");
		}
		else{
			$this->balance->insert($user_name,$createTime,$platform,$name,$type,
					$money,$timestamp,$updateTime,$isDeleted);
			$this->my_tools->output(0, "Inserted.");
		}		
	}
	
	public function RecordFromCloud(){
		$this->load->model('Record_model','record');
		
		//post 用户名、第几条往后
		$user_name=$this->input->post('username');
		$index=$this->input->post('index');
		$result=$this->record->getRecords($user_name,$index);
		echo json_encode($result);
	}
	
	public function BalanceFromCloud(){
		$this->load->model('Balance_model','balance');
		
		//post 用户名、第几条往后
		$user_name=$this->input->post('username');
		$index=$this->input->post('index');
		$result=$this->balance->getRecords($user_name,$index);
		echo json_encode($result);
	}
	
	public function RecordAmount()
	{
		$this->load->model('Record_model','record');
		$user_name=$this->input->post('username');
		echo $this->record->getAmount($user_name);
	}
	
	public function BalanceAmount(){
		$this->load->model('Balance_model','balance');
		$user_name=$this->input->post('username');
		echo $this->balance->getAmount($user_name);
	}
	
	
}