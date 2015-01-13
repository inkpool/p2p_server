package com.crowley.p2pnote;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import cn.pedant.SweetAlert.SweetAlertDialog;

import com.crowley.p2pnote.functions.ReturnList;
import com.crowley.p2pnote.ui.listAdapter;

import android.R.integer;
import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.Toast;

public class WaterFragment extends Fragment implements OnClickListener,OnItemLongClickListener,OnItemClickListener{
		
	private ListView listView;
	private listAdapter list_adapter;
	private List<Map<String, Object>> dataList;
	
	private ReturnList returnList;
	
	private boolean time_des=true;
	private boolean money_des=true;
	private boolean profit_des=true;
	private boolean begin_des=true;
	
	private RelativeLayout time_tab;
	private RelativeLayout money_tab;
	private RelativeLayout profit_tab;
	private RelativeLayout begin_invest;
	
	private TextView time_tab_text;
	private TextView money_tab_text;
	private TextView profit_tab_text;
	private TextView begin_invest_text;
	
	private ImageView time_tab_icon;
	private ImageView money_tab_icon;
	private ImageView profit_tab_icon;
	private ImageView begin_invest_icon;
	
	private int now_state;
	private boolean now_order;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		View view = inflater.inflate(R.layout.water_fragment, container, false);

		returnList = new ReturnList(this.getActivity());
		returnList.logInfo();
		dataList=new ArrayList<Map<String,Object>>();
        listView=(ListView) view.findViewById(R.id.water_list_view);
        time_tab=(RelativeLayout) view.findViewById(R.id.invest_time);
        money_tab=(RelativeLayout) view.findViewById(R.id.invest_money);
        profit_tab=(RelativeLayout) view.findViewById(R.id.invest_profit);
        begin_invest=(RelativeLayout) view.findViewById(R.id.begin_invest);
        
        time_tab_text=(TextView) view.findViewById(R.id.invest_time_text);
        money_tab_text=(TextView) view.findViewById(R.id.invest_money_text);
        profit_tab_text=(TextView) view.findViewById(R.id.invest_profit_text);
        begin_invest_text=(TextView) view.findViewById(R.id.begin_invest_text);
        
        time_tab_icon=(ImageView) view.findViewById(R.id.invest_time_icon);
        money_tab_icon=(ImageView) view.findViewById(R.id.invest_money_icon);
        profit_tab_icon=(ImageView) view.findViewById(R.id.invest_profit_icon);
        begin_invest_icon=(ImageView) view.findViewById(R.id.begin_invest_icon);
        
