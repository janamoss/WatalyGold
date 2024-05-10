import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watalyGold/UserManual.dart';

import 'ExportPrice/ExportPrice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



 void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 
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
       localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('th', 'TH'), 
        const Locale('en', 'US'), 
      ],
      //  home: const ExportPrice(),
      home: const UserManual(),
      
    );
  }
}
