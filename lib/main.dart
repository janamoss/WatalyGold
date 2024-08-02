import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watalygold/Database/Databasesqlite.dart';
import 'package:watalygold/Database/Result_DB.dart';
import 'package:watalygold/Database/User_DB.dart';
import 'package:watalygold/Home/UserManual/UserManual.dart';
import 'Home/basepage.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

String? _deviceId;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _deviceId = await PlatformDeviceId.getDeviceId;
  stdout.writeln(_deviceId);
  await DatabaseService().database;
  // await DatabaseService().deleteDatabases(await getDatabasesPath());
  if (await DatabaseService().isDatabaseExists()) {
    final results = await User_db().create(user_ipaddress: _deviceId!);
    // try {
    //   final r_id = await Result_DB().create(
    //       user_id: 1,
    //       another_note: "anotherNote",
    //       quality: "grade",
    //       lenght: 1.toDouble(),
    //       width: 2.toDouble(),
    //       weight: 3.toDouble());
    //   stdout.writeln(r_id);
    // } on Exception catch (e) {
    //   stdout.writeln(e);
    // }
    stdout.writeln('Database exists!');
  } else {
    stdout.writeln('Database does not exist.');
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseFunctions.instanceFor(region: 'asia-southeast1')
  //     .useFunctionsEmulator('192.168.1.120', 5001);
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  if (cameras.isEmpty) {
    // Handle the case where no cameras are available
    stdout.writeln('No cameras available');
    return;
  }
  runApp(
    MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('th', 'TH'),
        const Locale('en', 'US'),
      ],
      // initialRoute: '/base', // กำหนด initialRoute หรือหน้าแรกของแอพ
      // routes: {
      //   '/base': (context) => BasePage(camera: cameras),
      //   // '/base': (context) => const ResultPage(),
      // },
      theme: ThemeData(
        fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,
      ),
      title: "Wataly Gold", 
      // home: const ResultPage(),
      home: const UserManual(),
      // home: BasePage(camera: cameras),
      builder: EasyLoading.init(),
    ),
  );
}

// Future<void> main() async {
//   // Ensure that plugin services are initialized so that `availableCameras()`
//   // can be called before `runApp()`
//   WidgetsFlutterBinding.ensureInitialized();

//   // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();

//   // Get a specific camera from the list of available cameras.
//   final firstCamera = cameras.first;

//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: TakePictureScreen(
//         // Pass the appropriate camera to the TakePictureScreen widget.
//         camera: firstCamera,
//       ),
//     ),
//   );
// }

