import 'package:adr_timesheet/models/database_helper.dart';
import 'package:adr_timesheet/pages/time_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';


class TimeAddPage extends StatefulWidget {

  final String date;

  const TimeAddPage({Key key, this.date}) : super(key: key);

  @override
  _TimeAddPageState createState() => _TimeAddPageState();
}

class _TimeAddPageState extends State<TimeAddPage> {

  final dbHelper = DatabaseHelper.instance;
  List<dynamic> myList=[];

  int hour=8;
  int minute=0;

void _submitTime() async{
  var row = <String, dynamic>{
    DatabaseHelper.columnDate : widget.date,
    DatabaseHelper.columnMinutes: minute,
    DatabaseHelper.columnHours: hour
  };
  final id = await dbHelper.insert(row);
  print('$id, being the submitTime');
  await Navigator.push(context, MaterialPageRoute(builder: (context)=>TimeSummaryPage()));
}

// void _queryList() async{
//   myList.clear();
//   final allTime = await dbHelper.queryAllRows();
//   allTime.forEach((row) {myList.add(
//     Timesheet(id: row['_id'], date: row['date'], hours: row['hours'], minutes: row['minutes']));
//   });
//   setState(() {
//       });
// }
//
// void _update() async{
//   var row = {
//     DatabaseHelper.columnId : 1,
//     DatabaseHelper.columnDate : widget.date,
//     DatabaseHelper.columnMinutes : minute,
//     DatabaseHelper.columnHours : hour
//   };
//   final rowAffected = await dbHelper.update(row);
//   _queryList();
// }
//
// void _delete() async{
//   final id = await dbHelper.queryRowCount();
//   final rowDeleted = await dbHelper.delete(id);
//   _queryList();
// }

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
                      initialValue: hour,
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
                      onChanged: (value)=> setState(() =>hour=value )),
                ],
              ),
              Column(
                children: [Text('Minutes', style: TextStyle(fontWeight: FontWeight.bold),),
                  NumberPicker.integer(
                      initialValue: minute,
                      decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(style: BorderStyle.solid,color: Colors.grey),
                            left: BorderSide(style: BorderStyle.solid,color: Colors.grey),
                          )
                      ),
                      minValue: 0,
                      maxValue: 60,
                      selectedTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green),
                      infiniteLoop: true,
                      onChanged: (value)=> setState(() =>minute=value )),
                ],
              ),
            ],
          ),
          Text('${widget.date}, ', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Text('Time: $hour:${minute<10 ? '0$minute' : minute}',
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
