package com.crowley.p2pnote;

import java.util.ArrayList;

import com.crowley.p2pnote.functions.ReturnList;
import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.PieData;
import com.github.mikephil.charting.data.PieDataSet;
import com.github.mikephil.charting.utils.ColorTemplate;
import com.github.mikephil.charting.utils.Legend;
import com.github.mikephil.charting.utils.Legend.LegendForm;
import com.github.mikephil.charting.utils.Legend.LegendPosition;

import android.app.Fragment;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

public class AnalyzeFragment extends Fragment implements OnClickListener{
	
	private PieChart mChart;
	private ReturnList returnList;
	
	private TextView time_period;
	private ImageView prev;
	private ImageView next;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		View v = inflater.inflate(R.layout.analyze_fragment, container, false);
		returnList=new ReturnList();
		mChart = (PieChart) v.findViewById(R.id.pieChart1);
		time_period=(TextView) v.findViewById(R.id.time_period);
		prev=(ImageView) v.findViewById(R.id.prev);
		next=(ImageView) v.findViewById(R.id.next);
		
		String[] timeStrings = (time_period.getText().toString()).split(" ");
		String beginString = timeStrings[0];
		String endString = timeStrings[timeStrings.length-1];
		
        mChart.setDescription("");
        mChart.setUsePercentValues(true);
        mChart.setCenterText("投资平台\n占比图");
        mChart.setCenterTextSize(22f);
        mChart.setHoleRadius(45f); 
        mChart.setTransparentCircleRadius(50f);        
        mChart.setData(generatePieData(beginString,endString));        
        Legend l = mChart.getLegend();
        l.setPosition(LegendPosition.BELOW_CHART_CENTER);
        l.setForm(LegendForm.SQUARE);
        
        prev.setOnClickListener(this);
        next.setOnClickListener(this);
		
		return v;
	}
	
	protected PieData generatePieData(String beginString,String endString) {
        

        ArrayList<String> xVals = returnList.analyzexVals(this.getActivity(), 0, beginString, endString);
        ArrayList<Entry> entries1 =null;
        int count = xVals.size();
        PieData d;
        
        if(count==0){
        	xVals = new ArrayList<String>();
        	xVals.add("该月没有投资记录");
        	entries1 = new ArrayList<Entry>();
        	entries1.add(new Entry(100f, 0));
        }else{
        	entries1 = returnList.analyzeEntries(this.getActivity(), 0, beginString, endString, xVals);            
            for(int i = 0; i < count; i++) {
                xVals.add("entry" + (i+1));
            }            
        } 
        PieDataSet ds1 = new PieDataSet(entries1, "");
        ds1.setColors(ColorTemplate.VORDIPLOM_COLORS);
        ds1.setSliceSpace(2f);
        d = new PieData(xVals, ds1);
        return d;
		/*int count = 1;
        
        ArrayList<Entry> entries1 = new ArrayList<Entry>();
        ArrayList<String> xVals = new ArrayList<String>();
        
        xVals.add("该月没有投资记录");
        
        for(int i = 0; i < count; i++) {
            xVals.add("entry" + (i+1));    
            entries1.add(new Entry(100f, i));
        }
        
        PieDataSet ds1 = new PieDataSet(entries1, "");
        ds1.setColors(ColorTemplate.VORDIPLOM_COLORS);
        ds1.setSliceSpace(2f);
        
        PieData d = new PieData(xVals, ds1);
        return d;*/
    }

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		String[] timeStrings = (time_period.getText().toString()).split(" ");
		String beginString = timeStrings[0];
		String endString = timeStrings[timeStrings.length-1];
		String[] beginTime=beginString.split("-");
		String[] endTime=endString.split("-");
		int[] months={0,31,28,31,30,31,30,31,31,30,31,30,31};
		int beginYear=Integer.parseInt(beginTime[0]);
		int beginMonth=Integer.parseInt(beginTime[1]);
		int beginDay=Integer.parseInt(beginTime[2]);
		int endYear=Integer.parseInt(endTime[0]);
		int endMonth=Integer.parseInt(endTime[1]);
		int endDay=Integer.parseInt(endTime[2]);
		
		switch (v.getId()) {
		case R.id.prev:{
			if (beginMonth==1) {
				beginYear--;
				beginString=beginYear+"-12-01";
				endString=beginYear+"-12-31";				
			}else{
				beginMonth--;
				if(beginMonth<10){
					beginString=beginYear+"-0"+beginMonth+"-01";
					endString=beginYear+"-0"+beginMonth+"-"+months[beginMonth];
				}else{
					beginString=beginYear+"-"+beginMonth+"-01";
					endString=beginYear+"-"+beginMonth+"-"+months[beginMonth];
				}
			}
			time_period.setText(beginString+" 至 "+endString);
			mChart.setData(generatePieData(beginString,endString));
			mChart.invalidate();
			break;
		}
		case R.id.next:{
			if (beginMonth==12) {
				beginYear++;
				beginString=beginYear+"-01-01";
				endString=beginYear+"-01-31";				
			}else{
				beginMonth++;
				if(beginMonth<10){
					beginString=beginYear+"-0"+beginMonth+"-01";
					endString=beginYear+"-0"+beginMonth+"-"+months[beginMonth];
				}else{
					beginString=beginYear+"-"+beginMonth+"-01";
					endString=beginYear+"-"+beginMonth+"-"+months[beginMonth];
				}
			}
			time_period.setText(beginString+" 至 "+endString);
			mChart.setData(generatePieData(beginString,endString));
			mChart.invalidate();
			break;
		}
		default:
			break;
		}
		
	}

}
