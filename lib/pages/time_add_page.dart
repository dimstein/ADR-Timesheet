import 'package:adr_timesheet/main.dart';
import 'package:adr_timesheet/models/database_helper.dart';
import 'package:adr_timesheet/models/timesheet.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';

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
  String _date;

@override
  void initState() {
  super.initState();
    setState(() {
      widget.date.isEmpty ?
        _date=DateFormat('E, dd MMM yyyy').format(DateTime.now()).toString() :
        _date=widget.date;
        });
  }

  void _submitTime() async{

   dbHelper.submitted(Timesheet(date: _date,hours: hours, minutes: minutes), widget.uref);

  await Navigator.push(context, MaterialPageRoute(
           builder: (context)=>MyNavigationBar(selectedPageIndex: 1,uref: widget.uref)));
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: SingleChildScrollView(
        child: Card(color: Colors.grey[300],
          child: Column(
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
                Text('$_date,', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Text('Time: $hours:${minutes<10 ? '0$minutes' : minutes}',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                ElevatedButton.icon(
                    onPressed: _submitTime,
                    icon: Icon(Icons.add_circle_outlined, size: 40,),
                    label: Text('Add to Database'))
              ],

          ),
        ),
      ),
    );
  }
}
