// import 'package:custom_date_range_picker/custom_date_range_picker.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:watalygold/widget/Color.dart';
// import 'package:watalygold/widget/appcolor.dart';

// class _LineChart extends StatelessWidget {
//   final bool isShowingMainData;
//   final List<FlSpot> priceMaxSpots;
//   final List<FlSpot> priceMinSpots;

//   const _LineChart({
//     required this.isShowingMainData,
//     required this.priceMaxSpots,
//     required this.priceMinSpots,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       isShowingMainData ? sampleData1 : sampleData2,
//       duration: const Duration(milliseconds: 250),
//     );
     
//   }

//   LineChartData get sampleData1 => LineChartData(
//         lineTouchData: lineTouchData1,
//         gridData: gridData,
//         titlesData: titlesData1,
//         borderData: borderData,
//         lineBarsData: lineBarsData1,
//         minX: 0,
//         maxX: 25,
//         maxY: 5,
//         minY: 0,
//       );

//   LineChartData get sampleData2 => LineChartData(
//         lineTouchData: lineTouchData2,
//         gridData: gridData,
//         titlesData: titlesData2,
//         borderData: borderData,
//         lineBarsData: lineBarsData2,
//         minX: 0,
//         maxX: 25,
//         maxY: 6,
//         minY: 0,
//       );

//   LineTouchData get lineTouchData1 => LineTouchData(
//         handleBuiltInTouches: true,
//         touchTooltipData: LineTouchTooltipData(
//           tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
//         ),
//       );

//   FlTitlesData get titlesData1 => FlTitlesData(
//         bottomTitles: AxisTitles(
//           sideTitles: bottomTitles,
//         ),
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: leftTitles(),
//         ),
//       );

//   List<LineChartBarData> get lineBarsData1 => [
//         lineChartBarData1_2,
//         lineChartBarData1_3,
//       ];

//   LineTouchData get lineTouchData2 => const LineTouchData(
//         enabled: false,
//       );

//   FlTitlesData get titlesData2 => FlTitlesData(
//         bottomTitles: AxisTitles(
//           sideTitles: bottomTitles,
//         ),
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: leftTitles(),
//         ),
//       );

//   List<LineChartBarData> get lineBarsData2 => [
//         lineChartBarData2_2,
//         lineChartBarData2_3,
//       ];

//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 12,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 1:
//         text = '10m';
//         break;
//       case 2:
//         text = '40m';
//         break;
//       case 3:
//         text = '60m';
//         break;
//       case 4:
//         text = '80m';
//         break;
//       case 5:
//         text = '100m';
//         break;
//       default:
//         return Container();
//     }

//     return Text(text, style: style, textAlign: TextAlign.center);
//   }

//   SideTitles leftTitles() => SideTitles(
//         getTitlesWidget: leftTitleWidgets,
//         showTitles: true,
//         interval: 1,
//         reservedSize: 40,
//       );

//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 12,
//     );
//     Widget text;
//     switch (value.toInt()) {
//       case 2:
//         text = const Text('2020', style: style);
//         break;
//       case 7:
//         text = const Text('2021', style: style);
//         break;
//       case 12:
//         text = const Text('2022', style: style);
//         break;
//       case 17:
//         text = const Text('2023', style: style);
//         break;
//       case 22:
//         text = const Text('2024', style: style);
//         break;
//       default:
//         text = const Text('');
//         break;
//     }

//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 10,
//       child: text,
//     );
//   }

//   SideTitles get bottomTitles => SideTitles(
//         showTitles: true,
//         reservedSize: 32,
//         interval: 1,
//         getTitlesWidget: bottomTitleWidgets,
//       );

//   FlGridData get gridData => const FlGridData(show: false);

//   FlBorderData get borderData => FlBorderData(
//         show: true,
//         border: Border(
//           bottom: BorderSide(color: GPrimaryColor, width: 2),
//           left: const BorderSide(color: GPrimaryColor, width: 2),
//           right: const BorderSide(color: Colors.transparent),
//           top: const BorderSide(color: Colors.transparent),
//         ),
//       );

