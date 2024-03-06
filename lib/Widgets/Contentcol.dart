import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watalygold/Home/Knowledge/PageKnowledge.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/models/contents.dart';

class Contentcol extends StatefulWidget {
  final String ContentID;
  final IconData? icons;
  const Contentcol({super.key, required this.ContentID, this.icons});

  @override
  State<Contentcol> createState() => _ContentcolState();
}

class _ContentcolState extends State<Contentcol> {
  Future<Contents> getContentsById(String documentId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('Content').doc(documentId);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data();
      return Contents(
        ContentName: data!['ContentName'].toString(),
        ContentDetail: data['ContentDetail'].toString(),
        ImageURL: data['ImageUrl'].toString(),
      );
    } else {
      throw Exception('Document not found with ID: $documentId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Contents>(
      future: getContentsById(widget.ContentID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final contents = snapshot.data!;
          return ContentDisplay(
            contents: contents,
            icons: widget.icons,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class ContentDisplay extends StatelessWidget {
  final Contents contents;
  final IconData? icons;
  const ContentDisplay({Key? key, required this.contents, this.icons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => KnowledgePage(
                      icons: icons,
                      contents: contents,
                    )));
      },
      title: Text(
        contents.ContentName,
        style: TextStyle(
            color: GPrimaryColor, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      trailing: RotatedBox(
        quarterTurns: 1,
        child: Icon(
          Icons.keyboard_arrow_up_rounded,
          color: GPrimaryColor,
        ),
      ),
    );
  }
}
