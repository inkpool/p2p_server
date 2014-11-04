package com.p2pnote.db.dao;

import java.util.ArrayList;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.p2pnote.db.InvestSQLiteOpenHelper;
import com.p2pnote.db.pojo.Invest;

public class InvestDao {
	InvestSQLiteOpenHelper helper = null;

	public InvestDao(Context context) {
		super();
		this.helper = new InvestSQLiteOpenHelper(context);
	}

	public void add(Invest invest) {
		SQLiteDatabase db = this.helper.getWritableDatabase();
		/*
		String sqlString="insert into user_invest_record (invest_id, user_id, invest_date,"
				+"repayment_ending_date, p2p_channel_name, amount," 
				+"interest_rate_min, interest_rate_max, bonus_rate," 
				+"repayment_type_id, is_guarantee, is_mortgage," 
				+"is_tradeable, comment, gmt_create," 
				+"gmt_modify)"
				+"values (?,?,?,?,?,?,?,?,?,?,"
				+"?,?,?,?,?,?,?)";
		db.execSQL(sqlString,new Object(invest));
		db.close();
		*/
		
		ContentValues values = new ContentValues();
		//values.put("invest_id", invest.getInvestId());
		//values.put("user_id", invest.getUserId());
		values.put("invest_date", invest.getInvestDate());
		values.put("repayment_ending_date",invest.getRepaymentEndingDate());
		values.put("p2p_channel_name", invest.getP2pChannelName());
		values.put("invest_name", invest.getInvestName());
		values.put("amount", invest.getAmount());
		values.put("interest_rate_min", invest.getInterestRateMin());
		values.put("interest_rate_max", invest.getInterestRateMax());
		values.put("guarantee_type", invest.getGuaranteeType());
		values.put("repayment_type", invest.getRepaymentType());
		values.put("gmt_create", invest.getGmtCreate());
		values.put("gmt_modify",invest.getGmtModify());
		values.put("comment",invest.getComment());	
		
		long id = db.insert("user_invest_record", null, values);
		db.close();
	}

	public boolean find(String name) {
		SQLiteDatabase db = this.helper.getReadableDatabase();
		Cursor cursor = db.rawQuery("select * from user_invest_record where name=?",
				new String[] { name });
		boolean result = cursor.moveToNext();
		cursor.close();
		db.close();
		return result;
	}

	public void update(Invest invest,Long investId) {
		SQLiteDatabase db = this.helper.getWritableDatabase();
		db.execSQL("update user_invest_record set invest_name = ?,"+
					"user_id = ?,"+
					//"invest_type_id = ?,"+
					//"invest_status = ?,"+
					"invest_date = ?,"+
					"repayment_ending_date = ?,"+
					"p2p_channel_name = ?,"+
					"amount = ?,"+
					"interest_rate_min = ?,"+
					"interest_rate_max = ?,"+
					"repayment_type = ?,"+
					"guarantee_type = ?,"+
					"gmt_create = ?,"+
					"gmt_modify = ?,"+
					"comment = ? where invest_id=?",
				new Object[] {invest.getInvestName(),invest.getUserId(),invest.getInvestDate(),invest.getRepaymentEndingDate(),
							  invest.getP2pChannelName(),invest.getAmount(),
							  invest.getInterestRateMin(),invest.getInterestRateMax(),
							  invest.getRepaymentType(),invest.getGuaranteeType(),
							  invest.getGmtCreate(),invest.getGmtModify(),invest.getComment(),investId });
		db.close();
	}

	public void delete(Long investId) {
		SQLiteDatabase db = this.helper.getWritableDatabase();
		db.execSQL("delete from user_invest_record invest_id name=?", new Object[] { investId });
		db.close();
	}

	public ArrayList<Invest> findAll() {
		SQLiteDatabase db = this.helper.getReadableDatabase();
		ArrayList<Invest> invests = new ArrayList<Invest>();
		Cursor cursor = db.rawQuery("select * from user_invest_record order by invest_id desc", null);
		while (cursor.moveToNext()) {
			Invest p=new Invest(cursor);
			invests.add(p);
		}
		cursor.close();
		db.close();
		return invests;

	}

}
