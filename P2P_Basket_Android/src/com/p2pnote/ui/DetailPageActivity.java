package com.p2pnote.ui;

import java.util.ArrayList;
import java.util.HashMap;

import com.p2pnote.ui.R;
import com.p2pnote.ui.R.layout;
import com.p2pnote.ui.R.string;
import com.p2pnote.db.dao.InvestDao;
import com.p2pnote.db.pojo.Invest;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.Toast;
import br.com.dina.ui.widget.UITableView;
import br.com.dina.ui.widget.UITableView.ClickListener;

public class DetailPageActivity extends Activity {
    
	UITableView tableView;
	private ListView listView;
	private ArrayList<Invest> invests;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.detail_page);
        
        /*
        tableView = (UITableView) findViewById(R.id.tableView);
               
        InvestDao dao=new InvestDao(this);
        invests=dao.findAll();
        /*
		
		/*
		ArrayList<HashMap<String, Object>> data = new ArrayList<HashMap<String, Object>>();
		
		for (Invest invest:invests)
		{
			HashMap<String, Object> m1 = new HashMap<String, Object>();
			m1.put("channel_name", invest.getP2pChannelName());
			m1.put("amount", invest.getAmount());
			data.add(m1);
		}
		*/
		
        /*
		createList(invests);        
        Log.d("DetailPageActivity", "total items: " + tableView.getCount());        
        tableView.commit();
        */
    }
    
    private void createList(ArrayList<Invest> invests) {
    	CustomClickListener listener = new CustomClickListener();
    	tableView.setClickListener(listener);
    	for (Invest invest:invests)
		{
	    	tableView.addBasicItem(invest.getInvestDate()+" "+invest.getP2pChannelName()+" "+invest.getInvestName(), getString(R.string.amount)+" "+String.valueOf(invest.getAmount()));
		}
    }
    
    private class CustomClickListener implements ClickListener {

		@Override
		public void onClick(int index) {
			//Toast.makeText(DetailPageActivity.this, "item clicked: " + index, Toast.LENGTH_SHORT).show();
			Invest data = invests.get(index);
			if(data != null) {
				Intent intent = new Intent();
				intent.setClass(DetailPageActivity.this, RecordMaintainActivity.class);
				intent.putExtra("mode", RecordMaintainActivity.EDIT_MODE);
				intent.putExtra("data", data);
				startActivityForResult(intent, 0);	
			}
		}
    	
    }
    
}