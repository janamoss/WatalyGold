import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watalygold/Home/Collection/Homecollection.dart';
import 'package:watalygold/Home/History/Homehistory.dart';
import 'package:watalygold/Widgets/Color.dart';

class BaseHisorCol extends StatefulWidget implements PreferredSizeWidget {
  final int initialIndex;
  const BaseHisorCol({super.key, required this.initialIndex});

  @override
  State<BaseHisorCol> createState() => _BaseHisorColState();

  @override
  Size get preferredSize {
    final tabBarHeight = kToolbarHeight +
        TabBar(
          tabs: [
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.directions_transit)),
          ],
        ).preferredSize.height;
    return Size.fromHeight(tabBarHeight);
  }
}

class _BaseHisorColState extends State<BaseHisorCol> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("${widget.initialIndex} เปลี่ยนหน้าแล้ว");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.initialIndex,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.cyan, Colors.green],
              ),
            ),
          ),
          title: TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Color(0xffFFEE58),
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsetsDirectional.only(bottom: 7),
            tabs: [
              Tab(
                child: Text(
                  'ประวัติการวิเคราะห์',
                  style: const TextStyle(
                    color: WhiteColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'คอลเลคชั่นมะม่วง',
                  style: const TextStyle(
                    color: WhiteColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [HomeHistory(), HomeCollection()],
        ),
      ),
    );
  }
}
