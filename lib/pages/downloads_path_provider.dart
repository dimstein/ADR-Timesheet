import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:adr_timesheet/models/counter_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class DownloadsPathProviderApp extends StatefulWidget {

  final CounterStorage storage;

  const DownloadsPathProviderApp({Key key, this.storage}) : super(key: key);

  @override
  _DownloadsPathProviderAppState createState() => _DownloadsPathProviderAppState();
}

class _DownloadsPathProviderAppState extends State<DownloadsPathProviderApp> {

  int _counter=0;
  String doc;
  String data;
  String dataExt;


  String txt='vault';

  @override
  void initState() {
    super.initState();
    writeContent();
    writeDoc();
    readContent().then((String value) {
      setState(() {
        data = value;
      });
    });
    readDocument().then((String value) {setState(() {
      dataExt = value;
    });
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
   return directory.path;
  }

  Future<String> get _documentPath async{
    final docStorage = await getExternalStorageDirectory();
    return docStorage.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> get _documentFile async{
    final path = await _documentPath;
    doc=path;
    return File('$path/data.txt');
  }

  Future<File> writeContent() async {
    final file = await _localFile;
    return file.writeAsString('Hello Folks');
  }

  Future<File> writeDoc() async {
    final file = await _documentFile;
    return file.writeAsString('What is in the vault Rocky now!');
  }

  Future<String> readContent() async{
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents;
    } on Exception catch (e) {
      return 'Error readContent: $e';
    }
  }

  Future<String> readDocument() async{
    try {
      final file = await _documentFile;
      final contents = await file.readAsString();
      return contents;
    } on Exception catch (e) {
      return 'Error readDocument: $e';
    }
  }


  Future<File> _actionSaved(){
    setState(() {
      _counter++;
    });
    return widget.storage.writeDocuments(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Downloads Directory example app'),
        ),
        body: Center(
          child: Column(
            children: [
            Text(doc !=null
               ? 'Downloads directory: $doc\n : holds: $dataExt'
                 : 'Could not get the downloads directory: $txt'
             ),
              RaisedButton(
                child: Text('Saved the file $_counter'),
                  onPressed: (){
                    _actionSaved();

                  })

            ],
          )
          ),
      ),
    );
  }
}
