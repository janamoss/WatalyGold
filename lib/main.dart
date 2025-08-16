import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watalygold/Database/Databasesqlite.dart';
import 'package:watalygold/Database/User_DB.dart';
import 'package:watalygold/Home/Model/Image_State.dart';
import 'package:watalygold/Home/Model/Model_Analysis.dart';
import 'package:watalygold/Home/Model/gemini_state.dart';
import 'package:watalygold/Home/Onboarding/onboarding_screen.dart';
import 'Home/basepage.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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

  Gemini.init(apiKey: "AIzaSyDuPAwyNPI0AYLbmIv5zdnC--bLnht4MB8");

  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;
  // prefs.setBool("checkhowtouse", false);
  debugPrint("$onboarding");

  final mobileDeviceIdentifier = await getDeviceId();
  prefs.setString("device", mobileDeviceIdentifier!);
  await DatabaseService().database;
  // await DatabaseService().deleteDatabases(await getDatabasesPath());
  if (await DatabaseService().isDatabaseExists()) {
    log('Database exists!');
  } else {
    log('Database does not exist.');
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final cameras = await availableCameras();
  if (cameras.isEmpty) {
    log('No cameras available');
    return;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModelState()),
        ChangeNotifierProvider(create: (_) => ImageState()),
        ChangeNotifierProvider(create: (_) => ProcessCountProvider()),
      ],
      child: MaterialApp(
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

