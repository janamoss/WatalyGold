import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Appbar_Histion.dart';

class HomeCollection extends StatefulWidget {
  const HomeCollection({super.key});

  @override
  State<HomeCollection> createState() => _HomeCollectionState();
}

class _HomeCollectionState extends State<HomeCollection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("collection"),
      ),
    );
  }
}
