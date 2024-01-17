import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

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

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale("th", "TH"),
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('d/M/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF2F6F5),
        appBar: const Appbarmain_no_botton(name: 'ราคาตลาดกลาง'),
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('ExportPrice')
                .doc('new_ExportPrice')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }

              Map<String, dynamic>? data =
                  snapshot.data?.data() as Map<String, dynamic>?;

              if (data == null || data.isEmpty) {
                return Text('No data available');
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
                    padding: EdgeInsets.only(
                        left: 50, right: 50, top: 30, bottom: 20),
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
                            "ราคา  ${filteredItem?['price_max'] ?? ' '} - ${filteredItem?['price_min'] ?? ' '} ${unit ?? ' '}",
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
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            shape: DataMarkerType.circle,
                            color: GPrimaryColor,
                            height: 5,
                            width: 5,
                          ),
                        ),
                        LineSeries<NumericData, double>(
                          name: 'ราคาต่ำสุด',
                          dataSource: minDataList,
                          xValueMapper: (NumericData data, _) => data.domain,
                          yValueMapper: (NumericData data, _) => data.measure,
                          enableTooltip: true,
                          color: yellowColor,
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            shape: DataMarkerType.circle,
                            color: yellowColor,
                            height: 5,
                            width: 5,
                          ),
                        ),
                      ],
                      primaryXAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                      ),
                      primaryYAxis: NumericAxis(
                        labelFormat: '{value}',
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
