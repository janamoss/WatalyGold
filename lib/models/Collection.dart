class Collection {
  final int collection_id;
  final String collection_name;
  final String collection_image;
  final int user_id;

  final String created_at;
  final String? updated_at;
  final String? deleted_at;

  const Collection({
    required this.collection_id,
    required this.collection_name,
    required this.collection_image,
    required this.user_id,
    required this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory Collection.fromSqfliteDatabase(Map<String, dynamic> map) =>
      Collection(
        collection_id: map['collection_id']?.toInt() ?? 0,
        user_id: map['user_id']?.toInt() ?? 0,
        collection_name: map['collection_name'] ?? '',
        collection_image: map['collection_image'] ?? '',
        created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at'])
            .toIso8601String(),
        updated_at: DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
            .toIso8601String(),
      );
}
