import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/icon_app.dart';

class AppbarHistion extends StatefulWidget implements PreferredSizeWidget {
  final String name;
  final String name2;
  const AppbarHistion({super.key, required this.name, required this.name2});

  @override
  State<AppbarHistion> createState() => _AppbarHistionState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppbarHistionState extends State<AppbarHistion> {
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
      actions: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // นำทางไปยังหน้า "ประวัติการวิเคราะห์"
                  Navigator.pushNamed(context, '/history_analysis');
                },
                child: Text(
                  'ประวัติการวิเคราะห์',
                  style: const TextStyle(
                    color: WhiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
              ),
              GestureDetector(
                onTap: () {
                  // นำทางไปยังหน้า "คอลเลคชั่นมะม่วง"
                  Navigator.pushNamed(context, '/mango_collection');
                },
                child: Text(
                  'คอลเลคชั่นมะม่วง',
                  style: const TextStyle(
                    color: WhiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
