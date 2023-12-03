import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      title: "Wataly Gold",
      home: Myapp2(),
    );
  }
}

// Widget stateful
class Myapp2 extends StatefulWidget {
  const Myapp2({super.key});

  @override
  State<Myapp2> createState() => _Myapp2State();
}

class _Myapp2State extends State<Myapp2> {
  int number = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Wataly Gold",
            style: TextStyle(
                fontSize: 30,
                color: Colors.amber,
                fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("สวัสดีค่ะ ชื่อมอสนะคะ"),
            Text("Hello"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.lightGreenAccent,
    );
  }
}
