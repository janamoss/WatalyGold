import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watalygold/Widgets/BTNavBar.dart';
import 'package:watalygold/Widgets/Homebox.dart';

void main() {}

class Homeapp extends StatefulWidget {
  const Homeapp({super.key});

  @override
  State<Homeapp> createState() => _HomeappState();
}

class _HomeappState extends State<Homeapp> {
  int number = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        title: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/WatalyGoldIcons.png',
              fit: BoxFit.contain,
              width: 90,
            ),
          ),
        ),
        flexibleSpace: ClipPath(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
              image: DecorationImage(
                image: AssetImage('assets/images/WatalyGold.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
      body: Column(
        children: [Homebox()],
      ),
      backgroundColor: const Color(0xFFF2F6F5),
    );
  }
}

// class HomeBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         height: 844,
//         child: Stack(
//           children: [
//             Container(
//               width: 390,
//               height: 844,
//               clipBehavior: Clip.antiAlias,
//               decoration: BoxDecoration(color: Color(0xFFF2F6F5)),
//               child: Stack(
//                 children: [
//                   Positioned(
//                     left: 31,
//                     top: 449,
//                     child: Container(
//                       width: 154,
//                       height: 186,
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             left: 0,
//                             top: 0,
//                             child: Container(
//                               width: 154,
//                               height: 186,
//                               decoration: ShapeDecoration(
//                                 color: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 shadows: [
//                                   BoxShadow(
//                                     color: Color(0x3F000000),
//                                     blurRadius: 4,
//                                     offset: Offset(0, 2),
//                                     spreadRadius: 0,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 30,
//                             top: 110,
//                             child: Text(
//                               'คลังความรู้',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20,
//                                 fontFamily: 'IBM Plex Sans Thai',
//                                 fontWeight: FontWeight.w600,
//                                 height: 0,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 35,
//                             top: 26,
//                             child: Container(
//                               width: 84,
//                               height: 84,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                       "https://via.placeholder.com/84x84"),
//                                   fit: BoxFit.fill,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     left: 31,
//                     top: 205,
//                     child: Container(
//                       width: 154,
//                       height: 186,
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             left: 0,
//                             top: 0,
//                             child: Container(
//                               width: 154,
//                               height: 186,
//                               decoration: ShapeDecoration(
//                                 color: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 shadows: [
//                                   BoxShadow(
//                                     color: Color(0x3F000000),
//                                     blurRadius: 4,
//                                     offset: Offset(0, 2),
//                                     spreadRadius: 0,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 30,
//                             top: 107,
//                             child: Text(
//                               'ตลาดกลาง',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20,
//                                 fontFamily: 'IBM Plex Sans Thai',
//                                 fontWeight: FontWeight.w600,
//                                 height: 0,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 35,
//                             top: 23,
//                             child: Container(
//                               width: 84,
//                               height: 84,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                       "https://via.placeholder.com/84x84"),
//                                   fit: BoxFit.fill,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     left: 206,
//                     top: 205,
//                     child: Container(
//                       width: 154,
//                       height: 186,
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             left: 0,
//                             top: 0,
//                             child: Container(
//                               width: 154,
//                               height: 186,
//                               decoration: ShapeDecoration(
//                                 color: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 shadows: [
//                                   BoxShadow(
//                                     color: Color(0x3F000000),
//                                     blurRadius: 4,
//                                     offset: Offset(0, 2),
//                                     spreadRadius: 0,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 30,
//                             top: 107,
//                             child: Text(
//                               'คอลเลคชัน',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20,
//                                 fontFamily: 'IBM Plex Sans Thai',
//                                 fontWeight: FontWeight.w600,
//                                 height: 0,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 35,
//                             top: 23,
//                             child: Container(
//                               width: 84,
//                               height: 84,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                       "https://via.placeholder.com/84x84"),
//                                   fit: BoxFit.fill,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     left: 206,
//                     top: 449,
//                     child: Container(
//                       width: 154,
//                       height: 186,
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             left: 0,
//                             top: 0,
//                             child: Container(
//                               width: 154,
//                               height: 186,
//                               decoration: ShapeDecoration(
//                                 color: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 shadows: [
//                                   BoxShadow(
//                                     color: Color(0x3F000000),
//                                     blurRadius: 4,
//                                     offset: Offset(0, 2),
//                                     spreadRadius: 0,
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 34,
//                             top: 110,
//                             child: Text(
//                               'ประวัติการ\nวิเคราะห์',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20,
//                                 fontFamily: 'IBM Plex Sans Thai',
//                                 fontWeight: FontWeight.w600,
//                                 height: 0,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 35,
//                             top: 26,
//                             child: Container(
//                               width: 84,
//                               height: 84,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                       "https://via.placeholder.com/84x84"),
//                                   fit: BoxFit.fill,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
