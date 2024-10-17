import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:watalygold/Database/Collection_DB.dart';
import 'package:watalygold/Database/Image_DB.dart';
import 'package:watalygold/Database/Result_DB.dart';
import 'package:watalygold/Database/User_DB.dart';
import 'package:watalygold/ShareResults.dart';
import 'package:watalygold/Widgets/Appbar_main_exit.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/DialogCollection.dart';
import 'package:watalygold/Widgets/DialogSuccess.dart';
import 'package:watalygold/models/Collection.dart';
import 'package:watalygold/models/Image.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {super.key,
      required this.ID_Result,
      required this.ID_Image,
      required this.capturedImage,
      required this.ListImagePath});

  final String ID_Result;
  final List<String> ID_Image;
  final List<File> capturedImage;
  final List<String> ListImagePath;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Collection>? collection;
  bool _loading = true;
  int? user_id;
  int? resultId;

  int? status = 0;

  late String grade = ''; // Initialize grade with a default value
  late String anotherNote = '';
  late double weight = 0.0;

  double totalFlawsPercent = 0;
  double maxFlawsPercent = 0;
  double totalBrownSpot = 0;
  double maxBrownSpot = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _fetchData();
    _loadCollections();
    // stdout.writeln("เสร็จสิ้น");
  }

  Future<void> _loadCollections() async {
    collection = await Collection_DB().fetchAll();
    stdout.writeln(collection!.length);
    setState(() {});
  }

  Future<void> _fetchUserId() async {
    // ดึง user_id จากฐานข้อมูล
    final users = await User_db().fetchAll();
    if (users.isNotEmpty) {
      setState(() {
        user_id = users.first.user_id;
      });
    }
  }

  List<double> calculateFixedPercentages(List<double> n) {
    // กำหนดอัตราส่วนคงที่
    List<double> percentages = [40, 40, 20, 20];

    // คำนวณผลรวมของ n
    double total = n.reduce((a, b) => a + b); // คำนวณผลรวม

    // คำนวณค่าตามอัตราส่วนที่กำหนด
    List<double> results = [];
    for (int i = 0; i < n.length; i++) {
      if (i < percentages.length) {
        double result = (percentages[i] / 100) * total;
        results.add(result);
      } else {
        results.add(0); // กรณีที่ n มีความยาวมากกว่าจำนวนเปอร์เซ็นต์ที่กำหนด
      }
    }

    return results;
  }

  Future<void> _insertImage(int resultId) async {
    stdout.writeln(resultId);
    final results = FirebaseFirestore.instance.collection('Image');

    // สร้าง List เพื่อเก็บค่า flawsPercent และ brownSpot
    List<double> flawsPercentList = [];
    List<double> brownSpotList = [];

    for (int i = 0; i < widget.ID_Image.length; i++) {
      debugPrint("1234");
      final document = await results.doc(widget.ID_Image[i]).get();
      debugPrint(document["img_status"].toString());

      // ดึงค่า flawsPercent และ brownSpot จาก document
      double flawsPercent = document["flaws_percent"].toDouble();
      double brownSpot = document["brown_spot"].toDouble();

      // เก็บค่า flawsPercent และ brownSpot ไว้ใน List
      flawsPercentList.add(flawsPercent);
      brownSpotList.add(brownSpot);

      await Image_DB().insertdata(
          result_id: resultId.toInt(),
          image_status: document["img_status"].toString(),
          image_name: widget.ID_Image[i].toString(),
          image_url: widget.ListImagePath[i].toString(),
          image_weight: document["mango_weight"].toDouble(),
          flaws_percent: document["flaws_percent"].toDouble(),
          brown_spot: document["brown_spot"].toDouble(),
          color: document["color"].toString());

      debugPrint("สร้างข้อมูลรูปภาพเสร็จ");
      setState(() {});
    }

    List<double> fixedFlawsPercentages =
        calculateFixedPercentages(flawsPercentList);
    List<double> fixedBrownSpotPercentages =
        calculateFixedPercentages(brownSpotList);

    // ผลลัพธ์ที่คำนวณได้
    totalFlawsPercent = fixedFlawsPercentages.reduce((a, b) => a + b);
    totalBrownSpot = fixedBrownSpotPercentages.reduce((a, b) => a + b);

    debugPrint("Total Flaws Percent: $totalFlawsPercent");
    debugPrint("Total Brown Spot: $totalBrownSpot");
  }

  Future<void> _showToastUpdate() async {
    await Fluttertoast.showToast(
        msg: "บันทึกลงคอลเลคชันเรียบร้อย",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green.shade300,
        textColor: WhiteColor,
        fontSize: 15);
    await Future.delayed(Duration(seconds: 3));
  }

  Future<void> _fetchData() async {
    try {
      stdout.writeln("step 1");
      final results = FirebaseFirestore.instance.collection('Result');
      final document = await results.doc(widget.ID_Result).get();
      grade = document['Quality'];
      weight = document['Weight'];
      anotherNote = document['Another_note'];
      stdout.writeln("ทำงานอยู่จ้าเด้อ");
      resultId = await Result_DB().create(
          user_id: user_id!,
          another_note: anotherNote,
          quality: grade,
          weight: weight);
      stdout.writeln("เสร็จสิ้นสร้าง result");
      await _insertImage(resultId!);
      setState(() {
        resultId = resultId;
        _loading = false;
      }); // อัพเดตการแสดงผล
    } catch (error) {
      // จัดการข้อผิดพลาด
    }
  }

  @override
  Widget build(BuildContext context) {
    const Map<String, Color> gradeColor = {
      "ขั้นพิเศษ": Color(0xFF42BD41),
      "ขั้นที่ 1": Color(0xFF86BD41),
      "ขั้นที่ 2": Color(0xFFB6AC55),
      "ไม่เข้าข่าย": Color(0xFFB68955),
    };
    return Scaffold(
        appBar: const AppbarMainExit(name: "วิเคราะห์คุณภาพ"),
        body: SingleChildScrollView(
          child: _loading
              ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: WhiteColor,
                    secondRingColor: GPrimaryColor,
                    thirdRingColor: YPrimaryColor,
                    size: 200,
                  ),
                )
              : Column(
                  children: [
                    CarouselSlider(
                      items: widget.capturedImage
                          .map(
                            (image) => AspectRatio(
                              aspectRatio: 16 /
                                  9, // คุณสามารถปรับอัตราส่วนตามต้องการ เช่น 4/3, 1/1 เป็นต้น
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        aspectRatio: 16 / 9, // ต้องตรงกับ AspectRatio ของ item
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    Card(
                      clipBehavior: Clip.hardEdge,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(0),
                          bottom: Radius.circular(20),
                        ),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      color: WhiteColor,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: gradeColor[grade],
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20)),
                            ),
                            width: double.infinity,
                            height: 35,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Text(
                                "จากผลการวิเคราะห์คุณภาพพบว่า :",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, top: 10),
                                child: Text(
                                  "เกรดระดับ ",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  "$grade",
                                  style: TextStyle(
                                      color: gradeColor[grade], fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 110, top: 0),
                                child: IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.shareNodes,
                                    color: gradeColor[grade],
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SharePage(
                                          grade: grade,
                                          anotherNote: anotherNote,
                                          capturedImages: widget.capturedImage,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25, top: 5, bottom: 10, right: 15),
                                child: SingleChildScrollView(
                                  child: Text(
                                    anotherNote,
                                    style: TextStyle(
                                        color: gradeColor[grade], fontSize: 17),
                                    // overflow: TextOverflow.ellipsis,
                                    // maxLines: 2,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Card(
                      clipBehavior: Clip.hardEdge,
                      margin: EdgeInsets.only(top: 25),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(10),
                        ),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      color: WhiteColor,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                              color: Color(0xFF069D73),
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            width: double.infinity,
                            height: 35,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "รายละเอียด",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FittedBox(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: SizedBox(
                                    width: 140,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      leading: Icon(
                                        Icons.scale_rounded,
                                        size: 25,
                                        color: GPrimaryColor,
                                      ),
                                      title: Text(
                                        "น้ำหนัก : ",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 17),
                                child: Text(
                                  weight.toStringAsFixed(2) + " กรัม",
                                  style: TextStyle(
                                      color: Color(0xFF42BD41), fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FittedBox(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: SizedBox(
                                    width: 140,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      leading: Icon(
                                        Icons.brightness_1,
                                        size: 25,
                                        color: GPrimaryColor,
                                      ),
                                      title: Text(
                                        "พื้นที่จุดตำหนิ : ",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 17),
                                child: Text(
                                  totalFlawsPercent.toStringAsFixed(2) +
                                      " ตารางเซนติเมตร",
                                  style: TextStyle(
                                      color: Color(0xFF42BD41), fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FittedBox(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: SizedBox(
                                    width: 140,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      leading: Icon(
                                        Icons.bubble_chart_rounded,
                                        size: 25,
                                        color: GPrimaryColor,
                                      ),
                                      title: Text(
                                        "พื้นที่จุดกระสีน้ำตาล : ",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 17),
                                child: Text(
                                  totalBrownSpot.toStringAsFixed(2) +
                                      " เปอร์เซนต์",
                                  style: TextStyle(
                                      color: Color(0xFF42BD41), fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(25),
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Colors.white, Color(0xFFF2F6F5)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 8,
                            offset: Offset(2, 2),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(top: 25, left: 25, right: 25),
                            child: Text(
                              "คุณต้องการที่จะบันทึกลงคอลเลคชั่นของคุณหรือไม่ ?",
                              style: TextStyle(
                                  fontSize: 17, color: Color(0xff069D73)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  surfaceTintColor: status == 1
                                      ? MaterialStateProperty.all(
                                          Color(0xff069D73))
                                      : MaterialStateProperty.all(Colors.white),
                                  backgroundColor: status == 1
                                      ? MaterialStateProperty.all(
                                          Color(0xff069D73))
                                      : MaterialStateProperty.all(Colors.white),
                                  side: MaterialStateProperty.all(BorderSide(
                                      color: Color(0xff069D73), width: 2))),
                              onPressed: status == 1
                                  ? null
                                  : () async {
                                      await _displaybottomsheet(context);
                                      setState(() {});
                                    },
                              child: Text(
                                status == 1
                                    ? "คุณได้บันทึกลงคอลเลคชันเรียบร้อย"
                                    : "บันทึกลงคอลเลคชั่นของคุณ",
                                style: TextStyle(
                                    color: status == 1
                                        ? WhiteColor
                                        : Color(0xff069D73),
                                    fontSize: 15),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }

  Future _displaybottomsheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "บันทึกลงคอลเลคชันของคุณ",
                  style: TextStyle(
                      color: GPrimaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                // Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (int i = 0; i < collection!.length; i++)
                  ListTile(
                    leading: new Icon(
                      Icons.collections_rounded,
                      color: Colors.grey.shade700,
                      size: 30,
                    ),
                    title: Text(
                      collection![i].collection_name,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      _showToastUpdate();
                      final s = await Result_DB().updatecollection(
                          collection![i].collection_id, resultId!);
                      stdout.writeln("$s จ้าาาาาาา");
                      stdout.writeln(collection![i].collection_id);
                      setState(() {
                        status = 1;
                      });
                      Navigator.pop(context);
                      // widget.refreshCallback();
                    },
                  ),
                ListTile(
                  leading: SvgPicture.asset(
                    "assets/images/collections-add-svgrepo-com.svg",
                    colorFilter:
                        ColorFilter.mode(Colors.grey.shade700, BlendMode.srcIn),
                    semanticsLabel: 'A red up arrow',
                    height: 30,
                    width: 30,
                  ),
                  title: Text(
                    'สร้างคอลเลคชัน',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    final bool? result = await showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      transitionDuration: Duration(milliseconds: 500),
                      transitionBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final tween = Tween(begin: 0.0, end: 1.0).chain(
                          CurveTween(curve: Curves.bounceOut),
                        );
                        return ScaleTransition(
                          scale: animation.drive(tween),
                          child: child,
                        );
                      },
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return DialogCollection();
                      },
                    );
                    if (result == true) {
                      dialogsuccess(context);
                    } else {
                      Navigator.pop(context);
                    }
                    // Navigator.pop(context);
                    _loadCollections();
                    // widget.refreshCallback();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//           Container(
//             alignment: Alignment.topCenter,
//             // padding: const EdgeInsets.only(left: 25),
//             height: 130,
//             decoration: const BoxDecoration(
//               color: Colors.greenAccent,
//               borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//             ),
//             child: const Text(
//               "จากผลการวิเคราะห์คุณภาพพบว่า :",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ),