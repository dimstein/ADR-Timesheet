import 'package:adr_timesheet/models/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class TimeSummaryPage extends StatefulWidget {
  final int uref;

  const TimeSummaryPage({Key key, this.uref}) : super(key: key);

  @override
  _TimeSummaryPageState createState() => _TimeSummaryPageState();
}

class _TimeSummaryPageState extends State<TimeSummaryPage> {
  final dbHelper = DatabaseHelper.instance;
  final scrollDirection = Axis.vertical;
  int _uref;
  AutoScrollController controller;

  @override
  void initState() {
    super.initState();
    _uref = widget.uref;

    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToIndex());
    //_scrollToIndex();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          initialData: [],
          future: dbHelper.grabAllTime(),
          builder: (context, snapshot) {
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
                      snapshot.data.remove(index);
                    });
                    await dbHelper.delete(snapshot.data[index].id);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('${snapshot.data[index].date} dismissed')));
                    // Scaffold.of(context)
                    // .showSnackBar(SnackBar(content: Text('${snapshot.data[index].date} dismissed')));
                  },
                  background: Container(
                    color: Colors.red[200],
                  ),
                  child: AutoScrollTag(
                    key: UniqueKey(),
                    controller: controller,
                    index: index,
                    child: Card(
                      key: Key('summary'),
                      child: ListTile(
                        leading: Text('${snapshot.data[index].id}'),
                        //leading: Icon(Icons.timelapse_outlined),
                        title: Text('${snapshot.data[index].date}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          '${snapshot.data[index].hours}:'
                          '${snapshot.data[index].minutes < 10 ? '0${snapshot.data[index].minutes}' : '${snapshot.data[index].minutes}'}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        trailing: Text('$index'),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext content, int index) =>
                  Divider(color: Colors.orange),
              itemCount: snapshot.data.length,
            );
          }

          // floatingActionButton: FloatingActionButton(
          //   onPressed: _scrollToIndex,
          //   tooltip: 'Increment',
          //   child: Icon(Icons.arrow_circle_down_sharp),
          // ),
          ),
    );
  }

  void _scrollToIndex() async {
    final _lastRow = await dbHelper.grabRowsCount();
    final _searchedRow = await dbHelper.grabRowID(_uref);

    _uref == null
        ? await controller.scrollToIndex(_lastRow,
            preferPosition: AutoScrollPosition.end)
        : await controller.scrollToIndex(_searchedRow,
            preferPosition: AutoScrollPosition.middle);
  }
}
