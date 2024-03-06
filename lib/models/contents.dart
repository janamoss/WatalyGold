import 'package:cloud_firestore/cloud_firestore.dart';

class Contents {
  final String ContentName;
  final String ContentDetail;
  final String ImageURL;

  Contents({
    required this.ContentName,
    required this.ContentDetail,
    required this.ImageURL,
  });

  factory Contents.fromFirestore(DocumentSnapshot doc) {
    return Contents(
      ImageURL: doc['ImageURL'],
      ContentName: doc['ContentName'],
      ContentDetail: doc['ContentDetail'],
    );
  }

}
