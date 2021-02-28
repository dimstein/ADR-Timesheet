import 'package:adr_timesheet/pages/time_add_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class TimeEntryPage extends StatefulWidget {
  @override
  _TimeEntryPageState createState() => _TimeEntryPageState();
}

class _TimeEntryPageState extends State<TimeEntryPage> {

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args){
     final _selectedDate = DateFormat('E, dd MMM yyyy').format(args.value).toString();
     final _uref = int.parse(DateFormat('yyyyMMdd').format(args.value));
         Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) =>TimeAddPage(date: _selectedDate,uref: _uref)));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Entry'),),
      body: SingleChildScrollView(
        child:  SfDateRangePicker(
                view: DateRangePickerView.month,
                monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                selectionMode: DateRangePickerSelectionMode.single,
                onSelectionChanged: _onSelectionChanged,
                backgroundColor: Colors.grey[200],
               selectionColor: Colors.green,
               ),
         

        ),
      );
  }
}
