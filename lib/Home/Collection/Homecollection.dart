import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watalygold/Widgets/Appbar_Histion.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/DialogCollection.dart';

class HomeCollection extends StatefulWidget {
  const HomeCollection({super.key});

  @override
  State<HomeCollection> createState() => _HomeCollectionState();
}

class _HomeCollectionState extends State<HomeCollection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F6F5),
      floatingActionButton: FloatingActionButton(
        splashColor: GPrimaryColor.withOpacity(0.2),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(80)),
        elevation: 3,
        backgroundColor: WhiteColor,
        tooltip: 'Increment',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return DialogCollection();
            },
          );
        },
        child: SvgPicture.asset(
          "assets/images/collections-add-svgrepo-com.svg",
          colorFilter: ColorFilter.mode(GPrimaryColor, BlendMode.srcIn),
          semanticsLabel: 'A red up arrow',
          height: 40,
          width: 40,
        ),
      ),
      //   child: const Icon(Icons.add_to_photos_rounded,
      //       color: GPrimaryColor, size: 30),
      // ),
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
                          hintText: "ค้นหาคอลเลคชันของคุณ",
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
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: _results.length,
              //     itemBuilder: (context, index) {
              //       final result = _results[index];
              //       DateTime createdAt = DateTime.parse(result.created_at);
              //       final formattedDate =
              //           DateFormat('dd MMM yyyy', 'th_TH').format(createdAt);
              //       return CradforHistory(
              //         name: result.result_id
              //             .toString(), // หรือข้อมูลอื่นๆ ที่ต้องการแสดง
              //         result: result.quality.toString(),
              //         date: formattedDate,
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
