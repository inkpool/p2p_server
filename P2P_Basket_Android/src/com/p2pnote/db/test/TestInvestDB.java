package com.p2pnote.db.test;

import java.util.ArrayList;

import android.database.sqlite.SQLiteDatabase;
import android.test.AndroidTestCase;
import android.widget.Toast;

import com.p2pnote.db.InvestSQLiteOpenHelper;
import com.p2pnote.db.dao.InvestDao;
import com.p2pnote.db.pojo.Invest;

public class TestInvestDB extends AndroidTestCase {

	public void testCreateInvestDB() throws Exception {
		InvestSQLiteOpenHelper db = new InvestSQLiteOpenHelper(getContext());
		db.getWritableDatabase();
	}
	
	
	public void testAdd() {
		InvestDao pd = new InvestDao(getContext());
		Invest invest=new Invest();
		invest.setAmount(100d);
		invest.setP2pChannelName("aaa");
		invest.setUserId(1L);
		pd.add(invest);
		System.out.println("insert ok");
	}
	
	/*
	public void testFind() {
		InvestDao pd = new InvestDao(getContext());
		boolean result = pd.find("weijie");
		assertEquals(true, result);
	}

	public void testUpdate() {
		InvestDao pd = new InvestDao(getContext());
		pd.update("weijie", "3213545");
	}

	public void testDelete() {
		InvestDao pd = new InvestDao(getContext());
		pd.delete("weijie");
	}

	public void testFindAll() {
		InvestDao pd = new InvestDao(getContext());
		ArrayList<Invest> persons = pd.findAll();
		for (Invest person : persons) {
			System.out.println(person);
		}
	}

	public void testTransaction() {
		InvestSQLiteOpenHelper helper = new InvestSQLiteOpenHelper(getContext());
		SQLiteDatabase db = helper.getWritableDatabase();
		db.beginTransaction();
		try {
			db.execSQL(
					"update person set account = account + 1000 where name=?",
					new Object[] { "tom" });
			int i = 1 / 0;
			db.execSQL(
					"update person set account = account - 1000 where name=?",
					new Object[] { "jerry" });
			db.setTransactionSuccessful();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			db.endTransaction();
		}
	
	}
	*/
}
