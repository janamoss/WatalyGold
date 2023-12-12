import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watalygold/Widgets/BTNavBar.dart';

void main() {}

class Homeapp extends StatefulWidget {
  const Homeapp({super.key});

  @override
  State<Homeapp> createState() => _HomeappState();
}

class _HomeappState extends State<Homeapp> {
  int number = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 200,
          title: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/WatalyGoldIcons.png',
                fit: BoxFit.contain,
                width: 90,
              ),
            ),
          ),
          flexibleSpace: ClipPath(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(50)),
                image: DecorationImage(
                  image: AssetImage('assets/images/WatalyGold.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HBox2(
              text: 'คอลเลคชัน',
              imageAssetPath: 'assets/images/icons8-image-gallery-64.png',
            ),
            HBox2(
              text: 'ประวัติ\nการวิเคราะห์',
              imageAssetPath: 'assets/images/icons8-history-64.png',
            ),
          ],
        ),
        backgroundColor: const Color(0xFFF2F6F5),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) =>
                  states.contains(MaterialState.selected)
                      ? const TextStyle(color: Colors.yellow, fontSize: 12)
                      : const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          child: const NavBar(),
        ));
  }
}

class HBox extends StatelessWidget {
  final String text;
  final String imageAssetPath;

  const HBox({
    super.key,
    required this.text,
    required this.imageAssetPath,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 154,
      height: 186,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: 154,
              height: 186,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imageAssetPath,
                  fit: BoxFit.contain,
                  width: 90,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 30,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HBox2 extends StatefulWidget {
  final String text;
  final String imageAssetPath;

  const HBox2({
    super.key,
    required this.text,
    required this.imageAssetPath,
  });

  @override
  State<HBox2> createState() => _HBox2State();
}

class _HBox2State extends State<HBox2> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 154,
      height: 186,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: 154,
              height: 186,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  widget.imageAssetPath,
                  fit: BoxFit.contain,
                  width: 60,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 30,
            child: SizedBox(
              width: 124, // Adjust based on desired text width
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
