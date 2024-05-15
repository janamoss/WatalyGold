import 'package:watalygold/ExportPrice/ExportPrice.dart';
import 'package:watalygold/Home/Collection/baseColoorHis.dart';
import 'package:watalygold/Home/UserManual/usermanual.dart';
import 'package:watalygold/Widgets/Color.dart';

import 'HomeApp.dart';
import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/BTNavBar.dart';
import 'package:watalygold/Home/Quality/MainAnalysis.dart';
import 'package:camera/camera.dart';

class BasePage extends StatefulWidget {
  final List<CameraDescription> camera;

  const BasePage({Key? key, required this.camera}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int selectedIndex = 0;
  int tabviews = 0;

  late List<Widget> _widgetOption;

  @override
  void initState() {
    super.initState();
    _updateWidgetOption();
  }

  void _updateWidgetOption() {
    _widgetOption = [
      _createHomeapp(widget.camera),
      const ExportPrice(),
      TakePictureScreen(camera: widget.camera),
      BaseHisorCol(initialIndex: tabviews),
      const UserManual(),
    ];
  }

  Widget _createHomeapp(List<CameraDescription> camera) {
    return Homeapp(
      camera: camera,
      changeWidgetOption: changeWidgetOption,
      changeTabView: changeTabviews,
    );
  }

  void changeWidgetOption(int index) {
    setState(() {
      selectedIndex = index;
      _updateWidgetOption();
    });
  }

  void changeTabviews(int tabview) {
    setState(() {
      tabviews = tabview;
      selectedIndex = 3;
      _updateWidgetOption(); // เรียกใช้ _updateWidgetOption() อีกครั้งเมื่อ tabviews เปลี่ยน
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOption.elementAt(selectedIndex),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(5.0),
        child: FloatingActionButton(
          heroTag: "base-page-fab",
          elevation: 2,
          shape: OutlineInputBorder(
              gapPadding: 1,
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(100))),
          backgroundColor: GPrimaryColor,
          child: Icon(
            Icons.camera_alt_rounded,
            color: WhiteColor,
            size: 35,
          ),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => TakePictureScreen(camera: widget.camera),
            //   ),
            // );
            Navigator.of(context).push(_createRoute());
          }, // ฟังก์ชันสำหรับไอคอนกล้อง
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppbar(
        selectedIndex: selectedIndex, // Pass selectedIndex to BottomNavBar
        onItemTapped: (int index) {
          setState(() {
            setState(() {
              selectedIndex = index;
              _updateWidgetOption();
            });
          });
        },
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          TakePictureScreen(camera: widget.camera),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
