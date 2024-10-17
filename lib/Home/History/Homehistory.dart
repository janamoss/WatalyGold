import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:watalygold/Database/Collection_DB.dart';
import 'package:watalygold/Database/Result_DB.dart';
import 'package:watalygold/Home/History/HistoryDetail.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/CradforHistory.dart';
import 'package:watalygold/Widgets/DialogSuccess.dart';
import 'package:watalygold/models/Collection.dart';
import 'package:watalygold/models/Result_ana.dart';

class HomeHistory extends StatefulWidget {
  const HomeHistory({super.key});

  @override
  State<HomeHistory> createState() => _HomeHistoryState();
}

class _HomeHistoryState extends State<HomeHistory> {
  TextEditingController _controller = TextEditingController();

  List<Result> _results = [];
  List<Result> _originalresults = [];
  List<Collection> _collection = [];

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  Future<void> _loadCollections() async {
    _collection = await Collection_DB().fetchAll();
    stdout.writeln(_collection.length);
    setState(() {});
  }

  Future<void> _loadResults() async {
    _originalresults = await Result_DB().fetchAll();
    _results = _originalresults;
    stdout.writeln(_results.length);
    setState(() {});
  }

  Future<void> refreshList() async {
    debugPrint("working");
    _loadResults();
    _loadCollections();
    setState(() {}); // เรียกใช้ฟังก์ชันนี้เพื่ออัปเดตรายการ
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F6F5),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 50,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  fillColor: WhiteColor,
                  filled: true,
                  hintText: "ค้นหาการวิเคราะห์",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xff767676),
                    size: 30,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                ),
                onChanged: searchHistory,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshList,
                child: _results.isNotEmpty
                    ? ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final result = _results[index];
                          debugPrint("${result.collection_id} คือ id ของคอ");
                          DateTime createdAt =
                              DateTime.parse(result.created_at);
                          final formattedDate =
                              DateFormat('dd MMM yyyy', 'th_TH')
                                  .format(createdAt);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryDetail(
                                    results: result,
                                  ),
                                ),
                              );
                            },
                            child: CradforHistory(
                              date: formattedDate,
                              results: result,
                              number: index + 1,
                              refreshCallback: () => refreshList(),
                              collection: _collection,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_rounded,
                                size: 50, color: GPrimaryColor),
                            SizedBox(
                              height: 25,
                            ),
                            Text("คุณยังไม่มีรายการการวิเคราะห์คุณภาพ"),
                          ],
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> searchHistory(String query) async {
    if (query.isEmpty) {
      setState(() => _results = _originalresults);
    } else {
      final suggestions = _results.where((result) {
        final resultQuality = result.quality.toString();
        final input = query.toLowerCase();
        return resultQuality.toLowerCase().contains(input);
      }).toList();
      setState(() => _results = suggestions);
    }
  }
}
