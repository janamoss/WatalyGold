import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';

class Dialog_WN_Gemini extends StatefulWidget {
  final number;
  const Dialog_WN_Gemini({super.key, this.number});

  @override
  State<Dialog_WN_Gemini> createState() => _Dialog_WN_GeminiState();
}

class _Dialog_WN_GeminiState extends State<Dialog_WN_Gemini> {
  TextEditingController numberController = TextEditingController();
  int statusEdit = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ดึงเฉพาะตัวเลขออกจากค่า widget.number
    final RegExp regex = RegExp(
        r'\d+(\.\d+)?'); // Regular expression to match numbers (with or without decimal)
    final match = regex.firstMatch(widget.number);

    if (match != null) {
      // ตั้งค่าเฉพาะตัวเลขให้กับ numberController
      numberController.text = match.group(0) ?? '';
    } else {
      numberController.text = ''; // หากไม่มีตัวเลข
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: WhiteColor,
      title: const Text("ค่าน้ำหนักจากรูปภาพ",
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center),
      content: SizedBox(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("ค่าน้ำหนักถูกต้องหรือไม่",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // น้ำหนัก (Editable)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: GPrimaryColor, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5), // ระยะห่างที่คุณต้องการ
                          child: SizedBox(
                            width: 100, // ตั้งค่าขนาดความกว้างตามความเหมาะสม
                            child: TextField(
                              enabled: statusEdit == 1,
                              controller: numberController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Remove default TextField border
                                contentPadding:
                                    EdgeInsets.only(left: 5, bottom: 0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // Space between weight and unit
                    // หน่วยน้ำหนัก (Non-editable text)
                    Text(
                      widget.number.contains('g') ? "กรัม" : "กิโลกรัม",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 110,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    // Navigator.of(context).pop("");
                    if (statusEdit == 0) {
                      setState(() {
                        statusEdit = 1; // เมื่อกดปุ่มนี้จะเปิดให้แก้ไขได้
                      });
                    } else {
                      setState(() {
                        statusEdit = 0; // เมื่อกดปุ่มนี้จะเปิดให้แก้ไขได้
                      });
                    }
                  },
                  style: ButtonStyle(
                      padding:
                          const MaterialStatePropertyAll(EdgeInsets.all(5)),
                      shape: const MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      elevation: MaterialStateProperty.all(2),
                      backgroundColor: statusEdit == 1
                          ? MaterialStateProperty.all(Colors.grey.shade500)
                          : MaterialStateProperty.all(Colors.orange.shade300),
                      surfaceTintColor: statusEdit == 1
                          ? MaterialStateProperty.all(Colors.grey.shade500)
                          : MaterialStateProperty.all(Colors.orange.shade300)),
                  child: Text(
                    statusEdit == 1 ? "ยกเลิกการแก้ไข" : "แก้ไขค่าน้ำหนัก",
                    style: TextStyle(
                        color: WhiteColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
            ),
            SizedBox(
              width: 110,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(numberController.text.toString());
                  },
                  style: ButtonStyle(
                      padding:
                          const MaterialStatePropertyAll(EdgeInsets.all(5)),
                      shape: const MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      elevation: MaterialStateProperty.all(2),
                      backgroundColor:
                          MaterialStateProperty.all(G2PrimaryColor),
                      surfaceTintColor:
                          MaterialStateProperty.all(G2PrimaryColor)),
                  child: const Text(
                    "ค่าน้ำหนักถูกต้อง",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
            ),
          ],
        )
      ],
    );
  }
}
