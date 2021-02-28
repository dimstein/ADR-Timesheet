import 'package:adr_timesheet/pages/time_entry_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// ignore: public_member_api_docs, use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
    => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.lime,
         visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TimeEntryPage()

    );
  }



