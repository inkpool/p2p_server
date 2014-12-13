package com.crowley.p2pnote;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.R.integer;
import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

public class IndexFragment extends Fragment implements OnClickListener{	

	private View view;
	
	private ListView listView;
	private SimpleAdapter list_adapter;
	private List<Map<String, Object>> dataList;
	
	private LinearLayout tab_button01;
	private LinearLayout tab_button02;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		View view = inflater.inflate(R.layout.index_fragment, container, false);
		//TextView text = (TextView) view.findViewById(R.id.test);
		

        dataList=new ArrayList<Map<String,Object>>();
        listView=(ListView) view.findViewById(R.id.list_view);
        getData(1);
        list_adapter=new SimpleAdapter(this.getActivity(), dataList, R.layout.index_listview_item, new String[]{"time","item_icon","item_name","item_money","item_profit"}, new int[]{R.id.time,R.id.item_icon,R.id.item_name,R.id.item_money,R.id.item_profit});
        listView.setAdapter(list_adapter);
        
        tab_button01 = (LinearLayout) view.findViewById(R.id.tab_button01);
        tab_button02 = (LinearLayout) view.findViewById(R.id.tab_button02);
		
        tab_button01.setOnClickListener(this);
        tab_button02.setOnClickListener(this);
        
        return view;
	}

	//private List<Map<String, Object>> getData(int index){
	private void getData(int index){
		dataList.clear();
    	for(int i=0;i<20;i++){
    		Map<String, Object> map=new HashMap<String, Object>();
    		if(index==0){
    			map.put("time", "2014-10-1"+i);
        		map.put("item_icon", R.drawable.company_icon02);
        		map.put("item_name", "陆金所-富赢人生");
        		map.put("item_money", "12,000");
        		map.put("item_profit", "12%");
    		}else{    			
        		map.put("time", "2014-08-12");
        		map.put("item_icon", R.drawable.company_icon01);
        		map.put("item_name", "人人贷-优选计划");
        		map.put("item_money", "11,000");
        		map.put("item_profit", "8%");
    		}    		
    		dataList.add(map);    		
    	}
    	//return dataList;
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
            list_adapter.notifyDataSetChanged();
            for(int i = 0;i<listView.getChildCount();i++){
            	TextView textView= (TextView) listView.getChildAt(i).findViewById(R.id.item_name);
            	textView.setTextColor(getResources().getColor(R.color.company02));
            }            
            break;  
        case R.id.tab_button02:  
        	tab_button01.setBackgroundColor(getResources().getColor(R.color.tab_bg));  
            tab_button02.setBackgroundColor(getResources().getColor(R.color.white));
            getData(1);
            list_adapter.notifyDataSetChanged();
            for(int i = 0;i<listView.getChildCount();i++){
            	TextView textView= (TextView) listView.getChildAt(i).findViewById(R.id.item_name);
            	textView.setTextColor(getResources().getColor(R.color.company01));
            }
            break;   
        default:  
            break;  
        }
		
	}
}
