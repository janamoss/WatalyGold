import 'package:flutter/material.dart';
import 'package:watalygold/widget/Color.dart';
import 'package:watalygold/widget/knowledge/ExpansionTile.dart';

void main() {}

class knowledge extends StatefulWidget {
  const knowledge({super.key});

  @override
  State<knowledge> createState() => _knowledge();
}

class _knowledge extends State<knowledge> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xFFF2F6F5),
    appBar: AppBar(
      title: Text(
        "ราคาตลาดกลาง",
        style: TextStyle(
          fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: GPrimaryColor,
    ),
    body: SafeArea(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 45.3),
            width: 343,
            height: 80,
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                knowledgeTile(),
              ],
            ),
          ),
          SizedBox(height: 15), // สร้างระยะห่างระหว่าง Container ด้วย SizedBox
          
        ],
      ),
    ),
  );
  }
}
