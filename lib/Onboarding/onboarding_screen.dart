import 'package:flutter/material.dart';
import 'package:watalygold/Onboarding/onboarding_widget.dart';
import 'package:watalygold/Widgets/Color.dart';

class Myonboardingscreen extends StatefulWidget {
  const Myonboardingscreen({super.key});

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
      'image': ['assets/images/BG-MangoOnboard-Photoroom.png'],
      'description':
          'แอปพลิเคชันสามารถวิเคราะห์คุณภาพผลมะม่วงน้ำดอกไม้สีทองให้ตรงตามมาตรฐานสินค้าเกษตร(มกษ.) ติดตามราคาส่งออกของมะม่วงน้ำดอกไม้สีทองและมีคลังความรู้เกี่ยวกับมะม่วงน้ำดอกไม้สีทอง',
      'skip': true,
    },
    {
      'color': "ffFFEE58",
      'H1':
          'แอปพลิเคชันวิเคราะห์คุณภาพผลมะม่วงน้ำดอกไม้สีทองโดยการประมวลผลภาพ ',
      'H2': 'Mango Fruit Quality Analysis Application By Image Processing',
      'image': ['assets/images/BG-MangoOnboard-Photoroom.png'],
      'description':
          'แอปพลิเคชันสามารถวิเคราะห์คุณภาพผลมะม่วงน้ำดอกไม้สีทองให้ตรงตามมาตรฐานสินค้าเกษตร(มกษ.) ติดตามราคาส่งออกของมะม่วงน้ำดอกไม้สีทองและมีคลังความรู้เกี่ยวกับมะม่วงน้ำดอกไม้สีทอง',
      'skip': true,
    },
    {
      'color': "ffFFEE58",
      'H1':
          'แอปพลิเคชันวิเคราะห์คุณภาพผลมะม่วงน้ำดอกไม้สีทองโดยการประมวลผลภาพ ',
      'H2': 'Mango Fruit Quality Analysis Application By Image Processing',
      'image': ['assets/images/BG-MangoOnboard-Photoroom.png'],
      'description':
          'แอปพลิเคชันสามารถวิเคราะห์คุณภาพผลมะม่วงน้ำดอกไม้สีทองให้ตรงตามมาตรฐานสินค้าเกษตร(มกษ.) ติดตามราคาส่งออกของมะม่วงน้ำดอกไม้สีทองและมีคลังความรู้เกี่ยวกับมะม่วงน้ำดอกไม้สีทอง',
      'skip': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _activePage = page;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Myonboarding_widget(
                color: _pages[index]['color'],
                h1: _pages[index]['H1'],
                h2: _pages[index]['H2'],
                description: _pages[index]['description'],
                image: List<String>.from(_pages[index]['image']),
                skip: _pages[index]['skip'],
                onTab: onNextPage,
              );
            }),
        Positioned(
          top: MediaQuery.of(context).size.height / 1.1,
          bottom: 0,
          right: 0,
          left: 0,
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildIndicator())
            ],
          ),
        ),
      ],
    ));
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
    if(_activePage == 0){
      color = '#ffe24e';
    } else if(_activePage == 1){
      color = '#a3e4f1';
    } else{
      color = '#a3e4f1';
    }
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 6,
      width: 42,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: WhiteColor),
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
