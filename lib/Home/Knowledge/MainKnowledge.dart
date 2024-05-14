import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watalygold/Home/Knowledge/PageKnowledge.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/Knowledgecolumn.dart';
import 'package:watalygold/models/knowledge.dart';

class KnowledgeMain extends StatefulWidget {
  const KnowledgeMain({super.key});

  @override
  State<KnowledgeMain> createState() => _KnowledgeMainState();
}

class _KnowledgeMainState extends State<KnowledgeMain> {
  bool _isLoading = true;
  List<Knowledge> knowledgelist = [];

  Future<List<Knowledge>> getKnowledges() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('Knowledge').where('deleted_at', isNull: true).get();
    return querySnapshot.docs
        .map((doc) => Knowledge.fromFirestore(doc))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    getKnowledges().then((value) {
      setState(() {
        knowledgelist = value;
        _isLoading = false; // Set loading state to false once data is fetched
      });

      for (var knowledge in knowledgelist) {
        stdout.writeln('Knowledge : ${knowledge.contents}');
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarMains(name: 'คลังความรู้'),
      backgroundColor: Color(0xffF2F6F5),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: WhiteColor,
                  secondRingColor: GPrimaryColor,
                  thirdRingColor: YPrimaryColor,
                  size: 200,
                ),
              )
            : SingleChildScrollView(
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
                                        ),
                                      ),
                                    );
                            },
                            title: knowledge.knowledgeName,
                            icons: knowledge.knowledgeIcons,
                            ismutible:
                                knowledge.contents.isEmpty ? false : true,
                            contents: knowledge.contents,
                          ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
