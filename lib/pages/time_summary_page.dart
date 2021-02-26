import 'package:adr_timesheet/models/database_helper.dart';
import 'package:adr_timesheet/models/timesheet.dart';
import 'package:flutter/material.dart';

class TimeSummaryPage extends StatefulWidget {
  @override
  _TimeSummaryPageState createState() => _TimeSummaryPageState();
}

class _TimeSummaryPageState extends State<TimeSummaryPage> {

  final dbHelper = DatabaseHelper.instance;
  List<Timesheet> myTime=[];

  @override
  void initState() {
    _queryList();
    super.initState();
  }

  void _queryList() async {
    myTime.clear();
    final allTime = await dbHelper.queryAllRows();
    allTime.forEach((time) {
      myTime.add(
        Timesheet(id: time['_id'], date: time['date'], hours: time['hours'], minutes: time['minutes']));
    });
    setState(() {
          });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timesheet Summary'),
        ),
      body: ListView.separated(
          itemBuilder: (context, index){
            return ListTile(
              leading: Text('${myTime[index].id}'),
              title: Text('${myTime[index].date}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text('${myTime[index].hours}:'
                  '${myTime[index].minutes<10 ? '0${myTime[index].minutes}':'${myTime[index].minutes}'}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            );
          },
          separatorBuilder: (BuildContext content, int index)=>Divider(color: Colors.orange),
          itemCount: myTime.length),
    );
  }
}
