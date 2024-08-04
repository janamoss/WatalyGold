import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/icon_app.dart';

class AppbarMainExit extends StatefulWidget implements PreferredSizeWidget {
  final String name;

  const AppbarMainExit({Key? key, required this.name}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppbarMainExit> createState() => _AppbarMainExitState();
}

class _AppbarMainExitState extends State<AppbarMainExit> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[GPrimaryColor, Color(0xff42BD41)])),
      ),
      leading: IconButton(
        color: Colors.white,
        icon: const Appicons(
          icon: Icons.close_rounded,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/base');
        },
      ),
      title: Text(widget.name, style: const TextStyle(color: Colors.white)),
      centerTitle: true,
    );
  }
}
