package com.licaiji.ui;

import android.app.Activity;
import android.app.ActivityGroup;
import android.os.Bundle;
import android.view.Menu;



import android.annotation.SuppressLint;
import android.app.ActivityGroup;
import android.app.LocalActivityManager;
import android.content.Intent;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends ActivityGroup {

	boolean toExit = false;
	//Tab Activity Layout
    private LocalActivityManager localActivityManager = null;
    private LinearLayout mainTabContainer = null;
    private Intent mainTabIntent = null;

    //Tab banner title
    private TextView mainTabTitleTextView = null;
    //Tab ImageView
    private ImageView appreciateImageView = null;
    private ImageView discussImageView = null;
    private ImageView identifitab_bgionImageView = null;
    private ImageView favoriteImageView = null;
    private ImageView settingImageView = null;
    Button back;
    Button newinvest;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
    	
    	
        super.onCreate(savedInstanceState);
        
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        
        //this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, 
        //        WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.main_tab_container);
        
        mainTabContainer = (LinearLayout)findViewById(R.id.main_tab_container);
        localActivityManager = getLocalActivityManager();
        //初始页面在主页上
        setContainerView("appreciate", HomepageTabActivity.class);

        initTab();
        back=(Button)findViewById(R.id.back);
        back.setOnClickListener(new OnClickListener(){

			@SuppressLint("SimpleDateFormat")
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
			}
        	
        });
        newinvest=(Button)findViewById(R.id.newinvest);
        newinvest.setOnClickListener(new OnClickListener(){

        	
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				//plus.setBackgroundResource(R.drawable.plus2);
			    Intent intent=new Intent(MainActivity.this,NewInvestActivity.class);
			    startActivity(intent);
				
			}
        	
        });
        
    }

    
    /**
     * 初始化Tab项
     */
    private void initTab() {
        mainTabTitleTextView = (TextView)findViewById(R.id.main_tab_banner_title);
        appreciateImageView = (ImageView)findViewById(R.id.appreciate_tab_btn);
        discussImageView = (ImageView)findViewById(R.id.discuss_tab_btn);
        identifitab_bgionImageView = (ImageView)findViewById(R.id.identification_tab_btn);
        favoriteImageView = (ImageView)findViewById(R.id.favorite_tab_btn);
        settingImageView = (ImageView)findViewById(R.id.setting_tab_btn);
        
        //主页
        appreciateImageView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                mainTabTitleTextView.setText("理财记");
                setContainerView("appreciate", HomepageTabActivity.class);
                appreciateImageView.setImageResource(R.drawable.games_ios_blue);
                discussImageView.setImageResource(R.drawable.anchor);
                identifitab_bgionImageView.setImageResource(R.drawable.chart_up);
                favoriteImageView.setImageResource(R.drawable.layers);
                settingImageView.setImageResource(R.drawable.more);
            }
        });
        
        //好友
        discussImageView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                mainTabTitleTextView.setText("流水");
                setContainerView("discuss", AnchorTabActivity.class);
                appreciateImageView.setImageResource(R.drawable.games_ios);
                discussImageView.setImageResource(R.drawable.anchor_blue);
                identifitab_bgionImageView.setImageResource(R.drawable.chart_up);
                favoriteImageView.setImageResource(R.drawable.layers);
                settingImageView.setImageResource(R.drawable.more);
            }
        });
        
        //图库
        identifitab_bgionImageView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                mainTabTitleTextView.setText("分析");
                setContainerView("identifitab_bgion", AnalysisTabActivity.class);
                appreciateImageView.setImageResource(R.drawable.games_ios);
                discussImageView.setImageResource(R.drawable.anchor);
                identifitab_bgionImageView.setImageResource(R.drawable.chart_up_blue);
                favoriteImageView.setImageResource(R.drawable.layers);
                settingImageView.setImageResource(R.drawable.more);
            }
        });
        
        //消息
        favoriteImageView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                mainTabTitleTextView.setText("平台");
                setContainerView("favorite", LayersTabActivity.class);
                appreciateImageView.setImageResource(R.drawable.games_ios);
                discussImageView.setImageResource(R.drawable.anchor);
                identifitab_bgionImageView.setImageResource(R.drawable.chart_up);
                favoriteImageView.setImageResource(R.drawable.layers_blue);
                settingImageView.setImageResource(R.drawable.more);
            }
        });
        
        //设置
        settingImageView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                mainTabTitleTextView.setText("更多");
                setContainerView("setting", MoreTabActivity.class);
                appreciateImageView.setImageResource(R.drawable.games_ios);
                discussImageView.setImageResource(R.drawable.anchor);
                identifitab_bgionImageView.setImageResource(R.drawable.chart_up);
                favoriteImageView.setImageResource(R.drawable.layers);
                settingImageView.setImageResource(R.drawable.more_blue);
            }
        });
    }
    
    public void setContainerView(String id,Class<?> activity){
        mainTabContainer.removeAllViews();
        mainTabIntent = new Intent(this,activity);
        mainTabContainer.addView(localActivityManager.startActivity(id, mainTabIntent).getDecorView());
    }

public boolean onCreateOptionsMenu(Menu menu) {

	// Inflate the menu; this adds items to the action bar if it is present.
	//getMenuInflater().inflate(R.menu.mainmenu, menu);
	return true;
}
@Override
public void onBackPressed() {//setIcon(R.drawable.icon)
	//按两次
//		 AlertDialog.Builder builder = new AlertDialog.Builder(EntryActivity.this)
//		 .setMessage("确定退出?")
//		 .setPositiveButton("确定", new DialogInterface.OnClickListener() { 					
//			@Override
//			public void onClick(DialogInterface dialog, int which) {
//				System.exit(0);		
//			}
//		}).setNegativeButton("取消", new DialogInterface.OnClickListener() {
//			
//			@Override
//			public void onClick(DialogInterface dialog, int which) {
//				//dialog.cancel();
//				dialog.dismiss();							
//			}
//		});
		//builder.create().show();
	
	if(toExit == false)
	{
		Toast.makeText(MainActivity.this, "再按一次退出程序", Toast.LENGTH_LONG).show();
		toExit = true;
	}
	else
	{
		System.exit(0);		
	}
	
}
/*public boolean onKeyDown(int keyCode,KeyEvent event){
    if(keyCode==KeyEvent.KEYCODE_BACK){
      return true;
    }
    return super.onKeyDown(keyCode,event);
} */
}


