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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    numberController.text = widget.number;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("ค่าน้ำหนักจากรูปภาพ",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
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
              // TextField(
              //   controller: numberController,
              //   style: TextStyle(fontSize: 18, color: Colors.black),
              //   decoration: InputDecoration(
              //       contentPadding: EdgeInsets.only(left: 5, bottom: 0),
              //       floatingLabelStyle:
              //           TextStyle(fontSize: 15, color: Colors.grey.shade800),
              //       focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(5)),
              //           borderSide: BorderSide(color: Colors.grey.shade800)),
              //       fillColor: WhiteColor,
              //       label: Text.rich(TextSpan(children: <InlineSpan>[
              //         WidgetSpan(
              //           child: Text("น้ำหนักมะม่วง "),
              //           style: TextStyle(fontSize: 15),
              //         ),
              //       ]))),
              // )
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(widget.number,
                    style: const TextStyle(
                      fontSize: 25,
                      color: GPrimaryColor,
                    ),
                    textAlign: TextAlign.center),
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
                    Navigator.of(context).pop("");
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
                          MaterialStateProperty.all(Colors.orange.shade300),
                      surfaceTintColor:
                          MaterialStateProperty.all(Colors.orange.shade300)),
                  child: const Text(
                    "ถ่ายใหม่อีกครั้ง",
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
