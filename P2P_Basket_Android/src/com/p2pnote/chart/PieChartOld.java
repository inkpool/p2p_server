package com.p2pnote.chart;

import android.app.Activity;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Color;
import android.os.Bundle;

import com.echo.holographlibrary.PieGraph;
import com.echo.holographlibrary.PieGraph.OnSliceClickedListener;
import com.echo.holographlibrary.PieSlice;
import com.p2pnote.ui.R;
import com.p2pnote.ui.R.id;
import com.p2pnote.ui.R.layout;
import com.p2pnote.ui.R.string;
import com.p2pnote.db.InvestSQLiteOpenHelper;

public class PieChartOld extends Activity {
	private InvestSQLiteOpenHelper helper = null;
	private String sqlString;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.report_page);
		
		/*
        String[] color = {"#99CC00","#FFBB33","#AA66CC"};
		PieGraph pg = (PieGraph)this.findViewById(R.id.piegraph);
		
		helper = new InvestSQLiteOpenHelper(this);
		SQLiteDatabase db = this.helper.getReadableDatabase();
		sqlString=getString(R.string.sql_channel_report);
		
		Cursor cursor = db.rawQuery(sqlString, new String[] {});
        boolean next = cursor.moveToFirst();
        int number = 0;
        while (next) {
            PieSlice slice = new PieSlice();
            int i = number % color.length;
            slice.setColor(Color.parseColor(color[i])); //颜色交替
            slice.setTitle(cursor.getString(0));
            slice.setValue(cursor.getFloat(2)); //
            pg.addSlice(slice);
            next = cursor.moveToNext();
            number++;
        }
		
		pg.setOnSliceClickedListener(new OnSliceClickedListener(){

			@Override
			public void onClick(int index) {
				
			}
			
		});
		*/
	}
}
