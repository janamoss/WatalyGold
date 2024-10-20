import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  final int selectedIndex; // Receive selectedIndex from _BasePageState
  final Function(int) onItemTapped; // Receive callback function

  const BottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
    Key? key,
  }) : super(key: key);

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
      currentIndex:
          widget.selectedIndex, // Set currentIndex using received selectedIndex
      onTap: widget.onItemTapped, // Call the callback function on tap
    );
  }
}

class BottomAppbar extends StatefulWidget {
  final int selectedIndex; // Receive selectedIndex from _BasePageState
  final Function(int) onItemTapped; // Receive callback function

  const BottomAppbar(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  State<BottomAppbar> createState() => _BottomAppbarState();
}

class _BottomAppbarState extends State<BottomAppbar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: EdgeInsets.all(3),
      shape: CircularNotchedRectangle(),
      color: GPrimaryColor,
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => widget.onItemTapped(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home_rounded,
                        color: widget.selectedIndex == 0
                            ? YPrimaryColor
                            : WhiteColor,
                        size: 30,
                      ),
                      // IconButton(
                      //   isSelected: widget.selectedIndex == 0,
                      //   onPressed: () {
                      //     widget.onItemTapped(0);
                      //   },
                      //   icon: Icon(
                      //     Icons.home_rounded,
                      //     color: WhiteColor,
                      //   ),
                      //   selectedIcon: Icon(Icons.home_rounded, color: YPrimaryColor),
                      // ),
                      Text(
                        "หน้าหลัก",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: widget.selectedIndex == 0
                              ? YPrimaryColor
                              : WhiteColor,
                          fontSize: 11,
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => widget.onItemTapped(1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.store_rounded,
                        color: widget.selectedIndex == 1
                            ? YPrimaryColor
                            : WhiteColor,
                        size: 30,
                      ),
                      // IconButton(
                      //   isSelected: widget.selectedIndex == 1,
                      //   onPressed: () {
                      //     widget.onItemTapped(1);
                      //   },
                      //   icon: Icon(
                      //     Icons.store_rounded,
                      //     color: WhiteColor,
                      //   ),
                      //   selectedIcon: Icon(Icons.store_rounded, color: YPrimaryColor),
                      // ),
                      Text(
                        "ตลาดกลาง",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: widget.selectedIndex == 1
                              ? YPrimaryColor
                              : WhiteColor,
                          fontSize: 11,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => widget.onItemTapped(3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.collections_rounded,
                          color: widget.selectedIndex == 3
                              ? YPrimaryColor
                              : WhiteColor,
                          size: 30,
                        ),
                        // IconButton(
                        //   isSelected: widget.selectedIndex == 3,
                        //   onPressed: () {
                        //     widget.onItemTapped(3);
                        //   },
                        //   icon: Icon(
                        //     Icons.collections_rounded,
                        //     color: WhiteColor,
                        //   ),
                        //   selectedIcon:
                        //       Icon(Icons.collections_rounded, color: YPrimaryColor),
                        // ),
                        Text(
                          "คอลเลคชัน",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.selectedIndex == 3
                                ? YPrimaryColor
                                : WhiteColor,
                            fontSize: 11,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => widget.onItemTapped(4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.list_rounded,
                          color: widget.selectedIndex == 4
                              ? YPrimaryColor
                              : WhiteColor,
                          size: 30,
                        ),
                        // IconButton(
                        //   isSelected: widget.selectedIndex == 4,
                        //   onPressed: () {
                        //     widget.onItemTapped(4);
                        //   },
                        //   icon: Icon(
                        //     Icons.menu_book_rounded,
                        //     color: WhiteColor,
                        //   ),
                        //   selectedIcon:
                        //       Icon(Icons.menu_book_rounded, color: YPrimaryColor),
                        // ),
                        Text(
                          "เพิ่มเติม",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.selectedIndex == 4
                                ? YPrimaryColor
                                : WhiteColor,
                            fontSize: 11,
                          ),
                        )
                      ],
                    ),
                  )
                ]),
          ),
        ],
      ),
    );
  }
}
