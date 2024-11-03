import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watalygold/Database/Databasesqlite.dart';
import 'package:watalygold/Database/User_DB.dart';
import 'package:watalygold/Home/Onboarding/onboarding_screen.dart';
import 'package:watalygold/Home/Quality/WeightNumberTest.dart';

import 'package:watalygold/Home/Quality/test.dart';
import 'Home/basepage.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

String? _deviceId;

Future<String?> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id; // Unique ID on Android
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor; // Unique ID on iOS
  }
  return null;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Gemini.init(apiKey: "AIzaSyByGLUAfh3-KjTmTY2MV_i32u2MJFUtEDE");
  Gemini.init(apiKey: "AIzaSyCj01DiXYWv5bP6JzrBiYDAsbBnSpFAal0");

  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;
  // prefs.setBool("checkhowtouse", false);
  debugPrint("$onboarding");

  final mobileDeviceIdentifier = await getDeviceId();
  print('Device ID: $mobileDeviceIdentifier');
  prefs.setString("device", mobileDeviceIdentifier!);
  await DatabaseService().database;
  // await DatabaseService().deleteDatabases(await getDatabasesPath());
  if (await DatabaseService().isDatabaseExists()) {
    final results = await User_db()
        .create(user_ipaddress: mobileDeviceIdentifier.toString());

    log('Database exists!');
  } else {
    log('Database does not exist.');
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
    log('No cameras available');
    return;
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale('th', 'TH'),
      supportedLocales: [
        const Locale('th', 'TH'),
        const Locale('en', 'US'),
      ],
      // initialRoute: '/base', // กำหนด initialRoute หรือหน้าแรกของแอพ
      routes: {
        '/base': (context) => BasePage(camera: cameras),
        // '/base': (context) => const ResultPage(),
      },
      theme: ThemeData(
        fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,
      ),
      title: "Wataly Gold",
      // home: const Myonboardingscreen(),
      home: onboarding
          ? BasePage(camera: cameras)
          : Myonboardingscreen(camera: cameras),
      // home: const Testing(),
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
