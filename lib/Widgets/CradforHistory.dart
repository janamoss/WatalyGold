import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/models/Result_ana.dart';

class CradforHistory extends StatefulWidget {
  final String name;
  final String result;
  final String date;
  final Result? result_id;
  const CradforHistory(
      {super.key,
      required this.name,
      required this.result,
      required this.date,
      this.result_id});

  @override
  State<CradforHistory> createState() => _CradforHistoryState();
}

class _CradforHistoryState extends State<CradforHistory> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // กำหนด radius ของการ์ด
      ),
      surfaceTintColor: WhiteColor,
      child: SizedBox(
        // width: 450,
        height: 170,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: 120,
              height: 120,
              clipBehavior: Clip.antiAlias,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Image.asset(
                "assets/images/WatalyGold.png",
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0, top: 15, bottom: 15),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "รายการที่ xx",
                      style: TextStyle(
                        color: GPrimaryColor,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const Spacer(),
                    const Row(
                      children: [
                        Text(
                          "ระดับ",
                          style: TextStyle(color: GPrimaryColor, fontSize: 15),
                        ),
                        SizedBox(width: 15), // เว้นระยะห่างระหว่างข้อความ
                        Text(
                          "คุณภาพพิเศษ",
                          style: TextStyle(
                              color: G2PrimaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          "วันที่ 16 ส.ค 2023",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.green.shade400),
                              surfaceTintColor: MaterialStateProperty.all(
                                  Colors.green.shade400),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5)),
                              minimumSize:
                                  MaterialStateProperty.all(const Size(50, 25)),
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.collections_rounded,
                              color: WhiteColor,
                              size: 20,
                            ),
                            label: const Icon(
                              Icons.add,
                              color: WhiteColor,
                              size: 10,
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.red.shade400),
                              surfaceTintColor: MaterialStateProperty.all(
                                  Colors.red.shade400),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5)),
                              minimumSize:
                                  MaterialStateProperty.all(const Size(30, 30)),
                            ),
                            onPressed: () {},
                            child: const Icon(
                              Icons.delete_rounded,
                              color: WhiteColor,
                              size: 20,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
