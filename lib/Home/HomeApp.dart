import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watalygold/Widgets/BTNavBar.dart';
import 'package:watalygold/Widgets/Homebox.dart';
import 'package:camera/camera.dart';

void main() {}

class Homeapp extends StatefulWidget {
  final List<CameraDescription> camera;
  final Function(int) changeWidgetOption;

  const Homeapp(
      {Key? key, required this.camera, required this.changeWidgetOption})
      : super(key: key);

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
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 90, maxWidth: 200),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/WatalyGoldIcons.png',
              fit: BoxFit.contain,
              width: 90,
            ),
          ),
        ),
        centerTitle: true,
        flexibleSpace: ClipPath(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
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
        children: [
          Homebox(
            camera: widget.camera,
            changeWidgetOption: widget.changeWidgetOption,
          )
        ],
      ),
      backgroundColor: const Color(0xFFF2F6F5),
    );
  }
}
