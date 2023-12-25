import 'package:flutter/material.dart';
import 'package:watalygold/widget/Color.dart';
import 'package:http/http.dart' as http;


void main() {}

class ExportPrice extends StatefulWidget {
  const ExportPrice({super.key});

  @override
  State<ExportPrice> createState() => _ExportPriceState();
}

class _ExportPriceState extends State<ExportPrice> {
  TextEditingController _dateController = TextEditingController();
  
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
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            child: Text(
              "ราคาตลาดกลาง",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            margin: EdgeInsets.only(top: 30),
          ),
          Container(
            padding: EdgeInsets.all(50),
            child: TextField(
              controller: _dateController,
              decoration: InputDecoration(
                  labelText: 'เลือกวันที่',
                  labelStyle: TextStyle(color: const Color(0xFF767676)),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: const Color(0xFF767676),
                  ),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: GPrimaryColor),
                  )),
              readOnly: true,
            ),
          ),
          Container(
              height: 190,
              width: 325,
              // color: GPrimaryColor,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0.2,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "ราคาวันที่",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ])
                  )
        ])
        );
  }
}
