import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watalygold/Database/Collection_DB.dart';
import 'package:watalygold/Database/User_DB.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/DialogSuccess.dart';

class DialogCollection extends StatefulWidget {
  const DialogCollection({
    super.key,
  });
  @override
  State<DialogCollection> createState() => _DialogCollectionState();
}

class _DialogCollectionState extends State<DialogCollection> {
  File? capturedImages;
  TextEditingController nameController = TextEditingController();

  bool _isNotValidate = false;
  int? user_id;

  Future<void> _showToastUpdate() async {
    await Fluttertoast.showToast(
        msg: "ชื่อ ${nameController.text.toString()} ถูกใช้ไปแล้ว กรุณาลองใหม่",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green.shade300,
        textColor: WhiteColor,
        fontSize: 15);
    await Future.delayed(Duration(seconds: 3));
  }

  Future<bool> InsertCollection() async {
  try {
    if (nameController.text.isNotEmpty) {
      final s = await Collection_DB().create(
        user_id: user_id!.toInt(),
        collection_name: nameController.text.toString(),
        collection_image: capturedImages!.path.toString(),
      );
      stdout.writeln(s.toString());
      if (s == 0) {
        await _showToastUpdate();
        return false;
      }
      Navigator.of(context).pop(true); // ส่งค่า true กลับไปยัง HomeCollection
      return true;
    } else {
      setState(() {
        _isNotValidate = true;
      });
      return false;
    }
  } catch (e) {
    stdout.writeln(e);
    return false;
  }
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

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    capturedImages = File(
        "assets/images/Collection.png"); // กำหนดค่าเริ่มต้นของ capturedImages ในนี้
  }

  Future Gallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          capturedImages = File(image.path);
        });
      }
    } on PlatformException catch (e) {
      stdout.writeln('ผิดพลาด $e');
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
                  border: Border.all(
                    color: GPrimaryColor,
                    width: 2,
                  ),
                  image: capturedImages != null
                      ? capturedImages!.path == "assets/images/Collection.png"
                          ? DecorationImage(
                              image: AssetImage(capturedImages!.path),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
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
                stdout.writeln("กดแล้ว");
              },
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  elevation: 3,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: TextField(
                    maxLength: 20,
                    controller: nameController,
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
                ),
                if (_isNotValidate)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "กรุณากรอกข้อมูลให้ครบถ้วน",
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 125,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "ยกเลิก",
                  style: TextStyle(color: WhiteColor, fontSize: 12),
                ),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red.shade400),
                    surfaceTintColor:
                        MaterialStateProperty.all(Colors.red.shade400)),
              ),
            ),
            SizedBox(
              width: 125,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  InsertCollection();
                },
                child: Text(
                  "เพิ่มคอลเลคชัน",
                  style: TextStyle(color: WhiteColor, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2),
                    backgroundColor: MaterialStateProperty.all(G2PrimaryColor),
                    surfaceTintColor:
                        MaterialStateProperty.all(G2PrimaryColor)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
