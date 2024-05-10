import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watalyGold/widget/Color.dart';


class Mangoproperties extends StatefulWidget {
  const Mangoproperties({super.key});

  @override
  State<Mangoproperties> createState() => _MangopropertiesState();
}

class _MangopropertiesState extends State<Mangoproperties> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Container(
          // width: MediaQuery.of(context).size.width * 1,
          // height: 100,

          child: Column(
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
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: const Text(
                      "ชั้นพิเศษ (Extra Class)",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        child: Image.asset(
                          "assets/images/front.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ด้านหน้า",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        child: Image.asset(
                          "assets/images/front.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ด้านบน",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        child: Image.asset(
                          "assets/images/front.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ด้านหลัง",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        child: Image.asset(
                          "assets/images/front.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ด้านล่าง",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "สีหรือรูปร่าง : ",
                            style: TextStyle(
                              color: GPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "เหลืองทอง ไม่มีความผิดปกติทางรูปร่างของมะม่วง",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "จุดตำหนิ :",
                            style: TextStyle(
                              color: GPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "ไม่มีจุดตำหนิและจุดกระสีน้ำตาลที่ผิวของมะม่วง ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "น้ำหนัก : ",
                            style: TextStyle(
                              color: GPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "450 กรัมขึ้นไป",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 1,
                indent: 5,
                endIndent: 5,
                color: GPrimaryColor,
              ),
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
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: const Text(
                      "ชั้นที่หนึ่ง (Class 1) ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        child: Image.asset(
                          "assets/images/front.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ด้านหน้า",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        child: Image.asset(
                          "assets/images/front.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ด้านบน",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        child: Image.asset(
                          "assets/images/front.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ด้านหลัง",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        child: Image.asset(
                          "assets/images/front.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ด้านล่าง",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "สีหรือรูปร่าง : ",
                            style: TextStyle(
                              color: GPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "เหลืองทอง ไม่มีความผิดปกติทางรูปร่างของมะม่วง ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "จุดตำหนิ :",
                            style: TextStyle(
                              color: GPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "มีจุดตำหนิที่ผิวของมะม่วงรวมกันไม่เกิน 4 ตารางเซนติเมตร และจุดกระสีน้ำตาลรวมกันไม่เกิน 30% ของพื้นที่ผิว",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "น้ำหนัก : ",
                            style: TextStyle(
                              color: GPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            " 350-449 กรัมขึ้นไป",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 1,
                indent: 5,
                endIndent: 5,
                color: GPrimaryColor,
              ),
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
                          "3",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: const Text(
                      "ชั้นที่สอง (Class 2) ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        child: Image.asset(
                          "assets/images/front.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ด้านหน้า",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        child: Image.asset(
                          "assets/images/front.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ด้านบน",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        child: Image.asset(
                          "assets/images/front.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ด้านหลัง",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        child: Image.asset(
                          "assets/images/front.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ด้านล่าง",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "สีหรือรูปร่าง : ",
                            style: TextStyle(
                              color: GPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "เหลืองทอง มีความผิดปกติทางรูปร่างของมะม่วงเล็กน้อย",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "จุดตำหนิ :",
                            style: TextStyle(
                              color: GPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              " มีจุดตำหนิที่ผิวของมะม่วงรวมกันไม่เกิน 5 ตารางเซนติเมตร และจุดกระสีน้ำตาลรวมกันไม่เกิน 40% ของพื้นที่ผิว",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "น้ำหนัก : ",
                            style: TextStyle(
                              color: GPrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            " 250-349 กรัมขึ้นไป",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
