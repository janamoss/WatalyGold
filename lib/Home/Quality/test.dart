import 'dart:convert';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/WeightNumber/DialogAlertWNbyGemini.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  Future<void> analyzeImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path);
      final gemini = Gemini.instance;
      final result = await gemini.textAndImage(
        text:
            """The picture that you checked, please help me identify whether this is a mango or not. 
            If it is a mango, answer "mango". If it is not a mango, answer "not mango".""",
        images: [file.readAsBytesSync()],
      );

      final geminiText = result?.content?.parts?.last.text ?? '';
      debugPrint("Gemini response: $geminiText");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                String? results = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return Dialog_WN_Gemini(
                      number: "258.6 g",
                    );
                  },
                );

                if (results!.isNotEmpty) {
                  if (results == "") {
                    debugPrint("ไม่มีน้ำหนักที่ได้มา");
                  } else {
                    debugPrint(results);
                    // useFunctionandresult();
                    // ทำอะไรต่อกับ results ตามที่ต้องการ
                  }
                } else {
                  debugPrint("น้ำหนักไม่ถูกต้อง");
                  debugPrint("น้ำหนักที่ได้มา : $results");
                }
              },
              child: Text('Analyze Image'),
            ),
          )
        ],
      ),
    );
  }
}
