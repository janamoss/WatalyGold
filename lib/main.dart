import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Home/HomeApp.dart';

void main() {
  var app = const myApp();
  runApp(app);
}

// Widget  stateless
class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,),
      title: "Wataly Gold",
      home: Homeapp(),
    );
  }
}
