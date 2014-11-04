package com.p2pnote.db.dao;

import java.util.ArrayList;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.p2pnote.db.InvestSQLiteOpenHelper;
import com.p2pnote.db.pojo.Invest;

public class InvestDao2 {
	InvestSQLiteOpenHelper helper = null;
	
	public InvestDao2(Context context) {
		super();
		this.helper = new InvestSQLiteOpenHelper(context);
	}

	/*
	public long add(String name, String number,int money) {
		SQLiteDatabase db = this.helper.getWritableDatabase();
		ContentValues values = new ContentValues();
		values.put("name", name);
		values.put("number", number);
		values.put("account", money);
		long id = db.insert("person", null, values);
		db.close();
		return id;
	}

	public boolean find(String name) {
		SQLiteDatabase db = this.helper.getReadableDatabase();
		Cursor cursor = db.query("person", null, "name=?",
				new String[] { name }, null, null, null);
		boolean result = cursor.moveToNext();
		cursor.close();
		db.close();
		return result;
	}

	public int update(String name, String newNumber) {
		SQLiteDatabase db = this.helper.getWritableDatabase();
		ContentValues values = new ContentValues();
		values.put("number", newNumber);
		int number = db.update("person", values, "name=?",
				new String[] { name });
		db.close();
		return number;
	}

	public int delete(String name) {
		SQLiteDatabase db = this.helper.getWritableDatabase();
		// db.execSQL("delete from person where name=?", new Object[] { name });
		int number = db.delete("person", "name=?", new String[] { name });
		db.close();
		return number;
	}

	public ArrayList<Invest> findAll() {
		SQLiteDatabase db = this.helper.getReadableDatabase();
		ArrayList<Invest> persons = new ArrayList<Invest>();
		Cursor cursor = db.query("person", null, null, null, null, null, null);
		while (cursor.moveToNext()) {
			int id = cursor.getInt(cursor.getColumnIndex("id"));
			String name = cursor.getString(cursor.getColumnIndex("name"));
			String number = cursor.getString(cursor.getColumnIndex("number"));
			Invest p = new Invest(id, name, number);
			persons.add(p);
		}
		cursor.close();
		db.close();
		return persons;

	}
	*/

}
