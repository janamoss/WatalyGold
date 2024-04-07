class Result {
  final int result_id;
  final int image_id;
  final int? collection_id;

  final String another_note;
  final String quality;
  final int length;
  final int width;
  final int weight;

  final String created_at;
  final String? updated_at;
  final String? deleted_at;

  const Result({
    required this.result_id,
    required this.image_id,
    this.collection_id,
    required this.another_note,
    required this.quality,
    required this.length,
    required this.width,
    required this.weight,
    required this.created_at,
    this.updated_at,
    this.deleted_at,
  });
}
