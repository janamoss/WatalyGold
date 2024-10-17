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

  Future<bool> _checkRealInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      debugPrint("ไม่มีการเชื่อมต่อเครือข่าย");
      setState(() {
        _noInternet = true;
        _isLoading = false;
      });
    } else {
      bool hasRealConnectivity = await _checkRealInternetConnectivity();
      if (!hasRealConnectivity) {
        debugPrint(
            "มีการเชื่อมต่อเครือข่าย แต่ไม่สามารถเข้าถึงอินเทอร์เน็ตได้");
        setState(() {
          _noInternet = true;
          _isLoading = false;
        });
        return;
      }

      debugPrint("มีการเชื่อมต่ออินเทอร์เน็ต");
      setState(() {
        _noInternet = false;
        _isLoading = true;
      });

      try {
        final knowledges = await getKnowledges();
        setState(() {
          knowledgelist = knowledges;
          _isLoading = false;
        });

        for (var knowledge in knowledgelist) {
          debugPrint('Knowledge : ${knowledge.knowledgeImg}');
          debugPrint('Knowledge : ${knowledge.knowledgeDetail}');
          debugPrint('Contents : ${knowledge.contents}');
        }
      } catch (e) {
        debugPrint("เกิดข้อผิดพลาดในการโหลดข้อมูล: $e");
        setState(() {
          _noInternet = true;
          _isLoading = false;
        });
      }
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
                          size: 80,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "ตอนนี้คุณไม่ได้เชื่อมต่ออินเทอร์เน็ต",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red.shade400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _checkInternetConnection();
                            // Do not dismiss the modal here, let _updateNoInternetState handle it
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red.shade300),
                          ),
                          child: const Text(
                            "ลองใหม่",
                            style: TextStyle(color: WhiteColor, fontSize: 15),
                          ),
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
