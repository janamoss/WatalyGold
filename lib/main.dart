import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ExportPrice/ExportPrice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



 void main() {
   var app = myApp();
   runApp(app);
 }



// Widget  stateless
class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,
      ),
      title: "Wataly Gold",
      home: const ExportPrice(),
      
    );
  }
}

// class ExportPrice extends StatefulWidget {
//   @override
//   _ExportPageState createState() => _ExportPageState();
// }

// class _ExportPageState extends State<ExportPrice>{
//   @override
//   void initState(){
//     super.initState();
//     print("fkvmf");
//   }
//   @override
//   Widget build(BuildContext context) {
//     print("mfkv");
//     return Scaffold(
//      appBar: AppBar(
//       title: Text("ราคาตลาดส่งออก",
//       style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold)),
//      ),
//      body: Column(children: [],)
//     );
//   }
// }
