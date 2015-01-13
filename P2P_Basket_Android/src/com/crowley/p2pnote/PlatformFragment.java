package com.crowley.p2pnote;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.crowley.p2pnote.db.DBOpenHelper;
import com.crowley.p2pnote.functions.ReturnList;
import com.crowley.p2pnote.ui.HorizontalScrollViewAdapter;
import com.crowley.p2pnote.ui.MyHorizontalScrollView;
import com.crowley.p2pnote.ui.MyHorizontalScrollView.OnItemClickListener;

import android.app.Fragment;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class PlatformFragment extends Fragment implements OnClickListener{
	
	private ReturnList returnList;
	
	private MyHorizontalScrollView mHorizontalScrollView;  
    private HorizontalScrollViewAdapter mAdapter;  
    private LinearLayout recordsLinearLayout; 
    private List<Integer> mDatas;
    private List<String> mDatas2;
    private TextView title;
    private TextView platform_earning;
    private TextView platform_rest;
    private TextView platform_earning_rate;
    private TextView platform_amount;
    private TextView newest_date;
    private TextView newest_judge01;
    private TextView newest_judge02;
    private TextView newest_money;
   
    
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		View view = inflater.inflate(R.layout.platform_fragment, container, false);
		
		mHorizontalScrollView = (MyHorizontalScrollView) view.findViewById(R.id.scroll_view);
		recordsLinearLayout = (LinearLayout) view.findViewById(R.id.platform_record);
		title = (TextView) this.getActivity().findViewById(R.id.main_tab_banner_title);
		platform_earning = (TextView) view.findViewById(R.id.platform_earning);
		platform_rest = (TextView) view.findViewById(R.id.platform_rest);
		platform_earning_rate = (TextView) view.findViewById(R.id.platform_earning_rate);
		platform_amount = (TextView) view.findViewById(R.id.platform_amount);
		newest_date = (TextView) view.findViewById(R.id.newest_date);
		newest_judge01 = (TextView) view.findViewById(R.id.newest_judge01);
		newest_judge02 = (TextView) view.findViewById(R.id.newest_judge02);
		newest_money = (TextView) view.findViewById(R.id.newest_money);
		
		returnList=new ReturnList(this.getActivity());
		mDatas=returnList.getPlatformsIcon();
		mDatas2=returnList.getPlatformsName();
		
		if(!mDatas2.isEmpty()){
			updatePlatform(mDatas2.get(0));
		}	
		
		mAdapter = new HorizontalScrollViewAdapter(this.getActivity(), mDatas, mDatas2);
		
		recordsLinearLayout.setOnClickListener(this);
		//添加点击回调  
		mHorizontalScrollView.setOnItemClickListener(new OnItemClickListener()  
		{  
		
		    @Override  
		    public void onClick(View view, int position)
		    {  
		        ((ImageView)(((RelativeLayout) view).getChildAt(2))).setImageResource(R.drawable.platform_arrow_grey);
		        updatePlatform(((TextView)(((RelativeLayout) view).getChildAt(0))).getText().toString());
		    }  
		});  
		
		mHorizontalScrollView.initDatas(mAdapter); 
		return view;
	}


	public void updatePlatform(String platformString) {
		title.setText(platformString);
		platform_earning.setText(Float.valueOf(returnList.getEarningAll(platformString)).toString());
		platform_rest.setText(Float.valueOf(returnList.getRest(platformString)).toString());
		platform_earning_rate.setText(Float.valueOf(returnList.getEarningRateAll(platformString)).toString());
		platform_amount.setText(Float.valueOf(returnList.getAllAmount(platformString)).toString());
		newest_date.setText(returnList.getNewestDate(platformString));
		if(returnList.getNewestBool(platformString)){
			newest_judge01.setText("收益");
			newest_judge02.setText("+");
			newest_judge02.setTextColor(getResources().getColor(DBOpenHelper.platform_in));
		}else{
			newest_judge01.setText("取出");
			newest_judge02.setText("-");
			newest_judge02.setTextColor(getResources().getColor(DBOpenHelper.platform_out));
		}
		newest_money.setText(returnList.getNewestMoney(platformString, returnList.getNewestBool(platformString)));
	}


	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		switch (arg0.getId()) {
		case R.id.platform_record:{
			Intent intent=new Intent(this.getActivity(),RecordActivity.class);
			intent.putExtra("platform", title.getText());
            startActivity(intent);
            break;			
		}
		default:
			break;
		}
		
	}
	
	public void reflash(){
		mDatas=returnList.getPlatformsIcon();
		mDatas2=returnList.getPlatformsName();
		if(!mDatas2.isEmpty()){
			updatePlatform(mDatas2.get(0));
		}
		mAdapter=new HorizontalScrollViewAdapter(this.getActivity(), mDatas, mDatas2);
		mHorizontalScrollView.updateDate(mAdapter);
	}

	

}
