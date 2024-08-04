import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'icon_app.dart';

class Appbarmain extends StatelessWidget implements PreferredSizeWidget {
  final String name;

  const Appbarmain({required this.name});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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

class AppbarMains extends StatefulWidget implements PreferredSizeWidget {
  final String name;
  final VoidCallback? refresh;

  const AppbarMains({Key? key, required this.name, this.refresh})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppbarMains> createState() => _AppbarMainsState();
}

class _AppbarMainsState extends State<AppbarMains> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[GPrimaryColor, Color(0xff42BD41)])),
      ),
      leading: IconButton(
        color: Colors.white,
        icon: Appicons(
          icon: Icons.arrow_back_rounded,
        ),
        onPressed: widget.refresh == null
            ? () {
                Navigator.pop(context);
                // widget.refresh!();
              }
            : () {
                Navigator.pop(context);
                widget.refresh!();
              },
      ),
      title: Text(widget.name, style: TextStyle(color: Colors.white)),
      centerTitle: true,
    );
  }
}