//   LineChartBarData get lineChartBarData1_2 => LineChartBarData(
//         isCurved: true,
//         color: GPrimaryColor,
//         barWidth: 4,
//         isStrokeCapRound: true,
//         dotData: const FlDotData(show: false),
//         belowBarData: BarAreaData(
//           show: false,
//           color: GPrimaryColor.withOpacity(0),
//         ),
//         spots: priceMaxSpots, // Use price_max data here
//       );

//   LineChartBarData get lineChartBarData1_3 => LineChartBarData(
//         isCurved: true,
//         color: YPrimaryColor,
//         barWidth: 4,
//         isStrokeCapRound: true,
//         dotData: const FlDotData(show: false),
//         belowBarData: BarAreaData(show: false),
//         spots: priceMinSpots, // Use price_min data here
//       );

//   LineChartBarData get lineChartBarData2_2 => LineChartBarData(
//         isCurved: true,
//         color: GPrimaryColor.withOpacity(0.5),
//         barWidth: 4,
//         isStrokeCapRound: true,
//         dotData: const FlDotData(show: false),
//         belowBarData: BarAreaData(
//           show: true,
//           color: AppColors.contentColorPink.withOpacity(0.2),
//         ),
//         spots: const [
//           FlSpot(1, 1),
//           FlSpot(3, 2.8),
//           FlSpot(7, 1.2),
//           FlSpot(10, 2.8),
//           FlSpot(12, 2.6),
//           FlSpot(13, 3.9),
//         ],
//       );

//   LineChartBarData get lineChartBarData2_3 => LineChartBarData(
//         isCurved: true,
//         curveSmoothness: 0,
//         color: YPrimaryColor.withOpacity(0.5),
//         barWidth: 2,
//         isStrokeCapRound: true,
//         dotData: const FlDotData(show: true),
//         belowBarData: BarAreaData(show: false),
//         spots: const [
//           FlSpot(1, 3.8),
//           FlSpot(3, 1.9),
//           FlSpot(6, 5),
//           FlSpot(10, 3.3),
//           FlSpot(13, 4.5),
//         ],
//       );
// }

// class LineChartSample1 extends StatefulWidget {
//   const LineChartSample1({super.key});

//   @override
//   State<StatefulWidget> createState() => LineChartSample1State();
// }

// class LineChartSample1State extends State<LineChartSample1> {
//   TextEditingController _dateController = TextEditingController();
//   DateTime endDate = DateTime.now();
//   DateTime selectedDate = DateTime.now();

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         _dateController.text = DateFormat('d/M/yyyy').format(picked);
//         endDate = picked;
//       });
//     }
//   }

//   List<FlSpot> getPriceMaxData(DateTime selectedDate) {
//     return [
//       FlSpot(1, 2.5),
//       FlSpot(3, 3.0),
//     ];
//   }

//   List<FlSpot> getPriceMinData(DateTime selectedDate) {
//     return [
//       FlSpot(1, 1.5),
//       FlSpot(3, 2.0),
//     ];
//   }

//   late bool isShowingMainData;

