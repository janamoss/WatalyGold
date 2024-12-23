import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/widgets.dart';
import 'package:watalygold/Widgets/Color.dart';

class Manualphoto extends StatefulWidget {
  const Manualphoto({super.key});

  @override
  State<Manualphoto> createState() => _ManualphotoState();
}

final List<Map<String, String>> mangoImages = [
  {"image": "assets/images/f5.jpg", "label": "ด้านหน้า"},
  {"image": "assets/images/back5.jpg", "label": "ด้านหลัง"},
  {"image": "assets/images/Bottom5.jpg", "label": "ด้านล่าง"},
  {"image": "assets/images/top5.jpg", "label": "ด้านบน"},
];

class _ManualphotoState extends State<Manualphoto> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * 1,
      // height: 100,
      color: Colors.white,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.1,
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
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width * 0.78,
                child: const Text(
                  "ถ่ายภาพผลมะม่วงให้ครบทั้งหมด 4 ด้าน คือ ด้านหน้า ด้านหลัง ด้านบน และด้านล่าง ทุกภาพต้องมีเหรียญ 5 บาท 1 เหรียญในการวางไว้รอบข้างมะม่วง",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              height: 220,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: mangoImages.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          item['image']!,
                          fit: BoxFit.cover,
                          height: 150,
                        ),
                        SizedBox(height: 10),
                        Text(
                          item['label']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: mangoImages.asMap().entries.map((entry) {
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
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: GPrimaryColor,
                      ),
                      child: const Center(
                        child: Text(
                          "2",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: const Text(
                      "ถ่ายภาพต้องมีระยะห่างจากมะม่วง 30 ซม.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 300,
                height: 200,
                child: Image.asset(
                  "assets/images/mango30cm.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
