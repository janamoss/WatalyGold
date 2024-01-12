
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ExportPrice/ExportPrice.dart';
import 'package:firebase_core/firebase_core.dart';




 void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 
   var app = myApp();
   runApp(app);
 }



// Widget  stateless
class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,
      ),
      title: "Wataly Gold",
      home: const ExportPrice(),
      
    );
  }
}

// class MyHome extends StatelessWidget {
//   const MyHome({Key? key}): super(key: key);
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       body: Center(
//         child: Container(
//           color: Colors.blueGrey[900],
//           height: 200,
//           width: 400,
//           child: _LineChart(),
//         ),
//       )
//     );
//   }
// }

// class _LineChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context){
//     return LineChart(
     
//       sampleDeta1

//     );
//   }
// }
//  LineChartData get sampleDeta1 => LineChartData(
//   gridData: gridData,
//   titlesData: titlesData,
//   borderData: borderData,
//   lineBarsData: lineBarsData,
//   minX: 0,
//   maxX: 14,
//   minY: 0,
//   maxY: 4
//  );

// List<LineChartBarData> get lineBarsData => [
//   lineChartBarData1
// ];


//  FlTitlesData get titlesData => FlTitlesData(
//   bottomTitles: AxisTitles(
//     sideTitles: bottomTitles,
//   ),
//   rightTitles: AxisTitles(
//     sideTitles: SideTitles(showTitles: false),
//   ),
//   topTitles: AxisTitles(
//     sideTitles: SideTitles(showTitles: false),
//   ),
//   leftTitles: AxisTitles(sideTitles: leftTitles(),
//   )
//  );

//  Widget leftTitlesWidget(double value, TitleMeta meta){
//   const style = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.bold,
//     color: Colors.grey,
//   );
//   String text;
//   switch (value.toInt()){
//     case 1:
//     text = '1m';
//     break;
//     case 2:
//     text = '2m';
//     break;
//     case 3:
//     text = '3m';
//     break;
//     case 4:
//     text = '4m';
//     break;
//     case 5:
//     text = '5m';
//     break;
//     default:
//     return Container();
//   }
//   return Text(text,style: style,textAlign: TextAlign.center,);
//  }

//  SideTitles leftTitles() => SideTitles(
//   getTitlesWidget: leftTitlesWidget,
//   showTitles: true,
//   interval: 1,
//   reservedSize: 40
//  );

// Widget bottomTitlesWidgets(double value, TitleMeta meta){
//   const style = TextStyle(
//    fontSize: 15,
//     fontWeight: FontWeight.bold,
//     color: Colors.grey,
//   );
//   Widget text;
//   switch (value.toInt()){
//     case 2:
//     text = const Text('2020',style: style);
//     break;
//     case 7:
//     text = const Text('2021',style: style);
//     break;
//     case 12:
//     text = const Text('2022',style: style);
//     break;
//     default:
//     text = const Text('');
//     break;
//   }
//   return SideTitleWidget(
//     axisSide: meta.axisSide,
//     space: 10,
//     child: text,
//   );
// }

// SideTitles get bottomTitles => SideTitles(
//   showTitles: true,
//   reservedSize: 32,
//   interval: 1,
//   getTitlesWidget: bottomTitlesWidgets,
// );

// FlGridData get gridData => FlGridData(show: false);

// FlBorderData get borderData => FlBorderData(
//   show: true,
//   border: Border(bottom: BorderSide(color: Colors.grey,width: 4),
//   left: const BorderSide(color: Colors.grey),
//   right:const BorderSide(color: Colors.transparent),
//   top: const BorderSide(color: Colors.transparent) 
//   )
// );

// LineChartBarData get lineChartBarData1 => LineChartBarData(
//   isCurved: true,
//   color: Colors.purple,
//   barWidth: 6,
//   isStrokeCapRound: true,
//   dotData: FlDotData(show: false),
//   belowBarData: BarAreaData(show: false),
//   spots: const [
//     FlSpot(1, 1),
//     FlSpot(3, 1.5),
//     FlSpot(5, 1.6),
//     FlSpot(7, 3.4),
//     FlSpot(10, 2),
//     FlSpot(12, 2.5),
//     FlSpot(13, 1.6),
//   ]
// );