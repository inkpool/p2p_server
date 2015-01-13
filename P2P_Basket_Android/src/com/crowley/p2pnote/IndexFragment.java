package com.crowley.p2pnote;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.pedant.SweetAlert.SweetAlertDialog;

import com.crowley.p2pnote.db.DBOpenHelper;
import com.crowley.p2pnote.functions.ReturnList;
import com.crowley.p2pnote.ui.listAdapter;

import android.R.integer;
import android.app.Dialog;
import android.app.Fragment;
import android.content.ContentValues;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

public class IndexFragment extends Fragment implements OnClickListener,OnItemLongClickListener,OnItemClickListener{	

	private View view;
	private ReturnList returnList;
	private ListView listView;
	private listAdapter list_adapter;
	private List<Map<String, Object>> dataList;
	
	private LinearLayout tab_button01;
	private LinearLayout tab_button02;
	
	private TextView tab_button01_number;
	private TextView tab_button02_number;
	
	private TextView timeTextView;
	private TextView index_info_basic01_number;
	private TextView index_info_basic01_float;
	private TextView index_info_basic02_number;
	private TextView index_info_basic02_float;
	private TextView index_info_basic03_number;
	
	private Dialog dialog;
	
	private int nowState=0;
	private String id="";
	
	private Button cancelButton;
	private Button sureButton;
	private TextView timeEndTextView;
	private TextView productTextView;
	private TextView moneyTextView;
	private TextView rateTextView;
	private EditText earningText;
	private EditText getOutText;
	
	private float total=0.0f;
	
	
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		View view = inflater.inflate(R.layout.index_fragment, container, false);
		//TextView text = (TextView) view.findViewById(R.id.test);
		
		returnList = new ReturnList(this.getActivity());
        dataList=new ArrayList<Map<String,Object>>();
        listView=(ListView) view.findViewById(R.id.list_view);
        getData(0);
        list_adapter=new listAdapter(this.getActivity(), dataList, R.layout.index_listview_item, new String[]{"item_id","timeBegin","timeEnd","item_icon","item_name","item_money","item_profit"}, new int[]{R.id.item_id,R.id.timeBegin,R.id.timeEnd,R.id.item_icon,R.id.item_name,R.id.item_money,R.id.item_profit});
        listView.setAdapter(list_adapter);
        
        
        tab_button01 = (LinearLayout) view.findViewById(R.id.tab_button01);
        tab_button02 = (LinearLayout) view.findViewById(R.id.tab_button02);
        tab_button01_number = (TextView) view.findViewById(R.id.tab_button01_number);
        tab_button02_number = (TextView) view.findViewById(R.id.tab_button02_number);
        tab_button01_number.setText(String.valueOf(returnList.indexCount(0)));
        tab_button02_number.setText(String.valueOf(returnList.indexCount(1)));
        
        timeTextView = (TextView) view.findViewById(R.id.index_info_time);
        index_info_basic01_number = (TextView) view.findViewById(R.id.index_info_basic01_number);
    	index_info_basic01_float = (TextView) view.findViewById(R.id.index_info_basic01_float);
    	index_info_basic02_number = (TextView) view.findViewById(R.id.index_info_basic02_number);
    	index_info_basic02_float = (TextView) view.findViewById(R.id.index_info_basic02_float);
    	index_info_basic03_number = (TextView) view.findViewById(R.id.index_info_basic03_number);
    	
        timeTextView.setText(returnList.getTime());
        index_info_basic01_number.setText(returnList.getBaseInfo01Number01());
    	index_info_basic01_float.setText(returnList.getBaseInfo01Number02());
    	index_info_basic02_number.setText(returnList.getBaseInfo02Number01());
    	index_info_basic02_float.setText(returnList.getBaseInfo02Number02());
    	index_info_basic03_number.setText(returnList.getBaseInfo03());
    	
    	dialog = new Dialog(this.getActivity(), R.style.MyDialog);
        //设置它的ContentView
        dialog.setContentView(R.layout.dialog);
        timeEndTextView=(TextView) dialog.findViewById(R.id.end_time);
        productTextView=(TextView) dialog.findViewById(R.id.item_name);
        moneyTextView=(TextView) dialog.findViewById(R.id.money_invest);
        rateTextView=(TextView) dialog.findViewById(R.id.invest_rate);
        earningText=(EditText) dialog.findViewById(R.id.earning);
        getOutText=(EditText) dialog.findViewById(R.id.get_out);
        
        sureButton = (Button) dialog.findViewById(R.id.sure_button);
        cancelButton = (Button) dialog.findViewById(R.id.cancel_button);
        sureButton.setOnClickListener(this);
        cancelButton.setOnClickListener(this);
    	
		
        tab_button01.setOnClickListener(this);
        tab_button02.setOnClickListener(this);
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

