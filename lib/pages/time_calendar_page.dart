import 'package:adr_timesheet/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class TimeCalendarPage extends StatefulWidget {
  @override
  _TimeCalendarPageState createState() => _TimeCalendarPageState();
}

class _TimeCalendarPageState extends State<TimeCalendarPage> {

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args){
     final _selectedDate = DateFormat('E, dd MMM yyyy').format(args.value).toString();

     final _uref = int.parse(DateFormat('yyyyMMdd').format(args.value));
          Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => MyNavigationBar(selectedPageIndex: 2,
                              date: _selectedDate, uref: _uref)));

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: SingleChildScrollView(
          child:  SfDateRangePicker(
                  view: DateRangePickerView.month,
                  monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                  selectionMode: DateRangePickerSelectionMode.single,
                  onSelectionChanged: _onSelectionChanged,
                  backgroundColor: Colors.grey[200],
                 selectionColor: Colors.green,
            headerHeight: 50,
            ),
               ),
    );
  }
}
