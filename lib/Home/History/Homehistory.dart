import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/CradforHistory.dart';

class HomeHistory extends StatefulWidget {
  const HomeHistory({super.key});

  @override
  State<HomeHistory> createState() => _HomeHistoryState();
}

class _HomeHistoryState extends State<HomeHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F6F5),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SingleChildScrollView(
                child: Column(
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
                    CradforHistory(
                        name: "name", result: "result", date: "date"),
                  ],
                ),
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
        ),
      ),
    );
  }
}
