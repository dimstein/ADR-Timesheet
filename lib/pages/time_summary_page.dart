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
    body: FutureBuilder(initialData: [],
      future: dbHelper.grabAllTime(),
      builder: (context, snapshot){
        if(snapshot.connectionState==ConnectionState.none && snapshot.hasData==null){
          return Container(child: CircularProgressIndicator());
        }
          return ListView.separated(
              itemBuilder: (context, index){
                return ListTile(
                  leading: Text('${snapshot.data[index].id}'),
                  title: Text('${snapshot.data[index].date}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Text('${snapshot.data[index].hours}:'
                      '${snapshot.data[index].minutes<10 ? '0${snapshot.data[index].minutes}':'${snapshot.data[index].minutes}'}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  onLongPress: (){ setState(() {
                    dbHelper.delete(snapshot.data[index].id);
                  }); }
                );
              },
              separatorBuilder: (BuildContext content, int index)=>Divider(color: Colors.orange),
              itemCount: snapshot.data.length);
        }
    ));
  }




}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Timesheet Summary'),
  //       ),
  //     body: ListView.separated(
  //         itemBuilder: (context, index){
  //           return ListTile(
  //             leading: Text('${myTime[index].id}'),
  //             title: Text('${myTime[index].date}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  //             subtitle: Text('${myTime[index].hours}:'
  //                 '${myTime[index].minutes<10 ? '0${myTime[index].minutes}':'${myTime[index].minutes}'}',
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
  //             ),
  //           );
  //         },
  //         separatorBuilder: (BuildContext content, int index)=>Divider(color: Colors.orange),
  //         itemCount: myTime.length),
  //   );
  // }

