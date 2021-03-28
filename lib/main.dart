import 'package:adr_timesheet/pages/time_add_page.dart';
import 'package:adr_timesheet/pages/time_calendar_page.dart';
import 'package:adr_timesheet/pages/time_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context)
    => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.orange,
         visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyNavigationBar(),

    );
  }

  class MyNavigationBar extends StatefulWidget {

  final int selectedPageIndex;
  final String date;
  final int uref;

  const MyNavigationBar({Key key, this.selectedPageIndex=0,
     this.date, this.uref}) : super(key: key);

    @override
    _MyNavigationBarState createState() => _MyNavigationBarState();
  }

  class _MyNavigationBarState extends State<MyNavigationBar> {



    @override
    Widget build(BuildContext context) {
      return DefaultTabController(initialIndex: widget.selectedPageIndex,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Timesheet ADR'),
            backgroundColor: Colors.orange,
            bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.calendar_today)),
              Tab(icon: Icon(Icons.list_alt_sharp)),
              Tab(icon: Icon(Icons.input_rounded)),
            ]),
          ),

          body: TabBarView(
              children: [
                TimeCalendarPage(),   //selectedPageIndex = 0
                TimeSummaryPage(uref: widget.uref),//selectedPageIndex = 1
                TimeAddPage(uref: widget.uref,date: widget.date),  //selectedPageIndex = 2
              ]
          ),
        ),
      );
    }
  }




