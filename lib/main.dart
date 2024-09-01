import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watalygold/Database/Databasesqlite.dart';
import 'package:watalygold/Database/User_DB.dart';
import 'package:watalygold/Home/Onboarding/onboarding_screen.dart';
import 'package:watalygold/Home/Quality/WeightNumber.dart';
import 'Home/basepage.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

String? _deviceId;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;
  debugPrint("$onboarding");

  _deviceId = await PlatformDeviceId.getDeviceId;
  log(_deviceId!);
  await DatabaseService().database;
  // await DatabaseService().deleteDatabases(await getDatabasesPath());
  if (await DatabaseService().isDatabaseExists()) {
    final results = await User_db().create(user_ipaddress: _deviceId!);

    // try {
    //   final r_id = await Result_DB().create(
    //       user_id: 1,
    //       another_note: "anotherNote",
    //       quality: "grade",-
    //       lenght: 1.toDouble(),
    //       width: 2.toDouble(),
    //       weight: 3.toDouble());
    //   log(r_id);
    // } on Exception catch (e) {
    //   stdout.writeln(e);
    // }
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
      ],
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
          ? WeightNumber(camera: cameras)
          // ? BasePage(camera: cameras)
          // ? WeightNumber()
          : Myonboardingscreen(camera: cameras),
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

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:image_picker/image_picker.dart';

// void main() {
//   runApp(const App());
// }

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Text Recognition Flutter',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SevenSegmentOCRScreen(),
//     );
//   }
// }

// class SevenSegmentOCRScreen extends StatefulWidget {
//   @override
//   _SevenSegmentOCRScreenState createState() => _SevenSegmentOCRScreenState();
// }

// class _SevenSegmentOCRScreenState extends State<SevenSegmentOCRScreen> {
//   String recognizedNumber = '';

//   Future<void> processImage(ImageSource source) async {
//     final imageFile = await getImage(source);
//     if (imageFile != null) {
//       final ocrText = await performOCR(imageFile);
//       final number = extractNumber(ocrText);
//       setState(() {
//         recognizedNumber = number;
//       });
//     }
//   }

//   Future<File?> getImage(ImageSource source) async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: source);
//     return image != null ? File(image.path) : null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Seven Segment OCR')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Recognized Number: $recognizedNumber'),
//             ElevatedButton(
//               onPressed: () => processImage(ImageSource.camera),
//               child: Text('Capture Seven Segment Display'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => processImage(ImageSource.gallery),
//               child: Text('Upload Seven Segment Display Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<String> performOCR(File imageFile) async {
//     final InputImage inputImage = InputImage.fromFile(imageFile);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final RecognizedText recognizedText =
//         await textRecognizer.processImage(inputImage);

//     String text = recognizedText.text;
//     textRecognizer.close();

//     return text;
//   }

//   String extractNumber(String ocrText) {
//     // Keep digits and decimal point
//     return ocrText.replaceAll(RegExp(r'[^0-9.]'), '');
//   }
// }

// // import 'dart:io';
// // import 'package:image/image.dart' as img;
// // import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// // import 'package:camera/camera.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:watalygold/Textrecognition/result_screen.dart';

// // void main() {
// //   runApp(const App());
// // }

// // class App extends StatelessWidget {
// //   const App({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Text Recognition Flutter',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: const MainScreen(),
// //     );
// //   }
// // }

// // class MainScreen extends StatefulWidget {
// //   const MainScreen({super.key});

// //   @override
// //   State<MainScreen> createState() => _MainScreenState();
// // }

// // class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
// //   bool _isPermissionGranted = false;

// //   late final Future<void> _future;
// //   CameraController? _cameraController;

// //   final textRecognizer = TextRecognizer();

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addObserver(this);

// //     _future = _requestCameraPermission();
// //   }

// //   @override
// //   void dispose() {
// //     WidgetsBinding.instance.removeObserver(this);
// //     _stopCamera();
// //     textRecognizer.close();
// //     super.dispose();
// //   }

// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) {
// //     if (_cameraController == null || !_cameraController!.value.isInitialized) {
// //       return;
// //     }

