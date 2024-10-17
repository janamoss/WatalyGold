import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
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
  bool _noInternet = false;
  List<Knowledge> knowledgelist = [];
  final Connectivity _connectivity = Connectivity();

  Future<List<Knowledge>> getKnowledges() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore
        .collection('Knowledge')
        .where('deleted_at', isNull: true)
        .get();
    return querySnapshot.docs
        .map((doc) => Knowledge.fromFirestore(doc))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      debugPrint("ไม่มีอินเทอร์เน็ต");
      setState(() {
        _noInternet = true;
        _isLoading = false; // Stop loading if no internet
      });
    } else {
      debugPrint("มีอินเทอร์เน็ต");
      setState(() {
        _noInternet = false; // Reset the flag if there's internet
        _isLoading = true; // Start loading if there's internet
      });

      getKnowledges().then((value) {
        setState(() {
          knowledgelist = value;
          _isLoading = false;
        });

        for (var knowledge in knowledgelist) {
          debugPrint('Knowledge : ${knowledge.knowledgeImg}');
          debugPrint('Knowledge : ${knowledge.knowledgeDetail}');
          debugPrint('Contents : ${knowledge.contents}');
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
            : _noInternet
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          size: 100,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "ตอนนี้คุณไม่ได้เชื่อมต่ออินเทอร์เน็ต",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _checkInternetConnection,
                          child: const Text("ลองใหม่"),
                        ),
                      ],
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
