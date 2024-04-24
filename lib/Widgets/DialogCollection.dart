import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watalygold/Widgets/Color.dart';

class DialogCollection extends StatefulWidget {
  const DialogCollection({super.key});

  @override
  State<DialogCollection> createState() => _DialogCollectionState();
}

class _DialogCollectionState extends State<DialogCollection> {
  File? capturedImages;

  Future Gallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          capturedImages = File(image.path);
        });
      }
    } on PlatformException catch (e) {
      print('ผิดพลาด $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: WhiteColor,
      surfaceTintColor: WhiteColor,
      elevation: 2,
      title: Text(
        "เพิ่มคอลเลคชัน",
        style: TextStyle(fontSize: 15),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "รูปปกคอลเลคชัน",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: capturedImages != null
                      ? DecorationImage(
                          image: FileImage(capturedImages!),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: AssetImage("assets/images/Collection.png"),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              onTap: () {
                Gallery();
                print("กดแล้ว");
              },
            ),
            SizedBox(
              height: 10,
            ),
            Material(
              elevation: 3,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "กรอกชื่อคอลเลคชัน",
                ),
              ),
            )
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "ยกเลิก",
                style: TextStyle(color: WhiteColor),
              ),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(2),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.red.shade400),
                  surfaceTintColor:
                      MaterialStateProperty.all(Colors.red.shade400)),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "เพิ่มคอลเลคชัน",
                style: TextStyle(color: WhiteColor),
              ),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(2),
                  backgroundColor: MaterialStateProperty.all(G2PrimaryColor),
                  surfaceTintColor: MaterialStateProperty.all(G2PrimaryColor)),
            ),
          ],
        ),
      ],
    );
  }
}
