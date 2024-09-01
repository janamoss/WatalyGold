import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';

class Dialog_Choose extends StatefulWidget {
  const Dialog_Choose({super.key});

  @override
  State<Dialog_Choose> createState() => _Dialog_ChooseState();
}

class _Dialog_ChooseState extends State<Dialog_Choose> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "คุณต้องการกรอกน้ำหนัก\nมะม่วงแบบไหน ?",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      surfaceTintColor: WhiteColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "ถ่ายภาพน้ำหนัก",
                      style: TextStyle(
                          color: WhiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                        backgroundColor:
                            MaterialStatePropertyAll(GPrimaryColor),
                        elevation: MaterialStatePropertyAll(1)),
                  ),
                ),
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  child: IconButton(
                    icon: Icon(Icons.help_outline_rounded,
                        color: const Color.fromARGB(255, 98, 93, 93),
                        size: 25.0),
                    onPressed: null,
                  ),
                  message: 'ถ่ายภาพตัวเลขน้ำหนักจากตาชั่งดิจิทัล',
                  padding: const EdgeInsets.all(10),
                  showDuration: const Duration(seconds: 2),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  textStyle: const TextStyle(color: Colors.white),
                  preferBelow: false,
                  verticalOffset: 20,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "กรอกค่าน้ำหนักเอง",
                      style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.grey.shade200),
                        elevation: MaterialStatePropertyAll(1)),
                  ),
                ),
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  child: IconButton(
                    icon: Icon(Icons.help_outline_rounded,
                        color: const Color.fromARGB(255, 98, 93, 93),
                        size: 25.0),
                    onPressed: null,
                  ),
                  message:
                      'กรอกค่าน้ำหนักของมะม่วงที่วัดจากตาชั่งหรืออื่นๆ ด้วยตนเอง',
                  padding: const EdgeInsets.all(10),
                  showDuration: const Duration(seconds: 2),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  textStyle: const TextStyle(color: Colors.white),
                  preferBelow: false,
                  verticalOffset: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