	//private List<Map<String, Object>> getData(int index){
	//0锟斤拷锟斤拷锟窖撅拷锟斤拷锟节ｏ拷1锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷
	private void getData(int type){
		dataList.clear();
		List<Map<String, Object>> temp=new ArrayList<Map<String,Object>>();
		temp=returnList.indexList(type);
		for(int i=0;i<temp.size();i++){
			dataList.add(temp.get(i));
		}
    }

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId())  
        {  
        case R.id.tab_button01:  
            tab_button01.setBackgroundColor(getResources().getColor(R.color.white));  
            tab_button02.setBackgroundColor(getResources().getColor(R.color.tab_bg));
            getData(0);
            nowState=0;
            list_adapter.notifyDataSetChanged();
            break;  
        case R.id.tab_button02:  
        	tab_button01.setBackgroundColor(getResources().getColor(R.color.tab_bg));  
            tab_button02.setBackgroundColor(getResources().getColor(R.color.white));
            getData(1);
            nowState=1;
            list_adapter.notifyDataSetChanged();
            break;  
        case R.id.sure_button:{
        	boolean erroredBoolean=false;
        	String errorString="";
        	Float earningFloat=0.0f;
        	Float getOutFloat=0.0f;
        	if(TextUtils.isEmpty(earningText.getText())){
				erroredBoolean=true;
				errorString="收益确认不得为空";	
			}else{
				earningFloat = Float.parseFloat(earningText.getText().toString());
				if(earningFloat<0){
					erroredBoolean=true;
					errorString="收益必须大于0";	
				}
			}
        	if(TextUtils.isEmpty(getOutText.getText())){
        		getOutFloat=0.0f;
			}else{
				getOutFloat = Float.parseFloat(getOutText.getText().toString());
				if(getOutFloat<0){
					erroredBoolean=true;
					errorString="取出金额必须大于0";				
				}
				if(getOutFloat>total+earningFloat){
					erroredBoolean=true;
					errorString="取出金额必须小于"+(total+earningFloat);	
				}
			}
        	if (erroredBoolean) {
				//Toast.makeText(getApplicationContext(), errorString, Toast.LENGTH_SHORT).show();
				new SweetAlertDialog(this.getActivity(), SweetAlertDialog.ERROR_TYPE)
	                .setTitleText("确认投资失败")
	                .setContentText(errorString)
	                .setConfirmText("确定")
	                .show();
			//如果成功则插入数据并返回
			}else{
				returnList.dealRecord(id, earningFloat, getOutFloat);				
				dialog.dismiss();
				reflash();
			}
        	break;
        }
        case R.id.cancel_button:{
        	dialog.dismiss();
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
		case R.id.list_view:{
			new SweetAlertDialog(this.getActivity(), SweetAlertDialog.WARNING_TYPE)
            .setTitleText("确定删除该条记录嘛?")
            .setContentText("该记录将无法复原!")
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
			return true;
			//break;			
		}
		default:
			return false;	
		}		
	}
	
	public void reflash(){
		getData(nowState);
        list_adapter.notifyDataSetChanged();
        tab_button01_number.setText(String.valueOf(returnList.indexCount(0)));
        tab_button02_number.setText(String.valueOf(returnList.indexCount(1)));
        index_info_basic01_number.setText(returnList.getBaseInfo01Number01());
    	index_info_basic01_float.setText(returnList.getBaseInfo01Number02());
    	index_info_basic02_number.setText(returnList.getBaseInfo02Number01());
    	index_info_basic02_float.setText(returnList.getBaseInfo02Number02());
    	index_info_basic03_number.setText(returnList.getBaseInfo03());
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		// TODO Auto-generated method stub
		switch (arg0.getId()) {
		case R.id.list_view:{
			switch (nowState) {
			case 0:{			
				id=((TextView)arg1.findViewById(R.id.item_id)).getText().toString();
				String tempString=((TextView)arg1.findViewById(R.id.timeEnd)).getText().toString();
				String[] time=tempString.split(" ");
				timeEndTextView.setText(time[1]);
				productTextView.setText(((TextView)arg1.findViewById(R.id.item_name)).getText().toString());
				moneyTextView.setText(((TextView)arg1.findViewById(R.id.item_money)).getText().toString());
				String rateString=((TextView)arg1.findViewById(R.id.item_profit)).getText().toString();
				rateTextView.setText(rateString.substring(0, rateString.length()-1));
				earningText.setText("");
				try {
					earningText.setHint(returnList.getEarning(id));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				getOutText.setText("");
				total=returnList.getRest(returnList.getPlatformString(id))+Float.valueOf(((TextView)arg1.findViewById(R.id.item_money)).getText().toString());
				getOutText.setHint(Float.valueOf(total).toString());
                dialog.show();
				break;
			}case 1:{
				Intent intent=new Intent(this.getActivity(),NewItemActivity.class);
				//模式1表示修改记录，需要传递修改的id值
				intent.putExtra("model", "1");
				intent.putExtra("id", ((TextView)arg1.findViewById(R.id.item_id)).getText().toString());
				intent.putExtra("platform", "");
	            startActivity(intent);
				break;
			}
			default:
				break;
			}
						
		}
		default:
			break;		
		}
	}
}
