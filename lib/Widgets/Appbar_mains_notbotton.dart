import 'package:flutter/material.dart';
import 'package:watalygold/Home/Settings/settingPage.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'icon_app.dart';

class Appbarmain_no_botton extends StatelessWidget
    implements PreferredSizeWidget {
  final String name;
  final int? statusoption;

  const Appbarmain_no_botton({required this.name, this.statusoption});

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
                colors: <Color>[GPrimaryColor, Color(0xff42BD41)])),
      ),
      title: Text(name, style: TextStyle(color: Colors.white)),
      actions: statusoption == 1
          ? [
              // IconButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         PageRouteBuilder(
              //           transitionDuration: const Duration(
              //               milliseconds: 200), // กำหนดระยะเวลา transition
              //           transitionsBuilder:
              //               (context, animation, secondaryAnimation, child) {
              //             final animationTween = Tween<Offset>(
              //               begin: Offset(1.0, 0.0), // เริ่มต้นจากขวา
              //               end: Offset(0.0, 0.0), // สิ้นสุดที่ตรงกลาง
              //             );
              //             return SlideTransition(
              //               position: animationTween.animate(animation),
              //               child: child,
              //             );
              //           },
              //           pageBuilder: (context, _, __) => SettingPages(),
              //         ),
              //       );
              //     },
              //     icon: Icon(
              //       Icons.settings_rounded,
              //       color: WhiteColor,
              //       size: 30,
              //     ))
            ]
          : null,
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
