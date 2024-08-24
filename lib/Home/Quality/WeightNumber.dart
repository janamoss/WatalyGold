import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';

class WeightNumber extends StatefulWidget {
  const WeightNumber({super.key});

  @override
  State<WeightNumber> createState() => _WeightNumberState();
}

class _WeightNumberState extends State<WeightNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarMains(name: 'น้ำหนักมะม่วง'),
    );
  }
}
