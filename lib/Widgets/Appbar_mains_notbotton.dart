import 'package:flutter/material.dart';
import 'icon_app.dart';

class Appbarmain_no_botton extends StatelessWidget
    implements PreferredSizeWidget {
  final String name;

  const Appbarmain_no_botton({required this.name});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.cyan, Colors.green])),
      ),
      title: Text(name, style: TextStyle(color: Colors.white)),
      centerTitle: true,
    );
  }
}

class Appbarmain_no_bottons extends StatefulWidget
    implements PreferredSizeWidget {
  final String name;

  const Appbarmain_no_bottons({Key? key, required this.name}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<Appbarmain_no_bottons> createState() => _Appbarmain_no_bottonsState();
}

class _Appbarmain_no_bottonsState extends State<Appbarmain_no_bottons> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Colors.cyan, Colors.green])),
      ),
      title: Text(widget.name, style: TextStyle(color: Colors.white)),
      centerTitle: true,
    );
  }
}
