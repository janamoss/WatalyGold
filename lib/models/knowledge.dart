import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final Map<String, IconData> iconMap = {
  'Icons.abc_rounded': Icons.abc_rounded,
  // เพิ่มไอคอนอื่น ๆ
};

class Knowledge {
  final String id;
  final String knowledgeName;
  final List<dynamic> contents;
  final String knowledgeDetail;
  final IconData knowledgeIcons;
  final String knowledgeImg;

  Knowledge({
    required this.id,
    required this.knowledgeName,
    required this.contents,
    required this.knowledgeDetail,
    required this.knowledgeIcons,
    required this.knowledgeImg,
  });

  factory Knowledge.fromFirestore(DocumentSnapshot doc) {
    return Knowledge(
      id: doc.id,
      knowledgeName: doc['KnowledgeName'],
      contents: doc['Content'].map((e) => e).cast<dynamic>().toList(),
      knowledgeDetail: doc['KnowledgeDetail'],
      knowledgeIcons: iconMap[doc['KnowledgeIcons']] ?? Icons.question_mark,
      knowledgeImg: doc['KnowledgeImg'],
    );
  }
}
