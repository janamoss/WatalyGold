import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:watalygold/Widgets/Color.dart';

class DialogDelete extends StatefulWidget {
  final String message;
  final String name;
  final VoidCallback onConfirm;
  final int? statusdelete;
  const DialogDelete(
      {super.key,
      required this.message,
      required this.name,
      required this.onConfirm,
      this.statusdelete});

  @override
  State<DialogDelete> createState() => _DialogDeleteState();
}

class _DialogDeleteState extends State<DialogDelete> {
  Future<void> _showToastDelete() async {
    await Fluttertoast.showToast(
        msg: "คอลเลคชัน ${widget.message} ถูกลบเรียบร้อย",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red.shade300,
        textColor: WhiteColor,
        fontSize: 15);
    await Future.delayed(Duration(seconds: 3));
  }

  Future<void> _showToastDeleteresult() async {
    await Fluttertoast.showToast(
        msg: "รายการที่ ${widget.message} ถูกลบออกจากคอลเลคชันเรียบร้อย",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red.shade300,
        textColor: WhiteColor,
        fontSize: 15);
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.delete_forever_rounded,
        color: Colors.red.shade400,
        size: 30,
      ),
      backgroundColor: WhiteColor,
      elevation: 2,
      surfaceTintColor: WhiteColor,
      title: Text(
        'ต้องการลบ ${widget.name}',
      ),
      content: Text(
        '"${widget.message}"',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red.shade400)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ยกเลิก',
                    style: TextStyle(color: WhiteColor, fontSize: 16))),
            ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green.shade400)),
                onPressed: () async {
                  final status = widget.statusdelete ?? 0;
                  if (status == 0) {
                    widget.onConfirm();
                    Navigator.of(context).pop();
                    _showToastDelete();
                    setState(() {});
                  } else {
                    widget.onConfirm();
                    Navigator.of(context).pop();
                    _showToastDeleteresult();
                    setState(() {});
                  }
                },
                child: Text('ตกลง',
                    style: TextStyle(color: WhiteColor, fontSize: 16))),
          ],
        ),
      ],
    );
  }
}
