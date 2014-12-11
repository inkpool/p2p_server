package com.crowley.p2pnote;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import com.crowley.p2pnote.ui.listAdapter;

import android.R.array;
import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

public class WaterFragment extends Fragment{
	
	private View view;
	
	private ListView listView;
	private listAdapter list_adapter;
	private List<Map<String, Object>> dataList;
	
	List list = new ArrayList();
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		View view = inflater.inflate(R.layout.water_fragment, container, false);

		dataList=new ArrayList<Map<String,Object>>();
        listView=(ListView) view.findViewById(R.id.water_list_view);
        getData();
        list_adapter=new listAdapter(this.getActivity(), dataList, R.layout.index_listview_item, new String[]{"time","item_icon","item_name","item_money","item_profit"}, new int[]{R.id.time,R.id.item_icon,R.id.item_name,R.id.item_money,R.id.item_profit});
        listView.setAdapter(list_adapter);
        
		return view;
	}

	private void getData() {
		// TODO Auto-generated method stub
		dataList.clear();
    	for(int i=0;i<20;i++){
    		Map<String, Object> map=new HashMap<String, Object>();
    		if(i%2==0){
    			map.put("time", "2014-10-1"+i);
        		map.put("item_icon", R.drawable.company_icon02);
        		map.put("item_name", "陆金所-富赢人生");
        		map.put("item_money", "12,000");
        		map.put("item_profit", "12%");
        		list.add("0");
    		}else{    			
        		map.put("time", "2014-08-1"+i);
        		map.put("item_icon", R.drawable.company_icon01);
        		map.put("item_name", "人人贷-优选计划");
        		map.put("item_money", "11,000");
        		map.put("item_profit", "8%");
        		list.add("1");
    		}    		
    		dataList.add(map);    		
    	}
	}

}
