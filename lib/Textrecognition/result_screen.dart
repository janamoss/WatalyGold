import 'package:flutter/material.dart';
import 'dart:io';

class ResultScreen extends StatelessWidget {
  final String text;
  final File img; 

  const ResultScreen({super.key, required this.text, required this.img});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: SingleChildScrollView( // เพิ่มเพื่อเลื่อนเนื้อหาได้หากยาวเกิน
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              // แสดงรูปภาพ
              Image.file(
                img,
                width: 300,
                height: 300,
              ),
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
}
