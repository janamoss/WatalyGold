import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';
import 'package:intl/intl.dart';


// class LineChart extends StatelessWidget {
//   LineChart({Key? key}) : super(key: key);
//   final StreamChart = FirebaseFirestore.instance
//       .collection("ExportPrice")
//       .snapshots(includeMetadataChanges: true);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           StreamBuilder(
//               stream: StreamChart,
//               builder: (context,
//                   AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Text('Loading...');
//                 }

//                 if (snapshot.data == null) {
//                   return Text('Empty');
//                 }

//                 List<Map<String, dynamic>> listChart =
//                     snapshot.data!.docs.map((e) {
//                   return {
//                     "domain": e.data()['date'],
//                     "measure": e.data()['price_max_avg'],
//                   };
//                 }).toList();
//                 List<TimeData> timeDataList = [
//                   TimeData(domain: DateTime(2023, 8, 26), measure: 3),
//                   TimeData(domain: DateTime(2023, 8, 27), measure: 5),
//                   TimeData(domain: DateTime(2023, 8, 29), measure: 9),
//                   TimeData(domain: DateTime(2023, 9, 1), measure: 6.5),
//                 ];
//                 final timeGroupList = [
//                   TimeGroup(
//                     id: '1',
//                     data: timeDataList,
//                   ),
//                 ];
//                 return AspectRatio(
//                   aspectRatio: 16 / 9,
//                   child: DChartLineT(
//                     groupList: timeGroupList,
//                   ),
//                 );
//               }),
//         ],
//       ),
//     );
//   }
// }

//  class LineChart extends StatefulWidget {
//     const LineChart({Key? key}) : super(key: key);
//    @override
//    State<LineChart> createState() => _LineChartState();
//  }

//  class _LineChartState extends State<LineChart> {

//    List<TimeData> timeDataList = [
//      TimeData(domain: DateTime(2023, 8, 26), measure: 3),
//      TimeData(domain: DateTime(2023, 8, 27), measure: 5),
//      TimeData(domain: DateTime(2023, 8, 29), measure: 9),
//      TimeData(domain: DateTime(2023, 9, 1), measure: 6.5),
//  ];

//    @override
//    Widget build(BuildContext context) {
//      final timeGroupList = [
//      TimeGroup(
//          id: '1',
//          data: timeDataList,
//      ),
//  ];
//      return Scaffold(
//        body: ListView(
//          padding: EdgeInsets.all(16),
//          children: [
//            AspectRatio(
//              aspectRatio: 16 / 9,
//              child: DChartLineT(
//                groupList: timeGroupList,
//              ),
//            ),
//                     ],
//        ),
//      );
//    }
//  }


class LineChartSample2 extends StatefulWidget {
  final List<NumericData> maxDataList;
  final List<NumericData> minDataList;

  const LineChartSample2({
    required this.maxDataList,
    required this.minDataList,
    Key? key,
  }) : super(key: key);

  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color.fromARGB(255, 239, 198, 195),
    Colors.brown,
  ];



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
        // SizedBox(
        //   width: 60,
        //   height: 34,
        //   child: TextButton(
        //     onPressed: () {
        //       setState(() {
        //         showAvg = !showAvg;
        //       });
        //     },
        //     child: Text(
        //       'avg',
        //       style: TextStyle(
        //         fontSize: 12,
        //         color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  DateTime date;

  switch (value.toInt()) {
    case 2:
      date = DateTime(DateTime.now().year, 3, 1);
      break;
    case 3:
      date = DateTime(DateTime.now().year, 6, 1);
      break;
    case 4:
      date = DateTime(DateTime.now().year, 9, 1);
      break;
    default:
      return Container();
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(DateFormat('d').format(date), style: style),
  );
}


  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: const Color(0xFFF2F6F5),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.black),
          left: BorderSide(color: Colors.black),
        ),
      ),
      minX: 0,
      maxX: widget.maxDataList.length.toDouble() - 1,
      minY: 0,
      maxY: widget.maxDataList.isNotEmpty
          ? (widget.maxDataList.map((data) => data.measure).reduce(max) as int)
              .toDouble()
          : null,
      lineBarsData: [
        LineChartBarData(
          spots: widget.maxDataList
              .asMap()
              .entries
              .map((entry) => FlSpot(
                    entry.key.toDouble(),
                    entry.value.measure.toDouble(),
                  ))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
        LineChartBarData(
          spots: widget.minDataList
              .asMap()
              .entries
              .map((entry) => FlSpot(
                    entry.key.toDouble(),
                    entry.value.measure.toDouble(),
                  ))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  
}
