import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watalygold/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

void main() {}

class NumericData {
  NumericData(
      {required this.domain, required this.measure, required this.pointLabel});
  final double domain;
  final double? measure;
  final String pointLabel;
}

class ExportPrice extends StatefulWidget {
  const ExportPrice({super.key});

  @override
  State<ExportPrice> createState() => _ExportPriceState();
}

class _ExportPriceState extends State<ExportPrice> {
  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late TooltipBehavior _tooltipBehavior;
  String formattedDate = DateFormat('yyyy-M-d').format(DateTime.now());
  // void _updateExportPrice() {
  //   String formattedDate = DateFormat('yyyy-M-d').format(DateTime.now());
  //   updateExportPrice(formattedDate);
  // }

  @override
  void initState() {
    super.initState();
    _dateController.text =
        DateFormat('d/M/yyyy').format(selectedDate); //ตั้งค่าเร่ิมต้น
    checkDataForSelectedDate(context);
    fetchDataAndSaveToFirestore(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale("th", "TH"),
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData().copyWith(
            colorScheme: ColorScheme.dark(
              primary: GPrimaryColor, // header background color
              onPrimary: YPrimaryColor, // text color on header background
              surface: Colors.white, // dialog background color
              onSurface: Colors.black, // text color on dialog background
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('d/M/yyyy').format(picked);
      });
      fetchDataAndSaveToFirestore(context);
      await checkDataForSelectedDate(context);
    }
  }

