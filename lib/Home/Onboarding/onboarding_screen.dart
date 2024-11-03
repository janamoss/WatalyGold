import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watalygold/Home/Onboarding/onboarding_widget.dart';
import 'package:watalygold/Home/basepage.dart';
// import 'package:watalygold/Onboarding/onboarding_widget.dart';
import 'package:watalygold/Widgets/Color.dart';

class Myonboardingscreen extends StatefulWidget {
  final List<CameraDescription> camera;
  const Myonboardingscreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  // const Myonboardingscreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<Myonboardingscreen> createState() => _MyonboardingscreenState();
}

class _MyonboardingscreenState extends State<Myonboardingscreen> {
  final PageController _pageController = PageController();

  int _activePage = 0;

  void onNextPage() {
    if (_activePage < _pages.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    }
  }

  final List<Map<String, dynamic>> _pages = [
    {
      'color': "ff069D73",
      'H1':
          'แอปพลิเคชันวิเคราะห์คุณภาพผลมะม่วงน้ำดอกไม้สีทองโดยการประมวลผลภาพ ',
      'H2': 'Mango Fruit Quality Analysis Application By Image Processing',
      'image': ['assets/images/onboarding-11.gif'],
      'description':
          'แอปพลิเคชันสามารถวิเคราะห์คุณภาพผลมะม่วงน้ำดอกไม้สีทองให้ตรงตามมาตรฐานสินค้าเกษตร(มกษ.) ติดตามราคาส่งออกของมะม่วงน้ำดอกไม้สีทองและมีคลังความรู้เกี่ยวกับมะม่วงน้ำดอกไม้สีทอง',

      
    },
    {
      'color': "ffFFEE58",
      'H1': 'การถ่ายภาพมะม่วง',
      'H2':
          'เพื่อให้การวิเคราะห์มีความแม่นยำ ต้องถ่ายภาพผลมะม่วงให้ครบ 4 ด้าน ได้แก่ ด้านหน้า ด้านหลัง ด้านบน และด้านล่าง โดยมีระยะห่างจากผลมะม่วงประมาณ 30 ซม. และวางเหรียญ 5 บาทข้างๆ ผลมะม่วง',
      'image': ['assets/images/onboarding-22.gif'],
      'description': '',
    },
    {
      'color': "ffFFEE58",
      'H1': 'ตัวอย่างผลลัพธ์การวิเคราะห์',
      'H2':
          'หลังจากทำการวิเคราะห์ผลมะม่วงน้ำดอกไม้สีทอง แอปพลิเคชันจะแสดงผลลัพธ์ที่ประกอบด้วยข้อมูลคุณภาพของผลมะม่วง คือ เกรดของมะม่วง ความกว้าง ความยาว และน้ำหนัก',
      'image': ['assets/images/onboarding-33.gif'],
      'description': '',
    },
  ];

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Container(
          color: GPrimaryColor,
          child: isLastPage
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Getstart(),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            _pages.length - 1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text(
                          'ข้าม',
                          style: TextStyle(
                            fontSize: 20,
                            color: WhiteColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildIndicator(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: TextButton(
                          onPressed: () => _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linear),
                          // onPressed: () {},
                          child: const Text(
                            'ถัดไป',
                            style: TextStyle(
                              fontSize: 20,
                              color: WhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        body: PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _activePage = page;
                isLastPage = (page == _pages.length - 1);
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Myonboarding_widget(
                color: _pages[index]['color'],
                h1: _pages[index]['H1'],
                h2: _pages[index]['H2'],
                description: _pages[index]['description'],
                image: List<String>.from(_pages[index]['image']),
                indicators: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildIndicator(),
                ),
              );
            })
        // body: Stack(
        //   children: [
        //     PageView.builder(
        //         controller: _pageController,
        //         itemCount: _pages.length,
        //         onPageChanged: (int page) {
        //           setState(() {
        //             _activePage = page;
        //             isLastPage = (page == _pages.length - 1);
        //           });
        //         },
        //         itemBuilder: (BuildContext context, int index) {
        //           return Myonboarding_widget(
        //             color: _pages[index]['color'],
        //             h1: _pages[index]['H1'],
        //             h2: _pages[index]['H2'],
        //             description: _pages[index]['description'],
        //             image: List<String>.from(_pages[index]['image']),
        //           );
        //         }),
        //     Positioned(
        //       top: MediaQuery.of(context).size.height / 1.18,
        //       bottom: 0,
        //       right: 0,
        //       left: 0,
        //       child: Column(
        //         children: [
        //           Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: _buildIndicator())
        //         ],
        //       ),
        //     ),
        //   ],
        // )
        );
  }

  Widget Getstart() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 45,
      child: MaterialButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool("onboarding", true);

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BasePage(
                camera: widget.camera,
              ),
            ),
          );
        },
        color: WhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text(
          "เริ่มต้นใช้งาน",
          style: TextStyle(
              fontSize: 18, color: GPrimaryColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    final indicators = <Widget>[];

    for (var i = 0; i < _pages.length; i++) {
      if (_activePage == i) {
        indicators.add(_indicatorsTrue());
      } else {
        indicators.add(_indicatorsFalse());
      }
    }
    return indicators;
  }

  Widget _indicatorsTrue() {
    final String color;
    if (_activePage == 0) {
      color = '#ffFFEE58';
    } else if (_activePage == 1) {
      color = '#ffFFEE58';
    } else {
      color = '#ffFFEE58';
    }
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 6,
      width: 42,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: YPrimaryColor),
    );
  }

  Widget _indicatorsFalse() {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 8,
      width: 8,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: WhiteColor),
    );
  }
}
