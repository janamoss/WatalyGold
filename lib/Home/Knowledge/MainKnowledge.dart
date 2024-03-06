import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watalygold/Home/Knowledge/PageKnowledge.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Knowledgecolumn.dart';
import 'package:watalygold/models/knowledge.dart';

class KnowledgeMain extends StatefulWidget {
  const KnowledgeMain({super.key});

  @override
  State<KnowledgeMain> createState() => _KnowledgeMainState();
}

class _KnowledgeMainState extends State<KnowledgeMain> {
  List<Knowledge> knowledgelist = [];

  Future<List<Knowledge>> getKnowledges() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('Knowledge').get();
    return querySnapshot.docs
        .map((doc) => Knowledge.fromFirestore(doc))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    getKnowledges().then((value) {
      setState(() {
        knowledgelist = value;
      });
      for (var knowledge in knowledgelist) {
        print('Knowledge : ${knowledge.contents}');
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarMains(name: 'คลังความรู้'),
      backgroundColor: Color(0xffF2F6F5),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Column(
              children: [
                for (var knowledge in knowledgelist)
                  KnowlegdeCol(
                    onTap: () {
                      knowledge.contents.isNotEmpty
                          ? null
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KnowledgePage(
                                        knowledge: knowledge,
                                        icons: knowledge.knowledgeIcons,
                                      )));
                    },
                    title: knowledge.knowledgeName,
                    icons: knowledge.knowledgeIcons,
                    ismutible: knowledge.contents.isEmpty ? false : true,
                    contents: knowledge.contents,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
