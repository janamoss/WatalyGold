import 'package:flutter/material.dart';
// import 'package:intl/intl.dark';

class ExportBox extends StatelessWidget{
  String title ;
  String price ;
  Color color;
  double size;

  ExportBox(this.title,this.color,this.price,this.size);

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10)
      ),
      height: size,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
          style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(price.toString(),
          style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,))
        ],
      ),
    );
    
  }
}