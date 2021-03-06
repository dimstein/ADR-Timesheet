import 'package:adr_timesheet/main.dart';
import 'package:adr_timesheet/models/database_helper.dart';
import 'package:adr_timesheet/models/timesheet.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class TimeSummaryPage extends StatefulWidget {
  final int? uref;

  const TimeSummaryPage({Key? key, this.uref}) : super(key: key);

  @override
  _TimeSummaryPageState createState() => _TimeSummaryPageState();
}

class _TimeSummaryPageState extends State<TimeSummaryPage> {
  late DatabaseHelper dbHelper;
  final scrollDirection = Axis.vertical;
  int? _uref;
  AutoScrollController? controller;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper.instance;
    _uref = widget.uref;
setState(() {

});
    controller = AutoScrollController(
            viewportBoundaryGetter: () =>
                Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
            axis: scrollDirection,
    suggestedRowHeight: 200
    );

    _scrollToIndex();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void _onCardTap(String? date, int? ref) {

    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => MyNavigationBar(selectedPageIndex: 2,
                date: date, uref: ref)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RefreshIndicator(onRefresh: _scrollToIndex,
        child: FutureBuilder(
            initialData: [Timesheet(id: 1, date: 'date', hours: 1, minutes: 1)],
            future: dbHelper.grabAllTime(),
            builder: (context, AsyncSnapshot<List<Timesheet>> snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  !snapshot.hasData) {
                return Container(child: CircularProgressIndicator());
              }
              return ListView.separated(
                scrollDirection: scrollDirection,
                controller: controller,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) async {
                      setState(() {
                        snapshot.data!.remove(index);
                      });
                      await dbHelper.delete(snapshot.data![index].id!);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('${snapshot.data![index].date} dismissed')));
                      // Scaffold.of(context)
                      // .showSnackBar(SnackBar(content: Text('${snapshot.data[index].date} dismissed')));
                    },
                    background: Container(
                      color: Colors.red[200],
                    ),
                    child: AutoScrollTag(
                      key: UniqueKey(),
                      controller: controller!,
                      index: index,

                      child: Card(
                        key: Key('summary'),
                        child: ListTile(
                          //leading: Text('${snapshot.data![index].id!}'),
                          leading: Icon(Icons.timelapse_outlined),
                          title: Text('${snapshot.data![index].date!}',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            '${snapshot.data![index].hours!}:'
                            '${snapshot.data![index].minutes! < 10 ?
                              '0${snapshot.data![index].minutes!}       [hh:mm]'
                                : '${snapshot.data![index].minutes!}      [hh:mm]'}',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          //trailing: Text('$index'),
                          onTap: () => _onCardTap(
                              snapshot.data![index].date!, snapshot.data![index].id!),
                          ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext content, int index) =>
                    Divider(color: Colors.orange),
                itemCount: snapshot.data!.length,

              );
            }
            ),
      ),
    );
  }

  Future<void> _scrollToIndex() async {

      final _lastRow = await dbHelper.grabRowsCount();
      final _searchedRow = await dbHelper.grabRowID(_uref);

      if (_uref == null || _uref! < 5) {
        await controller!
            .scrollToIndex(_lastRow, preferPosition: AutoScrollPosition.end);
      } else {
        await controller!.scrollToIndex(_searchedRow,
            preferPosition: AutoScrollPosition.middle);
      }

      setState(() {  });
  }
}
  

