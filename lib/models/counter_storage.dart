import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';



class CounterStorage {

  Future<String> get _localPath async{
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async{
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  // ignore: public_member_api_docs
  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      final content =await file.readAsString();
      return int.parse(content);
    } on Exception catch (e) {
      print('$e from the readCounter');
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }

  Future<String> get _localPathDoc async{
    final directory = await DownloadsPathProvider.downloadsDirectory;
    return directory.path;
  }

  Future<File> get _localFileDoc async{
    final path = await _localPathDoc;
    print('$path');
    return File('$path/counter.txt');
  }

  Future<File> writeDocuments(int counter) async {
    final file = await _localFileDoc;
    return file.writeAsString('$counter');
  }

  Future<int> readDocument() async {
    try {
      final file = await _localFileDoc;
      final content = await file.readAsString();
      return int.parse(content);
    } on Exception catch (e) {
      print('$e from the readCounter');
      return 0;
    }
  }

}