import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:watalygold/Widgets/Color.dart';

class WeightManual extends StatefulWidget {
  const WeightManual({Key? key}) : super(key: key);

  @override
  State<WeightManual> createState() => _WeightManualState();
}

class _WeightManualState extends State<WeightManual> {
  int _current = 0;
  int _circleNumber = 1;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: GPrimaryColor,
                  ),
                  child: const Center(
                    child: Text(
                      "1",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "ถ่ายภาพจากตาชั่งดิจิทัลที่เห็นตัวเลขและหน่วยของตาชั่งดิจิทัลอย่างชัดเจน ห้ามถ่ายใกล้หรือไกลเกิน",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    softWrap: true,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              "assets/images/closefar.png",
              width: 250,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: GPrimaryColor,
                ),
                child: const Center(
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "ถ่ายภาพตาชั่งดิจิทัลในพื้นที่มีแสงเพียงพอ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              "assets/images/Whiteblack.png",
              width: 250,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: GPrimaryColor,
                ),
                child: const Center(
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "ครอบภาพให้คล้ายคลึงกับตัวอย่างให้ใกล้เคียงมากที่สุด",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              "assets/images/WeightNumber_Cut.png",
              width: 250,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
