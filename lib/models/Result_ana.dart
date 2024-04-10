class Result {
  final int result_id;
  final int user_id;
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
    required this.user_id,
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

  factory Result.fromSqfliteDatabase(Map<String, dynamic> map) => Result(
        result_id: map['result_id']?.toInt() ?? 0,
        user_id: map['user_id']?.toInt() ?? 0,
        collection_id: map['collection_id']?.toInt() ?? 0,
        another_note: map['another_note'] ?? '',
        length: map['length']?.toInt() ?? 0,
        weight: map['weight']?.toInt() ?? 0,
        width: map['width']?.toInt() ?? 0,
        quality: map['quality'] ?? '',
        created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at'])
            .toIso8601String(),
        updated_at: DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
            .toIso8601String(),
      );

}
