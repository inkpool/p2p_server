package com.licaiji.ui;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Activity;
import android.app.TabActivity;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.widget.AbsListView;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.SimpleAdapter;
import android.widget.TabHost;

public class HomepageTabActivity extends Activity{
	
	SimpleAdapter adapter,adapter2;  
	private List<Map<String,String>> data = new ArrayList<Map<String,String>>();
   
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_homepage);
        Map<String, String> map1 = new HashMap<String, String>();  
        map1.put("姓名", "A");  
        data.add(map1);  
        Map<String, String> map2 = new HashMap<String, String>();  
        map2.put("姓名", "B");  
        data.add(map2);
        Map<String, String> map3 = new HashMap<String, String>();  
        map3.put("姓名", "C");  
        data.add(map3);
        Map<String, String> map4 = new HashMap<String, String>();  
        map4.put("姓名", "D");  
        data.add(map4);
        Map<String, String> map5 = new HashMap<String, String>();  
        map5.put("姓名", "E");  
        data.add(map5);
     // 获取TabHost对象  
        
        
        
        TabHost tabHost = (TabHost) findViewById(R.id.tabhost);         
        LinearLayout l=(LinearLayout)findViewById(R.id.linearlayout);
          //自定义样式
        RelativeLayout tabStyles1=(RelativeLayout)LayoutInflater.from(this).inflate(R.layout.tab_style,null);
        RelativeLayout tabStyles2=(RelativeLayout)LayoutInflater.from(this).inflate(R.layout.tab_style2,null);
        // 如果没有继承TabActivity时，通过该种方法加载启动tabHost 
        tabHost.setup();  
        Drawable drawable = getResources().getDrawable(R.drawable.down);   
        //l.setSelected(drawable);
        
        tabHost.addTab(tabHost.newTabSpec("tab1").setIndicator(tabStyles1)
        		.setContent(R.id.view1));  
        ListView listview1=(ListView)findViewById(R.id.view1);
		adapter = new SimpleAdapter(this, data, R.layout.activity_expire, new String[]{"姓名"}, new int[]{android.R.id.text1});  
        listview1.setAdapter(adapter);
        tabHost.addTab(tabHost.newTabSpec("tab2").setIndicator(tabStyles2)  
                .setContent(R.id.view2)); 
        ListView listview2=(ListView)findViewById(R.id.view2);
		adapter2 = new SimpleAdapter(this, data, R.layout.activity_hasexpired, new String[]{"姓名"}, new int[]{android.R.id.text1});  
        listview2.setAdapter(adapter2);
    }
}
