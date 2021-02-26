import 'dart:io';

import 'package:adr_timesheet/pages/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('looking for the path provider directory', (WidgetTester tester) async{

  setUpAll(() async {
    //temporary directory
    final directory = await Directory.systemTemp.createTemp();
    print(directory);
    //Mock out the MethodChannel for the plug_provider plugin
    const MethodChannel('plugins.flutter.io/path_provider')
      .setMockMethodCallHandler((MethodCall methodCall) async {
      //if you get the app documents directory, return the path of temp directory on the test env
      if(methodCall.method == 'getApplicationDocumentsDirectory'){
        return null;
      }
    });
  });

    // Build our app and trigger a frame.
    await tester.pumpWidget(DownloadsPathProviderApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}