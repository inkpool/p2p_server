package com.p2pnote.db;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

public class InvestSQLiteOpenHelper extends SQLiteOpenHelper {
	private static final String DBFILENAME = "invest.db";
	private static int db_version = 1;
	private static final String tag = "com.p2pnote.db";

	public InvestSQLiteOpenHelper(Context context) {
		super(context, DBFILENAME, null, db_version);
	}

	/**
	 * 数据库初始化
	 */
	@Override
	public void onCreate(SQLiteDatabase db) {
		String sql = "CREATE TABLE user_invest_record ("
				  +"invest_id integer primary key autoincrement,"
				  +"invest_name varchar(300) DEFAULT NULL,"
				  +"user_id integer DEFAULT NULL,"
				  +"invest_type_id integer DEFAULT 1,"
				  +"invest_status varchar(30) DEFAULT '投资中',"
				  +"invest_date varchar(20) NOT NULL,"
				  +"repayment_ending_date varchar(20),"
				  +"p2p_channel_name varchar(300) NOT NULL,"
				  +"amount double NOT NULL,"
				  +"interest_rate_min double DEFAULT NULL,"
				  +"interest_rate_max double DEFAULT NULL,"
				  +"bonus_rate double DEFAULT NULL,"
				  +"repayment_type varchar(30),"
				  +"guarantee_type varchar(30),"
				  +"gmt_create varchar(20),"
				  +"gmt_modify varchar(20),"
				  +"comment varchar(2000))";
		Log.d(tag, sql);
		db.execSQL(sql);
		
		sql = "CREATE TABLE user_channel_curr_amount ("
				  +"id integer primary key autoincrement,"
				  +"channel_name varchar(300) NOT NULL,"
				  +"user_id integer DEFAULT NULL,"
				  +"amount double DEFAULT 0,"
				  +"gmt_create varchar(20),"
				  +"gmt_modify varchar(20))";
		Log.d(tag, sql);
		db.execSQL(sql);
		
		sql = "CREATE TABLE user_channel_amount_log ("
				  +"id integer primary key autoincrement,"
				  +"channel_name varchar(300) NOT NULL,"
				  +"user_id integer DEFAULT NULL,"
				  +"amount_type varchar(10) NOT NULL,"
				  +"change_amount double DEFAULT 0,"
				  +"amount double DEFAULT 0,"
				  +"gmt_create varchar(20))";
		Log.d(tag, sql);
		db.execSQL(sql);
	}

	/**
	 * 数据库版本升级
	 */
	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		Log.d(tag, "db upgrade");
		String sql = "alter table invest add account varchar(20)";
		db.execSQL(sql);
	}

}
