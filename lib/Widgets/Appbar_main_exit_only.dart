import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/icon_app.dart';

class AppbarMainExit_only extends StatefulWidget implements PreferredSizeWidget {
  final String name;
  final Widget? actions;
  const AppbarMainExit_only({Key? key, required this.name, this.actions})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppbarMainExit_only> createState() => _AppbarMainExit_onlyState();
}

class _AppbarMainExit_onlyState extends State<AppbarMainExit_only> {
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
            _showExitConfirmationDialog(context);
          },
        ),
        title: Text(widget.name, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: widget.actions != null ? [widget.actions!] : null);
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: WhiteColor,
          surfaceTintColor: WhiteColor,
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'คุณแน่ใจหรือไม่ว่าต้องการออกจากหน้านี้ ?',
              style: TextStyle(
                  color: GPrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          content: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'ถ้าหากออกจากหน้านี้\nคุณจะต้องเริ่มกระบวนการใหม่ทั้งหมด',
              style: TextStyle(color: Colors.black, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "ยกเลิก",
                        style: TextStyle(
                            color: WhiteColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          elevation: MaterialStateProperty.all(2),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red.shade400),
                          surfaceTintColor:
                              MaterialStateProperty.all(Colors.red.shade400))),
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // ปิด dialog
                        Navigator.pushNamed(
                            context, '/base'); // เปลี่ยนหน้าเมื่อกด "ตกลง"
                      },
                      child: Text(
                        "ยืนยัน",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          elevation: MaterialStateProperty.all(2),
                          backgroundColor:
                              MaterialStateProperty.all(G2PrimaryColor),
                          surfaceTintColor:
                              MaterialStateProperty.all(G2PrimaryColor))),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
