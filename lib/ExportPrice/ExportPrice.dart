import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watalyGold/widget/Color.dart';

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
    _tooltipBehavior = TooltipBehavior(enable: true);
    fetchDataAndSaveToFirestore();
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
              colorScheme: const ColorScheme.dark(
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
      fetchDataAndSaveToFirestore() ;
    }
  }
  
 Future<void> fetchDataAndSaveToFirestore() async {
  const apiUrl =
      "https://dataapi.moc.go.th/gis-product-prices?product_id=W14024&from_date=2018-01-01&to_date=2030-02-28";
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // แปลงวันที่ในรูปแบบ timestamp เป็นรูปแบบ "1/3/2018"
      final List<dynamic> priceList = data['price_list'];
      for (int i = 0; i < priceList.length; i++) {
        final DateTime dateTime = DateTime.parse(priceList[i]['date']);
        final formattedDate = '${dateTime.month}/${dateTime.day}/${dateTime.year}';
        priceList[i]['date'] = formattedDate;
      }

      // เพิ่มข้อมูลลงใน Firestore ด้วย Firebase Firestore API
      await FirebaseFirestore.instance
          .collection('ExportPrice')
          .doc('new_ExportPrice')
          .set(data);
      
      print('Data fetched from API and saved to Firestore successfully.');
    } else {
      print('Failed to fetch data from API: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching data from API: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F5),
      appBar: AppBar(
        title: const Text(
          "ราคาตลาดกลาง",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: GPrimaryColor,
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
            return const Text('Loading...');
          }

          Map<String, dynamic>? data =
              snapshot.data?.data() as Map<String, dynamic>?;

          if (data == null || data.isEmpty) {
            return const Text('No data available');
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

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: GPrimaryColor,
                      width: 4.0,
                    ),
                  ),
                ),
                child: const Text(
                  "ราคาตลาดกลาง",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 33, right: 29, top: 30, bottom: 20),
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: 'เลือกวันที่',
                        labelStyle: TextStyle(
                          color: Color(0xFF767676),
                          fontSize: 18,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Color(0xFF767676),
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
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0.2,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 60),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: GPrimaryColor,
                              width: 3.0,
                            ),
                          ),
                        ),
                        child: Text(
                          "ราคาวันที่ ${_dateController.text}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, left: 20),
                      child: Text(
                        "ราคา  ${filteredItem?['price_max'] ?? ' '} - ${filteredItem?['price_min'] ?? ' '} ${unit ?? ' '}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            const TextSpan(
                              text: "ราคาสูงสุด ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 5, 5, 5),
                              ),
                            ),
                            TextSpan(
                              text: "${filteredItem?['price_max'] ?? ' '} ",
                              style: const TextStyle(
                                fontSize: 18,
                                color: GPrimaryColor,
                              ),
                            ),
                            TextSpan(
                              text: "${unit ?? ' '}",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 5, 5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            const TextSpan(
                              text: "ราคาต่ำสุด ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 5, 5, 5),
                              ),
                            ),
                            TextSpan(
                              text: "${filteredItem?['price_min'] ?? ' '} ",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFFFBBD17),
                              ),
                            ),
                            TextSpan(
                              text: "${unit ?? ' '}",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 5, 5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Row(children: <Widget>[
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
                padding: const EdgeInsets.all(7),
                child: SfCartesianChart(
                  tooltipBehavior: _tooltipBehavior,
                  series: <ChartSeries>[
                    LineSeries<NumericData, double>(
                      name: 'ราคาสูงสุด',
                      dataSource: maxDataList,
                      xValueMapper: (NumericData data, _) => data.domain,
                      yValueMapper: (NumericData data, _) => data.measure,
                      enableTooltip: true,
                      color: GPrimaryColor,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                        color: GPrimaryColor,
                        height: 5,
                        width: 5,
                      ),
                    ),
                    AreaSeries<NumericData, double>(
                     name: 'ราคาสูงสุด',
                      dataSource: maxDataList,
                      xValueMapper: (NumericData data, _) => data.domain,
                      yValueMapper: (NumericData data, _) => data.measure,
                      enableTooltip: true,
                      color: YPrimaryColor.withOpacity(0.2), 
                     
                    ),
                    LineSeries<NumericData, double>(
                      name: 'ราคาต่ำสุด',
                      dataSource: minDataList,
                      xValueMapper: (NumericData data, _) => data.domain,
                      yValueMapper: (NumericData data, _) => data.measure,
                      enableTooltip: true,
                      color: yellowColor,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                        color: yellowColor,
                        height: 5,
                        width: 5,
                      ),
                    ),
                     AreaSeries<NumericData, double>(
                      name: 'ราคาต่ำสุด',
                      dataSource: minDataList,
                      xValueMapper: (NumericData data, _) => data.domain,
                      yValueMapper: (NumericData data, _) => data.measure,
                      enableTooltip: true,
                      color: YPrimaryColor.withOpacity(0.2), 
                     
                    ),
                   
                    // AreaSeries<NumericData, double>(
                    //  name: 'ราคาสูงสุด',
                    //   dataSource: maxDataList,
                    //   xValueMapper: (NumericData data, _) => data.domain,
                    //   yValueMapper: (NumericData data, _) => data.measure,
                    //   enableTooltip: true,
                    //   color: GPrimaryColor.withOpacity(0.2), 
                     
                    // ),
                  ],
                  // primaryXAxis: NumericAxis(
                  //   edgeLabelPlacement: EdgeLabelPlacement.shift,
                  // ),
                  // primaryYAxis: NumericAxis(
                  //   labelFormat: '{value}',
                  // ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
