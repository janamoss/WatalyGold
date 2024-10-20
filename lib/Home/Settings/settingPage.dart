import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';

class SettingPages extends StatefulWidget {
  const SettingPages({super.key});

  @override
  State<SettingPages> createState() => _SettingPagesState();
}

class _SettingPagesState extends State<SettingPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarmain(name: "การตั้งค่า"),
      body: Column(
        children: [],
      ),
    );
  }
}