import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Map<String, IconData> iconMap = {
  'สถิติ': Icons.analytics_outlined,
  'ดอกไม้': Icons.yard,
  'หนังสือ': Icons.book,
  'น้ำ': Icons.water_drop_outlined,
  'ระวัง': Icons.warning_rounded,
  'คำถาม': Icons.quiz_outlined,
};

class Knowledge {
  final String id;
  final String knowledgeName;
  final List<dynamic> contents;
  final String knowledgeDetail;
  final IconData knowledgeIcons;
  final List<dynamic> knowledgeImg;

  Knowledge({
    required this.id,
    required this.knowledgeName,
    required this.contents,
    required this.knowledgeDetail,
    required this.knowledgeIcons,
    required this.knowledgeImg,
  });

  factory Knowledge.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Knowledge(
      id: doc.id,
      knowledgeName: data['KnowledgeName'] ?? '',
      contents: data['Content']?.map((e) => e).cast<dynamic>().toList() ?? [],
      knowledgeDetail: data['KnowledgeDetail'] ?? '',
      knowledgeIcons: iconMap[data['KnowledgeIcons']] ?? Icons.question_mark,
      // knowledgeImg: data['KnowledgeImg'] ?? '',
      knowledgeImg: data['KnowledgeImg']?.map((e) => e).cast<dynamic>().toList() ?? []
    );
  }
}
