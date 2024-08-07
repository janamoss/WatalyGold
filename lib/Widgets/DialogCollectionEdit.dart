import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watalygold/Database/Collection_DB.dart';
import 'package:watalygold/Database/User_DB.dart';
import 'package:watalygold/Widgets/Color.dart';

class DialogCollectionEdit extends StatefulWidget {
  final String edit_name;
  final String edit_image;
  final int collection_id;
  const DialogCollectionEdit({
    super.key,
    required this.edit_name,
    required this.edit_image,
    required this.collection_id,
  });
  @override
  State<DialogCollectionEdit> createState() => _DialogCollectionEditState();
}

class _DialogCollectionEditState extends State<DialogCollectionEdit> {
  File? capturedImages;
  TextEditingController nameController = TextEditingController();

  bool _isNotValidate = false;
  int? user_id;

  Future<void> _showToastUpdate() async {
    await Fluttertoast.showToast(
        msg: "คอลเลคชันถูกแก้ไขเรียบร้อย",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green.shade300,
        textColor: WhiteColor,
        fontSize: 15);
    await Future.delayed(Duration(seconds: 3));
  }

  Future<void> _showToastwarning() async {
    await Fluttertoast.showToast(
        msg: "ชื่อ ${nameController.text.toString()} ถูกใช้ไปแล้ว กรุณาลองใหม่",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green.shade300,
        textColor: WhiteColor,
        fontSize: 15);
    await Future.delayed(Duration(seconds: 3));
  }

  Future<bool> UpdateCollection() async {
    try {
      final isImageChanged =
          capturedImages!.path.toString() != widget.edit_image;
      final isNameChanged = nameController.text.toString() != widget.edit_name;

      if (isNameChanged && isImageChanged) {
        // กรณีที่เปลี่ยนทั้งรูปภาพและชื่อ
        final s = await Collection_DB().updateCollection(
          collection_id: widget.collection_id.toInt(),
          collection_name: nameController.text.toString(),
          collection_image: capturedImages!.path.toString(),
          user_id: user_id!.toInt(),
        );
        if (s == 0) {
          _showToastwarning();
          Navigator.of(context).pop();
          return false;
        } else {
          // _showToastUpdate();
          Navigator.of(context).pop(true);
          return true;
        }
      } else if (isImageChanged) {
        // กรณีที่เปลี่ยนแค่รูปภาพ
        final s = await Collection_DB().updatecolletiononlyImage(
          collection_id: widget.collection_id.toInt(),
          collection_name: widget.edit_name, // ใช้ชื่อเดิม
          collection_image: capturedImages!.path.toString(),
          user_id: user_id!.toInt(),
        );
        _showToastUpdate();
        Navigator.of(context).pop(true);
        return true;
      } else if (isNameChanged) {
        // กรณีที่เปลี่ยนแค่ชื่อ
        final s = await Collection_DB().updateCollection(
          collection_id: widget.collection_id.toInt(),
          collection_name: nameController.text.toString(),
          collection_image: widget.edit_image, // ใช้รูปภาพเดิม
          user_id: user_id!.toInt(),
        );
        if (s == 0) {
          _showToastwarning();
          Navigator.of(context).pop();
          return false;
        } else {
          // _showToastUpdate();
          Navigator.of(context).pop(true);
          return true;
        }
      } else {
        // กรณีที่ไม่มีการเปลี่ยนแปลง
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
    capturedImages =
        File(widget.edit_image); // กำหนดค่าเริ่มต้นของ capturedImages ในนี้
    nameController.text = widget.edit_name;
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
        "แก้ไขคอลเลคชัน",
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                InkWell(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image:
                          capturedImages!.path == "assets/images/Collection.png"
                              ? DecorationImage(
                                  image: AssetImage(capturedImages!.path),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: FileImage(capturedImages!),
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                  // onTap: () {
                  //   Gallery();
                  //   stdout.writeln("กดแล้ว");
                  // },
                ),
                Positioned(
                  right: -8,
                  bottom: -8,
                  child: IconButton(
                    onPressed: () {
                      Gallery();
                      stdout.writeln("กดแล้ว");
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.edit,
                        color: yellowColor,
                        size: 10.0,
                      ),
                    ),
                  ),
                ),
              ],
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
              onPressed: () {
                UpdateCollection();
              },
              child: Text(
                "แก้ไขคอลเลคชัน",
                style: TextStyle(color: WhiteColor),
              ),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(2),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.orange.shade300),
                  surfaceTintColor:
                      MaterialStateProperty.all(Colors.orange.shade300)),
            ),
          ],
        ),
      ],
    );
  }
}
