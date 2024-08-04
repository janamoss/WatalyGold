import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/models/contents.dart';
import 'package:watalygold/models/knowledge.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class KnowledgePage extends StatefulWidget {
  final Knowledge? knowledge;
  final IconData? icons;
  final Contents? contents;
  const KnowledgePage({super.key, this.knowledge, this.contents, this.icons});

  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  late String detail =
      widget.knowledge!.knowledgeDetail.replaceAll('\n', '\n\n');

  late CarouselController controller;
  int currentIndex = 0;

  @override
  void initState() {
    controller = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      appBar: Appbarmain(
        name: widget.knowledge != null
            ? widget.knowledge!.knowledgeName
            : widget.contents!.ContentName,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                CarouselSlider(
                  items: widget.knowledge != null
                      ? widget.knowledge!.knowledgeImg.map((img) {
                          return Image.network(
                            img,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        }).toList()
                      : widget.contents!.ImageURL.map((img) {
                          return Image.network(
                            img,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        }).toList(),
                  carouselController: controller,
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    height: 300,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  child: DotsIndicator(
                    dotsCount: widget.knowledge != null
                        ? widget.knowledge!.knowledgeImg.length
                        : widget.contents!.ImageURL.length,
                    position: currentIndex,
                    onTap: (position) {
                      controller.animateToPage(position.toInt());
                    },
                    decorator: DotsDecorator(
                      color: GPrimaryColor.withOpacity(0.4),
                      activeColor: GPrimaryColor.withOpacity(0.9),
                      size: const Size.square(9.0),
                      activeSize: const Size(18.0, 9.0),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                )
              ],
            ),
            // Image.network(
            // widget.knowledge != null
            //     ? widget.knowledge!.knowledgeImg
            //     : widget.contents!.ImageURL,
            //   fit: BoxFit.cover,
            //   height: 400,
            // ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                decoration: BoxDecoration(
                  color: WhiteColor,
                  border: Border(
                      top: BorderSide(
                    color: GPrimaryColor,
                    width: 5,
                  )),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(widget.icons ?? Icons.question_mark_rounded,
                            color: GPrimaryColor, size: 40),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            widget.knowledge != null
                                ? widget.knowledge!.knowledgeName
                                : widget.contents!.ContentName,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    HtmlWidget(
                      widget.knowledge != null
                          ? '${widget.knowledge!.knowledgeDetail}'
                          : '${widget.contents!.ContentDetail}',
                      textStyle: TextStyle(color: Colors.black, fontSize: 15),
                      renderMode: RenderMode.column,
                      customStylesBuilder: (element) {
                        if (element.localName == 'br') {
                          return {'margin': '0', 'padding': '0'};
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// FutureBuilder<void>(
//       future: Future.delayed(Duration(seconds: 3)),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: LoadingAnimationWidget.discreteCircle(
//               color: WhiteColor,
//               secondRingColor: GPrimaryColor,
//               thirdRingColor: YPrimaryColor,
//               size: 200,
//             ),
//           );
//         } else {
//           return _buildKnowledgePageContent(context);
//         }
//       },
    // );