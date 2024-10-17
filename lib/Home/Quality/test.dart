import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/DialogHowtoUse.dart';
import 'package:watalygold/Widgets/WeightNumber/DialogAlertWNbyGemini.dart';
import 'package:watalygold/Widgets/WeightNumber/DialogHowtoUse_WN.dart';

final List<Map<String, String>> mangoImages = [
  {"image": "assets/images/f5.jpg", "label": "ด้านหน้า"},
  {"image": "assets/images/back5.jpg", "label": "ด้านหลัง"},
  {"image": "assets/images/Bottom5.jpg", "label": "ด้านล่าง"},
  {"image": "assets/images/top5.jpg", "label": "ด้านบน"},
];

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  PageController _controllerpage = PageController();
  int _currentPage = 0;

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

  // สร้างลิสต์ตามตัวอย่างที่คุณให้มา
  List<double> myValues = [
    1.0763513116720778,
    0.25597804509392824,
    0.14898399062066423,
    1.0783864144021538
  ];

  // ฟังก์ชันคำนวณอัตราส่วน
  List<double> calculateFixedPercentages(List<double> n) {
    List<double> percentages = [40, 40, 20, 20];

    double total = n.reduce((a, b) => a + b); // คำนวณผลรวม

    List<double> results = [];
    for (int i = 0; i < n.length; i++) {
      if (i < percentages.length) {
        double result = (percentages[i] / 100) * total;
        results.add(result);
      } else {
        results.add(0); // กรณีที่ n มีความยาวมากกว่าจำนวนเปอร์เซ็นต์ที่กำหนด
      }
    }

    return results;
  }

  // ตัวแปรเก็บผลลัพธ์
  double calculatedTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _controllerpage.addListener(() {
      setState(() {
        _currentPage = _controllerpage.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ผลลัพธ์การคำนวณ: $calculatedTotal',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // คำนวณผลลัพธ์เมื่อกดปุ่ม
              List<double> results = calculateFixedPercentages(myValues);

              // อัปเดตผลลัพธ์ในตัวแปร
              setState(() {
                calculatedTotal = results.reduce((a, b) => a + b);
              });
            },
            child: Text('Analyze Image'),
          ),
        ],
      ),
    );
  }
}
