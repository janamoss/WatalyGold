import 'package:flutter/material.dart';

class Appicons extends StatelessWidget {
  final IconData icon;
  final Color backgroundcolor;
  final Color color;
  final double size;
  const Appicons(
      {Key? key,
      required this.icon,
      this.backgroundcolor = const Color(0xffF2F6F5),
      this.color = const Color(0xff069D73),
      this.size = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: backgroundcolor),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}