  Future<void> checkDataForSelectedDate(BuildContext context) async {
    try {
      final formattedDate = DateFormat('M/d/yyyy').format(selectedDate);

      final docSnapshot = await FirebaseFirestore.instance
          .collection('ExportPrice')
          .doc('new_ExportPrice')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final priceList = data['price_list'] as List<dynamic>?;

        if (priceList != null &&
            priceList.any((priceItem) => priceItem['date'] == formattedDate)) {
          return;
        }
      }
      showNoDataDialog(context);
    } catch (error) {
      print('Error checking data: $error');
    }
  }

  Future<void> fetchDataAndSaveToFirestore(BuildContext context) async {
    DateTime selectedDate = this.selectedDate;
    DateTime endOfMonth = DateTime(selectedDate.year, selectedDate.month + 1,
        0); //+1 และ 0 ทำให้ได้วันสุดท้ายของเดือน
    String toDate = DateFormat('yyyy-MM-dd').format(endOfMonth);
    debugPrint("toDate ${toDate}");
    final apiUrl =
        "https://dataapi.moc.go.th/gis-product-prices?product_id=W14024&from_date=2018-01-01&to_date=$toDate";
    debugPrint(apiUrl);
    //     "https://dataapi.moc.go.th/gis-product-prices?product_id=W14024&from_date=2018-01-01&to_date=2030-02-28";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // แปลงวันที่ในรูปแบบ timestamp เป็นรูปแบบ "1/3/2018"
        final List<dynamic> priceList = data['price_list'];
        for (int i = 0; i < priceList.length; i++) {
          final DateTime dateTime = DateTime.parse(priceList[i]['date']);
          final formattedDate =
              '${dateTime.month}/${dateTime.day}/${dateTime.year}';
          priceList[i]['date'] = formattedDate;
        }

        // เพิ่มข้อมูลลงใน Firestore ด้วย Firebase Firestore API
        await FirebaseFirestore.instance
            .collection('ExportPrice')
            .doc('new_ExportPrice')
            .set(data);

        stdout.writeln(
            'Data fetched from API and saved to Firestore successfully.');
      } else {
        stdout.writeln('Failed to fetch data from API: ${response.statusCode}');
      }
    } catch (error) {
      stdout.writeln('Error fetching data from API: $error');
    }
  }

  void showNoDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              color: WhiteColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              border: Border(
                bottom: BorderSide(
                  color: GPrimaryColor,
                  width: 10,
                ),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.red.shade400,
                          size: 35,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'ไม่พบข้อมูล',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'ไม่พบข้อมูลราคาตลาดกลางสำหรับวันที่ ${DateFormat('d/M/yyyy').format(selectedDate)} สามารถตรวจสอบได้ที่ ',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        InkWell(
                          onTap: () {
                            launch('https://data.moc.go.th');
                          },
                          child: Text(
                            'https://data.moc.go.th',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    child: Text('ตกลง',
                        style: TextStyle(color: GPrimaryColor, fontSize: 16)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F5),
      appBar: Appbarmain_no_botton(
        name: "ตลาดกลาง",
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ExportPrice')
            .doc('new_ExportPrice')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: WhiteColor,
                secondRingColor: GPrimaryColor,
                thirdRingColor: YPrimaryColor,
                size: 200,
              ),
            );
          }

          Map<String, dynamic>? data =
              snapshot.data?.data() as Map<String, dynamic>?;

          if (data == null || data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 80,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "ตอนนี้คุณไม่ได้เชื่อมต่ออินเทอร์เน็ต",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Do not dismiss the modal here, let _updateNoInternetState handle it
                  //   },
                  //   style: ButtonStyle(
                  //     backgroundColor:
                  //         MaterialStateProperty.all(Colors.red.shade300),
                  //   ),
                  //   child: const Text(
                  //     "ลองใหม่",
                  //     style: TextStyle(color: WhiteColor, fontSize: 15),
                  //   ),
                  // ),
                ],
              ),
            );
          }

          String? unit = data['unit'];

          List<dynamic> yourList = data['price_list'] ?? [];

          dynamic filteredItem = yourList.firstWhereOrNull((item) =>
              item['date'] == DateFormat('M/d/yyyy').format(selectedDate));

          List<dynamic> monthData = yourList.where((item) {
            DateTime itemDate = DateFormat('M/d/yyyy').parse(item['date']);
            return itemDate.year == selectedDate.year &&
                itemDate.month == selectedDate.month;
          }).toList();

          List<NumericData> maxDataList = monthData.map((item) {
            DateTime itemDate = DateFormat('M/d/yyyy').parse(item['date']);
            return NumericData(
              domain: itemDate.day.toDouble(),
              measure: (item['price_max'] ?? 0).toDouble(),
              pointLabel: item['date'],
            );
          }).toList();

          List<NumericData> minDataList = monthData.map((item) {
            DateTime itemDate = DateFormat('M/d/yyyy').parse(item['date']);
            return NumericData(
              domain: itemDate.day.toDouble(),
              measure: (item['price_min'] ?? 0).toDouble(),
              pointLabel: item['date'],
            );
          }).toList();

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "ราคาตลาดกลาง",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: GPrimaryColor,
                        width: 4.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 33, right: 29, top: 30, bottom: 20),
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'เลือกวันที่',
                          labelStyle: TextStyle(
                            color: const Color(0xFF767676),
                            fontSize: 18,
                          ),
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
                          ),
                        ),
                        readOnly: true,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 160,
                  width: 325,
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(bottom: 25),
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
                        padding: EdgeInsets.only(bottom: 15, left: 60),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: GPrimaryColor,
                                width: 3.0,
                              ),
                            ),
                          ),
                          child: Text(
                            "ราคาวันที่ ${_dateController.text}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5, left: 20),
                        child: Text(
                          filteredItem != null
                              ? "ราคา ${filteredItem['price_max'] ?? ''} ${filteredItem['price_min'] != null ? '- ${filteredItem['price_min']}' : ''} ${unit ?? ''}"
                              : "ราคา  ${unit ?? ''}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                text: "ราคาสูงสุด ",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: const Color.fromARGB(255, 5, 5, 5),
                                ),
                              ),
                              TextSpan(
                                text: "${filteredItem?['price_max'] ?? ' '} ",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: GPrimaryColor,
                                ),
                              ),
                              TextSpan(
                                text: "${unit ?? ' '}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: const Color.fromARGB(255, 2, 5, 5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                text: "ราคาต่ำสุด ",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: const Color.fromARGB(255, 5, 5, 5),
                                ),
                              ),
                              TextSpan(
                                text: "${filteredItem?['price_min'] ?? ' '} ",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: const Color(0xFFFBBD17),
                                ),
                              ),
                              TextSpan(
                                text: "${unit ?? ' '}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: const Color.fromARGB(255, 2, 5, 5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(children: <Widget>[
                  Expanded(
                      child: Divider(
                    color: GPrimaryColor,
                    thickness: 2.0,
                  )),
                  SizedBox(width: 8.0),
                  Text(
                    "กราฟราคา",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                      child: Divider(
                    color: GPrimaryColor,
                    thickness: 2.0,
                  )),
                ]),
                Padding(
                  padding: EdgeInsets.all(7),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          SfCartesianChart(
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              color: Colors.white,
                              textStyle:
                                  TextStyle(color: Colors.black, fontSize: 14),
                              borderColor: Colors.grey,
                              borderWidth: 1,
                              duration: 3000,
                              animationDuration: 500,
                            ),
                            series: <CartesianSeries<NumericData, double>>[
                              // ... (ส่วนของ series คงเดิม)
                            ],
                          ),
                          if (maxDataList.isEmpty && minDataList.isEmpty)
                            Positioned.fill(
                              child: Container(
                                color: Colors.white.withOpacity(
                                    0.7), // เพิ่มพื้นหลังโปร่งแสงเพื่อให้ข้อความชัดเจนขึ้น
                                child: Center(
                                  child: Text(
                                    'ไม่พบข้อมูลราคาตลาดกลางสำหรับเดือนนี้',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
