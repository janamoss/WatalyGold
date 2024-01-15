import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:watalygold/Home/Quality/MainAnalysis.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watalygold/Home/Quality/Result.dart';
import 'Home/HomeApp.dart';
import 'Home/basepage.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFunctions.instanceFor(region: 'asia-southeast1')
      .useFunctionsEmulator('127.0.0.1', 5001);
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  if (cameras.isEmpty) {
    // Handle the case where no cameras are available
    print('No cameras available');
    return;
  }
  runApp(
    MaterialApp(
      initialRoute: '/base', // กำหนด initialRoute หรือหน้าแรกของแอพ
      routes: {
        '/base': (context) => BasePage(camera: cameras),
        // '/base': (context) => const ResultPage(),
        '/home': (context) =>
            Homeapp(camera: cameras), // กำหนด route สำหรับ BasePage
        // เพิ่ม routes อื่นๆ ตามต้องการ
      },
      theme: ThemeData(
        fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,
      ),
      title: "Wataly Gold",
      // home: const ResultPage(),
      home: BasePage(camera: cameras),
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

