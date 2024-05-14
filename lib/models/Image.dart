class Images {
  final int image_id;
  final int result_id;

  final String image_status;
  final String image_name;
  final String image_url;
  final int image_lenght;
  final int image_width;
  final int image_weight;
  final int flaws_percent;
  final int brown_spot;
  final String color;

  final String created_at;
  final String? updated_at;
  final String? deleted_at;

  const Images({
    required this.image_id,
    required this.result_id,
    required this.image_status,
    required this.image_name,
    required this.image_url,
    required this.image_lenght,
    required this.image_width,
    required this.image_weight,
    required this.flaws_percent,
    required this.brown_spot,
    required this.color,
    required this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory Images.fromSqfliteDatabase(Map<String, dynamic> map) => Images(
        image_id: map['image_id']?.toInt() ?? 0,
        result_id: map['result_id']?.toInt() ?? 0,
        image_status: map['image_status'] ?? '',
        image_name: map['image_name'] ?? '',
        image_url: map['image_url'] ?? '',
        image_lenght: map['length']?.toDouble() ?? 0,
        image_width: map['weight']?.toDouble() ?? 0,
        image_weight: map['width']?.toDouble() ?? 0,
        flaws_percent: map['quality']?.toDouble() ?? 0,
        brown_spot: map['quality']?.toDouble() ?? 0,
        color: map['quality'] ?? '',
        created_at: DateTime.fromMicrosecondsSinceEpoch(map['created_at'])
            .toIso8601String(),
        updated_at: map['updated_at'] != null
            ? (map['updated_at'] is int
                ? DateTime.fromMicrosecondsSinceEpoch(map['updated_at'])
                    .toIso8601String()
                : map['updated_at'] as String)
            : null,
      );
}