// //     if (state == AppLifecycleState.inactive) {
// //       _stopCamera();
// //     } else if (state == AppLifecycleState.resumed &&
// //         _cameraController != null &&
// //         _cameraController!.value.isInitialized) {
// //       _startCamera();
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return FutureBuilder(
// //       future: _future,
// //       builder: (context, snapshot) {
// //         return Stack(
// //           children: [
// //             if (_isPermissionGranted)
// //               FutureBuilder<List<CameraDescription>>(
// //                 future: availableCameras(),
// //                 builder: (context, snapshot) {
// //                   if (snapshot.hasData) {
// //                     _initCameraController(snapshot.data!);

// //                     return Center(child: CameraPreview(_cameraController!));
// //                   } else {
// //                     return const LinearProgressIndicator();
// //                   }
// //                 },
// //               ),
// //             Scaffold(
// //               appBar: AppBar(
// //                 title: const Text('Text Recognition Sample'),
// //               ),
// //               backgroundColor: _isPermissionGranted ? Colors.transparent : null,
// //               body: _isPermissionGranted
// //                   ? Column(
// //                       children: [
// //                         Expanded(
// //                           child: Container(),
// //                         ),
// //                         Container(
// //                           padding: const EdgeInsets.only(bottom: 30.0),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                             children: [
// //                               ElevatedButton(
// //                                 onPressed: _scanImage,
// //                                 child: const Text('Scan text'),
// //                               ),
// //                               ElevatedButton(
// //                                 onPressed: _pickImage,
// //                                 child: const Text('Upload Image'),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     )
// //                   : Center(
// //                       child: Container(
// //                         padding: const EdgeInsets.only(left: 24.0, right: 24.0),
// //                         child: const Text(
// //                           'Camera permission denied',
// //                           textAlign: TextAlign.center,
// //                         ),
// //                       ),
// //                     ),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Future<void> _requestCameraPermission() async {
// //     final status = await Permission.camera.request();
// //     _isPermissionGranted = status == PermissionStatus.granted;
// //   }

// //   void _startCamera() {
// //     if (_cameraController != null) {
// //       _cameraSelected(_cameraController!.description);
// //     }
// //   }

// //   void _stopCamera() {
// //     if (_cameraController != null) {
// //       _cameraController?.dispose();
// //     }
// //   }

// //   void _initCameraController(List<CameraDescription> cameras) {
// //     if (_cameraController != null) {
// //       return;
// //     }

// //     // Select the first rear camera.
// //     CameraDescription? camera;
// //     for (var i = 0; i < cameras.length; i++) {
// //       final CameraDescription current = cameras[i];
// //       if (current.lensDirection == CameraLensDirection.back) {
// //         camera = current;
// //         break;
// //       }
// //     }

// //     if (camera != null) {
// //       _cameraSelected(camera);
// //     }
// //   }

// //   Future<void> _cameraSelected(CameraDescription camera) async {
// //     _cameraController = CameraController(
// //       camera,
// //       ResolutionPreset.max,
// //       enableAudio: false,
// //     );

// //     await _cameraController!.initialize();
// //     await _cameraController!.setFlashMode(FlashMode.off);

// //     if (!mounted) {
// //       return;
// //     }
// //     setState(() {});
// //   }

// //   Future<void> _scanImage() async {
// //     if (_cameraController == null) return;

// //     final navigator = Navigator.of(context);

// //     try {
// //       final pictureFile = await _cameraController!.takePicture();

// //       final file = File(pictureFile.path);

// //       final inputImage = InputImage.fromFile(file);
// //       final recognizedText = await textRecognizer.processImage(inputImage);

// //       await navigator.push(
// //         MaterialPageRoute(
// //           builder: (BuildContext context) =>
// //               ResultScreen(text: recognizedText.text),
// //         ),
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('An error occurred when scanning text'),
// //         ),
// //       );
// //     }
// //   }

// //   Future<void> _pickImage() async {
// //     final ImagePicker _picker = ImagePicker();
// //     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

// //     if (image != null) {
// //       final file = File(image.path);
// //       final inputImage = InputImage.fromFile(file);
// //       final recognizedText = await textRecognizer.processImage(inputImage);
// //       print("recognizedText.text = ${recognizedText.text}");

// //       // กรองเฉพาะตัวเลข
// //       // final String numbersOnly = _extractNumbers(recognizedText.text);
// //       // print(recognizedText.text);

// //       // ส่งเฉพาะตัวเลขไปที่หน้าผลลัพธ์
// //       Navigator.of(context).push(
// //         MaterialPageRoute(
// //           builder: (BuildContext context) => ResultScreen(text: recognizedText.text),
// //         ),
// //       );
// //     }
// //   }

// //   // String _extractNumbers(String text) {
// //   //   final RegExp regExp = RegExp(r'\d+'); // กรองเฉพาะตัวเลข
// //   //   Iterable<RegExpMatch> matches = regExp.allMatches(text);
// //   //   return matches
// //   //       .map((m) => m.group(0))
// //   //       .join(' '); // รวมผลลัพธ์เป็น string เดียว
// //   // }
// // }
