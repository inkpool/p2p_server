package com.p2pnote.ui;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Spinner;

import com.p2pnote.ui.R;
import com.p2pnote.ui.R.array;
import com.p2pnote.ui.R.id;
import com.p2pnote.ui.R.layout;
import com.p2pnote.ui.R.string;
import com.p2pnote.chart.PieChart;
import com.p2pnote.db.InvestSQLiteOpenHelper;

public class ReportActivity extends Activity {
	private InvestSQLiteOpenHelper helper = null;
	private String sqlString,report_title;
	Spinner spinner_report_type;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.report_page);
		
        //String[] color = {"#99CC00","#FFBB33","#AA66CC"};
		//PieGraph pg = (PieGraph)this.findViewById(R.id.piegraph);
		
		spinner_report_type=(Spinner)this.findViewById(R.id.spinner_report_type);
		spinner_report_type.setOnItemSelectedListener(new SpinnerSelectedListener());
		report_title=this.getResources().getStringArray(R.array.report_type)[0];
		spinner_report_type.setSelection(0);
		
	}
	
	public void showChart(String sqlString,int arg2)
	{
		report_title= this.getResources().getStringArray(R.array.report_type)[arg2];
		helper = new InvestSQLiteOpenHelper(this);
		SQLiteDatabase db = this.helper.getReadableDatabase();
		Cursor cursor = db.rawQuery(sqlString, new String[] {});
		int length=cursor.getCount();
		
		if (length>0)
		{	
	        boolean next = cursor.moveToFirst();
	        int number = 0;
	        double[] values=new double[length];
	        String[] titles=new String[length];
	        
	        while (next) {
	            titles[number]=cursor.getString(0);
	            values[number]=cursor.getFloat(2);
	            next = cursor.moveToNext();
	            number++;
	        }
	        
	    	Intent achartIntent = new PieChart(values,titles,report_title).execute(this);
	        startActivity(achartIntent);
		}
	}
	
	class SpinnerSelectedListener implements OnItemSelectedListener{

		@Override
		public void onItemSelected(AdapterView<?> arg0, View arg1, int arg2,
				long arg3) {
			// TODO Auto-generated method stub
			switch (arg2)
			{
				case 0:
					sqlString=getString(R.string.sql_channel_report);
					break;
				case 1:
					sqlString=getString(R.string.sql_repayment_date_report);
					break;
				case 2:
					sqlString=getString(R.string.sql_interest_report);
					break;					
			}

			showChart(sqlString,arg2);
		}

		@Override
		public void onNothingSelected(AdapterView<?> arg0) {
			// TODO Auto-generated method stub
			
		}  
    }  
}
