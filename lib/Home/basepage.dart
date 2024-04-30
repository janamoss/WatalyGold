import 'package:watalygold/ExportPrice/ExportPrice.dart';
import 'package:watalygold/Home/Collection/Homecollection.dart';
import 'package:watalygold/Home/Collection/baseColoorHis.dart';

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
      _createHomeapp(widget.camera),
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
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex, // Pass selectedIndex to BottomNavBar
        onItemTapped: (int index) {
          setState(() {
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TakePictureScreen(camera: widget.camera),
                ),
              );
            } else {
              setState(() {
                selectedIndex = index;
              });
            } // Update selectedIndex on tap
          });
        },
      ),
    );
  }
}
