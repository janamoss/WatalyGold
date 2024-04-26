import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:watalygold/Widgets/Color.dart';

class DialogDelete extends StatefulWidget {
  final String message;
  final String name;
  final VoidCallback onConfirm;
  const DialogDelete(
      {super.key,
      required this.message,
      required this.name,
      required this.onConfirm});

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
        'ต้องการลบ${widget.name}',
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
                onPressed: () {
                  Navigator.of(context).pop();
                  _showToastDelete();
                  widget.onConfirm();
                },
                child: Text('ตกลง',
                    style: TextStyle(color: WhiteColor, fontSize: 16))),
          ],
        ),
      ],
    );
  }
}
