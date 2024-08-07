import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Myonboarding_widget extends StatelessWidget {
  const Myonboarding_widget({
    super.key,
    required this.color,
    required this.h1,
    required this.h2,
    required this.description,
    required this.skip,
    required this.image,
    required this.onTab,
  });

  final String color;
  final String h1;
  final String h2;
  final String description;
  final bool skip;
  final List<String> image;
  final VoidCallback onTab;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: hexToColor(color),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.86,
            child: CarouselSlider(
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 1.0,
              ),
              items: image.map((imgPath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imgPath),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.0,
              decoration: BoxDecoration(
                color: GPrimaryColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 45),
                child: Column(
                  children: [
                    SizedBox(
                      height: 62,
                    ),
                    Text(
                      h1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: WhiteColor,
                        
                      ),textAlign: TextAlign.center ,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      h2,
                      style: TextStyle(
                        fontSize: 16,
                        color: WhiteColor,
                      ),textAlign: TextAlign.center
                    ),
                    SizedBox(height: 10),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                        color: WhiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Padding(
                padding: EdgeInsets.all(16),
                child: skip
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'ข้าม',
                              style: TextStyle(
                                fontSize: 16,
                                color: WhiteColor,
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: onTab,
                          //   child: Container(
                          //     padding: EdgeInsets.all(8),
                          //     decoration: BoxDecoration(
                          //         color: YPrimaryColor,
                          //         borderRadius: BorderRadius.circular(50)),
                          //     child: const Icon(
                          //       Icons.arrow_circle_right,
                          //       color: WhiteColor,
                          //       size: 42,
                          //     ),
                          //   ),
                          // )
                        ],
                      )
                    :  SizedBox(
                        height: 45,
                        child: MaterialButton(
                             onPressed: () {  },
                          color: WhiteColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          
                       
                          child: Text("เริ่มต้นใช้งาน"),
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex));
  return Color(int.parse(hex.substring(1), radix: 16) +
      (hex.length == 7 ? 0xFF000000 : 0x00000000));
}
