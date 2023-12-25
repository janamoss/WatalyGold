import 'package:flutter/material.dart';

class Knowledge {
  late String name;
  List<Knowledge> subKnowledge = [];
  late String icon;

  Knowledge(
      {required this.name, required this.subKnowledge, required this.icon});

  Knowledge.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    if (json['subKnowledge'] != null) {
      subKnowledge.clear();
      json['subKnowledge'].forEach((v) {
        subKnowledge.add(Knowledge.fromJson(v));
      });
    }
  }
}

List datalist = [
  {
    "name" : "โรคที่มักพบบ่อย",
    "icon" : "assets/images/Vector.png",
    "subKnowledge" : [
      {"icon" : "assets/images/Vector.png",
      "name" : "โรคแอนแทรคโนส" },
      {"name" :"โรคราแป้ง"}
    ]
  },
  {
    "name" : "โรคที่มักพบบ่อย",
    "icon" : "assets/images/Vector.png",
  }
];