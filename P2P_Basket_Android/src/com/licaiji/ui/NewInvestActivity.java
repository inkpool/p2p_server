package com.licaiji.ui;

import java.util.ArrayList;
import android.widget.AdapterView.OnItemSelectedListener;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.LocalActivityManager;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.SimpleAdapter;
import android.widget.Spinner;
import android.widget.Toast;

public class NewInvestActivity extends Activity {
	
	private LocalActivityManager localActivityManager = null;
    private LinearLayout mainTabContainer = null;
    private Intent mainTabIntent = null;
    private Button back=null;
    private Spinner spinner=null;
    private  Spinner spinner2=null;
	 @Override
	    protected void onCreate(Bundle savedInstanceState) {
	        super.onCreate(savedInstanceState);
	        
	        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
	        
	        setContentView(R.layout.activity_newinvest);
	        
	        
	        mainTabContainer = (LinearLayout)findViewById(R.id.main_tab_container2);
	        
	        spinner=(Spinner)findViewById(R.id.spinner1);
	        spinner2=(Spinner)findViewById(R.id.spinner2);
	        SimpleAdapter simpleAdapter=new SimpleAdapter(
	        		NewInvestActivity.this,getData(),R.layout.spinner_item,
	        		new String[]{"ivLogo","applicationName"},new int[]{
	        			R.id.imageview,R.id.spinner_textview
	        		}
	        		) ;
	        SimpleAdapter simpleAdapter2=new SimpleAdapter(
	        		NewInvestActivity.this,getData2(),R.layout.spinner2_item,
	        		new String[]{"applicationName2"},new int[]{
	        			R.id.spinner_textview2
	        		}
	        		) ;
	        spinner.setAdapter(simpleAdapter);
	        spinner2.setAdapter(simpleAdapter2);
	        spinner.setOnItemSelectedListener(new OnItemSelectedListener() {
	        	 
	        	             public void onItemSelected(AdapterView<?> parent, View view,
	        	                     int position, long id) {
	        	                 //parentΪһ��Map�ṹ�ĺ�����
	        	                 Map<String, Object> map = (Map<String, Object>) parent
	        	                         .getItemAtPosition(position);
	        	                 /*Toast.makeText(NewInvestActivity.this,
	        	                         map.get("applicationName").toString(),
	        	                         Toast.LENGTH_SHORT).show();*/
	        	             }
	        	 
	        	             public void onNothingSelected(AdapterView<?> arg0) {
	        	                 
	        	             }
	        	         });
	        	     
	        back=(Button)findViewById(R.id.back2);
	        back.setOnClickListener(new OnClickListener(){

				@SuppressLint("SimpleDateFormat")
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub
					Intent intent=new Intent(NewInvestActivity.this,MainActivity.class);
					startActivity(intent);
				}
	        	
	        });
	    }
	 public void setContainerView(String id,Class<?> activity){
	        mainTabContainer.removeAllViews();
	        mainTabIntent = new Intent(this,activity);
	        mainTabContainer.addView(localActivityManager.startActivity(id, mainTabIntent).getDecorView());
	    }
	 public List<Map<String, Object>> getData() {
		         //��������Դ
		          List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		          //ÿ��Map�ṹΪһ�����ݣ�key��Adapter�ж����String�����ж����һһ��Ӧ��
		          Map<String, Object> map = new HashMap<String, Object>();
		          map.put("ivLogo", R.drawable.one);
		          map.put("applicationName", "���˴�");
		          list.add(map);
		          Map<String, Object> map2 = new HashMap<String, Object>();
		          map2.put("ivLogo", R.drawable.two);
		          map2.put("applicationName", "½����");
		          list.add(map2);
		          
		          return list;
		      }
	 public List<Map<String, Object>> getData2() {
         //��������Դ
          List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
          //ÿ��Map�ṹΪһ�����ݣ�key��Adapter�ж����String�����ж����һһ��Ӧ��
          Map<String, Object> map = new HashMap<String, Object>();
          map.put("applicationName2", "��Ӯ����(P2P)");
          list.add(map);
          Map<String, Object> map2 = new HashMap<String, Object>();
          map2.put("applicationName2", "��Ӯ����(P1P)");
          list.add(map2);
          
          return list;
      }
}
