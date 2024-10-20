import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

import 'package:screenshot/screenshot.dart';

final _screenshotController = ScreenshotController();

class ResultScreen extends StatelessWidget {
  final String text;
  final img.Image imgs;
  // final String imagePath;

  // const ResultScreen({super.key, required this.imagePath});
  const ResultScreen({
    super.key,
    required this.text,
    required this.imgs,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // แสดงรูปภาพ
              // Image.file(
              //   img,

              // ),
              Image.memory(Uint8List.fromList(img.encodePng(imgs))),
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
