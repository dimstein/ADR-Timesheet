import 'package:adr_timesheet/models/database_helper.dart';
import 'package:adr_timesheet/models/timesheet.dart';
import 'package:adr_timesheet/pages/time_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';


class TimeAddPage extends StatefulWidget {

  final String date;
  final int uref;

  const TimeAddPage({Key key, this.date, this.uref}) : super(key: key);

  @override
  _TimeAddPageState createState() => _TimeAddPageState();
}

class _TimeAddPageState extends State<TimeAddPage> {

  final dbHelper = DatabaseHelper.instance;

  int hours=8;
  int minutes=0;

void _submitTime() async{
  final id = await dbHelper.checkDate(Timesheet(date: widget.date));

  if(id==null){
    await dbHelper.insertTime(
        Timesheet(id: widget.uref,date: widget.date,hours: hours, minutes: minutes));
  }else{
    await dbHelper.updateTime(
      Timesheet(id: id,date: widget.date,hours: hours, minutes: minutes));
  }


  await Navigator.push(context, MaterialPageRoute(
          builder: (context)=>TimeSummaryPage()));
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Entry'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [Text('Hour', style: TextStyle(fontWeight: FontWeight.bold),),
                  NumberPicker.integer(
                      initialValue: hours,
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(style: BorderStyle.solid,color: Colors.grey),
                            left: BorderSide(style: BorderStyle.solid,color: Colors.grey),
                        )
                      ),
                      minValue: 0,
                      maxValue: 13,
                      selectedTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green),
                      infiniteLoop: true,
                      onChanged: (value)=> setState(() =>hours=value )),
                ],
              ),
              Column(
                children: [Text('Minutes', style: TextStyle(fontWeight: FontWeight.bold),),
                  NumberPicker.integer(
                      initialValue: minutes,
                      decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(style: BorderStyle.solid,color: Colors.grey),
                            left: BorderSide(style: BorderStyle.solid,color: Colors.grey),
                          )
                      ),
                      minValue: 0,
                      maxValue: 59,
                      selectedTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green),
                      infiniteLoop: true,
                      onChanged: (value)=> setState(() =>minutes=value )),
                ],
              ),
            ],
          ),
          Text('${widget.date}, ', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Text('Time: $hours:${minutes<10 ? '0$minutes' : minutes}',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _submitTime,
        ),
    );
  }
}
