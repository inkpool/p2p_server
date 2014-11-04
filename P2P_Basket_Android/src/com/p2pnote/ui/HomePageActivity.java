package com.p2pnote.ui;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;

import com.p2pnote.ui.R.id;
import com.p2pnote.ui.R.layout;
import com.p2pnote.ui.R.string;
import com.p2pnote.db.InvestSQLiteOpenHelper;
import com.p2pnote.db.dao.InvestDao;
import com.p2pnote.db.pojo.Invest;
import com.p2pnote.ui.InvestListActivity;
import com.p2pnote.utility.Function;
import com.p2pnote.utility.MyProcessBar;
import com.p2pnote.ui.R;

import android.opengl.Visibility;
import android.os.Bundle;
import android.R.integer;
import android.content.Intent;
import android.text.format.Time;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

import android.database.Cursor;
import android.database.CursorWrapper;
import android.database.sqlite.SQLiteDatabase;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;

public class HomePageActivity extends BaseActivity implements OnClickListener {
	/** Called when the activity is first created. */
	private InvestSQLiteOpenHelper helper = null;
	private String year = null;
	private String month = null;
	private String day = null;
	private String nextweek = null;
	public String today=null;
	private String weekStart = null;
	private String weekEnd = null;
	private double total_amount = 0.0;
	private String avg_interest_rate = "0";
	private int today_invest_count = 0;
	private int already_expire_count = 0;
	private int will_expire_count = 0;

	private Button btn_login;
	private Button btn_record;
	private TextView text_today;
	private TextView text_today_income;
	private TextView text_avg_interest_rate;
	private TextView text_total_amount;

