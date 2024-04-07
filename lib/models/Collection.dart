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
}
