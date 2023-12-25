import 'package:flutter/material.dart';
import 'Color.dart';

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

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: YPrimaryColor,
      backgroundColor: GPrimaryColor,
      unselectedItemColor: WhiteColor,
      elevation: 0,
      items: [
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.home_rounded, color: YPrimaryColor),
          icon: Icon(Icons.home_rounded, color: WhiteColor),
          label: 'หน้าหลัก',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.store_rounded, color: YPrimaryColor),
          icon: Icon(Icons.store_rounded, color: WhiteColor),
          label: 'ตลาดกลาง',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.camera_alt_rounded, color: YPrimaryColor),
          icon: Icon(Icons.camera_alt_rounded, color: WhiteColor),
          label: 'วิเคราะห์\nคุณภาพ',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.collections_rounded, color: YPrimaryColor),
          icon: Icon(Icons.collections_rounded, color: WhiteColor),
          label: 'คอลเลคชัน',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.menu_book_rounded, color: YPrimaryColor),
          icon: Icon(Icons.menu_book_rounded, color: WhiteColor),
          label: 'คู่มือการ\nใช้งาน',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}