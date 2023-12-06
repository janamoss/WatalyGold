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

class _MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width / 2, size.height + 25, 0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_MyCustomClipper oldClipper) => true;
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
        toolbarHeight: 200,
        title: ClipRRect(
          
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            'assets/images/WatalyGoldIcons.png',
            fit: BoxFit.contain,
            width: 80,
          ),
        ),
        flexibleSpace: ClipPath(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(75)),
              image: DecorationImage(
                image: AssetImage('assets/images/WatalyGold.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(75)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("สวัสดีค่ะ ชื่อมอสนะคะ"),
            const Text("Hello"),
            Text(
              number.toString(),
              style: const TextStyle(fontSize: 50),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNumber,
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.lightGreenAccent,
    );
  }

  void addNumber() {
    setState(() {
      number++;
    });
  }
}
