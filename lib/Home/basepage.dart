import 'HomeApp.dart';
import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/BTNavBar.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int selectedIndex = 0;
  static const List<Widget> _widgetOption = <Widget>[
    Homeapp(),
    Homeapp(),
    Homeapp(),
    Homeapp(),
    Homeapp(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOption.elementAt(selectedIndex),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
