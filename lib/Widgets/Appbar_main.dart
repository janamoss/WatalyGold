import 'package:flutter/material.dart';
import 'icon_app.dart';


class Appbarmain extends StatelessWidget {
  final String name;

  const Appbarmain({required this.name});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      leading: IconButton(
        color: Colors.white,
        icon: Appicons(
          icon: Icons.arrow_back_rounded,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(name, style: TextStyle(color: Colors.white)),
      centerTitle: true,
    );
  }
}
