import 'package:flutter/material.dart';

class knowledgeTile extends StatelessWidget {
  const knowledgeTile();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
     
      
      child: ExpansionTile(
        backgroundColor: Colors.white,
        title: Text(
          "โรคที่พบบ่อย",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'IBM Plex Sans Thai',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        leading: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Image.asset("assets/images/Vector.png"),
        ),
      ),
    );
  }
}