//   @override
//   void initState() {
//     super.initState();
//     isShowingMainData = true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final priceMaxData = getPriceMaxData(selectedDate);
//     final priceMinData = getPriceMinData(selectedDate);
//     return AspectRatio(
//       aspectRatio: 1.25,
//       child: Stack(
//         children: <Widget>[
 
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//             Padding(
//             padding: EdgeInsets.only(top: 20, right: 20),
//             // child: Row(
//             //   mainAxisAlignment: MainAxisAlignment.end,
//             //   children: [
//             //     Spacer(),
//             //     Container(
//             //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//             //       decoration: BoxDecoration(
//             //         color: Color.fromARGB(255, 153, 231, 138),
//             //         borderRadius: BorderRadius.circular(20),
//             //       ),
//             //       // child: InkWell(
//             //       //   onTap: () {
//             //       //     showCustomDateRangePicker(
//             //       //       context,
//             //       //       dismissible: true,
//             //       //       endDate: selectedDate,
//             //       //       startDate: selectedDate.subtract(Duration(days: 7)),
//             //       //       maximumDate: DateTime.now(),
//             //       //       minimumDate: DateTime(2000),
//             //       //       onApplyClick: (start, end) {
//             //       //         setState(() {
//             //       //           selectedDate = start ?? selectedDate;
//             //       //           _dateController.text =
//             //       //               "${DateFormat('d/M/yyyy').format(start!)} - ${DateFormat('d/M/yyyy').format(end!)}";
//             //       //         });
//             //       //       },
//             //       //       onCancelClick: () {},
//             //       //     );
//             //       //   },
//             //       //   child: Row(
//             //       //     children: [
//             //       //       Text(
//             //       //         _dateController.text.isEmpty
//             //       //             ? 'เลือกวันที่'
//             //       //             : _dateController.text,
//             //       //         style: TextStyle(
//             //       //           fontSize: 16,
//             //       //           color: Colors.black,
//             //       //         ),
//             //       //       ),
//             //       //       SizedBox(width: 10),
//             //       //       Icon(Icons.calendar_today, color: Colors.black),
//             //       //     ],
//             //       //   ),
//             //       // ),
//             //     ),
//             //   ],
//             // ),
//           ),
//               const SizedBox(
//                 height: 37,
//               ),
//               const SizedBox(
//                 height: 37,
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 16, left: 6),
//                  child: _LineChart(
//                 isShowingMainData: isShowingMainData,
//                 priceMaxSpots: priceMaxData,
//                 priceMinSpots: priceMinData,
//               ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:watalyGold/widget/Color.dart';
import 'package:watalyGold/widget/appcolor.dart';


class _LineChart extends StatelessWidget {
  const _LineChart({required this.isShowingMainData});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        // lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 14,
        maxY: 6,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        
      ];

  LineTouchData get lineTouchData2 => const LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  // List<LineChartBarData> get lineBarsData2 => [
  //       lineChartBarData2_1,
  //       lineChartBarData2_2,
        
  //     ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1m';
        break;
      case 2:
        text = '2m';
        break;
      case 3:
        text = '3m';
        break;
      case 4:
        text = '5m';
        break;
      case 5:
        text = '6m';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('SEPT', style: style);
        break;
      case 7:
        text = const Text('OCT', style: style);
        break;
      case 12:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom:
              BorderSide(color: const Color.fromARGB(255, 4, 38, 45).withOpacity(0.2), width: 2),
          left: const BorderSide(color: Color.fromARGB(0, 255, 17, 17)),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: yellowColor,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 1.5),
          FlSpot(5, 1.4),
          FlSpot(7, 3.4),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: GPrimaryColor,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: AppColors.contentColorPink.withOpacity(0),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  

  // LineChartBarData get lineChartBarData2_1 => LineChartBarData(
  //       isCurved: true,
  //       curveSmoothness: 0,
  //       color: AppColors.contentColorGreen.withOpacity(0.5),
  //       barWidth: 4,
  //       isStrokeCapRound: true,
  //       dotData: const FlDotData(show: false),
  //       belowBarData: BarAreaData(show: false),
  //       spots: const [
  //         FlSpot(1, 1),
  //         FlSpot(3, 4),
  //         FlSpot(5, 1.8),
  //         FlSpot(7, 5),
  //         FlSpot(10, 2),
  //         FlSpot(12, 2.2),
  //         FlSpot(13, 1.8),
  //       ],
  //     );

  // LineChartBarData get lineChartBarData2_2 => LineChartBarData(
  //       isCurved: true,
  //       color: AppColors.contentColorPink.withOpacity(0.5),
  //       barWidth: 4,
  //       isStrokeCapRound: true,
  //       dotData: const FlDotData(show: false),
  //       belowBarData: BarAreaData(
  //         show: true,
  //         color: AppColors.contentColorPink.withOpacity(0.2),
  //       ),
  //       spots: const [
  //         FlSpot(1, 1),
  //         FlSpot(3, 2.8),
  //         FlSpot(7, 1.2),
  //         FlSpot(10, 2.8),
  //         FlSpot(12, 2.6),
  //         FlSpot(13, 3.9),
  //       ],
  //     );

  
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 37,
              ),
              
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _LineChart(isShowingMainData: isShowingMainData),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
         ),

        ],
      ),
    );
  }
}
