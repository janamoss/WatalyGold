import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watalygold/Database/Result_DB.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/CradforHistory.dart';
import 'package:watalygold/Widgets/icon_app.dart';
import 'package:watalygold/models/Collection.dart';
import 'package:watalygold/models/Result_ana.dart';

class SelectResult extends StatefulWidget {
  final Collection collections;
  final VoidCallback? refreshs;
  const SelectResult({super.key, required this.collections, this.refreshs});

  @override
  State<SelectResult> createState() => _SelectResultState();
}

class _SelectResultState extends State<SelectResult> {
  List<Result> _results = [];
  List<Result> _resultsreal = [];
  Map<int, bool> _selectedResults = {}; // เก็บค่า isCheck ของแต่ละ Result

  bool isDone = false;

  Future<void> _loadResults() async {
    _results = await Result_DB().fetchResultinCol();
    _resultsreal = await Result_DB().fetchAll();
    _selectedResults = {}; // เริ่มต้นให้ _selectedResults เป็น Map ว่าง

    for (var result in _results) {
      _selectedResults[result.result_id] =
          false; // เริ่มต้นให้ทุก Result ไม่ถูกเลือก
    }

    stdout.writeln(_selectedResults); // ตรวจสอบค่าของ _selectedResults
    setState(() {});
  }

  Future<void> _updateresulttocollection() async {
    for (final entry in _selectedResults.entries) {
      final resultId = entry.key;
      final isSelected = entry.value;

      if (isSelected) {
        // Update the database for this result
        await Result_DB()
            .updatecollection(widget.collections.collection_id, resultId);
      }
    }
  }

  void selectresult(int resultId) {
    stdout.writeln("ทำงาน");
    setState(() {
      // Update the selected value for the specific result
      if (_selectedResults[resultId] == true) {
        _selectedResults[resultId] = false;
      } else {
        _selectedResults[resultId] = true;
      }

      // Check if any value in _selectedResults is true
      bool anyResultSelected = false;
      _selectedResults.values.forEach((value) {
        if (value == true) {
          anyResultSelected = true;
          return; // Stop iterating once a true value is found
        }
      });

      // Update isDone based on the check
      isDone = anyResultSelected;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F6F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.white),
        ),
        leading: IconButton(
          color: Colors.white,
          icon: Appicons(
            icon: Icons.arrow_back_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("ผลการวิเคราะห์",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: isDone
                ? () async {
                    stdout.writeln(_selectedResults);
                    await _updateresulttocollection();
                    Navigator.pop(context);
                    widget.refreshs!();
                  }
                : null,
            icon: Icon(
              Icons.check_rounded,
              color: isDone ? GPrimaryColor : GPrimaryColor.withOpacity(0.2),
              size: 25,
            ),
          )
        ],
      ),
      body: _results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 50, color: GPrimaryColor),
                  SizedBox(
                    height: 25,
                  ),
                  Text("คุณยังไม่มีรายการการวิเคราะห์คุณภาพ"),
                ],
              ),
            )
          : ListView.builder(
              // ใช้จำนวนรายการที่มีอยู่ใน _results
              itemCount: _results.length,
              itemBuilder: (context, index) {
                // ดึง result ที่จะใช้แสดงจาก _results
                final result = _results[index];

                // ค้นหา index ของ result นี้ใน _resultsreal เพื่อใช้เป็นลำดับที่แท้จริง
                final actualIndex = _resultsreal.indexWhere(
                    (realResult) => realResult.result_id == result.result_id);

                DateTime createdAt = DateTime.parse(result.created_at);
                final formattedDate =
                    DateFormat('dd MMM yyyy', 'th_TH').format(createdAt);

                return CradforHistory(
                  date: formattedDate,
                  results: result,
                  number: actualIndex +
                      1, // ใช้ actualIndex จาก _resultsreal เพื่อแสดงลำดับจริง
                  refreshCallback: () => _loadResults(),
                  statusSelect: 1,
                  isChecked: _selectedResults[result.result_id],
                  onCheckChanged: () => selectresult(result.result_id),
                );
              },
            ),
    );
  }
}
