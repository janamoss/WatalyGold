import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:watalygold/Database/Image_DB.dart';
import 'package:watalygold/Database/Result_DB.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/CradforHistory.dart';
import 'package:watalygold/models/Result_ana.dart';

class HomeHistory extends StatefulWidget {
  const HomeHistory({super.key});

  @override
  State<HomeHistory> createState() => _HomeHistoryState();
}

class _HomeHistoryState extends State<HomeHistory> {
  List<Result> _results = [];
  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    _results = await Result_DB().fetchAll();
    print(_results.length);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F6F5),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return Column(
                    children: [
                      Center(
                        child: SearchBar(
                          constraints: BoxConstraints(
                            minWidth: 100,
                            minHeight: 45,
                            maxWidth: 300,
                            maxHeight: 60,
                          ),
                          elevation: MaterialStateProperty.all(2),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                          controller: controller,
                          hintText: "ค้นหาการวิเคราะห์",
                          surfaceTintColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          overlayColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          padding: MaterialStatePropertyAll<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 15)),
                          // onTap: () {
                          //   controller.openView();
                          // },
                          // onChanged: (_) {
                          //   controller.openView();
                          // },
                          leading: Icon(Icons.search),
                        ),
                      ),
                    ],
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(5, (int index) {
                    final String item = 'item $index';
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          controller.closeView(item);
                        });
                      },
                    );
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    DateTime createdAt = DateTime.parse(result.created_at);
                    final formattedDate =
                        DateFormat('dd MMM yyyy', 'th_TH').format(createdAt);
                    return CradforHistory(
                      name: result.result_id
                          .toString(), // หรือข้อมูลอื่นๆ ที่ต้องการแสดง
                      result: result.quality.toString(),
                      date: formattedDate,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
