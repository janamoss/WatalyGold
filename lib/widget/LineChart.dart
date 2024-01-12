import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

 class LineChart extends StatefulWidget {
    const LineChart({Key? key}) : super(key: key);
   @override
   State<LineChart> createState() => _LineChartState();
 }

 class _LineChartState extends State<LineChart> {

   List<TimeData> timeDataList = [
     TimeData(domain: DateTime(2023, 8, 26), measure: 3),
     TimeData(domain: DateTime(2023, 8, 27), measure: 5),
     TimeData(domain: DateTime(2023, 8, 29), measure: 9),
     TimeData(domain: DateTime(2023, 9, 1), measure: 6.5),
 ];

   @override
   Widget build(BuildContext context) {
     final timeGroupList = [
     TimeGroup(
         id: '1',
         data: timeDataList,
     ),
 ];
     return Scaffold(
       body: ListView(
         padding: EdgeInsets.all(16),
         children: [
           AspectRatio(
             aspectRatio: 16 / 9,
             child: DChartLineT(
               groupList: timeGroupList,
             ),
           ),
                    ],
       ),
     );
   }
 }
