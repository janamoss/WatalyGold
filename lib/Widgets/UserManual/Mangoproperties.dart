import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:watalygold/Widgets/Color.dart';

class Mangoproperties extends StatefulWidget {
  const Mangoproperties({Key? key}) : super(key: key);

  @override
  State<Mangoproperties> createState() => _MangopropertiesState();
}

class _MangopropertiesState extends State<Mangoproperties> {
  int _current = 0;
   int _circleNumber = 1; 
  final CarouselController _controller = CarouselController();

  final List<String> imgListClassone = [
    "assets/images/Classonefront.jpg",
    "assets/images/Classoneback.jpg",
    "assets/images/Classonebottom.jpg",
    "assets/images/Classonetop.jpg"
  ];

  final List<String> imgListClasstwo = [
    "assets/images/Classtwofront.jpg",
    "assets/images/Classtwoback.jpg",
    "assets/images/Classtwobottom.jpg",
    "assets/images/Classtwotop.jpg"
  ];

  final List<String> imgListExtraClass = [
    "assets/images/Extrafront.jpg",
    "assets/images/Extraback.jpg",
    "assets/images/Extrabottom.jpg",
    "assets/images/Extratop.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
           width: MediaQuery.of(context).size.width * 1,
          height: 1600,
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSection(
                title: 'ชั้นพิเศษ (Extra Class)',
                images: imgListExtraClass,
                description: [
                  'สีหรือรูปร่าง : เหลืองทอง ไม่มีความผิดปกติทางรูปร่างของมะม่วง',
                  'จุดตำหนิ : ไม่มีจุดตำหนิและจุดกระสีน้ำตาลที่ผิวของมะม่วง',
                  'น้ำหนัก : 450 กรัมขึ้นไป',
                ],
                circleNumber: 1,
              ),
              buildSection(
                title: 'ชั้นที่หนึ่ง (Class 1)',
                images: imgListClassone,
                description: [
                  'สีหรือรูปร่าง : เหลืองทอง ไม่มีความผิดปกติทางรูปร่างของมะม่วง',
                  'จุดตำหนิ : มีจุดตำหนิที่ผิวของมะม่วงรวมกันไม่เกิน 4 ตารางเซนติเมตร และจุดกระสีน้ำตาลรวมกันไม่เกิน 30% ของพื้นที่ผิว',
                  'น้ำหนัก : 350-449 กรัมขึ้นไป',
                ],
                circleNumber: 2,
              ),
              buildSection(
                title: 'ชั้นที่สอง (Class 2)',
                images: imgListClasstwo,
                description: [
                  'สีหรือรูปร่าง : เหลืองทอง มีความผิดปกติทางรูปร่างของมะม่วงเล็กน้อย',
                  'จุดตำหนิ : มีจุดตำหนิที่ผิวของมะม่วงรวมกันไม่เกิน 5 ตารางเซนติเมตร และจุดกระสีน้ำตาลรวมกันไม่เกิน 40% ของพื้นที่ผิว',
                  'น้ำหนัก : 250-349 กรัมขึ้นไป',
                ],
                circleNumber: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required List<String> images,
    required List<String> description,
     int circleNumber = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: GPrimaryColor,
              ),
              child: Center(
                child: Text(
                  '$circleNumber',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: 220,
          child: buildImageCarousel(images),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: description
                .map((item) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        SizedBox(height: 10),
        Divider(
          thickness: 1,
          indent: 5,
          endIndent: 5,
          color: GPrimaryColor,
        ),
      ],
    );
  }

  Widget buildImageCarousel(List<String> imageList) {
    final List<Widget> imageSliders = imageList
        .map((item) => Container(
              child: Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(item, fit: BoxFit.cover, width: 260.0),
                    ],
                  ),
                ),
              ),
            ))
        .toList();

    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 1.9,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GPrimaryColor.withOpacity(
                      _current == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}