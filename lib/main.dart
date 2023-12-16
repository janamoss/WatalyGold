import 'package:flutter/material.dart';
import 'package:watalygold/Home/Quality/MainAnalysis.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Home/HomeApp.dart';
import 'Home/basepage.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  if (cameras.isEmpty) {
    // Handle the case where no cameras are available
    print('No cameras available');
    return;
  }

  runApp(
    MaterialApp(
      initialRoute: '/home', // กำหนด initialRoute หรือหน้าแรกของแอพ
      routes: {
        '/home': (context) =>
            Homeapp(camera: cameras), // กำหนด route สำหรับ BasePage
        // เพิ่ม routes อื่นๆ ตามต้องการ
      },
      theme: ThemeData(
        fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,
      ),
      title: "Wataly Gold",
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