        getData(3,begin_des);
        now_state=3;
        now_order=begin_des;
        list_adapter=new listAdapter(this.getActivity(), dataList, R.layout.index_listview_item, new String[]{"item_id","item_state","timeBegin","timeEnd","item_icon","item_name","item_money","item_profit"}, new int[]{R.id.item_id,R.id.item_state,R.id.timeBegin,R.id.timeEnd,R.id.item_icon,R.id.item_name,R.id.item_money,R.id.item_profit});
        
               
        listView.setAdapter(list_adapter);
        time_tab.setOnClickListener(this);
        money_tab.setOnClickListener(this);
        profit_tab.setOnClickListener(this);
        begin_invest.setOnClickListener(this);
        listView.setOnItemClickListener(this);
        listView.setOnItemLongClickListener(this);
		return view;
	}
	
	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
    	reflash();
	}

	public void reflash() {
		getData(now_state,now_order);
    	list_adapter.notifyDataSetChanged();
	}

	private void getData(int type,boolean des) {
		// TODO Auto-generated method stub
		dataList.clear();
		List<Map<String, Object>> temp=new ArrayList<Map<String,Object>>();
		temp=returnList.waterSort(type,des);
		for(int i=0;i<temp.size();i++){
			dataList.add(temp.get(i));
		}
	}
	
	public void tabReset(){
		time_tab_text.setTextColor(getResources().getColor(R.color.light_black));
		money_tab_text.setTextColor(getResources().getColor(R.color.light_black));
		profit_tab_text.setTextColor(getResources().getColor(R.color.light_black));
		begin_invest_text.setTextColor(getResources().getColor(R.color.light_black));
		if(time_des){
			time_tab_icon.setImageResource(R.drawable.water_arrow_down);
		}else{
			time_tab_icon.setImageResource(R.drawable.water_arrow_up);
		}
		if(money_des){
			money_tab_icon.setImageResource(R.drawable.water_arrow_down);
		}else{
			money_tab_icon.setImageResource(R.drawable.water_arrow_up);
		}
		if(profit_des){
			profit_tab_icon.setImageResource(R.drawable.water_arrow_down);
		}else{
			profit_tab_icon.setImageResource(R.drawable.water_arrow_up);
		}
		if(begin_des){
			begin_invest_icon.setImageResource(R.drawable.water_arrow_down);
		}else{
			begin_invest_icon.setImageResource(R.drawable.water_arrow_up);
		}
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.invest_time:{
			time_des=!time_des;
			tabReset();
			time_tab_text.setTextColor(getResources().getColor(R.color.tab_text_chosen));
			if(time_des){
				time_tab_icon.setImageResource(R.drawable.water_arrow_down_chosen);
			}else{
				time_tab_icon.setImageResource(R.drawable.water_arrow_up_chosen);
			}
			getData(0,time_des);
			now_state=0;
			now_order=time_des;
			list_adapter.notifyDataSetChanged();
			break;			
		}
		case R.id.invest_money:{
			money_des=!money_des;
			tabReset();
			money_tab_text.setTextColor(getResources().getColor(R.color.tab_text_chosen));
			if(money_des){
				money_tab_icon.setImageResource(R.drawable.water_arrow_down_chosen);
			}else{
				money_tab_icon.setImageResource(R.drawable.water_arrow_up_chosen);
			}
			getData(1,money_des);
			now_state=1;
			now_order=money_des;
			list_adapter.notifyDataSetChanged();
			break;			
		}
		case R.id.invest_profit:{
			profit_des=!profit_des;
			tabReset();
			profit_tab_text.setTextColor(getResources().getColor(R.color.tab_text_chosen));
			if(profit_des){
				profit_tab_icon.setImageResource(R.drawable.water_arrow_down_chosen);
			}else{
				profit_tab_icon.setImageResource(R.drawable.water_arrow_up_chosen);
			}
			getData(2,profit_des);
			now_state=2;
			now_order=profit_des;
			list_adapter.notifyDataSetChanged();
			break;			
		}
		case R.id.begin_invest:{
			begin_des=!begin_des;
			tabReset();
			begin_invest_text.setTextColor(getResources().getColor(R.color.tab_text_chosen));
			if(begin_des){
				begin_invest_icon.setImageResource(R.drawable.water_arrow_down_chosen);
			}else{
				begin_invest_icon.setImageResource(R.drawable.water_arrow_up_chosen);
			}
			getData(3,begin_des);
			now_state=3;
			now_order=begin_des;
			list_adapter.notifyDataSetChanged();
			break;			
		}
		default:
			break;
		}
	}

	@Override
	public boolean onItemLongClick(AdapterView<?> arg0, final View arg1, int arg2,
			long arg3) {
		// TODO Auto-generated method stub
		switch (arg0.getId()) {
		case R.id.water_list_view:{	
			if((((TextView)arg1.findViewById(R.id.item_state)).getText().toString()).equals("0")){
				new SweetAlertDialog(this.getActivity(), SweetAlertDialog.WARNING_TYPE)
	            .setTitleText("确定删除该条记录嘛?")
	            .showContentText(false)
	            .setCancelText("取消")
	            .setConfirmText("确定")
	            .showCancelButton(true)
	            .setConfirmClickListener(new SweetAlertDialog.OnSweetClickListener() {
	                @Override
	                public void onClick(SweetAlertDialog sDialog) {
	                	returnList.deleteItem(((TextView)arg1.findViewById(R.id.item_id)).getText().toString());
	                	reflash();
	                    sDialog.setTitleText("记录已删除")
	                            .setConfirmText("确定")
	                            .showContentText(false)
	                            .showCancelButton(false)
	                            .setCancelClickListener(null)
	                            .setConfirmClickListener(null)
	                            .changeAlertType(SweetAlertDialog.SUCCESS_TYPE);
	                }
	            })
	            .show();
			}else{
				Toast.makeText(this.getActivity(), "已结算项目暂不提供删除", Toast.LENGTH_SHORT).show();
			}
			
			return true;
			//break;			
		}
		default:
			return false;	
		}
	}


	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		// TODO Auto-generated method stub
		switch (arg0.getId()) {
		case R.id.water_list_view:{
			if((((TextView)arg1.findViewById(R.id.item_state)).getText().toString()).equals("0")){
				Intent intent=new Intent(this.getActivity(),NewItemActivity.class);
				//模式1表示修改记录，需要传递修改的id值
				intent.putExtra("model", "1");
				intent.putExtra("id", ((TextView)arg1.findViewById(R.id.item_id)).getText().toString());
				intent.putExtra("platform", "");
	            startActivity(intent);
			}else{
				Toast.makeText(this.getActivity(), "已结算项目暂不提供修改", Toast.LENGTH_SHORT).show();
			}			
			break;			
		}
		default:
			break;		
		}
	}

}
