import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';

class Dialog_WeightNumber extends StatefulWidget {
  const Dialog_WeightNumber({super.key});

  @override
  State<Dialog_WeightNumber> createState() => _Dialog_WeightNumberState();
}

class _Dialog_WeightNumberState extends State<Dialog_WeightNumber> {
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: WhiteColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("กรอกค่าน้ำหนักมะม่วง",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            child: IconButton(
              icon: Icon(Icons.help_outline_rounded,
                  color: const Color.fromARGB(255, 98, 93, 93), size: 25.0),
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
      content: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              style: TextStyle(fontSize: 18, color: Colors.black),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5, bottom: 0),
                  floatingLabelStyle:
                      TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade800)),
                  fillColor: WhiteColor,
                  label: Text.rich(TextSpan(children: <InlineSpan>[
                    WidgetSpan(
                      child: Text("น้ำหนักมะม่วง "),
                      style: TextStyle(fontSize: 15),
                    ),
                    WidgetSpan(
                      child: Text("(หน่วย กรัม)"),
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade800),
                    ),
                  ]))),
            )
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop("");
                  },
                  child: Text(
                    "ยกเลิก",
                    style: TextStyle(
                        color: WhiteColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                      elevation: MaterialStateProperty.all(2),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red.shade400),
                      surfaceTintColor:
                          MaterialStateProperty.all(Colors.red.shade400))),
            ),
            SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop("${numberController.text.toString()} g");
                  },
                  child: Text(
                    "ยืนยัน",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                      elevation: MaterialStateProperty.all(2),
                      backgroundColor:
                          MaterialStateProperty.all(G2PrimaryColor),
                      surfaceTintColor:
                          MaterialStateProperty.all(G2PrimaryColor))),
            )
          ],
        ),
      ],
    );
  }
}
