import 'dart:io';
import 'dart:async';

import 'package:adr_timesheet/models/counter_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class FlutterDemo extends StatefulWidget {

  final CounterStorage storage;

  const FlutterDemo({Key key, this.storage}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {

  int _counter;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter(){
    setState(() {
      _counter++;
    });
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading and Writing Files')),
      body: SafeArea(
          child: Text(
            'Button tapped $_counter time${_counter == 1 ? '' : 's'}.',
          ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
      ),
    );
  }
}
