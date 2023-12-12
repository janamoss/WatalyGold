import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      elevation: 0,
      selectedIndex: 1,
      backgroundColor: const Color.fromRGBO(6, 157, 115, 100),
      indicatorColor: Colors.yellow[600],
      // surfaceTintColor: Colors.white,
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.home_rounded, color: Colors.white),
            label: 'หน้าหลัก'),
        NavigationDestination(
          icon: Icon(Icons.store_rounded, color: Colors.white),
          label: 'ตลาดกลาง',
        ),
        NavigationDestination(
          icon: Icon(Icons.camera_alt_rounded, color: Colors.white),
          label: 'วิเคราะห์\nคุณภาพ',
        ),
        NavigationDestination(
            icon: Icon(Icons.collections_rounded, color: Colors.white),
            label: 'คอลเลคชัน'),
        NavigationDestination(
            icon: Icon(Icons.menu_book_rounded, color: Colors.white),
            label: 'คู่มือการใช้งาน'),
      ],
    );
  }
}