	private TextView today_count_tv;
	private TextView today_invest_amount_tv;
	private TextView today_interest_amount_tv;
	private TextView already_expire_count_tv;
	private TextView already_expire_amount_tv;
	private TextView already_expire_interest_tv;
	private TextView will_expire_count_tv;
	private TextView will_expire_amount_tv;
	private TextView will_expire_interest_tv;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.homepage);

		refreshTransactions();
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		super.onActivityResult(requestCode, resultCode, data);
		
		if (requestCode == 0) {
			refreshTransactions();
		}
	}

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		
		refreshTransactions();
	}
	
	private void refreshTransactions() {
		initDate();
		loadingFormation();
		initInfo();
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		Intent intent = null;
		switch (v.getId()) {
		case R.id.btn_login:
			intent = new Intent(this, LoginUIActivity.class);
			startActivity(intent);
			break;
		case R.id.btn_record:
			intent = new Intent(this, RecordMaintainActivity.class);
			startActivity(intent);
			break;
		case R.id.today_row_rl:
			showInvestListActivity(today, today,getString(R.string.today_invest), InvestListActivity.mode_today_invest);
			break;
		case R.id.already_expire_row_rl:
			showInvestListActivity(today,today,getString(R.string.already_expire), InvestListActivity.mode_already_expire);
			break;
		case R.id.will_expire_row_rl:
			showInvestListActivity(today,nextweek,getString(R.string.will_expire), InvestListActivity.mode_will_expire);
			break;		
		}
	}
	
	private void showInvestListActivity(String str_startTime,String str_endTime, String title, int mode)
	{
		Intent intent = new Intent(this, InvestListActivity.class);
		intent.putExtra(InvestListActivity.str_startTime, str_startTime);
		intent.putExtra(InvestListActivity.str_endTime, str_endTime);
		intent.putExtra(InvestListActivity.str_title, title);
		intent.putExtra(InvestListActivity.str_mode, mode);
		
		startActivity(intent);
	}	

	private void initDate() {
		today = Function.getCurrentDate(); // 显示当前的年月日
		nextweek = Function.getNextweek();
	}

	private void loadingFormation() {
		// 给button增加点击事件
		btn_login = (Button) this.findViewById(R.id.btn_login);
		btn_login.setOnClickListener(this);

		btn_record = (Button) this.findViewById(R.id.btn_record);
		btn_record.setOnClickListener(this);

		text_today = (TextView) findViewById(R.id.text_today);
		text_today_income = (TextView) findViewById(R.id.text_today_income);
		text_avg_interest_rate = (TextView) findViewById(R.id.text_avg_interest_rate);
		text_total_amount = (TextView) findViewById(R.id.text_total_amount);

		today_count_tv = (TextView) findViewById(R.id.today_count_tv);
		today_invest_amount_tv = (TextView) findViewById(R.id.today_invest_amount_tv);
		today_interest_amount_tv = (TextView) findViewById(R.id.today_interest_amount_tv);
		already_expire_count_tv = (TextView) findViewById(R.id.already_expire_count_tv);
		already_expire_amount_tv = (TextView) findViewById(R.id.already_expire_amount_tv);
		already_expire_interest_tv = (TextView) findViewById(R.id.already_expire_interest_tv);
		will_expire_count_tv = (TextView) findViewById(R.id.will_expire_count_tv);
		will_expire_amount_tv = (TextView) findViewById(R.id.will_expire_amount_tv);
		will_expire_interest_tv = (TextView) findViewById(R.id.will_expire_interest_tv);

		findViewById(R.id.today_row_rl).setOnClickListener(this);
		findViewById(R.id.already_expire_row_rl).setOnClickListener(this);
		findViewById(R.id.will_expire_row_rl).setOnClickListener(this);
	}

	private void initInfo() {

		// db = SplashScreenActivity.db;
		
		String sqlString=null;
		String avg_interest_rate_max=null;

		text_today.setText(today);

		helper = new InvestSQLiteOpenHelper(this);
		SQLiteDatabase db = this.helper.getReadableDatabase();
		
		sqlString=getString(R.string.sql_total_sum);
		Cursor cursor = db.rawQuery(sqlString, null);
		if (cursor.moveToNext()) {
			total_amount = cursor.getDouble(1);
			if (total_amount>0)
			{
				text_total_amount.setText("¥ " + cursor.getDouble(1));
				
				int nameColumn = cursor.getColumnIndex("avg_interest_rate");
				avg_interest_rate = cursor.getString(nameColumn);
				
				nameColumn = cursor.getColumnIndex("avg_interest_rate_max");
				avg_interest_rate_max=cursor.getString(nameColumn);
				
				if (avg_interest_rate_max!=null && avg_interest_rate!=null && Double.parseDouble(avg_interest_rate_max)>Double.parseDouble(avg_interest_rate))
					text_avg_interest_rate.setText(avg_interest_rate + "% ~ "+avg_interest_rate_max+"%");
				else 
					text_avg_interest_rate.setText(avg_interest_rate + "%");
			}
		}

		if (total_amount > 0) {
			DecimalFormat df = new DecimalFormat("#.##");
			double today_income=0,today_income_max=0;
			if (avg_interest_rate!=null)
				today_income = total_amount*Double.parseDouble(avg_interest_rate) / 100/365;
			if (avg_interest_rate_max!=null)
				today_income_max = total_amount*Double.parseDouble(avg_interest_rate_max) / 100/365;			
			
			if (today_income_max>today_income)
				text_today_income.setText(String.valueOf(df.format(today_income))+" ~ "+String.valueOf(df.format(today_income_max)));
			else 
				text_today_income.setText(String.valueOf(df.format(today_income)));
		}
		
		sqlString=getString(R.string.sql_today_sum);
		cursor = db
				.rawQuery(
						sqlString,
						new String[] { today,today });
		//System.out.println("sql:"+ sqlString);
		if (cursor.moveToNext()) {
			today_invest_count = cursor.getInt(0);
			if (today_invest_count > 0)
			{	
				today_count_tv.setText(today_invest_count + "笔");
				today_invest_amount_tv.setText("¥ " + cursor.getDouble(1));
				today_interest_amount_tv.setText("¥ " + cursor.getDouble(2));
			}	
		}
		
		sqlString=getString(R.string.sql_already_expire_sum);
		cursor = db
				.rawQuery(sqlString,new String[] { today,today });
		if (cursor.moveToNext()) {
			already_expire_count = cursor.getInt(0);
			if (already_expire_count > 0)
			{	
				already_expire_count_tv.setText(already_expire_count + "笔");
				already_expire_amount_tv.setText("¥ " + cursor.getDouble(1));
				already_expire_interest_tv.setText("¥ " + cursor.getDouble(2));
			}	
		}
		
		sqlString=getString(R.string.sql_will_expire_sum);
		cursor = db
				.rawQuery(sqlString,new String[] { today,nextweek });
		if (cursor.moveToNext()) {
			will_expire_count = cursor.getInt(0);
			if (will_expire_count > 0)
			{	
				will_expire_count_tv.setText(will_expire_count + "笔");
				will_expire_amount_tv.setText("￥ " + cursor.getDouble(1));
				will_expire_interest_tv.setText("￥ " + cursor.getDouble(2));
			}	
		}

		cursor.close();
		db.close();
	}

}
