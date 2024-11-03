import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:screenshot/screenshot.dart';

final _screenshotController = ScreenshotController();

class ResultScreen extends StatelessWidget {
  final String text;
  final File img;
  // final String imagePath;

  // const ResultScreen({super.key, required this.imagePath});
  const ResultScreen({super.key, required this.text, required this.img,});

  @override
  Widget build(BuildContext context) => Scaffold(
     // Integrate Gemini

      // gemini.countTokens("Write a story about a magic backpack.")
      // gemini
      //     .countTokens(text,img)
      //     .then((value) => print("countTokens ${value}"))

      //     /// output like: `6` or `null`
      //     .catchError((e) => log('countTokens', error: e));

        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // แสดงรูปภาพ
              Image.file(
                img,

              ),
              // Container(child: screenshot()),

              const SizedBox(height: 20),
              // แสดงข้อความ
              Text(
                text,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      );
  Widget screenshot() {
    return Screenshot(
      controller: _screenshotController,
      child: Stack(
        children: [
          SizedBox(
            child: Positioned(
              left: 50,
              top: 250,
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';

// class ResultScreen extends StatefulWidget {
//   final String text;
//   final File img;

//   const ResultScreen({
//     super.key, 
//     required this.text, 
//     required this.img,
//   });

//   @override
//   State<ResultScreen> createState() => _ResultScreenState();
// }

// class _ResultScreenState extends State<ResultScreen> {
//   int? tokenCount;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize the Gemini instance
//     final gemini = Gemini.instance;

//     // Read the image as bytes
//     // final imageBytes = widget.img.readAsBytesSync();

//     // // Call the API to count tokens, passing both text and image
//     // gemini.textAndImage(
//     //   text: widget.text,
//     //   images: [imageBytes], // Send the image as bytes
//     // ).then((value) {
//     //   // Get token count from the response
//     //   final extractedText = value?.content?.parts?.last.text ?? '';
//     //   // Optional: Extract numbers from text if required
//     //   final extractedNumbers = _extractNumbersGeminiText(extractedText);

//     //   setState(() {
//     //     tokenCount = extractedNumbers != null ? extractedNumbers.length : null;
//     //   });
//     //   print("Token count: ${extractedNumbers!.length}");
//     // }).catchError((e) {
//     //   print('textAndImage error: $e');
//     // });


// gemini.countTokens()
//     .then((value) => print(value)) /// output like: `6` or `null`
//     .catchError((e) => log('countTokens', error: e));
//   }
//   String? _extractNumbersGeminiText(String response) {
//     final regex = RegExp(r"(\d+(\.\d*)?)\s([a-zA-Z]+)");
//     final match = regex.firstMatch(response);
//     if (match != null) {
//       final number = match.group(1);
//       final unit = match.group(3);
//       return "$number $unit";
//     }
//     return "รูปที่คุณถ่ายไม่ใช่เครื่องชั่งน้ำหนัก";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Result'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Display the image
//             Image.file(
//               widget.img,
//             ),
//             const SizedBox(height: 20),
//             // Display the text
//             Text(
//               widget.text,
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 20),
//             // Display the token count
//             Text(
//               'Token count: ${tokenCount ?? "Loading..."}',
//               style: const TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// //